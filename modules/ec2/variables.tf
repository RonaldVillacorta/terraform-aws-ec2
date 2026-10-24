variable "project_name" {
  type        = string
  default     = "MyProject"
  description = "The name of the project."
}

variable "instance_type" {
  type        = string
  default     = "t3.nano"
  description = "The type of instance to use for the EC2 instance."
}

variable "ami" {
  type        = string
  default     = "ami-0531fecfb292182a3"
  description = "The AMI ID to use for the EC2 instance."
}

variable "volumen_size" {
  type        = number
  default     = 10
  description = "The size of the root volume in GB."
}

variable "user_data" {
  type        = string
  default     = ""
  description = "The user data to provide when launching the instance."
}
