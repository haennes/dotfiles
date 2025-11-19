{ pkgs, ... }: {
  home.packages = with pkgs; [
    gitui # switch to neogit
    git-crypt # should be obsolete
  ];
  programs.git = {
    enable = true;
    lfs.enable = true;
    signing = {
      key = null;
      signByDefault = true;
    };
    settings = {
      user.name = "haennes";
      user.email = "hannes.hofmuth@gmail.com";
      init = { defaultBranch = "main"; };
      push.autoSetupRemote = true;
    };
  };
  programs.lazygit = {
    enable = true;
    settings = { git.overrideGpg = true; };
  };
  programs.zsh.shellAliases = {
    gitcpr = "${pkgs.writeShellScript "gitcpr" (''
      pr=$1
      remote=$2
      shift
      if [ ! -z "$remote" ]; then
        shift
      fi
      shift
      set -x
      git fetch $'' + ''
        {remote:-origin} pull/$pr/head:pr_$pr
              git switch pr_$pr $@
      '')}";
    gitcmr = "${pkgs.writeShellScript "gitcmr" (''
      mr=$1
      remote=$2
      shift
      if [ ! -z "$remote" ]; then
        shift
      fi
      set -x
      git fetch $'' + ''
        {remote:-origin} merge-requests/$mr/head:mr_$mr
                      git switch mr_$mr $@
      '')}";
    gitam = "git commit --amend --no-edit";
  };
}
