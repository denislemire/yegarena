#!/bin/bash

if [ ! -d /tmp/yegarena ]; then
	/bin/mkdir /tmp/yegarena
fi

/usr/bin/fswebcam -c /home/denis/yegarena/fswebcam.conf

for file in /tmp/yegarena/output-*; do scp "$file" frosty.incoherency.net:public_html/yegarena && rm "$file" ; done

# Append the remote log file
cat /tmp/yegarena/webcamlog.txt | ssh frosty.incoherency.net "cat >> /home/denis/public_html/yegarena/webcamlog.txt" && rm /tmp/yegarena/webcamlog.txt

/usr/bin/ssh frosty.incoherency.net public_html/yegarena/link.sh
