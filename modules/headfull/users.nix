{ lib, config, ... }:
let
  inherit (lib) mergeAttrsList map;
  inherit (lib.my) age_obtain_user_password;
  obtain_user_passwords = names:
    mergeAttrsList (map (name: age_obtain_user_password name config) names);
  gen_user = name: {
    "${name}" = {
      isNormalUser = true;
      description = name;
      home = "/home/${name}";
    };
  };
in {
  users.users = {
    "hannses" = {
      isNormalUser = true;
      description = "hannses";
      extraGroups =
        [ "networkmanager" "wheel" "family" "video" "libvirtd" "docker" ];
    };
  } // (gen_user "mum") // (gen_user "dad");

  users.extraGroups.vboxusers.members = [ "hannses" ];
  users.groups = { "family".members = [ "mum" "dad" "hannses" ]; };
} // (obtain_user_passwords [ "hannses" "mum" "dad" ])
