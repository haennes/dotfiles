{ pkgs, ... }: {
  # Set up zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  # Set up starship
  #TODO determine if this changes ANYTHING
  programs.starship.enable = true;
}
