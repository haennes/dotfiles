# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ips, hips, macs, specialArgs, lib, ... }: {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-25879778-fcba-4dab-9ad7-a929638b13ec".device =
    "/dev/disk/by-uuid/25879778-fcba-4dab-9ad7-a929638b13ec";
  networking.hostName = "yoga"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  services.syncthing_wrapper = { enable = true; };
  services.syncthing = {
    dataDir = "/home/hannses";
    user = "hannses";
  };
  services.wireguard-wrapper.enable =
    false; # currently wg0 forwarind all traffic is broken
  networking.networkmanager.unmanaged = [ "wg0" ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  microvm.vms = {
    fons = {
      inherit specialArgs;
      config = import ../../servers/fons;
    };
  };
  systemd.network = {
    enable = true;
    netdevs.virbr0.netdevConfig = {
      Kind = "bridge";
      Name = "virbr0";
    };
    networks.virbr0 = {
      matchConfig.Name = "virbr0";

      addresses = [
        { Address = "${ips.vm-host.virbr0}/24"; }
        { Address = "fd12:3456:789a::1/64"; }
      ];
      # Hand out IP addresses to MicroVMs.
      # Use `networkctl status virbr0` to see leases.
      networkConfig = {
        DHCPServer = true;
        IPv6SendRA = true;
      };
      # Let DHCP assign a statically known address to the VMs
      dhcpServerStaticLeases = [{
        MACAddress = "${macs.vm-fons.eth0}";
        Address = "${ips.vm-fons.virbr0}";
      }];
      # IPv6 SLAAC
      ipv6Prefixes = [{ Prefix = "fd12:3456:789a::/64"; }];
    };
    networks.microvm-eth0 = {
      matchConfig.Name = "vm-*";
      networkConfig.Bridge = "virbr0";
    };
  };
  # Allow DHCP server
  networking.firewall.allowedUDPPorts = [ 67 ];
  # Allow Internet access
  networking.nat = {
    enable = true;
    enableIPv6 = true;
    internalInterfaces = [ "virbr0" ];
    externalInterface = "lo";

    forwardPorts = [{
      proto = "tcp";
      sourcePort = 2222;
      destination = "${ips.vm-fons.virbr0}:22";
    }];
  };

  networking.extraHosts = ''
    ${ips.vm-fons.virbr0} fons
  '';

}
