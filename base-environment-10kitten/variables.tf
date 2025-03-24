variable img_display_name {
  type = string
  default = "almalinux-kitten-genericcloud-10-20241227.0.x86_64.qcow2"
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
