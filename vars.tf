variable "proxmox_host" {
    default = "192.168.100.11"
}

variable "deploy_defaults" {
    type    = map
    default = {
        "cpu_type"      = "kvm64"
        "os_template"   = "ubuntu-2004-cloudinit-template"

    }
}

variable "instances" {
    default = {
        "server01" = {
            hostname    = "server01"
            ip_address  = "192.168.100.121/24"
            gateway     = "192.168.100.1",
            target_node = "pve",
            cpu_cores   = 2,
            cpu_sockets = 1,
            memory      = "2048",
            hdd_size    = "10G",
        },
        "agent01" = {
            hostname    = "agent01"
            ip_address  = "192.168.100.131/24"
            gateway     = "192.168.100.1",
            target_node = "pve",
            cpu_cores   = 2,
            cpu_sockets = 1,
            memory      = "2048",
            hdd_size    = "10G",
        },
    }
}