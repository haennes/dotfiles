{
  description = "System Config";

  inputs = {
    nixpkgs-stable.url = "nixpkgs/nixos-24.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    futils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    home-manager-option-search = {
      url = "github:mipmip/home-manager-option-search";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    manix = {
      url = "github:haennes/manix?ref=fix/hm-options-with-flakes";
      #url = "github:zvolin/manix/c532d14b0b59d92c4fab156fc8acd0565a0836af";
    };
    hyprland = {
      url =
        "github:hyprwm/Hyprland/47b087950dcfaf6fdda63c4d5f13efda3508a6fb?submodules=1"; # works
    };

    nix-update-inputs = {
      url = "github:haennes/nix-update-input/cycle";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-inspect.url = "github:bluskript/nix-inspect";

    haumea.url = "github:nix-community/haumea/v0.2.2";
    haumea.inputs.nixpkgs.follows = "nixpkgs";
    #split-monitor-workspaces = {
    #  url = "github:bivsk/split-monitor-workspaces/bivsk";
    #  inputs.hyprland.follows = "hyprland";
    #};

    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-dns = {
      url = "github:Janik-Haag/nixos-dns";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs.url = "github:serokell/deploy-rs";
    rust-overlay.url = "github:oxalica/rust-overlay";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      #inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-yazi-plugins = {
      url = "github:haennes/nix-yazi-plugins";
      #url = "github:lordkekz/nix-yazi-plugins";
      #url = "git+file:///home/hannses/programming/nix/nix-yazi-plugins/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      #optional:
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wireguard-wrapper = {
      url = "github:haennes/wireguard-wrapper.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    syncthing-wrapper = {
      url = "github:haennes/syncthing-wrapper.nix";
      #url = "git+file:///home/hannses/programming/nix/syncthing-wrapper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    IPorts = {
      #url = "github:haennes/IPorts.nix";
      url = "git+file:///home/hannses/programming/nix/IPorts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tasks_md = { url = "git+file:///home/hannses/programming/nix/tasks"; };
    signal-whisper = {
      url = "github:haennes/signal-whisper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, deploy-rs, rust-overlay, nur
    , nix-yazi-plugins, futils, wireguard-wrapper, syncthing-wrapper, tasks_md
    , nix-update-inputs, signal-whisper, IPorts, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ];
      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib {
          inherit inputs;
          lib = self;
        };
      });
      client_modules = [
        home-manager.nixosModules.home-manager
        tasks_md.nixosModules.default
        (import ./modules/home_manager)
        ./modules/gnome
        ./modules/headfull
        {
          specialisation = {
            gnome.configuration = {
              services.xserver.desktopManager.gnome.enable = true;
              services.gnome.gnome-remote-desktop.enable =
                false; # conflicts with pulsaudio
              system.nixos.tags = [ "gnome" ];
            };
          };
        }
      ];
      server_modules = [ ./modules/headless ];
      server = hostname: {
        config.is_server = true;
        imports = [ ./servers/${hostname} ] ++ server_modules;
      };
      client = hostname: {
        config.is_client = true;
        imports = [ ./systems/${hostname} ] ++ client_modules;
      };
      microvm_host = {
        config.is_microvm_host = true;
        imports = [ inputs.microvm.nixosModules.host ./modules/microvm.nix ];
      };
      microvm = hostname: {
        config.is_microvm = true;
        imports = [ (server hostname) inputs.microvm.nixosModules.microvm ];
      };
      sshkeys = import ./secrets/sshkeys.nix;

    in futils.lib.mkFlake {
      inherit self inputs;
      supportedSystems = [ "x86_64-linux" ];

      sharedOverlays = [
        nur.overlay
        rust-overlay.overlays.default
        nix-yazi-plugins.overlays.default
        nix-update-inputs.overlays.default
        signal-whisper.overlays.default
      ];

      channels = {
        unfree = { # lets us explicitly declare that something is unfree
          input = nixpkgs;
          config.allowUnfree = true;
        };
        insecure = {
          input = nixpkgs;
          config.permittedInsecurePackages = [ "electron-25.9.0" ];
        };
        deployrs = {
          input = nixpkgs;
          overlaysBuilder = channels: [
            deploy-rs.overlay
            (self: super: {
              deploy-rs = {
                inherit (channels.nixpkgs.pkgs) deploy-rs;
                lib = super.deploy-rs.lib;
              };
            })
          ];
        };
      };

      hostDefaults = rec {
        system = "x86_64-linux";
        modules = [
          ./modules/all
          ./modules/age.nix
          ./modules/machine_properties.nix
          ./secrets/macs.nix
          ./secrets/ips.nix
          ./secrets/ports.nix
          wireguard-wrapper.nixosModules.wireguard-wrapper
          syncthing-wrapper.nixosModules.syncthing-wrapper
          #nur.nixosModules.nur
          IPorts.nixosModules.default # adds ips, macs and ports
        ];
        specialArgs = { inherit inputs sshkeys lib; };
        extraArgs = { inherit sshkeys system; };
      };

      deploy = lib.my.mkDeploy { inherit (inputs) self; };
      formatter =
        forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-classic);

      hosts = {
        deus = { modules = [ (server "deus") microvm_host ]; };
        welt = {
          modules = [ (server "welt") inputs.nixos-dns.nixosModules.dns ];
        };
        porta = { modules = [ (server "porta") ]; };
        syncschlawiner = { modules = [ (server "syncschlawiner") ]; };
        syncschlawiner_mkhh = { modules = [ (server "syncschlawiner_mkhh") ]; };
        #tabula = { modules = [ (server "tabula") ]; };
        tabula = { modules = [ (microvm "tabula") ]; };
        tabula_mkhh = { modules = [ (server "tabula_mkhh") ]; };
        hermes = { modules = [ (server "hermes") ]; };
        fons = { modules = [ (microvm "fons") ]; };
        grapheum = { modules = [ (server "grapheum") ]; };
        #
        yoga = { modules = [ (client "yoga") microvm_host ]; };
        thinkpad = { modules = [ (client "thinkpad") ]; };
        thinknew = { modules = [ (client "thinknew") ]; };
      };
    };
}
