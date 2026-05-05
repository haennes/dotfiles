{
  lib,
  config,
  inputs,
  ...
}:
let
  channelPath = "/nix/var/nix/profiles/per-user/root/channels";
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.nix.channel.enable = mkEnableOption "add legacy support for channels" // {
    default = !config.my.nix.enable;
  };
  config = mkIf config.my.nix.channel.enable {
    nix = {
      registry.nixpkgs.flake = inputs.nixpkgs;

      nixPath = [
        "nixpkgs=${channelPath}"
        #"/nix/var/nix/profiles/per-user/root/channels"
      ];
    };
    systemd.tmpfiles.rules = [ "L+ ${channelPath}     - - - - ${inputs.nixpkgs}" ];

  };
}
