{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ yubikey-manager ];
  services.udev.packages = with pkgs; [ yubikey-personalization ];

}
