{
  description = "System Config";

  inputs = {
    nixpkgs-stable.url = "nixpkgs/nixos-24.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    futils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix";

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
    hyprcursor-phinger = {
      url = "github:jappie3/hyprcursor-phinger";
      inputs.nixpkgs.follows = "nixpkgs";
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
      #url = "github:haennes/nix-yazi-plugins";
      #url = "github:lordkekz/nix-yazi-plugins";
      #url = "git+file:///home/hannses/programming/nix/nix-yazi-plugins/";
      url = "git+file:///home/hannses/programming/nix/nix-yazi-plugins?ref=fg";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      #optional:
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wireguard-wrapper = {
      #url = "git+file:///home/hannses/programming/nix/wireguard-wrapper";
      url = "github:haennes/wireguard-wrapper.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wg-friendly-peer-names = {
      #url = "git+file:///home/hannses/programming/wg-friendly-peer-names";
      url = "github:haennes/wg-friendly-peer-names";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    syncthing-wrapper = {
      #url = "github:haennes/syncthing-wrapper.nix";
      url = "git+file:///home/hannses/programming/nix/syncthing-wrapper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    IPorts = {
      #url = "github:haennes/IPorts.nix";
      url = "git+file:///home/hannses/programming/nix/IPorts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tasks_md = {
      url = "git+file:///home/hannses/programming/nix/tasks?ref=four_working";
      #url = "github:haennes/tasks_md.nix/four_working";
    };
    signal-whisper = {
      url = "github:haennes/signal-whisper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-topology.url = "github:oddlama/nix-topology";
    #esw-machines.url = "git+file:///home/hannses/programming/esw-machines";
    esw-machines.url = "github:haennes/esw-machines";
    prost.url = "git+file:///home/hannses/programming/PRoST";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, deploy-rs, rust-overlay, nur
    , nix-yazi-plugins, futils, wireguard-wrapper, wg-friendly-peer-names
    , syncthing-wrapper, tasks_md, nix-update-inputs, signal-whisper, IPorts
    , nix-topology, raspberry-pi-nix, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ];
      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib {
          inherit inputs;
          lib = self;
        };
      });
      all_modules = [
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
        nix-topology.nixosModules.default
        tasks_md.nixosModules.default
        wg-friendly-peer-names.nixosModules.default
      ];
      client_modules = [
        home-manager.nixosModules.home-manager
        (import ./modules/home_manager)
        ./modules/gnome
        ./modules/gnome/specialisation.nix
        ./modules/headfull
      ];
      server_modules = [ ./modules/headless ];
      microvm_modules_host =
        [ inputs.microvm.nixosModules.host ./modules/microvm_host.nix ];
      microvm_modules_guest = [ ];
      # ./modules/microvm_guest.nix is not included as it includes these modules when using declarative configuration
      # inputs.microvm.nixosModules.microvm is not included as it automatically gets when using declarative configuration

      server = hostname: {
        config.is_server = true;
        config.is_client = false;
        imports = [ ./servers/${hostname} ] ++ server_modules;
      };
      client = hostname: {
        config.is_client = true;
        imports = [ ./systems/${hostname} ] ++ client_modules;
      };
      microvm_host = {
        config.is_microvm_host = true;
        imports = microvm_modules_host;
      };
      microvm = hostname: {
        config.is_microvm = true;
        imports = [
          (server hostname)
          ./modules/microvm_guest.nix
          inputs.microvm.nixosModules.microvm
        ] ++ microvm_modules_guest;
      };
      sshkeys = import ./secrets/sshkeys.nix;

      topology_pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ nix-topology.overlays.default ];
      };

    in futils.lib.mkFlake {
      inherit self inputs;
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];

      sharedOverlays = [
        nur.overlays.default
        rust-overlay.overlays.default
        nix-yazi-plugins.overlays.default
        nix-update-inputs.overlays.default
        signal-whisper.overlays.default
      ];

      channels = {
        unstable = { # lets us explicitly declare that something is unfree
          input = nixpkgs;
          #config.allowUnfree = true;
          config = {
            allowUnfreePredicate = pkg:
              builtins.elem (lib.getName pkg) [
                "obsidian"
                "lutris"
                "steam"
                "steam-original"
                "steam-unwrapped"
                "steam-run"
                "corefonts-1"
                "corefonts"
                "vista-fonts"
                "clion"
              ];
          };
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
        pi = { input = nixpkgs; };
      };

      hostDefaults = rec {
        system = "x86_64-linux";
        modules = all_modules;
        channelName = "unstable";
        specialArgs = {
          inherit inputs sshkeys lib all_modules client_modules server_modules
            microvm_modules_host microvm_modules_guest system;
          inherit (self) topology;
        };
        extraArgs = { inherit sshkeys system; };
      };

      deploy = {
        activationTimeout = 600;
        confirmTimeout = 120;
        nodes = (lib.my.mkDeploy {
          inherit (inputs) self;
          exclude = [ "welt" ];
        }) // (lib.my.genNodeSimple self "welt");
      };
      formatter =
        forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-classic);

      topology.x86_64-linux = import nix-topology {
        pkgs =
          topology_pkgs; # Only this package set must include nix-topology.overlays.default
        modules = [
          # Your own file to define global topology. Works in principle like a nixos module but uses different options.
          #./topology.nix
          # Inline module to inform topology of your existing NixOS hosts.
          { nixosConfigurations = self.nixosConfigurations; }
        ];
      };
      hosts = {
        deus = { modules = [ (server "deus") microvm_host ]; };
        dea = { modules = [ (server "dea") microvm_host ]; };
        welt = {
          modules = [ (server "welt") inputs.nixos-dns.nixosModules.dns ];
        };
        #porta = { modules = [ (server "porta") ]; };
        #syncschlawiner = { modules = [ (server "syncschlawiner") ]; };
        #syncschlawiner_mkhh = { modules = [ (server "syncschlawiner_mkhh") ]; };
        #tabula = { modules = [ (server "tabula") ]; };
        #tabula = { modules = [ (microvm "tabula") ]; };
        #tabula_mkhh = { modules = [ (server "tabula_mkhh") ]; };
        #hermes = { modules = [ (server "hermes") ]; };
        #fons = { modules = [ (microvm "fons") ]; };
        #grapheum = { modules = [ (server "grapheum") ]; };
        yoga = {
          modules =
            [ (client "yoga") microvm_host inputs.prost.nixosModules.default ];
        };
        fabulinus = {
          system = "aarch64-linux";
          modules = [
            raspberry-pi-nix.nixosModules.raspberry-pi
            raspberry-pi-nix.nixosModules.sd-image
            (server "fabulinus")
          ];
        };

        matemate = { # deutch englisch
          system = "aarch64-linux";
          modules = [
            raspberry-pi-nix.nixosModules.raspberry-pi
            raspberry-pi-nix.nixosModules.sd-image
            ./servers/matemate
          ];
        };
        thinkpad = { modules = [ (client "thinkpad") ]; };
        thinknew = { modules = [ (client "thinknew") ]; };
      };
    };
}
