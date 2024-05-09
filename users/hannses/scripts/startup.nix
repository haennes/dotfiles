{ pkgs, ... }: {
  startup = pkgs.pkgs.writeShellScript "startup" ''
    ${pkgs.waybar}/bin/waybar &
    ${pkgs.wpaperd}/bin/wpaperd
  '';
}
