// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0

variable "name" {
  type = string
}

variable "s3_logging_bucket" {
  type    = string
  default = null
}

variable "kms_key" {
  type    = string
  default = null
}
