data "harvester_image" "img" {
  display_name = var.img_display_name
  namespace    = "harvester-public"
}

data "harvester_ssh_key" "mysshkey" {
  name      = var.keyname
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

  name                 = "${var.username}-registry-${format("%02d", count.index + 1)}-${random_id.secret.hex}"
  namespace            = var.namespace
  restart_after_update = true

  description = "Docker Registry VM"

  cpu    = 1
  memory = "8Gi"

  efi         = true
  secure_boot = true

  run_strategy    = "RerunOnFailure"
  hostname        = "${var.username}-registry-${format("%02d", count.index + 1)}-${random_id.secret.hex}"
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
    size       = "100Gi"
    bus        = "virtio"
    boot_order = 1

    image       = data.harvester_image.img.id
    auto_delete = true
  }

  tags = {
    condenser_ingress_isEnabled = true
    condenser_ingress_reg_hostname = "registry"
    condenser_ingress_reg_port = 6000
    condenser_ingress_reg_protocol = "https"
    condenser_ingress_reg_nginx_proxy-body-size = "100000m"
    condenser_ingress_cons_hostname = "registry-rw"
    condenser_ingress_cons_port = 5000
    condenser_ingress_cons_protocol = "https"
    condenser_ingress_cons_nginx_proxy-body-size = "100000m"
    condenser_ingress_cache_hostname = "dockerhub"
    condenser_ingress_cache_port = 4000
    condenser_ingress_cache_protocol = "https"
    condenser_ingress_cache_nginx_proxy-body-size = "100000m"
  }

  cloudinit {
    user_data_secret_name = harvester_cloudinit_secret.cloud-config.name
  }
}
