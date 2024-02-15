let
  default_bootl = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  ovh_custom_bootl = {
    grub.enable = true;
    grub.device = "/dev/sda15";
    grub.forceInstall = true;
  };
  secrets = import ../../lib/wireguard;
  priv_key = hostname: secrets.age_obtain_wireguard_priv{inherit hostname;};
in
{config, pkgs, lib, ips, vps ? false, proxmox ? false, ...}:
with lib;
with ips;
let
  simple_ip = name: { "${name}".ips = [ (ip_cidr ips."${name}".wg0)]; };
in
{
  config = {
  boot.loader = mkIf (!proxmox) (if vps then ovh_custom_bootl else default_bootl);
  system.stateVersion = "23.11"; # Did you read the comment?
  
  # Make ready for nix flakes
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';


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
  networking.networkmanager.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # Enable the OpenSSH daemon.
  services.openssh.enable = true; #TODO: extract into module 


  services.wireguard-wrapper = {
    #port = 51821;
    connections = [
      ["tabula" "welt"]
      ["porta" "welt"]
      ["syncschlawiner" "welt"]
      ["syncschlawiner_mkhh" "welt"]
      ["handy_hannses" "welt"]
      ["thinkpad" "welt"]
      ["mainpc" "welt"]
    ];
    nodes = { 
      welt = {
        ips = [
          (ip_cidr welt.wg0)
          (subnet_cidr lib welt.wg0)
        ]; 
        endpoint = "hannses.de:51821"; 
      }; 
    }
    // simple_ip "porta"
    // simple_ip "syncschlawiner"
    // simple_ip "syncschlawiner_mkhh"
    // simple_ip "tabula"
    // simple_ip "thinkpad"
    // simple_ip "mainpc"
    // simple_ip "handy_hannses"
    ;
    publicKey = name: ((secrets.obtain_wireguard_pub{hostname = name;}).key);
    privateKeyFile = config.age.secrets."wireguard_${config.networking.hostName}_wg0_private".path;
    port = 51821;
  };
} // priv_key config.networking.hostName;
}
