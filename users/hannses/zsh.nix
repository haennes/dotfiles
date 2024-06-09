{ config, pkgs, ... }:
let
  home = config.home.homeDirectory;
  dotfiles_path = "${home}/.dotfiles";
in {
  home.packages = with pkgs; [ nom eza ];
  programs.zsh = {
    enable = true;
    shellAliases = rec {
      dticket = "${pkgs.zathura}/bin/zathura --mode=fullscreen ${home}/Documents/DeutschlandTicket.pdf";
      ticket = dticket;
      db = dticket;

      #nix = "nom";
      nix-build = "nom-build";
      nix-shell = "nom-shell";

      vim = "nvim";
      vi = "nvim";

      ls = "eza -lh";
      sl = "ls";
      la = "eza -Alh";
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
      cfg_build = "${dotfiles_path}/build";
      cfg_repl = "${dotfiles_path}/repl";

      # vim keybindings
      ":q" = "exit";
    };
    initExtra = ''
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
