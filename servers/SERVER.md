# Names from:
[non wikipedia](https://www.forumtraiani.de/roemische-goettinen-roemische-goettin/)

[wikipedia](https://de.wikipedia.org/wiki/R%C3%B6mische_Mythologie#Die_r%C3%B6mischen_G%C3%B6tter)

[wikipedia en](https://en.wikipedia.org/wiki/List_of_Roman_deities)
# Infrastruktur:

- welt: **VPS von OVH** wireguard-tunnel nach Hause [nixos-infected](https://github.com/elitak/nixos-infect) [tutorial](https://lyderic.origenial.fr/install-nixos-on-ovh#installing-with-nixos-infect-(recommended))
    1. Reinstall VPS
    2. add sshkey to root
    3. ssh into server as root
    4. run
        ```
        curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-unstable bash -x
        curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | NIX_CHANNEL=24.05 bash -x
        ```
    5. ```
      umount /run/lock
      mkdir -p /run/current-system/sw/bin
    ```
    6. test if it can reboot.
- dea: **cloud + syncthing**
- tabula: **Website**
- hesperos: **openfortivpn jump**
- fons: **rss**
- historia: **atuin shell history**
- minerva: **anki-sync**
- vertumnus: **gitea**
- proserpina: **esw machines**
- pales: **github, gitea runners, nginx file host**
- Terminus: **Calendar**
- Janus: **sftp-server**

## inaktiv:
- deus: **HOST FÜR ALLE ANDEREN**
- concordia: **cloud + ipfs + syncthing**
- porta: **WG-Endpoint** war Proxmox VM (evtl: -> PI bzw. als teil von PI config) (nicht mehr gebraucht, da ssh bereits über deus möglich)
- fenestra **2WG-Endpoint** bis jetzt Proxmox VM (evtl: -> microvm) (Backup Zugriff, falls Fehlkonfiguration von porta)
- merkur: mail
- grapheum: **OnlyOffice - Server** bis jetzt Proxmox VM (evtl: -> microvm)
- speilunke: **pterodactyl** bis jetzt Proxmox VM (evtl: -> microvm)
