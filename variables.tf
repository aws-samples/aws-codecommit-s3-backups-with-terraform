// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0

variable "name" {
  type = string
}

variable "region" {
  default = "eu-west-2"
  type = string
}

variable "retention_in_days" {
  type = string
  default = "30"
}

variable "enable_retention" {
  description = "if true, a retention policy is enabled"
  type = bool
}