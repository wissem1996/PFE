variable "zoneName" {
  type = string
  default = ""
}
# variable "recordName" {
#   type = string
# }
# variable "type" {
#   type = string
  
# }
# variable "ttl" {
#   type = number
# }
# variable "records" {
#   type = set(string)
# }

variable "external_dns_policy_name" {
  type = string
}      
variable "external_dns_role_name" {
  type = string
}   
variable "account_id" {}              
variable "oidc_url" {}         
variable "region" {
  type = string
}               

variable "external_dns_version" {
  type = string
  default = "6.11.2"
}
