variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "cluster_endpoint_public_access" {
  type = bool
}

variable "vpc_id" {
  type = string
}
variable "private_subnets" {
  type = list(string)
}
variable "public_subnets" {
  type = list(string)
}
variable "instance_type" {
  type = string
}
variable "instance_types" {
  type = list(string)
}

variable "capacity_type" {
  type = string

}
variable "min_size" {
  type = number

}
variable "max_size" { 
  type = number
}
variable "desired_size" {
  type = number
  
}
variable "namespace" {
  type    = string
  default = "monitoring"
}
variable "kube-version" {
  type = string
  default = "36.2.0"
}