{ pkgs, inputs, ... }: {
  home.packages = with pkgs; [ gnupg ];
  programs.gpg = { enable = true; };
  services.gpg-agent = {
    pinentry.package = inputs.pinentry-keepassxc.packages.x86_64-linux.default;
    enable = true;
  };
}
