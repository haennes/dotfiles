{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  inherit (types) str listOf oneOf package;
in
{
  options.my.office.comms = {
    enable = mkEnableOption "communications" // {
      default = config.my.office.enable;
    };
    specialWorkspace = {
      name = mkOption {
        type = str;
        default = "chat";
      };
      enable = mkEnableOption "specialWorkspace" // {
        default = true;
      };
      autostart = {
        autostart = mkOption {
          type = listOf (oneOf [ str package ]);
          default = [];
        };
        enable = mkEnableOption "autostartup" // {
          default = true;
        };
      };
    };

  };
  imports = [
    ./signal.nix
    ./matrix.nix
    ./mail.nix
  ];
  config = 
  let
    wname = config.my.office.comms.specialWorkspace.name;
  in 
  mkIf config.my.office.comms.specialWorkspace.enable {
    my.desktop = {
      wm.common.specialWorkspaces = {
        ${wname} = "c";
      };
      autostart.autostart = mkIf config.my.office.comms.specialWorkspace.autostart.enable {
        "special:${wname}".tabbed = config.my.office.comms.specialWorkspace.autostart.autostart;
      };
    };
  };
}
