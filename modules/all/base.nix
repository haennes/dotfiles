{ config, pkgs, lib, ... }:
with lib; {
  imports = [ ./syncthing_wrapper_secrets.nix ];
  config = {
    boot.tmp.cleanOnBoot = true;
    system.stateVersion = "23.11"; # Did you read the comment?

    # Make ready for nix flakes

    nix = {
      package = pkgs.nix;
      settings.experimental-features = [ "nix-command" "flakes" ];
    };

    time.timeZone = "Europe/Berlin";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
    # Configure console keymap
    console.keyMap = "de-latin1-nodeadkeys";
    #console.font = "MesloLGM Nerd Font";

    # Set up zsh
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
    # Set up starship
    #TODO determine if this changes ANYTHING
    programs.starship.enable = true;

    networking.firewall.enable = true;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
    # Enable the OpenSSH daemon.
    services.openssh = {
      enable = true; # TODO: extract into module
      ports = [ config.ports.ports.curr_ports.sshd ];
    };

  };
}
