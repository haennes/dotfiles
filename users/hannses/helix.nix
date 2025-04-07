{ pkgs, ... }: {
  programs.helix = let
    typst-watch-script = pkgs.writeShellScript "watch-typst.sh" ''
      dir=$(${pkgs.mktemp}/bin/mktemp -d)
      _=$(${pkgs.typst}/bin/typst watch "$1" "$dir/tmp.pdf" & echo $! > "$dir/pid")&
      until [ -f "$dir/tmp.pdf" ]
      do
        sleep 0.5
      done
      pid=$(${pkgs.coreutils}/bin/cat "$dir/pid")
      ${pkgs.zathura}/bin/zathura "$dir/tmp.pdf"
      kill "$pid"
      rm -fr "$dir"
    '';
  in {
    enable = true;
    #defaultEditor = true; # leave nvim for now
    languages = {
      language-server = {
        rust-analyzer = {
          config.check.command = "clippy";
          command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
          cargo = { allFeatures = true; };
        };
        nil = {
          command = "${pkgs.nil}/bin/nil";
          nix = {
            flake = {
              autoArchive = false;
              autoEvalInputs = true;
            };
          };
        };
        ruff-lsp.command = "${pkgs.ruff}/bin/ruff";
      };
      language = [
        {
          name = "rust";
          auto-format = true;
        }
        {
          name = "typst";
          auto-format = true;
        }
        {
          name = "nix";
          formatter.command = "nix fmt -- --";
          auto-format = true;
        }
        { name = "cpp"; }
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

    settings = {
      theme = "material_deep_ocean";
      editor = {
        end-of-line-diagnostics = "hint";
        inline-diagnostics = { cursor-line = "warning"; };
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "block";
        };
      };
      keys.normal = {
        space.t.y = ":sh ${typst-watch-script} %{buffer_name} 2>/dev/null &";
      };
    };
  };
}
