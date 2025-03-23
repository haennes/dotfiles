{ pkgs, ... }: {
  home.packages = with pkgs; [
    gitui # switch to neogit
    git-crypt # should be obsolete
  ];
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "haennes";
    userEmail = "hannes.hofmuth@gmail.com";
    signing = {
      key = null;
      signByDefault = true;
    };
    extraConfig = {
      init = { defaultBranch = "main"; };
      push.autoSetupRemote = true;
    };
  };
  programs.zsh.shellAliases = {
    gitcpr = "${pkgs.writeShellScript "gitcpr" ''
      pr=$1
      shift
      set -x
      git fetch $@ pull/$pr/head:pr_$pr
      git switch pr_$pr
    ''}";
    gitam = "git commit --amend --no-edit";
  };
}
