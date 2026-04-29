{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
in
{
  options.my.office.cli.shell.completion.enable = mkEnableOption "shell completions" // {
    default = config.my.office.cli.shell.enable;
  };
  config = mkIf config.my.office.cli.shell.completion.enable {
    programs.zsh.envExtra = ''
      export CARAPACE_BRIDGES="zsh"
      export CARAPACE_EXCLUDES="nix"
    '';

    programs.carapace = {
      enable = true;
      enableZshIntegration = true;
    };

    xdg.configFile =
      let
        onChange = ''
          ${pkgs.carapace}/bin/carapace --clear-cache
        '';
      in
      {
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
  };
}
