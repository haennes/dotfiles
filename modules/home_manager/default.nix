{ inputs, pkgs, system, config, nur, sshkeys, ... }@all_inputs:
let build_user = name: { ${name} = import ../../users/${name}; };
in rec {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit (inputs) nixvim;
      inherit inputs sshkeys system;
      #TODO this is dumb, import them at a user level or make them user bound and move them here
      theme = import ../../users/hannses/theme.nix;
      globals = import ../../users/hannses/globals.nix all_inputs;
      scripts = import ../../users/hannses/scripts all_inputs;
    };
    users = build_user "hannses";
    #// build_user "mum_dad";
  };

  age.secrets = {
    "atuin/key.age" = {
      file = ../../secrets/atuin/key.age;
      name = "key";
      symlink = false;
      owner = "hannses";
      path = config.home-manager.users.hannses.home.homeDirectory
        + "/.local/share/atuin/key";
    };
    "atuin/session.age" = {
      file = ../../secrets/atuin/session.age;
      name = "session";
      owner = "hannses";
      symlink = false;
      path = config.home-manager.users.hannses.home.homeDirectory
        + "/.local/share/atuin/session";
    };
  };
}
