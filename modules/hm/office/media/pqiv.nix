{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.office.media.pqiv.enable = mkEnableOption "pqiv media player" // {
    default = config.my.office.media.enable;
  };
  config = mkIf config.my.office.media.pqiv.enable {
    programs.pqiv = {
      enable = true;

      settings = {
        options = {
          lazy-load = 1;
          hide-info-box = 1;
          background-pattern = "black";
          thumbnail-size = "256x256";
          command-1 = "dolphin"; # TODO!!! globals
        };
      };
    };
  };
}
