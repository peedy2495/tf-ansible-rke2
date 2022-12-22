provider "proxmox" {
    pm_api_url = "https://${var.proxmox_host}:8006/api2/json"
    pm_tls_insecure = true

    # Uncomment the below for debugging.
    # pm_log_enable = true
    # pm_log_file = "terraform-plugin-proxmox.log"
    # pm_debug = true
    # pm_log_levels = {
    # _default = "debug"
    # _capturelog = ""
    # }
}

resource "proxmox_vm_qemu" "instances" {

    for_each    = var.instances
    name        = each.value.hostname
    target_node = each.value.target_node
    clone       = var.deploy_defaults["os_template"]
    hotplug     = 0
    agent       = 1
    os_type     = "cloud-init"
    cores       = each.value.cpu_cores
    sockets     = each.value.cpu_sockets
    #default: host ;use kvm64 in nested virtualization 
    cpu         = var.deploy_defaults["cpu_type"]
    memory      = each.value.memory
    scsihw      = "virtio-scsi-pci"
    bootdisk    = "scsi0"
    boot        = "c"
    desc        = "testing multiple instances rollout"
    disk {
        slot        = 0
        size        = each.value.hdd_size
        type        = "scsi"
        storage     = "local-lvm"
        iothread    = 1
    }
 
    vga {
        type        = "cirrus"
        memory      = 4
    }

    network {
        model       = "virtio"
        bridge      = "vmbr0"
        firewall    = false
        link_down   = false
    }

    network {
        model       = "virtio"
        bridge      = "vmbr1"
        firewall    = false
        link_down   = false
    }

    # Not sure exactly what this is for. something about 
    # ignoring network changes during the life of the VM.
    lifecycle {
        ignore_changes = [
                            network,
        ]
    }

    # Cloud-init config
    ciuser          = "ansible"
    ipconfig0       = "ip=${each.value.ip_address},gw=${each.value.gateway}"
    sshkeys         = file("./assets/id_ed25519.pub")

    #provisioner "local-exec" {
    #    command     = "ansible-playbook -u ansible -i inventory hardening.yml"
    #}
}