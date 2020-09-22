# another way to promt. This time direct "yes" answer is required

echo -n "2/2: Do you want to remove the Trafikto agent files in $BASEDIR? (type 'yes' to continue): "; read x
if [ "$x" != 'yes' ]; then
    echo "** Uninstall aborted!"
    exit 0
fi
