{
  osConfig,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mapAttrsToList mkEnableOption mkIf;
in
{
  options.my.office.flashcards = {
    enable = mkEnableOption "flashcards - anki" // {
      default = config.my.office.enable;
    };
    typ2anki.enable = mkEnableOption "typ2anki" // {
      default = config.my.office.flashcards.enable;
    };
  };
  config = mkIf config.my.office.flashcards.enable {
    home.packages = mkIf config.my.office.flashcards.typ2anki.enable (
      with pkgs;
      [
        inputs.typ2anki.packages.${system}.default
      ]
    );

    programs.anki = {
      enable = true;
      answerKeys =
        let
          sk = v: { ease = v; };
        in
        mapAttrsToList (n: v: { key = n; } // v) {
          "1" = sk 1;
          "2" = sk 2;
          "3" = sk 3;
          "4" = sk 4;
        };
      addons = with pkgs.ankiAddons; [
        anki-connect
        image-occlusion-enhanced
      ];
      profiles.hannses =
        let
          port = osConfig.ports.ports.ports.minerva.ankisync;
          ip = osConfig.ips.ips.ips.default.minerva.wg2;
        in
        {
          default = true;
          sync = {
            autoSync = true;
            autoSyncMediaMinutes = 10;
            keyFile = osConfig.age.secrets."anki-KeyFile.age".path;
            syncMedia = true;
            url = "http://${ip}:${toString port}";
            username = "hannses";
          };
        };
    };
  };
}
