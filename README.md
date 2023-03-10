## aws-codecommit-s3-backups-with-terraform

This pattern uses Terraform to backup AWS CodeCommit repositories to Amazon S3. 

## Prerequisites

- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- A repository in AWS CodeCommit

## Architecture
The pattern will be deployed from a local Repository, using Terraform. 

![image info](./img/architecture.png)

1. Code is pushed to a repository in AWS CodeCommit.
2. Amazon EventBridge monitors for changes to any repository.
3. EventBridge invokes AWS CodeBuild and sends it information about the repository. 
4. CodeBuild clones the repository and packages it into a .zip file.
5. CodeBuild uploads the .zip file to an S3 bucket. 

## Deploy Pattern


| Story | Description |
|---|---|
| Edit variables | Edit values in `deploy/config.auto.tfvars`. The values that must be edited are `region` and `name`. `name` is the project name and is applied to the various resources created. 
| Deploy resources | Initialize the directory and apply |
| (Optional) Test backups | Push a new commit to any repository in AWS CodeCommit and then monitor the relevant S3 bucket for a backup .zip file. |

## Troubleshooting

| Issue | Fix |
|---|---|
| Errors containing `NO_ARTIFACTS` or `NO_SOURCE` | Run a destroy and then a fresh apply. CodeBuild projects with no artifacts and defined source may generate errors when they are being edited (rather than built fresh). |

## Related Resources

- [Automate event-driven backups from CodeCommit to Amazon S3 using CodeBuild and CloudWatch Events](https://docs.aws.amazon.com/prescriptive-guidance/latest/patterns/automate-event-driven-backups-from-codecommit-to-amazon-s3-using-codebuild-and-cloudwatch-events.html)
- [Resource: aws_codebuild_project](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project)
- [Resource: aws_cloudwatch_event_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule)

## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.

