# My NixOS config


# Structure
- lib (one file per function)
   - default.nix
   - systemd_timer_service.nix
   - wireguard.nix
   - age-helper.nix (TODO: name -> name + path - attr)
- opts
  - by-user.nix
  - headfull.nix
  - headless.nix
  - all.nix
  - default.nix
  - machine_properties.nix
- modules
   - inc (lib.mkDefault - enables all modules)
      - headfull.nix
      - headless.nix
      - _all.nix
   - hm (hm-modules / files, only included if enabled)
      - globals.nix
      - oth TODO MOVE MOST HERE
      - theme.nix
      - utils
         - wl-clipboard.nix
         - pdf.nix
         - tuis
            - btop.nix
         - ffmpeg.nix
         - nix
            - nh.nix
            - nix-search.nix
            - nix-diff.nix
            - nix-tree.nix
            - nix-inspect.nix
      - hardware
         - power.nix
      - identity
         - gpg.nix
         - keepassxc.nix
      - virtualization.nix
      - desktop
         - dunst.nix
         - gnome.nix <+- dconf-editor
         - gtk.nix
         - hyprland.nix
         - wallpaper.nix
         - lock.nix
         - idle.nix
         - nightlight.nix
         - launchers
            - rofi.nix
            - vicinae.nix
         - bar.nix
         - portal.nix <+- xdg-desktop-portal-hyprland 
         - libnotify.nix TODO WHO USES THIS?
         - screenshot.nix <+- grim, grimblast, slurp
           TODO DO WE NEED THIS IF WE HAVE THE SCRIPT
         - disable_ext_monitors.nix <- move here + add to packages
      - office
         - files
            - bookmarks.nix
            - yazi.nix
            - udiskie.nix
         - rss.nix
         - icdiff.nix TODO MOVE TO SOMEWHERE MORE SENSIBLE
         - fonts.nix <+- fontforge-gtk
         - cliphist.nix
         - anki.nix
         - tasks.nix
         - calc.nix <+- fend
         - finances.nix <+- protfolio
         - music
           - compose.nix <+- pkgs.musescore
           - listen.nix
         - cli
            - terminal
               - kitty.nix
               - wezterm.nix
            - shells
              - zsh.nix
            - shell
               - shell.nix TODO SPLIT
               - ssh.nix
               - starship.nix
               - atuin.nix
               - carapace.nix
               - zoxide.nix
               - television.nix
            - mux
               - tmux.nix
         - markup
           - typst.nix
         - editors
            - codium.nix
            - helix.nix
            - vim.nix
            - plantuml.nix TODO
            - tex.nix ?? TODO
         - media
            - mime.nix
            - mpv.nix
            - pqiv.nix
            - zathura.nix
            - vimiv.nix
            - feh.nix
         - simulation TODO MOVE MOST HERE
         - gaming TODO MOVE MOST HERE
         - programming
            - direnv.nix
            - git.nix
            - gdb.nix
            - license-cli.nix
            - platformio.nix
            - rust.nix <+- rust-analyzer
            - sqllite
         - comms
            - signal.nix
            - mail.nix
            - element.nix
         - browsers
            - firefox
               - default.nix
               - engines
                  - alto.nix
                  - bahn.nix
                  - cpp.nix
                  - fdroid.nix
                  - geizhals.nix
                  - github.nix
                  - hidden.nix
                  - icons.nix
                  - mail.nix
                  - models.nix
                  - nix.nix
                  - openscad.nix
                  - oth.nix
                  - programming.nix
                  - social.nix
                  - typst.nix
                  - websearch.nix
                  - wikipedia.nix
                  - wooclap.nix
                  - settings.nix
         - lorien.nix
         - scripts <!-- TODO move each to sensible locations -->
            - default.nix
            - src
               - bluetooth.nix
               - brightness.nix
               - calc.nix
               - clear-clipboard.nix
               - clipboard.nix
               - dbui_dmenu.nix
               - dbui_fzf.nix
               - deutschland_ticket_firefox.nix
               - deutschland_ticket_pdf.nix
               - deutschland_ticket_screenshot.nix
               - donotdisturb.nix
               - file_manager.nix
               - file_selector.nix
               - ftb.nix
               - gcpp.nix
               - get_shell_file_dir.sh
               - keyboard_layout.nix
               - killall.nix
               - kill.nix
               - lock.nix
               - monitorsetup.nix
               - mount.nix
               - nightlight.nix
               - nix-search.nix
               - notification-info.nix
               - ports_fzf.nix
               - README.md
               - rem-from-clipboard.nix
               - screenshot-fast.nix
               - screenshot.nix
               - selector.nix
               - switchmonitor.nix
               - toggle_opague.nix
               - volume.nix
               - wallpaper.nix
               - waybar.nix
               - wifi.nix
               - wwhich.nix
            - startup.nix

  - sys (system-modules / files, onyl included if enabled)
      - default.nix
      - users <+- users.nix
        - forward.nix
      - watchers
         - default.nix
         - nextcloud_sync_fs.nix
         - typst.nix
         - xournalpp.nix
      - kernel.nix
      - udisks.nix
      - greeter.nix
      - zfs.nix
      - age.nix
      - tmp.nix <- base.nix
      - state-version.nix <- base.nix
      - graphics.nix
      - i18n.nix
      - ssh.nix
      - networks
         - nm.nix
         - firewall.nix here
         - hotspot.nix TODO
      - virtualization
         - default.nix
         - microvm_guest.nix
         - microvm_host.nix
         - microvm_host_stock.nix
         - microvm_host_systemd.nix
         - docker.nix
      - utils
         <!-- things that make life easier -->
         - pdf.nix <- diff-pdf + pdfarranger
         - loc.nix
         - prettifiers.nix
         - archive.nix <- unzip + zip
         - wl-clipboard.nix
         - fix_hid.nix
         - ips_cli.nix
         - ports_cli.nix
         - ripgrep-all.nix <- pkgs.ripgrep-all
         - eza.nix
         - ncdu.nix
         - lsof.nix
         - networking.nix
            - nmap
            - wget
            - dig.
            - tcpdump
         - tldr.nix
         - usbutils.nix
         - sshfs.nix
         - sudo.nix
         - adb.nix
         - dll.nix
         - tuis
            - btop.nix
            - bluetuith.nix
         - cifs-utils.nix
      - converge 
         <!-- things that make sure state across the infra converges to one -->
         - syncthing-wrapper.nix <+- syncthing_wrapper_secrets
         - wireguard-wrapper.nix <+- pkgs.wireguard-tools
           ```nix
           # add abstraction here as well
           {
             from = ["VPSA", "VPSB"];
             to = ["workerA", "workerB"];
             via = "wg0";
           }
           # -> connections = [
           #  ["VPSA%wg0" "workerA%wg0"]
           #  ["VPSB%wg0" "workerB%wg0"]
           #  ["VPSA%wg0" "workerB%wg0"]
           #  ["VPSB%wg0" "workerA%wg0"]
           # ]
           ```
         - ipfs.nix
      - services
         ```nix
            depends = mkOption{
               type = atrrsOf (
                 oneOf [(enum "all") (int) (listOf int)]
               )
               description = ''
                 all -> all services registered under that name
                 int -> number of services required
                 list of int -> which service ids
               ''
            };
            config = mkOption {
               type = functionTo anything;
            };
         ```
         - homepage-dashboard.nix
         - vsftpd.nix
         - nginx.nix <+- local_nginx.nix
         - calendar.nix
         - anki-sync.nix
         - taskchampion.nix
         - hydra.nix
         - nix-serve.nix
         - optionsearch.nix
         - dns-server.nix <- pons/dns.nix
         - kasm.nix
         - tasks.nix
         - nextcloud.nix
         - minecraft.nix
         - gitlab-runner.nix
         - auth.nix TODO
         - mailsrv.nix TODO
         - monitoring.nix TODO
         - uptime.nix TODO
         - photos.nix TODO
         - mealie.nix TODO
      - hardware
         - power.nix
         - fwupd.nix
         - secure-boot.nix <- pkgs.sbctl
         - switches.nix
         - printers/
            - default.nix <- printing.nix
            - ppd
               - FSIM.ppd
               - HH.ppd
               - kitchen_klein.ppd
               - Kitchen.ppd
            - printers.conf
      - nix
         - nix.nix
         - store_optimize.nix
         - crosscompile.nix
         - distributed_builds.nix
         - deploy-rs.nix
      - oth
         - oth_files.nix
         - fortivpn.nix
      - identity
         - keyring.nix
         - yubikey.nix
         - acme.nix
      - office
         - dictionaries.nix
         - shell.nix
         - xdg.nix
         - wireshark.nix
         - mail.nix
         - markup
            - plantuml.nix
            - tex.nix ??
         - editors
            - helix.nix
            - neovim.nix
            - libreoffice.nix
            - xournalpp.nix
            - obsidian.nix
         - media
            - gimp.nix
            - vlc.nix
            - audio.nix
            - chromecast.nix
         - simulation
            - freecad.nix
            - openscad.nix
            - prusa-slicer.nix
            - kicad.nix
         - gaming
            - wine.nix
            - minecraft.nix
            - steam.nix
         - programming
            - arduino.nix
            - hugo.nix
            - rust.nix
            - python.nix <+- ruff
            - c.nix <- gcc + valgrind
            - make.nix <- gnumake, cmake
            - pg_dev.nix
            - git.nix
         - browsers
            - firefox.nix
            - brave.nix
            - tor-browser.nix
            - chromium.nix
   - conf (always included)
      - wg-vpn.nix
      - sync-folders.nix
      - network
         - ips.nix (essentially "symlinks" to secrets)
         - macs.nix (essentially "symlinks" to secrets)
         - ports.nix (essentially "symlinks" to secrets)
         - folders.nix
         - vms.nix
         - reverseproxy.nix
           ```nix
           "cloud.hannses.de" = [
            ["pons_1" "pons_2"], "wg0", ["workera", "workerb"]
            # each pons_1, and pons_2 have a nginx configured for cloud. will forward to workera / workerb (HA)
           ];
      
           ```
      - dns
         - hosters.nix -> which machines host dns zones
         - de
            - hannses
               - local.nix
         - eu
- users
   - hannses.nix
- systems
  - vms
    - templates
      - hostname.nix
    - realizations
       - hostname_inst.nix
  - phsc
    - specialisations (no overwrites -> composition)
      - base.nix
      - gnome.nix
      - hyprland.nix
    - templates
    - $hostname
      - hardware.nix
      - default.nix
- rebuild.py
- relock.sh

