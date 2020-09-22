#!/usr/bin/env sh

export BASEDIR=$1

# create prev logs file and clear current logs file
export LOGFILE=$BASEDIR/logs.log
if [ -f $LOGFILE ]; then
  # This would always clean up log file and put older log to logs.log.prev file
  cp $LOGFILE $LOGFILE.prev
  echo "" >$LOGFILE
  # if want to better keep last 1000 lines of log to bak file, use this:
  # cp $LOGFILE $LOGFILE.bak
  # tail -n 1000 $LOGFILE.bak >$LOGFILE
fi

###################################################
# functions to handle logs instead of using syslog
###################################################

DEBUG=1
VERBOSE=1

fn_log() {
  echo "$(date +'%x %X') $*" >>"$LOGFILE"
  if [ "$VERBOSE" ]; then
    echo "$(date +'%x %X') $*"
  fi
}

fn_debug() {
  if [ "$DEBUG" ]; then
    fn_log "DEBUG $*"
  fi
}
