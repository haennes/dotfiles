{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.identity.passwords =  {
    enable = mkEnableOption "passwords manager" // {
      default = config.my.identity.enable;
    };
    autostart = {
      enable = mkEnableOption "password manager" // {
        default = true;
      };
    };
  };
  config = mkIf config.my.identity.passwords.enable {
    programs.keepassxc = {
      enable = true;
    };

    programs.firefox.profiles.default.extensions.packages =
    let
      addons = pkgs.nur.repos.rycee.firefox-addons;
    in
    mkIf config.programs.firefox.enable [ addons.keepassxc-browser ];

    my.desktop = mkIf config.my.identity.passwords.autostart.enable {
      autostart.autostart."special:passwords" = {
        tabbed = [ "${pkgs.keepassxc}/bin/keepassxc" ];
      };
      wm.common.specialWorkspaces = {
        passwords = "z";
      };
    };
  };
}
