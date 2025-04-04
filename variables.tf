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


variable "ip_address" {
  description = "Your IP Address"
  default     = "213.22.159.152"
}

variable "ip_range_filter" {
  description = "Your IP Address"
  default     = "213.22.159.152/32"
}

