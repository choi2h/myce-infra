variable "name_prefix" {
    type = string
}

variable "db_name" {
    type = string
}

variable "subnets" {
    type = list(string)
}

variable "security_groups" {
    type = list(string)
}

variable "availability_zone" {
    type = string
}