{ favicon, updateInterval, ... }: {
  "Rust Std" = {
    urls =
      [{ template = "https://doc.rust-lang.org/std/?search={searchTerms}"; }];
    icon = "https://www.rust-lang.org/static/images/rust-logo-blk.svg";
    inherit updateInterval;
    definedAliases = [ "<rsd" ];
  };

  "Crates.io" = {
    urls = [{ template = "https://crates.io/search?q={searchTerms}"; }];
    icon = "https://crates.io/assets/cargo.png";
    inherit updateInterval;
    definedAliases = [ "<cr" ];
  };

  "Pip / PyPi" = {
    urls = [{ template = "https://pypi.org/search/?q={searchTerms}"; }];
    icon = "https://www.python.org/static/opengraph-icon-200x200.png";
    inherit updateInterval;
    definedAliases = [ "<pip" "<py" ];
  };
  "ascii" = {
    urls =
      [{ template = "https://typst.app/tools/ascii-table/#q={searchTerms}"; }];
    definedAliases = [ "<ascii" "<char" ];
    icon = favicon "typst.app";
    inherit updateInterval;
  };

}
