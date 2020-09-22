# kill any running instances of `trafikito_wrapper.sh`
kill $(ps aux | awk '/trafikito_wrapper.sh/ {print $2}') >/dev/null 2>&1
