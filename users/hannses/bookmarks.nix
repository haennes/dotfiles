{ lib, config, globals, inputs, ... }: {
  imports = [ inputs.fs-bookmarks.homeManagerModules.default ];
  fs-bookmarks = {
    enable = true;
    useToplevelShellAliases = false; # default to false
    useDirectoryStack = true;
    set = {
      shell = {
        ion = true;
        bash = true;
        fish = true;
        nushell = true;
        zsh = true;
      };
      # yazi.yamb = true;
      yazi.whoosh = true;
    };
    bookmarks = let
      inherit (lib) range listToAttrs;
      home = config.home.homeDirectory;
      studium = "${home}/Documents/Studium";
      semester_max = 4;
      semester = listToAttrs (map (i: {
        name = toString i;
        value = "${studium}/Semester${toString i}";
      }) (range 1 semester_max));
    in rec {
      "down" = {
        tag = "Downloads";
        dir = "$HOME/Downloads";
        description = "The download directory";
      };
      dotf = dotfiles;
      dotfiles = { dir = "$HOME/.dotfiles"; };

      oth = { dir = semester.${toString semester_max}; };

      pro = { dir = "${home}/programming"; };

      fsim = { dir = "${studium}/FSIM"; };
      # Semester 1
      pg1 = { dir = "${semester."1"}/PG1"; };
      ma1 = { dir = "${semester."1"}/MA1"; };
      ph = { dir = "${semester."1"}/PH1"; };
      ti = { dir = "${semester."1"}/TI1"; };
      uws = { dir = "${semester."1"}/Umweltschutz_Einfuehrung"; };

      # Semester 2
      cs = { dir = "${semester."2"}/CS"; };
      ma = { dir = "${semester."2"}/MA2"; };
      rb = { dir = "${semester."2"}/RB"; };
      ge = { dir = "${semester."2"}/GE"; };
      pg = { dir = "${semester."2"}/PG2"; };

      # Semester 3
      ad = { dir = "${semester."3"}/AD"; };
      em = { dir = "${semester."3"}/EM"; };
      se = { dir = "${semester."3"}/SE"; };
      st = { dir = "${semester."3"}/ST"; };
      zock = { dir = "${semester."3"}/ZOCK/group"; };

      ks = { dir = "${semester."4"}/KS"; };
      os = { dir = "${semester."4"}/OS"; };
      DD = { dir = "${semester."4"}/DD"; };
      db = { dir = "${semester."4"}/DB"; };
      tt = { dir = "${semester."4"}/TTPG2"; };
      natu = { dir = "${semester."4"}/NATU"; };
    };
  };
}
