#!/bin/bash

EADTMPSTASH='/tmp/yegarena'
EADDIR='/home/denis/yegarena'
EADHOST='frosty.incoherency.net'
EADHOSTPATH='public_html/yegarena'

# Create the working dir in tmp
if [ ! -d $EADTMPSTASH ]; then
	/bin/mkdir $EADTMPSTASH
fi

# Papa-paparazzi
/usr/bin/fswebcam -c $EADDIR/fswebcam.conf

# Copy the images and remove locals on success
for file in $EADTMPSTASH/output-*; do scp "$file" $EADHOST:$EADHOSTPATH && rm "$file" ; done

# Append the remote log file
cat $EADTMPSTASH/webcamlog.txt | ssh $EADHOST "cat >> $EADHOSTPATH/webcamlog.txt" && rm $EADTMPSTASH/webcamlog.txt

/usr/bin/ssh $EADHOST $EADHOSTPATH/link.sh
