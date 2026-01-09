variable img_display_name {
  type = string
  default = "AlmaLinux-9-GenericCloud-9.6-20250522"
}

variable namespace {
  type = string
  default = "arc-general-ns"
}

variable network_name {
  type = string
  default = "arc-general-ns/default"
}

variable username {
  type = string
#  default = ""
}

variable keyname {
  type = string
#  default = ""
}

variable vm_count {
  type    = number
  default = 1
}
