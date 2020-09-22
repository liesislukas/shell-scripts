# Chek if systemd, System V or openRC is available on server and configure running Trafikito agent on one of these mechanics. Also prepare remove script.

#####################################
# systemd: test for useable systemctl
#####################################
x=`which systemctl 2>/dev/null`
if [ $? -eq 0 ]; then
    echo "You are running systemd..."
    echo "Configuring, enabling and starting the agent service..."
    (
    echo "[Unit]"
    echo "Description=Trafikito Agent"
    echo "After=network.target"
    echo "[Service]"
    echo "Type=simple"
    echo "ExecStart=$BASEDIR/lib/trafikito_wrapper.sh $SERVER_ID $BASEDIR"
    echo "[Install]"
    echo "WantedBy=multi-user.target"
    ) >/etc/systemd/system/trafikito.service
    (
    echo "echo Disabling and removing systemd"
    echo "systemctl stop trafikito"
    echo "systemctl disable trafikito"
    echo "rm -f /etc/systemd/system/trafikito.service"
    ) >$BASEDIR/lib/remove_startup.sh
    chown $RUNAS $BASEDIR/lib/remove_startup.sh
    systemctl enable trafikito
    systemctl start trafikito
    systemctl status trafikito --no-pager

    # remove script to manually control trafikito
    # rm $BASEDIR/trafikito
    echo
    echo "Done. You will see data at dashboard after a minute."
    echo
    echo
    echo
    echo "Manual control with:"
    echo "  $BASEDIR/trafikito {start|stop|restart|status}"
    echo
    echo "Uninstall with:"
    echo "  sh $BASEDIR/uninstall"
    echo

    exit 0
fi

#################################################################
# System V startup
#################################################################
control=`which update-rc.d 2>/dev/null`    # debian/ubuntu
if [ $? -ne 0 ]; then
    control=`which chkconfig 2>/dev/null`  # mostly everything else
fi
if [ ! -z "$control" ]; then
    echo "System V using $control is available on this server..."
    echo "Configuring, enabling and starting the agent service..."
    (
    echo "#!/bin/sh"
    echo "#"
    echo "# chkconfig: 345 56 50"
    echo "#"
    echo "### BEGIN INIT INFO"
    echo "# Provides:          trafikito"
    echo "# Required-Start:"
    echo "# Required-Stop:"
    echo "# Should-Start:"
    echo "# Should-Stop:"
    echo "# Default-Start:"
    echo "# Default-Stop:"
    echo "# Short-Description: Starts or stops the trafikito agent"
    echo "# Description:       Starts and stops the trafikito agent"
    echo "### END INIT INFO"
    echo
    # remove hash bang and redefine BASEDIR
    grep -v '#!' $BASEDIR/trafikito | sed -e "s#export BASEDIR.*#export BASEDIR=$BASEDIR#"
    ) >/etc/init.d/trafikito
    chmod +x /etc/init.d/trafikito

    case $control in
        *update-rc.d)
            (
            echo "echo Removing System V startup"
            echo "service trafikito stop"
            echo "update-rc.d -f trafikito remove"
            echo "rm -f /etc/init.d/trafikito"
            ) >$BASEDIR/lib/remove_startup.sh
            chown $RUNAS $BASEDIR/lib/remove_startup.sh
            update-rc.d trafikito defaults 99
            update-rc.d trafikito enable
            service trafikito start
            ;;
        *chkconfig)
            (
            echo "echo Removing System V startup"
            echo "service trafikito stop"
            echo "chkconfig --del trafikito"
            echo "rm -f /etc/init.d/trafikito"
            ) > $BASEDIR/lib/remove_startup.sh
            chown $RUNAS $BASEDIR/lib/remove_startup.sh
            chkconfig --add trafikito
            chkconfig trafikito on
            service trafikito start
            ;;
    esac

    # remove script to manually control trafikito
    # rm $BASEDIR/trafikito

    echo
    echo "Done. You will see data at dashboard after a minute."
    echo
    echo
    echo
    echo "Manual control with:"
    echo "  $BASEDIR/trafikito {start|stop|restart|status}"
    echo
    echo "Uninstall with:"
    echo "  sh $BASEDIR/uninstall"
    echo

    exit 0
fi

#################################################################
# openRC: Arch + Gentoo
#################################################################
control=`which rc-update`
if [ ! -z "$control" ]; then
    echo "openRC is available on this server..."
    echo "Configuring, enabling and starting the agent service..."
    (
    # remove hash bang and redefine BASEDIR
    cat $BASEDIR/trafikito | sed -e "s#export BASEDIR.*#export BASEDIR=$BASEDIR#"
    ) >/etc/init.d/trafikito
    chmod +x /etc/init.d/trafikito
    (
    echo "echo Removing openRC startup"
    echo "rc-service trafikito stop"
    echo "rc-update del trafikito"
    echo "rm -f /etc/init.d/trafikito"
    ) >$BASEDIR/lib/remove_startup.sh
    chown $RUNAS $BASEDIR/lib/remove_startup.sh
    rc-update add trafikito
    rc-service trafikito start

    # remove script to manually control trafikito
    # rm $BASEDIR/trafikito

    echo
    echo "Done. You will see data at dashboard after a minute."
    echo
    echo
    echo
    echo "Manual control with:"
    echo "  $BASEDIR/trafikito {start|stop|restart|status}"
    echo
    echo "Uninstall with:"
    echo "  sh $BASEDIR/uninstall"
    echo

    exit 0
fi

echo "Could not determine the startup method on this server"
