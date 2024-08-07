let

  secrets = import ../../lib/wireguard;
  ids = import ../../secrets/not_so_secret/syncthing.key.nix;
  priv_key = hostname: secrets.age_obtain_wireguard_priv { inherit hostname; };
in { config, pkgs, lib, ips, ports, vps ? false, proxmox ? false, ... }:
with lib;
with ips;
let
  hostname = config.networking.hostName;
  simple_ip = name: { "${name}".ips = [ (ip_cidr ips."${name}".wg0) ]; };
  recursiveMerge = listOfAttrsets:
    lib.fold (attrset: acc: lib.recursiveUpdate attrset acc) { } listOfAttrsets;
in {
  imports = [ ./syncthing_wrapper_secrets.nix ];
  config = {
    boot.tmp.cleanOnBoot = true;
    system.stateVersion = "23.11"; # Did you read the comment?

    # Make ready for nix flakes
    nix.package = pkgs.nixFlakes;
    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';

    time.timeZone = "Europe/Berlin";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
    # Configure console keymap
    console.keyMap = "de-latin1-nodeadkeys";
    #console.font = "MesloLGM Nerd Font";

    # Set up zsh
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
    # Set up starship
    #TODO determine if this changes ANYTHING
    programs.starship.enable = true;

    networking.firewall.enable = true;
    networking.networkmanager.enable = true;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
    # Enable the OpenSSH daemon.
    services.openssh.enable = true; # TODO: extract into module

    services.wireguard-wrapper = {
      connections = [
        [ "tabula" "welt" ]
        [ "porta" "welt" ]
        [ "hermes" "welt" ]
        [ "syncschlawiner" "welt" ]
        [ "syncschlawiner_mkhh" "welt" ]
        [ "handy_hannses" "welt" ]
        [ "thinkpad" "welt" ]
        [ "thinknew" "welt" ]
        [ "yoga" "welt" ]
        [ "mainpc" "welt" ]
      ];
      nodes = {
        welt = {
          ips = [ (ip_cidr ips.welt.wg0) (subnet_cidr lib ips.welt.wg0) ];
          endpoint = "hannses.de:${builtins.toString ports.welt.wg0}";
        };
      } // simple_ip "porta" // simple_ip "hermes" // simple_ip "syncschlawiner"
        // simple_ip "syncschlawiner_mkhh" // simple_ip "tabula"
        // simple_ip "thinkpad" // simple_ip "thinknew" // simple_ip "mainpc"
        // simple_ip "yoga" // simple_ip "handy_hannses";
      publicKey = name:
        ((secrets.obtain_wireguard_pub { hostname = name; }).key);
      privateKeyFile = lib.mkIf (config.services.wireguard-wrapper.enable)
        config.age.secrets."wireguard_${config.networking.hostName}_wg0_private".path;
      port = ports."${hostname}".wg0;
    };

    services.syncthing_wrapper = rec {
      default_versioning = {
        type = "simple";
        params.keep = "10";
      };
      devices = rec {
        all_pcs = {
          thinknew = ids.thinknew;
          mainpc = ids.mainpc;
          yoga = ids.yoga;
        };
        thinkpad = {
          thinkpad = ids.thinkpad;
        };
        all_handys = {
          handyHannes = ids.handyHannes;
          handyAlexandra = ids.handyMum;
          handyThomas = ids.handyThomas;
          tablet = ids.tablet;

        };
        servers = { syncschlawiner = ids.syncschlawiner; };
        all_servers = servers // { tabula = ids.tabula; };

        #uni = {
        #  stefan_handy = ids.stefan_handy;
        #  sebastian_s_mac = ids.sebastian_s_mac;
        #  sebastian_r_laptop = ids.sebastian_r_laptop;
        #};
      };
      folders = with devices;
        with devices.all_handys;
        with devices.all_servers; {
          "Family" = {
            devices = [(all_pcs // servers) "thinkpad"];
            paths = {
              "mainpc" = "/home/Family";
              "thinkpad" = "/home/Family";
              "thinknew" = "/home/Family";
              "yoga" = "/home/Family";
            };
          };
          "Passwords" = {
            devices = [(all_pcs // all_handys // servers) "thinkpad"];
            versioning = {
              type = "simple";
              params.keep = "100";
            };
          };
          "3d_printing" = [ (all_pcs // servers) ];
          "Documents" = [ (all_pcs // servers) ];
          "Notes" = [ (all_pcs // servers) ];
          "tasks" = {
            devices = [ (all_pcs // servers) ];
            paths = {
              syncschlawiner = "/data/syncthing/hannses/tasks";
            };
          };
          "Downloads" = [ (all_pcs // servers) ];
          "Music" = [ (all_pcs // servers) ];
          "Pictures" = [ (servers // all_pcs) ];
          "Templates" = [ (all_pcs // servers) ];
          "Videos" = [ (all_pcs // servers) ];
          "game_servers" = [ (all_pcs // servers) ];
          "programming" = [ (all_pcs // servers) ];
          "AegisBak" = [ (all_pcs // servers) "handyHannes" ];
          "SignalBackup" = [ (all_pcs // servers) "handyHannes" ];
          "DownloadHandyH" = [ (all_pcs // servers) "handyHannes" ];
          "HannesKamera" = [ (all_pcs // servers) "handyHannes" ];
          "HannesGalerie" = [ (all_pcs // servers) "handyHannes" ];
          "AlexandraKamera" = [ (servers) "handyAlexandra" ];
          "AlexandraGalerie" = [ (servers) "handyAlexandra" ];
          "ThomasKamera" = [ (servers) ];
          "ThomasGalerie" = [ (servers) ];
          "website" = [ (all_pcs) "tabula" ];
          };
    };
    #folders_list = with all_handys all_pcs servers;

    services.syncthing = {
      settings = {
        options = {
          urAccepted = -1; # do not send reports
          relaysEnabled = true;
        };
      };
      key = lib.mkIf (config.services.syncthing.enable)
        config.age.secrets."syncthing_key_${config.networking.hostName}".path;
      cert = lib.mkIf (config.services.syncthing.enable)
        config.age.secrets."syncthing_cert_${config.networking.hostName}".path;
    };
  } // (priv_key (config.networking.hostName));
}
