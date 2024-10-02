{ pkgs, scripts, lib, ... }: ''
  input=$( \
    echo "${lib.concatLines [ "browser" "pdf" "screenshot" ]}" \
    | ${pkgs.fzf}/bin/fzf)
  case $input in
    browser)
      ${scripts.deutschland_ticket_firefox}/bin/deutschland_ticket_firefox
    ;;
    pdf)
      ${scripts.deutschland_ticket_pdf}/bin/deutschland_ticket_pdf
    ;;
    screenshot)
      ${scripts.deutschland_ticket_screenshot}/bin/deutschland_ticket_screenshot
    ;;
  esac
''
