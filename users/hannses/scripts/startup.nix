{ pkgs, ... }: {
  startup = pkgs.pkgs.writeShellScript "startup" ''
    ${pkgs.waybar}/bin/waybar &
    ${pkgs.swww}/bin/swww init
    $(cat ~/.wallpapercall)

    # start wallpaper using my wallpaper script
  '';
}
