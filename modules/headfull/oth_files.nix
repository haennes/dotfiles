{ pkgs, ... }@inputs: {
  environment.systemPackages = [
    (import ../../secrets/not_so_secret/mount_cmd_string.nix { inherit pkgs; })
  ];
}
