data "harvester_image" "img" {
  display_name = var.img_display_name
  namespace    = "harvester-public"
}

data "harvester_ssh_key" "mysshkey" {
  name      = var.username
  namespace = var.namespace
}

resource "random_id" "secret" {
  byte_length = 5
}

resource "harvester_cloudinit_secret" "cloud-config" {
  name      = "cloud-config-${random_id.secret.hex}"
  namespace = var.namespace

  user_data = templatefile("cloud-init.tmpl.yml", {
      public_key_openssh = data.harvester_ssh_key.mysshkey.public_key
    })
}

resource "harvester_virtualmachine" "vm" {
  
  count = var.vm_count

  name                 = "${var.username}-jupyterhub-${format("%02d", count.index + 1)}-${random_id.secret.hex}"
  namespace            = var.namespace
  restart_after_update = true

  description = "Jupyterhub VM"

  cpu    = 2
  memory = "16Gi"

  efi         = true
  secure_boot = true

  run_strategy    = "RerunOnFailure"
  hostname        = "${var.username}-jupyterhub-${format("%02d", count.index + 1)}-${random_id.secret.hex}"
  reserved_memory = "100Mi"
  machine_type    = "q35"

  network_interface {
    name           = "nic-1"
    wait_for_lease = true
    type           = "bridge"
    network_name   = var.network_name
  }

  disk {
    name       = "rootdisk"
    type       = "disk"
    size       = "50Gi"
    bus        = "virtio"
    boot_order = 1

    image       = data.harvester_image.img.id
    auto_delete = true
  }
  tags = {
    condenser_ingress_isEnabled = true
    condenser_ingress_jh_hostname = "${var.username}-jh"
    condenser_ingress_jh_port = 8000
    condenser_ingress_jh_protocol = "https"
    condenser_ingress_jh_nginx_proxy-body-size = "100000m"
  }

  cloudinit {
    user_data_secret_name = harvester_cloudinit_secret.cloud-config.name
  }
}
