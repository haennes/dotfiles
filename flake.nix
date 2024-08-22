{
  description = "System Config";

  inputs = {
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland/47b087950dcfaf6fdda63c4d5f13efda3508a6fb?submodules=1"; #works
    };

    nix-update-inputs.url = "github:haennes/nix-update-input/cycle";

    haumea.url = "github:nix-community/haumea/v0.2.2";
    haumea.inputs.nixpkgs.follows = "nixpkgs";
    #split-monitor-workspaces = {
    #  url = "github:bivsk/split-monitor-workspaces/bivsk";
    #  inputs.hyprland.follows = "hyprland";
    #};

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-dns = {
      url = "github:Janik-Haag/nixos-dns";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    simple-nixos-mailserver.url =
      "gitlab:simple-nixos-mailserver/nixos-mailserver";
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
      #url = "github:lordkekz/nix-yazi-plugins";
      url = "git+file:///home/hannses/programming/nix/nix-yazi-plugins/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      #optional:
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wireguard-wrapper = { url = "github:haennes/wireguard-wrapper.nix"; };
    syncthing-wrapper = {
      url = "git+file:///home/hannses/programming/nix/syncthing-wrapper";
    };
    tasks_md = {
      url = "git+file:///home/hannses/programming/nix/tasks";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nixos-generators, deploy-rs
    , nixos-dns, rust-overlay, disko, nur, nixvim, nix-yazi-plugins, agenix, flake-utils-plus
    , simple-nixos-mailserver, wireguard-wrapper, syncthing-wrapper, tasks_md, nix-update-inputs, haumea, ... }:
    let
      overlays = [ nur.overlay rust-overlay.overlays.default nix-yazi-plugins.overlays.default nix-update-inputs.overlays.default ];
      system = "x86_64-linux";
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ];
      lib = nixpkgs.lib;
      pkgs = import nixpkgs {
        inherit system overlays;
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [ "electron-25.9.0" ];
        };
      };
      deployPkgs = import nixpkgs {
        inherit system;
        overlays = [
          deploy-rs.overlay
          (self: super: {
            deploy-rs = {
              inherit (pkgs) deploy-rs;
              lib = super.deploy-rs.lib;
            };
          })
        ];
      };
      sshkeys = import ./secrets/sshkeys.nix;
      ips = import ./secrets/ips.nix{inherit (nixpkgs) lib;};
      ports = import ./secrets/ports.nix{inherit (nixpkgs) lib;};

      build_common_attrs = { hostname, modules, specialArgs, proxmox, vps }: {
        inherit system;
        modules = modules ++ [
          ./modules/all
          ./modules/age.nix
          wireguard-wrapper.nixosModules.wireguard-wrapper
          syncthing-wrapper.nixosModules.syncthing-wrapper
          nur.nixosModules.nur
        ];
        specialArgs = specialArgs // {
          inherit sshkeys inputs system proxmox vps ips ports overlays;
          permit_pkgs = pkgs;
        } // {hports = if (ports ? "${hostname}") then ports.${hostname} else null;};
      };

      generate_common =
        { hostname, modules, specialArgs, proxmox, vps, format }: {
          packages.x86_64-linux.${hostname} = (nixos-generators.nixosGenerate
            ((build_common_attrs {
              inherit hostname modules specialArgs proxmox vps;
            }) // {
              inherit format;
            }));
        };

      build_common = { hostname, modules ? [ ], specialArgs ? { }
        , proxmox ? false, vps ? false, live_iso ? false }:
        {
          nixosConfigurations."${hostname}" = lib.nixosSystem
            (build_common_attrs {
              inherit hostname modules specialArgs proxmox vps;
            });
        } // (if proxmox then
          generate_common {
            inherit hostname modules specialArgs proxmox vps;
            format = "proxmox";
          }
        else
          { }) // (if live_iso then
            generate_common {
              inherit hostname modules specialArgs proxmox vps;
              format = "install-iso";
            }
          else
            { });
      build_deploy = { hostname, conf_hostname ? hostname }: {
        deploy.nodes.${hostname} = {
          profiles.system = {
            user = "root";
            path = deployPkgs.deploy-rs.lib.activate.nixos
              self.nixosConfigurations.${conf_hostname};
          };
          inherit hostname;
          sshUser = "root";
        };
      };

      build_headless = { hostname, dep_hostname ? hostname, proxmox ? false
        , vps ? false, live_iso ? false, local_and_global ? proxmox
        , specialArgs ? { }, modules ? [ ] }:
        build_common {
          inherit hostname proxmox vps specialArgs live_iso;
          modules = modules ++ [
            ./servers/${hostname}
            ./modules/headless
            simple-nixos-mailserver.nixosModule
          ];
        } // (if local_and_global then
          (recursiveMerge [
            (build_deploy {
              hostname = "${hostname}";
              conf_hostname = hostname;
            })
            (build_deploy {
              hostname = "${hostname}_noports";
              conf_hostname = hostname;
            })
            (build_deploy {
              hostname = "l_${hostname}";
              conf_hostname = hostname;
            })
            (build_deploy {
              hostname = "l_${hostname}_noports";
              conf_hostname = hostname;
            })
            (build_deploy {
              hostname = "m_${hostname}";
              conf_hostname = hostname;
            })
            (build_deploy {
              hostname = "m_${hostname}_noports";
              conf_hostname = hostname;
            })
            (build_deploy {
              hostname = "g_${hostname}";
              conf_hostname = hostname;
            })
            (build_deploy {
              hostname = "g_${hostname}_noports";
              conf_hostname = hostname;
            })
          ])
        else
          build_deploy { inherit hostname; });

      #homes_cfg = import ./modules/home_manager ;
      build_headfull =
        { hostname, specialArgs ? { }, modules ? [ ], live_iso ? false }:
        build_common {
          inherit hostname live_iso;
          modules = modules ++ [
            ./systems/${hostname}
            ./modules/headfull
            home-manager.nixosModules.home-manager
            tasks_md.nixosModules.default
            (import ./modules/home_manager)
            ./modules/gnome
            {
              specialisation = {
                   gnome.configuration = {
                     services.xserver.desktopManager.gnome.enable = true;
                     system.nixos.tags = ["gnome"];
                   };
              };
            }
          ];
          specialArgs = specialArgs // {
            nur = pkgs.nur;
            rust-bin = pkgs.rust-bin;
            inherit ips;
          };
        };
      recursiveMerge = listOfAttrsets:
        lib.fold (attrset: acc: lib.recursiveUpdate attrset acc) { }
        listOfAttrsets;
    in {
      formatter = forAllSystems (system: pkgs.nixfmt-classic);
    } // (recursiveMerge [
      # With GUI
      (build_headfull { hostname = "thinkpad"; })
      (build_headfull { hostname = "thinknew"; })
      (build_headfull { hostname = "yoga"; })
      (build_headfull { hostname = "mainpc"; })
      #(build_headfull{hostname = "live"; live_iso = true;}) #TAKES AGES TO MAKE THE FS

      # Servers
      (build_headless {
        hostname = "welt";
        vps = true;
        modules = [ nixos-dns.nixosModules.dns ];
      })
      (build_headless {
        hostname = "porta";
        proxmox = true;
      })
      (build_headless {
        hostname = "syncschlawiner";
        proxmox = true;
      })
      (build_headless {
        hostname = "syncschlawiner_mkhh";
        proxmox = true;
      })
      (build_headless {
        hostname = "tabula";
        proxmox = true;
      })
      (build_headless {
        hostname = "tabula_mkhh";
        proxmox = true;
      })
      (build_headless {
        hostname = "hermes";
        proxmox = true;
      })
      (build_headless {
        hostname = "grapheum";
        proxmox = true;
      })
    ]);

}
