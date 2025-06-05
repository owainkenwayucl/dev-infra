variable img_display_name {
  type = string
  default = "almalinux-10.0-20250528"
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

variable keyname {
  type = string
#  default = ""
}

variable vm_count {
  type    = number
  default = 1
}
