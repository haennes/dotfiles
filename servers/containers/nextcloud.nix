{config, pkgs, lib, ...}:{
  autoStart = true;
  privateNetwork = false;
  hostBridge = "ncbr";
  bindMounts = {
    "/var/lib/nextcloud" = {
      hostPath = "/ncdata";
      isReadOnly = false;
    };
  };
  # forwardPorts = [
  #   protocol = tpc;

  # ];
  config = let eval = import ../services/nextcloud.nix {config=config; pkgs=pkgs; lib=lib;}; in{config, pkgs, lib, ...}:{
    imports = [ eval ];
    
   environment.etc."resolv.conf".text = "nameserver 8.8.8.8";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
  };
}