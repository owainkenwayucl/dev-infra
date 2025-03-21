variable img_display_name {
  type = string
#  default = "ubuntu-22.04-20241206-jammy-server-cloudimg-amd64.img"
  default = "ubuntu-24.04-20241206-noble-server-cloudimg-amd64.img"
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
