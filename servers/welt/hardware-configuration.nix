{ lib, modulesPath, ... }: {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules =
    [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];

  #boot.loader.grub.enable = true;
  #boot.loader.grub.devices =  ["/efi"];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/46330877-4e0f-45b3-8a6d-9284dedf3cb1";
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
