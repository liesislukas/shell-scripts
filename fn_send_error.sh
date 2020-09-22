fn_send_error() {
    errcode=$1
    errfile=$2
    message=$3
    details=$4
    fn_log "** ERROR: $message"
    # test age of error
    last=0
    if [ -f "$BASEDIR/error.$errcode" ]; then
        last=`cat $BASEDIR/error.$errcode`
    fi
    now=`date +%s`
    age=$(( now - last ))
    # report same error once per 1 minute
    if [ $age -gt 60 ]; then
        fn_log "         reporting error to trafikito"
        ###############################################################################
        curl --request POST --silent --retry 3 --retry-delay 10 --max-time 30 \
              --url "$API_EDGE/v2/agent/error_feedback" \
              --header 'cache-control: no-cache' \
              --header 'content-type: multipart/form-data' \
              -F "code=$errcode" \
              -F "message=$message" \
              -F "details=$details" \
              -F "serverApiKey=$API_KEY"

        fn_check_curl_error $? 'sending error'
        ###############################################################################
        fn_log "         done"
        echo $now >$BASEDIR/var/error-$errcode
    else
        fn_log "          not reported to Trafikito"
    fi
}
