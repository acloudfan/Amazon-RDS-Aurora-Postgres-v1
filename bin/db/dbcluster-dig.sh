#!/bin/bash
#DIGs the CLUSTER & READER Endpoints

SLEEP_TIME=5

echo "^C to stop the script."

OLD_WRITER_IP=$(dig $PGWRITEREP +short | tail -n1)
OLD_READER_IP=$(dig $PGREADEREP +short | tail -n1)

COUNTER=0
while true; do
    COUNTER=$(($COUNTER+1))
    NEW_WRITER_IP=$(dig $PGWRITEREP +short | tail -n1)
    NEW_READER_IP=$(dig $PGREADEREP +short | tail -n1)

    if [ "$OLD_WRITER_IP" != "$NEW_WRITER_IP" ]; then
        echo "***WRITER EP - IP Changed - $OLD_WRITER_IP  > $NEW_WRITER_IP "
    fi
    OLD_WRITER_IP=$NEW_WRITER_IP

    if [ "$OLD_READER_IP" != "$NEW_READER_IP" ]; then
        echo "***READER EP - IP Changed - $OLD_READER_IP > $NEW_READER_IP"
    fi
    OLD_READER_IP=$NEW_READER_IP

    SECS_PASSED=$(($COUNTER*$SLEEP_TIME))
    echo "$SECS_PASSED s  :  Writer IP=$NEW_WRITER_IP   Reader IP=$NEW_READER_IP"

    sleep $SLEEP_TIME
done;
