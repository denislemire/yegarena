#!/bin/bash

#
# Script to gather images for the EAD time-lapse
#
# http://www.denis.lemire.name/yegarena/
#
# Denis Lemire, 2014
#

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
for file in $(/bin/ls -1t $EADTMPSTASH/output-*)
do
	scp -p "$file" $EADHOST:$EADHOSTPATH

	if [[ $? == 0 ]]; then
		/bin/rm $file
		LATEST=`/usr/bin/basename $file`
	else
		exit
	fi
done

# Symlink the latest image
/usr/bin/ssh $EADHOST "rm $EADHOSTPATH/output-latest.jpg && ln -s $LATEST $EADHOSTPATH/output-latest.jpg"

# Append the remote log file
/bin/cat $EADTMPSTASH/webcamlog.txt | /usr/bin/ssh $EADHOST "cat >> $EADHOSTPATH/webcamlog.txt" && rm $EADTMPSTASH/webcamlog.txt
