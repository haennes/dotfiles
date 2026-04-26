{
  lib,
  pkgs,
  theme,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.desktop.gtk.enable = mkEnableOption "gtk theming" // {
    default = config.my.desktop.enable;
  };
  config = mkIf config.my.desktop.gtk.enable {
    gtk = {
      enable = true;

      font = {
        name = "${theme.font}";
      };

      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.catppuccin-papirus-folders.override {
          flavor = "mocha";
          accent = "lavender";
        };
      };

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };

      gtk4 = {
        extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
        theme = config.gtk.theme;
      };
    };
  };
}
