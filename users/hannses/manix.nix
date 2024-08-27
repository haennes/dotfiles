{inputs, pkgs, system, ...}:
let
  manix_pkg = inputs.manix.packages."${system}".manix;
  manix = "${manix_pkg}/bin/manix";
  awk_cmd_2 = "awk '{for(i=5;i<=NF;i++) print $i}'";
in
{
  home.file.".local/state/nix/profiles/profile/share".source =  "${inputs.home-manager.packages."${system}".docs-json}/share";

  home.packages = [ manix_pkg ];
  programs.zsh.shellAliases =
  let
  sed = "${pkgs.gnused}/bin/sed";
  grep = "${pkgs.gnugrep}/bin/grep";
  fzf = "${pkgs.fzf}/bin/fzf";
  xargs = "${pkgs.findutils}/bin/xargs";
  generic_cmd_opts = optstr: ''
      ${manix} ${optstr} "" | ${grep} '^# ' | ${sed} 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | ${fzf} --preview="${manix} ${optstr} '{}'" | ${xargs} ${manix} ${optstr}
      '';
  manix_pkgs_awk = pkgs.writeShellScriptBin "manix_pkgs_awk" ''
          ${manix} --source nixpkgs-tree $1 | ${awk_cmd_2}
  '';
  manix_pkgs_awk_cmd = "${manix_pkgs_awk}/bin/manix_pkgs_awk";
  generic_cmd_pkgs = optstr:
      let
      awk_cmd = "awk '{for(i=5;i<=NF;i++) print $i}'";
      default_cmd = '' ${manix} ${optstr} "" | ${awk_cmd} '';
      in
      ''
      ${default_cmd} | ${fzf} --bind "change:reload:${manix_pkgs_awk_cmd} {q}" --ansi --phony --query ""
      '';
      #| ${fzf} --preview=\"${manix} ${optstr} '{}'\" | ${xargs} ${manix} ${optstr}
  in rec {

      all-nix-opt = generic_cmd_opts "";
      ano = all-nix-opt;

      nix-opt = generic_cmd_opts "--source=nixos-options";
      no = nix-opt;

      home-opt = generic_cmd_opts "--source=hm-options";
      ho = home-opt;


      nix-pkgs = generic_cmd_pkgs "--source nixpkgs-tree";
      pkgs = nix-pkgs;

  };
}
