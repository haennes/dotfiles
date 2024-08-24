
# Allgemein

<https://dl.dell.com/topicspdf/optiplex-5040-desktop_owners-manual_en-us.pdf>

<https://www.dell.com/support/home/de-de/product-support/product/optiplex-5040-desktop/overview>

## Prozessor

<https://ark.intel.com/content/www/de/de/ark/products/88184/intel-core-i56500-processor-6m-cache-up-to-3-60-ghz.html>

## RAM

8GB DDR3L SDRAM 1600MHz

## M.2 SSD

256GB




# Infrastruktur:

- welt: **VPS von OVH** wireguard-tunnel nach Hause [nixos-infected](https://github.com/elitak/nixos-infect) [tutorial](https://lyderic.origenial.fr/install-nixos-on-ovh#installing-with-nixos-infect-(recommended))
    1. Reinstall VPS
    2. add sshkey to root
    3. ssh into server as root
    4. run
        ```
        curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-unstable bash -x
        ```
    5. test if it can reboot.
- deus: **HOST FÜR ALLE ANDEREN**
- porta: **WG-Endpoint** bis jetzt Proxmox VM (evtl: -> microvm)
- tabula: **Website** bis jetzt Proxmox VM (evtl: -> microvm)
- syncschlawiner: **CLOUD ++ SYNCTHING** bis jetzt Proxmox VM (evtl: -> microvm)

## inaktiv:
- fenestra **2WG-Endpoint** bis jetzt Proxmox VM (evtl: -> microvm) (Backup Zugriff, falls Fehlkonfiguration von porta)
- hermes: mail
- vertumnus: **gitea**
- grapheum: **OnlyOffice - Server** bis jetzt Proxmox VM (evtl: -> microvm)
- speilunke: **pterodactyl** bis jetzt Proxmox VM (evtl: -> microvm)
