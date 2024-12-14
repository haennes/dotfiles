{ pkgs, scripts, globals, hm-config, lib, ... }:
let
  firefox_profiles = hm-config.programs.firefox.profiles;
  firefox_profiles_attr_names = with lib; (attrNames firefox_profiles);
  selector_str = with lib;
    concatStrings (map (x: ''
      firefox ${x}
    '') firefox_profiles_attr_names);
  executor_str = with lib;
    concatStrings (map (x: ''
      "firefox ${x}")
          ${pkgs.firefox}/bin/firefox -p "${x}"
          ;;
    '') firefox_profiles_attr_names);

  #TOOD change to use globals
in ''
  DMENU="${globals.dmenu}"
  CMD="/usr/bin/env bash -c $1"
  APPS="${globals.app_runner}"

  menu="\
  apps
  emacs
  ${selector_str}tor browser
  alacritty
  kitty
  wallpaper
  signal
  tuta
  dbui
  bitwarden
  keepassxc
  office
  xournal++
  zathura
  camera
  file manager
  wifi
  wifi gui
  bluetooth
  bluetooth gui
  clipboard
  remove from clipboard
  disturb
  silent
  clear-clipboard
  screenshot
  sccpa
  brightness
  volume
  volume gui
  mount
  umount
  eject usb
  monitor setup
  monitor setup gui
  nightlight
  lock
  sleep
  shutdown
  restart
  reboot
  kill
  killall
  fix
  keyboard layout
  rescue sh alacritty
  rescue sh kitty\
  "

  choice=$(echo -e "$menu" | ''${DMENU}) || exit

  case "$choice" in
  *\!)
      $CMD "$(printf "%s" "''${choice}" | cut -d'!' -f1)"
      ;;
  "apps")
      $APPS
      ;;
  "emacs")
      ${pkgs.emacs}/bin/emacsclient -c -a 'emacs'
      ;;
  ${executor_str}
  "tor browser")
      ${pkgs.tor-browser-bundle-bin}/bin/tor-browser
      ;;
  "alacritty")
      ${pkgs.alacritty}/bin/alacritty
      ;;
  "kitty")
      ${pkgs.kitty}/bin/kitty
      ;;
  "wallpaper")
      ${scripts.wallpaper}
      ;;
  "signal")
      ${pkgs.signal-desktop}/bin/signal-desktop --enable-features=UseOzonePlatform --ozone-platform=wayland
      ;;
  "tuta")
      # TODO
      ;;
  "bitwarden")
     ${pkgs.bitwarden}/bin/bitwarden --enable-features=UseOzonePlatform --ozone-platform=wayland
     ;;
  "dbui")
     ${scripts.dbui_dmenu}
     ;;
  "disturb")
     ${scripts.donotdisturb}
     ;;
  "silent")
      ${pkgs.dunst}/bin/dunstctl set-paused true
     ;;
  "keepassxc")
      ${pkgs.keepassxc}/bin/keepassxc
      ;;
  "office")
      ${pkgs.libreoffice}/bin/libreoffice
      ;;
  "xournal++")
      ${pkgs.xournalpp}/bin/xournalpp
      ;;
  "zathura")
      ${pkgs.zathura}/bin/zathura
      ;;
  "camera")
      ${pkgs.webcamoid}/bin/webcamoid
      ;;
  "file manager")
      # TODO
      ;;
  "wifi")
      ${scripts.wifi}
      ;;
  "wifi gui")
      ${pkgs.alacritty}/bin/alacritty -e ${pkgs.networkmanager}/bin/nmtui
      # TODO
      ;;
  "bluetooth")
      ${scripts.bluetooth}
      ;;
  "bluetooth gui")
      ${pkgs.alacritty}/bin/alacritty -e ${pkgs.bluetuith}/bin/bluetuith
      ;;
  "clipboard")
      ${scripts.clipboard}
      ;;
  "remove from clipboard")
      ${scripts.rem-from-clipboard}
      ;;
  "clear-clipboard")
      ${scripts.clear-clipboard}
      ;;
  "screenshot")
      ${scripts.screenshot}
      ;;
  "sccpa")
      ${scripts.screenshot-fast}
      ;;
  "brightness")
      ${scripts.brightness}
      ;;
  "volume")
      ${scripts.volume}
      ;;
  "volume gui")
      ${pkgs.pavucontrol}/bin/pavucontrol
      ;;
  "monitor setup")
      ${scripts.monitorsetup}
      ;;
  "monitor setup gui")
      ${pkgs.wdisplays}/bin/wdisplays
      ;;
  "nightlight")
      ${scripts.nightlight}
      ;;
  "mount")
      ${scripts.mount} -m
      ;;
  "umount")
      ${scripts.mount} -u
      ;;
  "eject usb")
      ${scripts.mount} -e
      ;;
  "lock")
      ${scripts.lock}
      ;;
  "sleep")
      systemctl suspend
      ${scripts.lock}
      ;;
  "shutdown")
      if [ "$(echo -e "yes\nno" | $DMENU)" = "yes" ]; then poweroff; fi
      ;;
  "restart"|"reboot")
      if [ "$(echo -e "yes\nno" | $DMENU)" = "yes" ]; then reboot; fi
      ;;
  "kill")
      ${scripts.kill}
      ;;
  "killall")
      ${scripts.killall}
      ;;
  "fix")
      # TODO script
      ;;
  "keyboard layout")
      ${scripts.keyboard_layout}
      ;;

  "rescue sh alacritty")
      ${pkgs.alacritty}/bin/alacritty -e /bin/sh
      ;;
  "rescue sh kitty")
      ${pkgs.kitty}/bin/kitty /bin/sh
      ;;
  *)
      echo "ERROR: choice not in list"
      exit
      ;;
  esac

''
