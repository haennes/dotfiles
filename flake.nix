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
     inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      #optional:
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nixos-generators, deploy-rs, nixos-dns, rust-overlay, disko, nur, nixvim, agenix, flake-utils-plus, ... }: 
  let 
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
          nur.overlay
      ];
      config = { 
        allowUnfree = true;
        permittedInsecurePackages = [
          "electron-25.9.0"
        ];
      };
    };
    deployPkgs = import nixpkgs {
      inherit system;
      overlays = [
        deploy-rs.overlay
        (self: super: { deploy-rs = { inherit (pkgs) deploy-rs; lib = super.deploy-rs.lib; }; })
      ];
    };
    sshkeys = import ./secrets/sshkeys.nix;
    ips = import ./secrets/ips.nix;

    build_common_attrs = {hostname, modules, specialArgs, proxmox, vps}:{
      inherit system;
      modules = modules ++ [
        ./modules/all
        ./modules/age.nix
	./modules/wireguard.nix
        nur.nixosModules.nur
      ];
      specialArgs = specialArgs // {inherit sshkeys inputs system proxmox vps ips; permit_pkgs = pkgs;};
    };

    generate_common = {hostname, modules, specialArgs, proxmox, vps, format}:{
      packages.x86_64-linux.${hostname} =
        (nixos-generators.nixosGenerate
	  ((build_common_attrs{inherit hostname modules specialArgs proxmox vps;}) // {inherit format;})
	);};

    build_common = {hostname, modules ? [], specialArgs ? {}, proxmox ? false, vps ? false, live_iso ? false}:{
      nixosConfigurations."${hostname}" = lib.nixosSystem (build_common_attrs{inherit hostname modules specialArgs proxmox vps;});
    } 
    // (if proxmox then  
      generate_common{inherit hostname modules specialArgs proxmox vps; format = "proxmox";}
     else {})
    // (if live_iso then
      generate_common{inherit hostname modules specialArgs proxmox vps; format = "install-iso";} else {})
    ;
    build_deploy = {hostname, conf_hostname ? hostname}:{
      deploy.nodes.${hostname} = {
        profiles.system = {
          user = "root";
          path = deployPkgs.deploy-rs.lib.activate.nixos self.nixosConfigurations.${conf_hostname};
        };
        inherit hostname;
        sshUser = "root"; 
      };
    };

    build_headless = {hostname, dep_hostname ? hostname, proxmox ? false, vps ? false, live_iso ? false, local_and_global ? proxmox, specialArgs ? {}, modules ? []}:
      build_common {
        inherit hostname proxmox vps specialArgs live_iso;
        modules = modules ++ [
          ./servers/${hostname}
          ./modules/headless
        ]; 
      } // (if local_and_global then (recursiveMerge [
          (build_deploy{hostname = "${hostname}"; conf_hostname = hostname;})
          (build_deploy{hostname = "${hostname}_noports"; conf_hostname = hostname;})
	  (build_deploy{hostname = "l_${hostname}";conf_hostname = hostname;})
	  (build_deploy{hostname = "l_${hostname}_noports";conf_hostname = hostname;})
	  (build_deploy{hostname = "m_${hostname}";conf_hostname = hostname;})
	  (build_deploy{hostname = "m_${hostname}_noports";conf_hostname = hostname;})
	  (build_deploy{hostname = "g_${hostname}";conf_hostname = hostname;})
	  (build_deploy{hostname = "g_${hostname}_noports";conf_hostname = hostname;})
	])
	else build_deploy{inherit hostname;});



    #homes_cfg = import ./modules/home_manager ;
    build_headfull = {hostname, specialArgs ? {}, modules ? [], live_iso ? false}:
      build_common {
	inherit hostname live_iso;
        modules = modules ++ [
          ./systems/${hostname}
          ./modules/headfull
	  home-manager.nixosModules.home-manager (import ./modules/home_manager )
          ./modules/gnome
	]; 
	specialArgs = specialArgs // { nur = pkgs.nur;  inherit ips; };
      };
  recursiveMerge= listOfAttrsets: lib.fold (attrset: acc: lib.recursiveUpdate attrset acc) {} listOfAttrsets;
  #    recursiveMerge = attrList:
  #    with lib;
  #let f = attrPath:
  #  zipAttrsWith (n: values:
  #    if tail values == []
  #      then head values
  #    else if all isList values
  #      then unique (concatLists values)
  #    else if all isAttrs values
  #      then f (attrPath ++ [n]) values
  #    else last values
  #  );
  #in f [] attrList;

  in { 
  } // 
  #{
      

	# With GUI
        #build_headfull{hostname = "thinkpad"; modules = [./modules/syncthing.nix]; specialArgs = {base_path = "/home/hannses/syncthing_test";}}
        (recursiveMerge[
	  (build_headfull{hostname = "thinkpad";})
          (build_headfull{hostname = "main_pc";})
          #(build_headfull{hostname = "live"; live_iso = true;}) #TAKES AGES TO MAKE THE FS

	
	  # Servers
          (build_headless{hostname = "welt"; vps = true; modules = [nixos-dns.nixosModules.dns];})
	  (build_headless{hostname = "porta"; proxmox = true;})
	  (build_headless{hostname = "syncschlawiner"; proxmox = true;})
	  (build_headless{hostname = "tabula"; proxmox = true;})
	  (build_headless{hostname = "grapheum"; proxmox = true;})


	]);
	
  #  };

        # rust = {pkgs, ...}:
        # {
        #   nixpkgs.overlays = [rust-overlay.overlays.default];
        #   #environment.systemPackages = [pkgs.rust-bin.nightly.latest.default];
        #   environment.systemPackages = [
        #     pkgs.rust-bin.selectLatestNightlyWith(toolchain: toolchain.default){}
        #   ];
        # };
}
