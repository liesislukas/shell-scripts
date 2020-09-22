#!/usr/bin/env sh

export BASEDIR=$1

# create prev logs file and clear current logs file
export LOGFILE=$BASEDIR/logs.log
if [ -f $LOGFILE ]; then
  cp $LOGFILE $LOGFILE.prev
  echo "" >$LOGFILE
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
