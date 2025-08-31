{ globals, config, ... }: ''
  ${globals.term} -e ${config.programs.yazi.package}
''
