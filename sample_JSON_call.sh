curl -X POST --silent --retry 3 --retry-delay 1 --max-time 30 "$API_EDGE/v2/agent/get_agent_file?file=trafikito.conf" \
    -H 'Cache-Control: no-cache' \
    -H 'Content-Type: application/json' \
    -d "{ \
        \"workspaceId\"  : \"$WORKSPACE_ID\", \
        \"userApiKey\": \"$USER_API_KEY\", \
        \"serverName\": \"$SERVER_NAME\", \
        \"tmpFilePath\": \"$TMP_FILE\" \
        }" >$TMP_FILE

grep -q server_id $TMP_FILE
if [ $? -ne 0 ]; then
    cat $TMP_FILE
    echo
    echo "Can not get configuration file. Network issue? Please try again."
    exit 1
fi
