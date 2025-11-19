variable "ami" {
  type = string
  default = "ami-0a71e3eb8b23101ed"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "name" {
  type = string
}

variable "key_pair_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_goups" {
  type = list(string)
}

variable "use_public_ip" {
  type = bool
  default = true
}
