{ ... }: {
  nix.gc = {
    automatic = true;
    frequency = "19:00";
    options = "--delete-older-than 14d";
  };
}
