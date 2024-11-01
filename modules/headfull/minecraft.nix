{ pkgs, ... }: {

  environment = {
    systemPackages = with pkgs; [
      atlauncher # minecraft launcher with mod support
      portablemc # minecraft launcher cmd
    ];

    etc = { "minecraft_deps/jre8".source = pkgs.jre8.outPath; };
  };
}
