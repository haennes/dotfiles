{
  description = "System Config";

  nixConfig = {
    abort-on-warn = true;
    extra-experimental-features = [ "pipe-operators" ];
    # allow-import-from-derivation = false; #FIXME remove this, these are ifds

    extra-substituters =
      [ "https://nix-community.cachix.org/" "https://numtide.cachix.org/" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
    ];
  };
  inputs = {
    nixpkgs-stable.url = "nixpkgs/nixos-25.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    noogle-cli = {
      url = "github:juliamertz/noogle-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-joint-venture = {
      url =
        "github:nix-joint-venture/nix-joint-venture?ref=recenct_files_zath_xour";
      # url = "/home/hannses/programming/nix/nix-joint-venture";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-alien.url = "github:thiagokokada/nix-alien";
    #nixpkgs.url = "git+file:///home/hannses/programming/nix/nixpkgs?ref=master_dotfiles";
    futils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix";
    watcher = {
      url = "github:haennes/watcher.nix";
      # url = "git+file:///home/hannses/programming/nix/watcher.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dns = {
      url = "github:nix-community/dns.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-option-search = {
      url = "github:mipmip/home-manager-option-search";
      #url =
      #"git+file:///home/hannses/programming/nix/home-manager-option-search";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      #url = "git+file:///home/hannses/programming/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprcursor-phinger = {
      url = "github:jappie3/hyprcursor-phinger";
      inputs.nixpkgs.follows = "nixpkgs";
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
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-yazi-plugins = {
      #url = "github:Mcrtin/nix-yazi-plugins?ref=open-with-cmd+bookmarks";
      url = "github:lordkekz/nix-yazi-plugins";
      #url = "github:lordkekz/nix-yazi-plugins?ref=pull/29/head";
      #url = "github:haennes/nix-yazi-plugins?ref=use-upstream-pkgs";
      # url = "/home/hannses/programming/nix/nix-yazi-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      #optional:
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wireguard-wrapper = {
      # url = "git+file:///home/hannses/programming/nix/wireguard-wrapper";
      url = "github:haennes/wireguard-wrapper.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wg-friendly-peer-names = {
      url = "git+file:///home/hannses/programming/wg-friendly-peer-names";
      # url = "github:haennes/wg-friendly-peer-names";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    syncthing-wrapper = {
      url = "github:haennes/syncthing-wrapper.nix";
      #url = "git+file:///home/hannses/programming/nix/syncthing-wrapper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    IPorts = {
      url = "github:haennes/IPorts.nix";
      #url = "git+file:///home/hannses/programming/nix/IPorts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tasks_md = {
      #url = "git+file:///home/hannses/programming/nix/tasks?ref=four_working";
      url = "github:haennes/tasks_md.nix/four_working";
    };
    waybar-taskwarrior = {
      #url = "git+https://code.ole.blue/ole/waybar-taskwarrior.rs";
      # url = "github:haennes/waybar-taskwarrior.rs";
      url = "github:haennes/waybar-taskwarrior.rs/formatting-rewrite";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    signal-whisper = {
      url = "github:haennes/signal-whisper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-topology.url = "github:oddlama/nix-topology";
    esw-machines = {
      # url = "git+file:///home/hannses/programming/esw-machines";
      url = "github:haennes/esw-machines";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      # url = "github:unixpariah/nh";
      url = "github:haennes/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    menu-calc = {
      url = "github:haennes/menu-calc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pinentry-keepassxc = {
      url = "github:amnore/pinentry-keepassxc";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };

    };
    nix-search-tv = {
      # url = "github:3timeslazy/nix-search-tv";
      url = "github:haennes/nix-search-tv?ref=nixpkgs-sh-module";
      # url = "git+file:///home/hannses/programming/nix/nix-search-tv?ref=nixpkgs-sh-module";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        noogle-cli.follows = "noogle-cli";
      };
    };
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ self, nixpkgs, home-manager, home-manager-option-search
    , deploy-rs, rust-overlay, nur, nix-yazi-plugins, futils, wireguard-wrapper
    , wg-friendly-peer-names, syncthing-wrapper, tasks_md, nix-update-inputs
    , signal-whisper, IPorts, nix-topology, raspberry-pi-nix, watcher, nh
    , menu-calc, pinentry-keepassxc, nix-minecraft, ... }:
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
        watcher.nixosModules.default
      ];
      client_modules = [
        home-manager.nixosModules.home-manager
        #home-manager-option-search.nixosModules.default
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
      laptop = hostname: (client hostname) // { config.is_laptop = true; };

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
        inputs.nix-alien.overlays.default
        nh.overlays.default

      ];
      nix = {
        generateRegistryFromInputs = true;
        generateNixPathFromInputs = true;
        linkInputs = true;
      };

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
                "corefonts-1" # ksp
                "corefonts" # ksp
                "vista-fonts" # ksp
                "clion"
                "minecraft-server"
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
            deploy-rs.overlays.default
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
        yoga = { modules = [ (laptop "yoga") microvm_host ]; };
        fabulinus = {
          system = "aarch64-linux";
          modules = [
            raspberry-pi-nix.nixosModules.raspberry-pi
            raspberry-pi-nix.nixosModules.sd-image
            (server "fabulinus")
          ];
        };

        #matemate = { # deutch englisch
        #  system = "aarch64-linux";
        #  modules = [
        #    raspberry-pi-nix.nixosModules.raspberry-pi
        #    raspberry-pi-nix.nixosModules.sd-image
        #    ./servers/matemate
        #  ];
        #};
        thinkpad = { modules = [ (laptop "thinkpad") ]; };
        thinknew = { modules = [ (laptop "thinknew") microvm_host ]; };
      };
      hydraJobs = {
        system-builds = let
          makeConfigurations = configurations:
            builtins.listToAttrs (map (configuration: {
              name = configuration;
              value =
                self.nixosConfigurations.${configuration}.config.system.build.toplevel;
            }) configurations);
        in makeConfigurations [ "dea" ];
      };
    };
}
