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
    simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
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
    wireguard-wrapper = {
      url = "github:haennes/wireguard-wrapper.nix";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nixos-generators, deploy-rs, nixos-dns, rust-overlay, disko, nur, nixvim, agenix, flake-utils-plus, simple-nixos-mailserver, wireguard-wrapper, ... }: 
  let 
    system = "x86_64-linux";
    forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ];
    lib = nixpkgs.lib;
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
          nur.overlay
          rust-overlay.overlays.default
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
	#wireguard-wrapper.nixosModules.wireguard-wrapper
	./modules/syncthing.nix
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
	  simple-nixos-mailserver.nixosModule
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
	specialArgs = specialArgs // { nur = pkgs.nur; rust-bin = pkgs.rust-bin;  inherit ips; };
      };
  recursiveMerge = listOfAttrsets: lib.fold (attrset: acc: lib.recursiveUpdate attrset acc) {} listOfAttrsets;
  in { 
  formatter = forAllSystems (system: pkgs.nixfmt );
  } // 
        (recursiveMerge[
	  # With GUI
	  (build_headfull{hostname = "thinkpad";})
	  (build_headfull{hostname = "thinknew";})
	  (build_headfull{hostname = "yoga";})
          (build_headfull{hostname = "mainpc";})
          #(build_headfull{hostname = "live"; live_iso = true;}) #TAKES AGES TO MAKE THE FS

	  # Servers
          (build_headless{hostname = "welt"; vps = true; modules = [nixos-dns.nixosModules.dns];})
	  (build_headless{hostname = "porta"; proxmox = true;})
	  (build_headless{hostname = "syncschlawiner"; proxmox = true;})
	  (build_headless{hostname = "syncschlawiner_mkhh"; proxmox = true;})
	  (build_headless{hostname = "tabula"; proxmox = true;})
	  (build_headless{hostname = "tabula_mkhh"; proxmox = true;})
	  (build_headless{hostname = "hermes"; proxmox = true;})
	  (build_headless{hostname = "grapheum"; proxmox = true;})
	]);
   
}
