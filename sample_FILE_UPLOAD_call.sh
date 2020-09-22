echo "* Getting available commands file & setting default dashboard"
curl --request POST --silent --retry 3 --retry-delay 1 --max-time 30 \
     --url    "$API_EDGE/v2/agent/get_agent_file?file=available_commands.sh" \
     --header "content-type: multipart/form-data" \
     --form   "output=@$TMP_FILE" \
     --form   "userApiKey=$USER_API_KEY" \
     --form   "workspaceId=$WORKSPACE_ID" \
     --form   "serverId=$SERVER_ID" \
     --form   "os=$os" \
     --form   "osCodename=$os_codename" \
     --form   "osRelease=$os_release" \
     --form   "centosFlavor=$centos_flavor" \
     --output "$BASEDIR/available_commands.sh"
echo
echo "  done"
