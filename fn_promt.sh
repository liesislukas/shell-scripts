
####### USAGE ######
# fn_prompt "N" "Continue as $WHOAMI [yN]: " || exit 1
#
# fn_prompt "Y" "Going to install Trafikito in $BASEDIR [Yn]: "
# if [ $? -eq 0 ]; then
#   echo "No agreed. Do something."
# fi
#
#
# fn_prompt "Y" "Going to install Trafikito in $BASEDIR [Yn]: "
# if [ $? -eq 1 ]; then
#   echo "Agreed. Do something."
# fi
#
#


# use printf (a shell builtin) here because echo is *very* distro dependant
fn_prompt() {
  default=$1
  message=$2
  # if not running with a tty returns $default
  if [ ! "$(tty)" ]; then
    return 1
  fi
  while true; do
    printf "%s " "$message"
    read -r x
    if [ -z "$x" ]; then
      answer="$default"
    else
      case "$x" in
      y* | Y*) answer=Y ;;
      n* | N*) answer=N ;;
      *)
        echo "Please reply y or n"
        continue
        ;;
      esac
    fi
    if [ "$answer" = "$default" ]; then
      return 1
    else
      return 0
    fi
  done
}
