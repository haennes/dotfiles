{ lib, modulesPath, ... }: {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules =
    [ "ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi" ];
  boot.kernelModules = [ "nvme" ];

  #boot.loader.grub.enable = true;
  #boot.loader.grub.devices =  ["/efi"];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/7c0c627f-f3a8-4d96-ae32-062f22a6d2af";
    fsType = "ext4";
  };

  #fileSystems."/efi" =
  #  { device = "systemd-1";
  #    fsType = "autofs";
  #  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.ens3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
