variable img_display_name {
  type = string
  default = "FreeBSD-15.0-BASIC-CLOUDINIT"
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
