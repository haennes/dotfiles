{ inputs, lib, pkgs,  config, nur, ips, sshkeys, overlays, permit_pkgs, ports, ... }@all_inputs:
let build_user = name: { ${name} = import ../../users/${name}; };
in {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      addons = nur.repos.rycee.firefox-addons;
      outer_config = config;
      inherit (inputs) nixvim;
      inherit inputs;
      inherit ips;
      inherit ports;
      inherit sshkeys;
      inherit overlays;
      inherit permit_pkgs;
      theme = import ../../users/hannses/theme.nix;
      globals = import ../../users/hannses/globals.nix { inherit pkgs; };
      scripts = import ../../users/hannses/scripts all_inputs;
      gnome_enable = config.services.xserver.desktopManager.gnome.enable;
      virt-manager_enable = config.programs.virt-manager.enable;
    };
    users = build_user "hannses";
    #// build_user "mum_dad";
  };
}
