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
}
