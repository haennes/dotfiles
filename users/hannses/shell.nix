{
  pkgs,
  globals,
  scripts,
  joint-standalone,
  lib,
  ...
}:
let
  inherit (lib)
    getExe
    listToAttrs
    flatten
    map
    ;
  aliases = [
    "dticket"
    "ticket"
  ];
in
{
  home.shellAliases = {
    dbui = "${scripts.dbui_fzf}";
    gcpp = "${scripts.gcpp}";

    wwhich = "${scripts.wwhich}";

    loc = "${pkgs.tokei}/bin/tokei";

    dpdf = "${pkgs.diff-pdf}/bin/diff-pdf --view";

    rg = "${pkgs.ripgrep-all}/bin/rga";

    nix-build = "${pkgs.nix-output-monitor}/bin/nom-build --run $SHELL";
    nix-shell = "${pkgs.nix-output-monitor}/bin/nom-shell --run $SHELL";

    #settings this to pkgs fails
    vim = "nvim";
    vi = "nvim";

    df = "${pkgs.duf}/bin/duf";
    # path cds
    "..." = "cd  ../../"; # dont want to enable prezto
    "...." = "cd  ../../../"; # dont want to enable prezto
    "....." = "cd  ../../../../"; # dont want to enable prezto
    "......" = "cd  ../../../../../"; # dont want to enable prezto
    # ...... seems more than enough

    # config apply & build
    cfg_apply = "${globals.dotfiles_path}/apply";
    cfg_update = "pushd ${globals.dotfiles_path} && ${globals.dotfiles_path}/update && popd";
    fs_cfg_sync =
      let
        path = "/home/hannses/Documents/Studium/FSIM/server-pedro";
      in
      "rsync -r fs_main:/etc/nixos/ ${path}";

    fs_cfg_sync_jmp =
      let
        path = "/home/hannses/Documents/Studium/FSIM/server-pedro";
      in
      "rsync -r fs_main_jmp:/etc/nixos/ ${path}";

    # vim keybindings
    ":q" = "exit";

    udmount = "udiskctl mount -b";
    udumount = "udiskctl umount -b";
    mount_phone = "${pkgs.jmtpfs}/bin/jmtpfs";

    cat_tests = "${joint-standalone.c_cat_tests}";
    edit_tests = "${joint-standalone.c_edit_tests}";
    gen_tests = "${joint-standalone.c_gen_tests}";
    run_tests = "${joint-standalone.c_run_tests}";

    ttask = getExe pkgs.taskwarrior-tui;

  }
  // listToAttrs (
    flatten (
      map (name: [
        {
          name = "${name}_bak";
          value = "${scripts.deutschland_ticket_pdf}";
        }
        {
          name = "${name}_bak_bak";
          value = "${scripts.deutschland_ticket_screenshot}";
        }
        {
          name = name;
          value = "${scripts.deutschland_ticket_firefox}";
        }
      ]) aliases
    )
  );
}
