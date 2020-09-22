# select which edge to use and which use as a fallback
API_EDGE="https://api.trafikito.com";

fn_select_edge ()
{
    API_EDGE_1="https://ap-southeast-1.api.trafikito.com"
    API_EDGE_2="https://eu-west-1.api.trafikito.com"
    API_EDGE_3="https://us-east-1.api.trafikito.com"

    # big range to avoid unequal random value distribution on some systems
    DEFAULT_EDGE=`awk 'BEGIN{srand();print int(rand()*(12000-1))+1 }'`
    if [ "$DEFAULT_EDGE" -gt 4000 ]; then
        API_EDGE_1="https://eu-west-1.api.trafikito.com"
        API_EDGE_2="https://us-east-1.api.trafikito.com"
        API_EDGE_3="https://ap-southeast-1.api.trafikito.com"
    fi

    if [ "$DEFAULT_EDGE" -gt 8000 ]; then
        API_EDGE_1="https://us-east-1.api.trafikito.com"
        API_EDGE_2="https://ap-southeast-1.api.trafikito.com"
        API_EDGE_3="https://eu-west-1.api.trafikito.com"
    fi

    testData=`curl -X POST --silent --retry 3 --retry-delay 1 --max-time 30 -H 'Cache-Control: no-cache' -H 'Content-Type: text/plain' "$API_EDGE_1/v2/ping"`
    if [ "$testData" = "OK" ]; then
        API_EDGE="$API_EDGE_1"
    else
      testData=`curl -X POST --silent --retry 3 --retry-delay 1 --max-time 30 -H 'Cache-Control: no-cache' -H 'Content-Type: text/plain' "$API_EDGE_2/v2/ping"`
        if [ "$testData" = "OK" ]; then
            API_EDGE="$API_EDGE_2"
        else
          testData=`curl -X POST --silent --retry 3 --retry-delay 1 --max-time 30 -H 'Cache-Control: no-cache' -H 'Content-Type: text/plain' "$API_EDGE_3/v2/ping"`
          if [ "$testData" = "OK" ]; then
              API_EDGE="$API_EDGE_3"
          else
            echo "Network issues? Try again."
          fi
        fi
    fi
}

fn_select_edge

echo "Edge selected: $API_EDGE"
