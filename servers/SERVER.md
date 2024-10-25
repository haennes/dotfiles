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
- tabula: **Website** Microvm inside of deus
- syncschlawiner: **CLOUD ++ SYNCTHING** bis jetzt Proxmox VM (evtl: -> microvm)
- fons: **rss**

## inaktiv:
- porta: **WG-Endpoint** war Proxmox VM (evtl: -> PI bzw. als teil von PI config) (nicht mehr gebraucht, da ssh bereits über deus möglich)
- fenestra **2WG-Endpoint** bis jetzt Proxmox VM (evtl: -> microvm) (Backup Zugriff, falls Fehlkonfiguration von porta)
- hermes: mail
- vertumnus: **gitea**
- grapheum: **OnlyOffice - Server** bis jetzt Proxmox VM (evtl: -> microvm)
- speilunke: **pterodactyl** bis jetzt Proxmox VM (evtl: -> microvm)
