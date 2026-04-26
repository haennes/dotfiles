{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.office.fonts.enable = mkEnableOption "fonts" // {
    default = config.my.office.enable;
  };
  config = mkIf config.my.office.fonts.enable {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      # keep-sorted start sticky_comments=no block=yes
      fontforge-gtk
      liberation_ttf
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      # keep-sorted end
    ];
  };
}
