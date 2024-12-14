{ pkgs, ... }: {
  programs.zsh.envExtra = ''
    export CARAPACE_BRIDGES="zsh"
    export CARAPACE_EXCLUDES="nix"
  '';

  programs.carapace = {
    enable = true;
    enableZshIntegration = true;
  };

  xdg.configFile = let
    onChange = ''
      ${pkgs.carapace}/bin/carapace --clear-cache
    '';
  in {
    "carapace/bridges.yaml" = {
      inherit onChange;
      text = ''
        # yaml-language-server: $schema=https://carapace.sh/schemas/command.json
        name:  nix
        description: nix build tool
        parsing: disabled
        completion:
          positionalany: ["$carapace.bridge.Zsh([nix])"]
      '';
    };
  };
}
