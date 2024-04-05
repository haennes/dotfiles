{inputs, lib, pkgs, config, nur, ips, ...}: 
let
  build_user = name: { ${name} = import ../../users/${name};};
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      addons = nur.repos.rycee.firefox-addons;
      inherit (inputs) nixvim; 
      inherit inputs;
      inherit ips;
      theme = import ../../users/hannses/theme.nix;
      globals = import ../../users/hannses/globals.nix {inherit pkgs;};
      scripts = import ../../users/hannses/scripts{inherit pkgs lib config;};
    };
    users = 
      build_user "hannses"
      ;
      #// build_user "mum_dad";
  };
}

