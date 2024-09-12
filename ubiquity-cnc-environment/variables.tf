variable img_display_name {
  type = string
  default = "almalinux-9.4-20240805"
}

variable namespace {
  type = string
  default = "arc-general-ns"
}

variable network_name {
  type = string
  default = "arc-general-ns/gen-proj"
}

variable username {
  type = string
#  default = ""
}

variable cncname {
  type = string
#  default = "cnc"
}

variable vm_count {
  type    = number
  default = 1
}
