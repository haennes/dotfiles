{ pkgs, ... }: {
  home.packages = with pkgs; [ gnupg ];
  programs.gpg = { enable = true; };
  services.gpg-agent = {
    pinentryPackage = pkgs.pinentry-tty;
    enable = true;
  };
}
