#!/bin/bash

# https://forums.opensuse.org/showthread.php/523476-Multimedia-Guide-for-openSUSE-Tumbleweed
# https://gist.github.com/ruario/bec42d156d30affef655

zypper ar -f http://packman.inode.at/suse/openSUSE_Tumbleweed/ packman
zypper ar -f http://opensuse-guide.org/repo/openSUSE_Tumbleweed/ libdvdcss
zypper refresh

zypper install libdvdcss2 ffmpeg lame gstreamer-plugins-libav gstreamer-plugins-bad gstreamer-plugins-ugly gstreamer-plugins-ugly-orig-addon vlc vlc-codecs flash-player flash-player-ppapi libxine2 libxine2-codecs chromium-ffmpeg-extra
