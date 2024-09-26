{ config, pkgs, lib, inputs, system, ... }:
let
  home = config.home.homeDirectory;
  dotfiles_path = "${home}/.dotfiles";
in {
  home.packages = with pkgs; [ nom eza tokei ];
  programs.zsh = {
    enable = true;
    shellAliases = let
      deutschland_ticket_pdf = pkgs.writeShellScriptBin "deutschland_ticket_pdf"
        "${pkgs.zathura}/bin/zathura --mode=fullscreen ${home}/Documents/DeutschlandTicket.pdf";
      deutschland_ticket_firefox =
        pkgs.writeShellScriptBin "deutschland_ticket_firefox"
        "${pkgs.firefox}/bin/firefox --new-window https://dticket-fuer-studenten.rvv.de/account/tickets";
      deutschland_ticket_screenshot =
        pkgs.writeShellScriptBin "deutschland_ticket_screenshot"
        "${pkgs.feh}/bin/feh -FZ ${home}/Documents/DeutschlandTicket.png";
      dbui_script = pkgs.writeShellScriptBin "dbui" ''
        input=$( \
          echo "${lib.concatLines [ "browser" "pdf" "screenshot" ]}" \
          | ${pkgs.fzf}/bin/fzf)
        case $input in
          browser)
            ${deutschland_ticket_firefox}/bin/deutschland_ticket_firefox
          ;;
          pdf)
            ${deutschland_ticket_pdf}/bin/deutschland_ticket_pdf
          ;;
          screenshot)
            ${deutschland_ticket_screenshot}/bin/deutschland_ticket_screenshot
          ;;
        esac
      '';

      aliases = [ "dticket" "ticket" "db" ];

    in rec {
      #manix and its aliases are configured in ./manix.nix
      dbui = "${dbui_script}/bin/dbui";

      loc = "${pkgs.tokei}/bin/tokei";
      bc = "${pkgs.fend}/bin/fend";

      dpdf = "${pkgs.diff-pdf}/bin/diff-pdf --view";

      rg = "${pkgs.ripgrep-all}/bin/rg";

      nix-build = "${pkgs.nix-output-monitor}/bin/nom-build";
      nix-shell = "${pkgs.nix-output-monitor}/bin/nom-shell";

      #settings this to pkgs fails
      vim = "nvim";
      vi = "nvim";

      ls = "${pkgs.eza}/bin/eza -lh";
      sl = ls;
      la = "${ls} -A";

      df = "${pkgs.duf}/bin/duf";
      # path cds
      dotfiles = "cd ${dotfiles_path}";
      dotf = dotfiles;

      oth = "cd ${home}/Documents/Studium/Semester1";
      down = "cd ${home}/Downloads";

      pro = "cd ${home}/programming";

      pg = "${oth}/PG1";
      ma = "${oth}/MA1";
      ph = "${oth}/PH1";
      ti = "${oth}/TI1";
      uws = "${oth}/Umweltschutz_Einfuehrung";

      "..." = "cd  ../../"; # dont want to enable prezto
      "...." = "cd  ../../../"; # dont want to enable prezto
      "....." = "cd  ../../../../"; # dont want to enable prezto
      "......" = "cd  ../../../../../"; # dont want to enable prezto
      # ...... seems more than enough

      # config apply & build
      cfg_apply = "${dotfiles_path}/apply";
      cfg_update = "pushd ${dotfiles_path} && ${dotfiles_path}/update && popd";

      # vim keybindings
      ":q" = "exit";

      udmount = "udiskctl mount -b";
      udumount = "udiskctl umount -b";

    } // lib.listToAttrs (lib.flatten (lib.lists.map (name: [
      {
        name = "${name}_bak";
        value = "${deutschland_ticket_pdf}/bin/deutschland_ticket_pdf";
      }
      {
        name = "${name}_bak_bak";
        value =
          "${deutschland_ticket_screenshot}/bin/deutschland_ticket_screenshot";
      }
      {
        name = name;
        value = "${deutschland_ticket_firefox}/bin/deutschland_ticket_firefox";
      }
    ]) aliases));
    initExtra = ''
      catcp () {
        cat "$1" | wl-copy
      }
      mkcdir ()
        {
          mkdir -p -- "$1" &&
          cd -P -- "$1"
        }
      runc ()
        {
          gcc "$1" &&
          ./a.out
        }
    '';

    autocd = true;
    autosuggestion.enable = true;
    defaultKeymap = "vicmd";
    history = {
      expireDuplicatesFirst = true;
      ignoreDups = true;
      share = true;
      size = 10000;
    };
  };
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv = { enable = true; };
  };
  programs.thefuck.enable = true;
}
