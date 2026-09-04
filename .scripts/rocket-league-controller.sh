#!/usr/bin/env bash

# Current hour (00–23)
HOUR=$(/usr/bin/date +%H)

# Convert to decimal (avoid octal issues with leading zero)
HOUR=$((10#$HOUR))

# if [ "$HOUR" -ne 13 ] && \
#    [ "$HOUR" -ne 20 ] && \
#    [ "$HOUR" -ne 21 ] ; then
#   /usr/bin/pkill -f RocketLeague
# fi

case "$HOUR" in
  12|13|20|21)
    ;; # do nothing
  *)
    /usr/bin/pkill -f RocketLeague
    /usr/bin/pkill -f steam
    ;;
esac
