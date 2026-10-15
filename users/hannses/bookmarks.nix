{
  lib,
  config,
  ...
}:
{
  my.office.files.bookmarks.enable = true;
  fs-bookmarks.bookmarks =
    let
      inherit (lib) range listToAttrs;
      home = config.home.homeDirectory;
      studium = "${home}/Documents/Studium";
      semester_curr = 6;
      semester = listToAttrs (
        map (i: {
          name = toString i;
          value = "${studium}/Semester${toString i}";
        }) (range 1 7)
      );
      semdir = s: n: { dir = "${semester."${toString s}"}/${n}"; };
    in
    rec {
      "down" = {
        tag = "Downloads";
        dir = "$HOME/Downloads";
        description = "The download directory";
      };
      dotf = dotfiles;
      dotfiles = {
        dir = "$HOME/.dotfiles";
      };

      oth = {
        dir = semester.${toString semester_curr};
      };

      pro = {
        dir = "${home}/programming";
      };

      fsim = {
        dir = "${studium}/FSIM";
      };
      # Semester 1
      pg1 =  semdir 1 "PG1";
      ma1 =  semdir 1 "MA1";
      ph =  semdir 1 "PH1";
      ti =  semdir 1 "TI1";
      uws =  semdir 1 "Umweltschutz_Einfuehrung";

      # Semester 2
      cs = semdir 2 "CS";
      ma = semdir 2 "MA2";
      rb = semdir 2 "RB";
      ge = semdir 2 "GE";
      pg = semdir 2 "PG2";

      # Semester 3
      ad = semdir 3 "AD";
      em = semdir 3 "EM";
      se = semdir 3 "SE";
      st = semdir 3 "ST";
      zock = semdir 3 "ZOCK/group";

      ks = semdir 4 "KS";
      os = semdir 4 "OS";
      DD = semdir 4 "DD";
      db = semdir 4 "DB";
      tt = semdir 4 "TTPG2";
      natu = semdir 4 "NATU";

      praxisbericht = semdir 5 "praxisbericht";
      seminararbeit = semdir 5 "seminararbeit";

      dcmd = semdir 6 "DCMC";
      fem = semdir 6 "FEM";
      is = semdir 6 "IS";
      pti = semdir 6 "PTI";
      tgi = semdir 6 "TGI";

      ba = semdir 7 "BA";
      sv = semdir 7 "SV";
    };
}
