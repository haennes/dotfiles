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
      inherit ips;
    };
    users = 
      build_user "hannses"
      ;
      #// build_user "mum_dad";
  };
}

