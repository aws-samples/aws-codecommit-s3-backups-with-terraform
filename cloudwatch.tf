// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/codebuild/${var.name}"
  retention_in_days = 30
}

resource "aws_cloudwatch_event_rule" "this" {
  name          = "codecommit-backups"
  description   = "This rule is used to trigger CodeCommit backups to S3"
  event_pattern = <<EOF
{
  "source": [
    "aws.codecommit"
  ],
  "detail-type": [
    "CodeCommit Repository State Change"
  ],
  "detail": {
    "event": [
      "referenceCreated",
      "referenceUpdated"
    ]
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "this" {
  rule      = aws_cloudwatch_event_rule.this.name
  target_id = "codebuild"
  arn       = aws_codebuild_project.this.arn
  role_arn  = aws_iam_role.cloudwatch.arn

  input_transformer {
    input_paths = {
      referenceType  = "$.detail.referenceType",
      region         = "$.region",
      repositoryName = "$.detail.repositoryName",
      account        = "$.account",
      referenceName  = "$.detail.referenceName",
    }
    input_template = <<EOF
{
    "environmentVariablesOverride": [
        {
            "name": "REFERENCE_NAME",
            "value": <referenceName>
        },
        {
            "name": "REFERENCE_TYPE",
            "value": <referenceType>
        },
        {
            "name": "REPOSITORY_NAME",
            "value": <repositoryName>
        },
        {
            "name": "REPO_REGION",
            "value": <region>
        },
        {
            "name": "ACCOUNT_ID",
            "value": <account>
        }
    ]
}
EOF
  }
}

resource "aws_iam_role" "cloudwatch" {
  name               = "${var.name}-cloudwatch-role"
  assume_role_policy = data.aws_iam_policy_document.cloudwatch_assume.json
}

data "aws_iam_policy_document" "cloudwatch_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values = [
        data.aws_caller_identity.current.account_id
      ]
    }
  }


}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.cloudwatch.name
  policy_arn = aws_iam_policy.cloudwatch.arn
}

resource "aws_iam_policy" "cloudwatch" {
  name   = "${var.name}-cloudwatch-policy"
  policy = data.aws_iam_policy_document.cloudwatch.json
}

data "aws_iam_policy_document" "cloudwatch" {
  statement {
    effect = "Allow"
    actions = [
      "codebuild:StartBuild"
    ]

    resources = [
      aws_codebuild_project.this.arn
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "batch:SubmitJob"
    ]

    resources = [
      "*"
    ]
  }
}

