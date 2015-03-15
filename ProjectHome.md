![http://cccatcher.googlecode.com/files/cccatcher.jpg](http://cccatcher.googlecode.com/files/cccatcher.jpg)

<a href='http://www.fdt.powerflasher.com'><img src='http://fdt.powerflasher.de/media/supported_by_FDT_187x35px.png' title='Supported by FDT' border='0' width='187' height='35' /></a>

An [Adobe AIR](http://www.adobe.com/products/air/) desktop application built with [Powerflasher's FDT](http://www.fdt.powerflasher.com/).

**PROBLEM:**

I'm a [Creative Commons](http://creativecommons.org/) junkie and dj. Check my <a href='http://gorehole.org/cockroaches/'>cockroaches mixes</a> or the <a href='http://ilovecopyleft.tumblr.com/'>ilovecopyleft mp3 blog</a>. Every year I collect a bunch of mp3 + <a href='http://starpause.tumblr.com/'>jpg</a> by hand, totaling an oppressive number of gigabytes. I lose site of the media as it piles up on dvds.

**SOLUTION:**

CCCatcher is a shuffle-ish music player that exposes me the latest mp3 treats I've downloaded, with easy access to _Delete_ tracks that hurt the ears and _Star_ tracks they want to find later and stick in a mix.

CCCatcher also displays cover art by grabbing a random image from the folder containing the current track. This way images are associated with sounds, based on monthly folders which I fill with mp3 and jpg.<br><br>

<b>INSTALLER:</b>

1. Install the <a href='http://get.adobe.com/air/'>Adobe AIR</a> run time. It's like the jvm, available free-as-in-beer for OSX/WIN/NIX.<br>
<br>
2. Install the <a href='http://cccatcher.googlecode.com/files/cccatcher-58.air'>cccatcher-58.air</a> by clicking on it and choose to run with Adobe AIR.<br>
<br>
Or if you'd rather nab the source, you can check out the CompileHowto.<br>
<br>
<b>CURRENT FEATURES:</b>
<ul><li>128x128 always-on-top, semi-transparent <code>CoverDisplay</code> window that shows a random jpg from the folder that holds whatever mp3 is playing, or the CCCatcher logo if it can't find a jpg.<br>
</li><li>double click the <code>CoverDisplay</code> to shuffle, double right-click <code>CoverDisplay</code> play previous track (stack).<br>
</li><li>mouse over waveform to see a <code>TimeDisplay</code>, click to seek<br>
</li><li>icon actions:<br>
<ul><li>Star (put -cccatcher- in the file name)<br>
</li><li>Trash (to recycle bin/trash where os supports it, bit bin otherwise)<br>
</li><li>Play/Pause (as you'd expect)<br>
</li><li>X (quit, escape the cccatcher's grasp)<br>
</li></ul></li><li>add mp3s to play by dropping them on the window, or folders of mp3s by doing the same<br>
</li><li>insta-play a single mp3 by dropping it onto the window<br>
</li><li>dropping lots of files on cccatcher will display a red pie as the tracks are processed<br>
</li><li>on mouse over CCCatcher: <code>NfoDisplay</code> shows icons, current file name and folder name, <code>TimeDisplay</code> shows songPosition + songLength.<br>
</li><li>right click the <code>NfoDisplay</code> for menu:<br>
<ul><li>Flush (the track list)<br>
</li></ul></li><li>cccatcher-config.xml file allows you to edit the tagText that Star applys (change from -cccatcher-)<br>
</li><li>when you quit the current song and position is stored, continues playback from that point on next boot.</li></ul>

<b>PLANNED FEATURES:</b>

<ul><li>mp3gain files to 89.0 before playing them (milestone)<br>
</li><li>catch rss feeds of tracks from netlabels/cc sources (milestone)<br>
<ul><li>delete old files based on time, but never ones that have been tagged.<br>
</li></ul></li><li>shuffle screen (milestone)<br>
<ul><li>trash warning<br>
</li><li>star-only playback mode<br>
</li><li>crossfade between tracks<br>
</li><li>different sized icons for all the OS<br>
</li><li>update window title with current track title/artist/album<br>
</li></ul></li><li>config screen (milestone)<br>
<ul><li>tag text<br>
</li><li>trash warning toggle<br>
</li></ul></li><li>past screen<br>
</li><li>future screen<br>
</li><li>right click to switch between screens