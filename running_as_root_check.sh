# uses another custom function `fn_prompt`
# text is from Trafikito instalation left as sample, update it to your case

# running as root or user?
RUNAS=`whoami`
WHOAMI=`whoami`

if [ "$WHOAMI" != "root" ]; then
    echo "If possible, run installation as root user."
    echo "To install as root either log in as root and execute the script or use:"
    echo
    echo "  sudo sh $0 --user_api_key=$USER_API_KEY --workspace_id=$WORKSPACE_ID --servername=$SERVER_NAME"
    echo
    fn_prompt "N" "Continue as $WHOAMI [yN]: " || exit 1
    RUNAS="$WHOAMI"
fi
