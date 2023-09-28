# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "profile" {
  description = "Please choose AWS Profile"
  type        = string
}

variable "Cluster_name" {
  description = "Please set EKS Cluster Name : "
  type = string
  #default = "NEX4"
}

variable "min" {
  description = "Minimum number of worker nodes"
  type        = number
 }

variable "max" {
  description = "Maximum number of worker nodes"
  type        = number
 }

variable "desired" {
  description = "Desired number of worker nodes"
  type        = number
 }

variable "ngName" {
  description = "Please enter the name for your node group:"
  type = string

}


