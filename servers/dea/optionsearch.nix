{
  inputs,
  pkgs,
  lib,
  config,
  options,
  ...
}:
let
  build-scope = modules: name: prefix: {
    modules = [ { _module.args = { inherit pkgs lib options; }; } ] ++ (lib.lists.toList modules);
    name = name;
    urlPrefix = prefix;
  };
  hostname = config.networking.hostName;
in
{
  networking.firewall.interfaces.wg0.allowedTCPPorts = [
    config.ports.ports.curr_ports."nuescht-options"
  ];
  services.nginx.virtualHosts."options.hannses.de" = {
    forceSSL = false;
    enableACME = false;
    listen = [
      {
        addr = config.ips.ips.ips.default.${hostname}.wg0;
        port = config.ports.ports.curr_ports."nuescht-options";
      }
    ];
    locations."/".root = inputs.nuscht-search.packages.${pkgs.stdenv.system}.mkMultiSearch {
      scopes = [
        (build-scope inputs.agenix.nixosModules.default "agenix"
          "https://github.com/ryantm/agenix/tree/main/"
        )
        (build-scope inputs.lanzaboote.nixosModules.lanzaboote "lanzaboote"
          "https://github.com/nix-community/lanzaboote/tree/main/"
        )
        {
          optionsJSON =
            (import "${inputs.nixpkgs}/nixos/release.nix" { }).options + /share/doc/nixos/options.json;
          name = "NixOS";
          urlPrefix = "https://github.com/NixOS/nixpkgs/tree/master/";
        }
        # (build-scope inputs.home-manager.nixosModules.home-manager
        #   "HomeManager" "https://example.com")
        (build-scope
          [
            inputs.simple-nixos-mailserver.nixosModules.default
            {
              mailserver = {
                fqdn = "mx.example.com";
                domains = [ "example.com" ];
                dmarcReporting = {
                  organizationName = "Example Corp";
                  domain = "example.com";
                };
              };
            }
          ]
          "simple-nixos-mailserver"
          "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/blob/master/"
        )
        (build-scope inputs.microvm.nixosModules.host "microvm.nix host"
          "https://github.com/astro/microvm.nix/tree/master/"
        )
        (build-scope inputs.microvm.nixosModules.microvm "microvm.nix guest"
          "https://github.com/astro/microvm.nix/tree/master/"
        )

        (build-scope inputs.nix-minecraft.nixosModules.minecraft-servers "nix-minecraft"
          "https://github.com/Infinidoge/nix-minecraft/tree/master/"
        )

        (build-scope inputs.strichliste-rs.nixosModules.${config.nixpkgs.system}.default "strichliste-rs"
          "https://github.com/DestinyofYeet/strichliste/tree/master/"
        )
        (build-scope inputs.syncthing-wrapper.nixosModules.default "syncthing-wrapper"
          "https://github.com/haennes/syncthing-wrapper.nix/tree/master/"
        )
        # (build-scope inputs.wireguard-wrapper.nixosModules.default "wireguard-wrapper"
        #   "https://github.com/haennes/wireguard-wrapper.nix/tree/master/"
        # )
        (build-scope inputs.signal-whisper.nixosModules.default "signal-whisper"
          "https://github.com/haennes/signal-whisper/tree/master/"
        )
        (build-scope inputs.nix-yazi-plugins.legacyPackages.x86_64-linux.homeManagerModules.default "nix-yazi-plugins"
          "https://github.com/lordkekz/nix-yazi-plugins/tree/master/"
        )
        (build-scope inputs.fs-bookmarks.nixosModules.default "fs-bookmarks.nix"
          "https://github.com/haennes/fs-bookmarks.nix/tree/master/"
        )
        (build-scope inputs.watcher.nixosModules.default "watcher.nix"
          "https://github.com/haennes/watcher.nix/tree/master/"
        )
        (build-scope inputs.bindfs.nixosModules.default "bindfs.nix"
          "https://github.com/haennes/bindfs.nix/tree/master/"
        )
        (build-scope inputs.IPorts.nixosModules.default "IPorts.nix"
          "https://github.com/haennes/IPorts.nix/tree/master/"
        )
      ];
    };
  };
}
