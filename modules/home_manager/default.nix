{ inputs, pkgs,  config, nur, ips, sshkeys, overlays, permit_pkgs, ports, ... }@all_inputs:
let build_user = name: { ${name} = import ../../users/${name}; };
in {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      addons = nur.repos.rycee.firefox-addons;
      outer_config = config;
      inherit (inputs) nixvim;
      inherit inputs ips ports sshkeys overlays permit_pkgs;
      #TODO this is dumb, import them at a user level or make them user bound and move them here
      theme = import ../../users/hannses/theme.nix;
      globals = import ../../users/hannses/globals.nix all_inputs;
      scripts = import ../../users/hannses/scripts all_inputs;
      gnome_enable = config.services.xserver.desktopManager.gnome.enable;
      virt-manager_enable = config.programs.virt-manager.enable;
    };
    users = build_user "hannses";
    #// build_user "mum_dad";
  };
}
