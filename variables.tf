variable "location" {
  default = "francecentral"
}

variable "environment" {
  default = "Taskify Demo"
}

variable "team" {
  default = "DevOps"
}

# variable "ip_range_filter" {
#   default = "213.22.159.152/32"
# }

variable "allowed_ips" {
  description = "List of allowed IP addresses."
  # type        = list(string)
  default = [
    "89.155.125.86/32",
    "213.22.159.152/32",
    "193.137.66.216/32",
    "193.137.66.206/32",
    "213.22.158.67/32"
  ]
}


variable "allowed_ips1" {
  description = "List of allowed IP addresses."
  default = [
    "89.155.125.86/32",
    "213.22.159.152/32",
    "193.137.66.216/32",
    "193.137.66.206/32",
    "213.22.158.67/32"
  ]
}


# "89.155.125.86/32", "213.22.159.152/32, 193.137.66.216/32", "193.137.66.206/32"

# curl https://api.ipify.org executar para saber o ip publico

# 213.22.70.61/32            

variable "ip_address" {
  description = "Seu bloco /30 que inclui seu IP"
  type        = string
  default     = "213.22.70.60/30"
}


# variable "ip_range_filter" {
#   description = "Your IP Address"
#   default     = "213.22.159.152/32"
# }


