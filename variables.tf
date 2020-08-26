

variable "region" {
  description = "The AWS region to create resources in."
  default     = "eu-central-1"
}

# TODO: support multiple availability zones, and default to it.
variable "availability_zone_a" {
  description = "The availability zone"
  default     = "eu-central-1a"
}
variable "availability_zone_b" {
  description = "The availability zone"
  default     = "eu-central-1b"
}

variable "ecs_cluster_name" {
  description = "The name of the Amazon ECS cluster."
  default     = "main"
}

variable "amis" {
  description = "Which AMI to spawn. Defaults to the AWS ECS optimized images."
  # TODO: support other regions.
  default = {
    eu-central-1 = "ami-0bb4d38e0bc27a390"
  }
}


variable "autoscale_min" {
  default     = "1"
  description = "Minimum autoscale (number of EC2)"
}

variable "autoscale_max" {
  default     = "4"
  description = "Maximum autoscale (number of EC2)"
}

variable "autoscale_desired" {
  default     = "2"
  description = "Desired autoscale (number of EC2)"
}


variable "instance_type" {
  default = "t2.micro"
}

variable "ssh_pubkey_file" {
  description = "Path to an SSH public key"
  default     = "~/.ssh/id_rsa.pub"
}
