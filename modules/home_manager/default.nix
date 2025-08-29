{ inputs, pkgs, system, config, nur, sshkeys, ... }@all_inputs:
let
  build_user = name: { ${name} = import ../../users/${name}; };
  inputs_hm_imports = all_inputs // {
    hm-config = config.home-manager.users.hannses;
    joint-standalone =
      inputs.nix-joint-venture.packages.x86_64-linux.scripts.standalone;
  };
in rec {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = rec {
      inherit (inputs) nixvim menu-calc;
      inherit inputs sshkeys system;
      #TODO this is dumb, import them at a user level or make them user bound and move them here
      theme = import ../../users/hannses/theme.nix;
      globals = import ../../users/hannses/globals.nix inputs_hm_imports;
      scripts = import ../../users/hannses/scripts (inputs_hm_imports // {
        inherit globals joint-non_standalone joint-standalone;
      });
      joint-non_standalone =
        inputs.nix-joint-venture.packages.x86_64-linux.scripts.non_standalone {
          inherit globals;
        };
      joint-standalone =
        inputs.nix-joint-venture.packages.x86_64-linux.scripts.standalone;
    };
    users = build_user "hannses";
    #// build_user "mum_dad";
  };

  age.secrets = {
    "wifihotspot.age" = {
      file = ../../secrets/wifihotspot.age;
      owner = "hannses";
    };
    "taskswarrior-extraConfig.age" = {
      file = ../../secrets/taskwarrior-extraConfig.age;
      owner = "hannses";
    };
  };
}
