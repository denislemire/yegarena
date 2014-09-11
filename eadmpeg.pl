#!/usr/local/bin/perl

chdir "/home/denis";

opendir (INDIR,"/home/denis/public_html/yegarena/");

open(FFMPEG, "| /usr/local/bin/ffmpeg -f image2pipe -r 24 -vcodec mjpeg -i - -vcodec libx264 -s 854x480 /home/denis/public_html/yegarena-tmp.mp4");

while (readdir (INDIR))
{
	if ($_ =~ /^output-/) {
		open (JPEG,"/home/denis/public_html/yegarena/$_") or die "Couldn't open $_\n";

		while (<JPEG>) {
			print FFMPEG $_;
		}

		close JPEG;
	}
}

close INDIR;
close FFMPEG;

system ("mv public_html/yegarena-tmp.mp4 public_html/yegarena.mp4");
