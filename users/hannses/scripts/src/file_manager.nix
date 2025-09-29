{ globals, config, lib, ... }: ''
  ${globals.term} -e ${lib.getExe config.programs.yazi.package}
''
