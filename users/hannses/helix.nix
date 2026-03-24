{
  pkgs,
  config,
  lib,
  ...
}:
{
  home.file.".config/clangd/config.yaml".text = ''
    CompileFlags:                                                                                                                                                                                          
      Add: [                                                                                                                                                                                               
        "-isystem", "${pkgs.gcc.cc}/include/c++/${pkgs.gcc.version}",                                                                                                                                      
        "-isystem", "${pkgs.gcc.cc}/include/c++/${pkgs.gcc.version}/${pkgs.stdenv.hostPlatform.config}",                                                                                                   
        "-isystem", "${pkgs.gcc.cc}/lib/gcc/${pkgs.stdenv.hostPlatform.config}/${pkgs.gcc.version}/include",                                                                                               
        "-isystem", "${pkgs.glibc.dev}/include",                                                                                                                                                           
        "-L${pkgs.gcc.cc}/lib",                                                                                                                                                                            
        "-Wno-unknown-attributes",                                                                                                                                                                         
        "-fno-ms-extensions"                                                                                                                                                                               
      ]                                                                                                                                                                                                    
  '';
  programs.helix =
    let
      zathura = lib.getExe pkgs.zathura;
      typst-watch-script = pkgs.writeShellScript "watch-typst.sh" ''
        dir=$(${pkgs.mktemp}/bin/mktemp -d)
        _=$(${pkgs.typst}/bin/typst watch "$1" "$dir/tmp.pdf" & echo $! > "$dir/pid")&
        until [ -f "$dir/tmp.pdf" ]
        do
          sleep 0.5
        done
        pid=$(${pkgs.coreutils}/bin/cat "$dir/pid")
        ${zathura} "$dir/tmp.pdf"
        kill "$pid"
        rm -fr "$dir"
      '';
      getPdfName = pkgs.writeShellScript "get_pdf_name" ''
        file=$1

        ${zathura} "''${file%.*}.pdf"
      '';
    in
    {
      enable = true;
      defaultEditor = true;
      extraPackages = with pkgs; [
              # keep-sorted start
        rust-analyzer
        nil
        ruff
        pyright
        black
        clang-tools
        gcc
        lldb
        nix
        tinymist
        bash-language-server
        typstyle
        yazi
        lazygit
        config.programs.nix-search-tv-script.outputPackage
        xdg-utils
        dhall-lsp-server
        dhall
              # keep-sorted end

      ];
      languages = {
        language-server = {
          pyright = {
            command = "pyright-langserver";
            args = [ "--stdio" ];
          };
          rust-analyzer = {
            config.check.command = "clippy";
            command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
            config.cargo = {
              allFeatures = true;
            };
            formatting.command = [ "${pkgs.rustfmt}/bin/rustfmt" ];
          };
          clangd1 = {
            command = "clangd";
            args = [
              "--background-index"
              "--fallback-style=llvm"
            ];
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
          ruff-lsp = {
            command = "${pkgs.ruff}/bin/ruff";
            args = [ "server" ];
            environment = {
              "RUFF_TRACE" = "messages";
            };

          };
          tinymist = {
            command = "${lib.getExe pkgs.tinymist}";
            config = {
              exportPdf = "onType";
              showExportFileIn = "systemDefault"; # auto open still broken
              outputPath = "$root/$dir/$name";
            };
          };
        };
        language = [
          {
            name = "rust";
            auto-format = true;
          }
          {
            name = "typst";
            formatter.command = "typstyle";
            language-servers = [ "tinymist" ];
            auto-format = true;
          }
          {
            name = "cpp";
            auto-format = true;
            language-servers = [ "clangd1" ];
          }
          {
            name = "python";
            language-servers = [
              "pyright"
              "ruff-lsp"
            ];

            # In case you'd like to use ruff alongside black for code formatting:
            formatter = {
              command = "black";
              args = [
                "--quiet"
                "-"
              ];
            };
            auto-format = true;
          }
          { name = "diff"; }
          { name = "dhall"; }
        ];
      };

      settings = {
        theme = "material_deep_ocean";
        editor = {
          end-of-line-diagnostics = "hint";
          inline-diagnostics = {
            cursor-line = "warning";
          };
          cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "block";
          };
          line-number = "relative";
          # word-completion = {
          #   enable = true;
          #   trigger-length = 3;
          # };

          mouse = false;
        };
        keys.normal = {
          space.t.Y = ":sh ${typst-watch-script} %{buffer_name} 2>/dev/null &";
          space.t.y = [
            ":lsp-workspace-command tinymist.doStartPreview"
            '':sh ${getPdfName} "%{file_path_absolute}" 2>/dev/null''
            ":lsp-workspace-command tinymist.doKillPreview"
          ];
          space.z.y = [
            ":sh rm -f /tmp/unique-file"
            ":insert-output yazi %{buffer_name} --chooser-file=/tmp/unique-file"
            '':insert-output echo "\x1b[?1049h\x1b[?2004h" > /dev/tty''
            ":open %sh{cat /tmp/unique-file}"
            ":redraw"
          ];
          space.l.g = [
            ":new"
            ":insert-output lazygit"
            ":buffer-close!"
            ":redraw"
          ];
          space.n.s = [
            ":new"
            ":insert-output ${lib.getExe config.programs.nix-search-tv-script.outputPackage}"
            ":buffer-close!"
            ":redraw"
          ];
          space.t.w = [
            ":new"
            ":insert-output ${lib.getExe pkgs.taskwarrior-tui}"
            ":buffer-close!"
            ":redraw"

          ];
        };
      };
    };
}
