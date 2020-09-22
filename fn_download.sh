# It's from Trafikito agent installation. It has a list of files to be downloaded from API endpoint and it just tries to get it. Has some retry mechanism in case of network issues.

fn_download ()
{
    count=$1
    file=$2

    url="$API_EDGE/v2/agent/get_agent_file?file=$file"
    curl -X POST --silent --retry 3 --retry-delay 1 --max-time 30 --output "$BASEDIR/$file" -H 'Cache-Control: no-cache' -H 'Content-Type: text/plain' "$url" > /dev/null
    if [ ! -f "$BASEDIR/$file" ]; then
        echo "*** $count/5 Failed to download. Retrying."
        curl -X POST --silent --retry 3 --retry-delay 1 --max-time 60 --output "$BASEDIR/$file" -H 'Cache-Control: no-cache' -H 'Content-Type: text/plain' "$url" > /dev/null
        if [ ! -f "$BASEDIR/$file" ]; then
            echo "*** $count/5 Failed to download. Retrying."
            curl -X POST --silent --retry 3 --retry-delay 1 --max-time 60 --output "$BASEDIR/$file" -H 'Cache-Control: no-cache' -H 'Content-Type: text/plain' "$url" > /dev/null
            if [ ! -f "$BASEDIR/$file" ]; then
                echo "*** $count/5 Failed to download: $file"
                exit 1;
            fi
        fi
    else
        echo "*** $count/5 done"
    fi
}

echo "*** Starting to download agent files"
# during download - set which edge to use for future requests during installation
fn_download 1 trafikito
fn_download 2 uninstall.sh
fn_download 3 lib/trafikito_wrapper.sh
fn_download 4 lib/trafikito_agent.sh
fn_download 5 lib/set_os.sh


########################################## 2nd sample of similart thing ###################
fn_get_download_endpoint()
{
 echo "$API_EDGE/v2/agent/get_agent_file?file=$1"
}

fn_upgrade()
{
    fn_debug "*** Starting to download agent files"
    curl -X POST --silent --retry 3 --retry-delay 1 --max-time 30 -H 'Cache-Control: no-cache' -H 'Content-Type: text/plain' --output "${BASEDIR}/trafikito" `fn_download trafikito` > /dev/null
    fn_check_curl_error $? "downloading trafikito"
    fn_debug "*** 1/5 done"
    curl -X POST --silent --retry 3 --retry-delay 1 --max-time 30 -H 'Cache-Control: no-cache' -H 'Content-Type: text/plain' --output "${BASEDIR}/uninstall.sh" `fn_download uninstall.sh` > /dev/null
    fn_check_curl_error $? "downloading uninstall"
    fn_debug "*** 2/5 done"
    curl -X POST --silent --retry 3 --retry-delay 1 --max-time 30 -H 'Cache-Control: no-cache' -H 'Content-Type: text/plain' --output "${BASEDIR}/lib/trafikito_wrapper.sh" `fn_download lib/trafikito_wrapper.sh` > /dev/null
    fn_check_curl_error $? "downloading wrapper"
    fn_debug "*** 3/5 done"
    curl -X POST --silent --retry 3 --retry-delay 1 --max-time 30 -H 'Cache-Control: no-cache' -H 'Content-Type: text/plain' --output "${BASEDIR}/lib/trafikito_agent.sh" `fn_download lib/trafikito_agent.sh` > /dev/null
    fn_check_curl_error $? "downloading agent"
    fn_debug "*** 4/5 done"
    curl -X POST --silent --retry 3 --retry-delay 1 --max-time 30 -H 'Cache-Control: no-cache' -H 'Content-Type: text/plain' --output "${BASEDIR}/lib/set_os.sh" `fn_download lib/set_os.sh` > /dev/null
    fn_check_curl_error $? "downloading set_os"
    fn_debug "*** 5/5 done"

    chmod +x $BASEDIR/trafikito $BASEDIR/uninstall.sh $BASEDIR/lib/*
}

if [ "$AGENT_VERSION" != "$AGENT_NEW_VERSION" ]; then
    fn_log "Changing this agent (version $AGENT_VERSION) to version $AGENT_NEW_VERSION"
    fn_upgrade
fi



