# when need to check if some tools are available and if not - try to install it or ask user to do it for you.
# defined function `fn_install_tools` which is compatible with Debian, RedHat, Alpine, Arch and SuSE package managers
# then defines all tools needed with some description for user
# then loops through required tools and tries to install if is root, if not - makes a list for user and prints out.
# uses custom fn_prompt which can be found in this repo to confirm action.


# function to install tools
fn_install_tools() {
    TOOLS=$*
    if [ `which apt-get` ]; then # Debian
        apt-get install $TOOLS
    elif [ `which yum` ]; then # RedHat
        yum -y install $TOOLS
    elif [ `which apk` ]; then # alpine
        apk --no-cache add $TOOLS
    elif [ `which pacman` ]; then # arch
        pacman -S add $TOOLS
    elif [ `which zypper` ]; then # SuSE
        zypper install $TOOLS
    else
        echo "  ERROR: your system's package manager is not supported"
        echo "    Supported package managers: apt-get, yum, apk, pacman, zypper"
        return 1
    fi
}
echo "* Looking for required commands..."
TOOLS=''
set "curl"   "transfer an url (essential)"\
    "df"     "report file system disk space usage"\
    "free"   "report amount of free and used memory in the system"\
    "egrep"  "print lines matching a pattern"\
    "pgrep"  "look up or signal processes based on name and other attributes"\
    "sed"    "stream editor for filtering and transforming text"\
    "su"     "change user ID or become superuser"\
    "top"    "display processes"\
    "uptime" "tell how long the system has been running"\
    "vmstat" "report virtual memory statistics"
while [ $# -ne 0 ]; do
    tool=$1
    help=$2
    shift 2
    printf "  $tool: $help..."
    x=`which $tool` 2>/dev/null
    if [ -z $x ]; then
        TOOLS="$TOOLS$tool "
        echo NOT FOUND
    else
        echo found $x
    fi
done

if [ -z $TOOLS ]; then
    echo
    echo "  Found all required commands"
else
    if [ $WHOAMI = 'root' ]; then
        fn_prompt "Y" "Shall I install missing tools? [Yn]: "
        if [ $? -eq 1 ]; then
            fn_install_tools $TOOLS
        else
            echo
            echo "  Please install the following tools as root: $TOOLS"
        fi
    else
        echo
        echo "  Please install the following tools as root: $TOOLS"
    fi
fi
