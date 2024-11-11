{ pkgs, ... }: {
  programs.helix = {
    enable = true;
    #defaultEditor = true; # leave nvim for now
    languages = {
      language-server = {
        rust-analyzer = {
          config.check.command = "clippy";
          command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        };
        nil = { command = "${pkgs.nil}/bin/nil"; };
        ruff-lsp.command = "${pkgs.ruff}/bin/ruff";
      };
      language = [
        {
          name = "rust";
          auto-format = true;
        }
        {
          name = "nix";
          formatter = { command = "nixpkgs-fmt"; };
          auto-format = true;
        }
        {
          name = "python";
          language-servers = [ "ruff-lsp" ];

          # In case you'd like to use ruff alongside black for code formatting:
          formatter = {
            command = "black";
            args = [ "--quiet" "-" ];
          };
          auto-format = true;
        }
      ];
    };

    settings = { theme = "material_deep_ocean"; };
  };
}
