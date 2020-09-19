#!/bin/bash

# https://forums.opensuse.org/showthread.php/523476-Multimedia-Guide-for-openSUSE-Tumbleweed
# https://gist.github.com/ruario/bec42d156d30affef655

zypper ar -f http://packman.inode.at/suse/openSUSE_Tumbleweed/ packman
zypper ar -f http://opensuse-guide.org/repo/openSUSE_Tumbleweed/ libdvdcss
zypper ar -f https://rpm.opera.com/rpm opera
zypper ar -f https://packages.microsoft.com/yumrepos/vscode vscode
zypper ar -f https://packages.microsoft.com/opensuse/15/prod/ packages-microsoft-com-prod

zypper refresh

cat opensuse-interactive.txt| xargs zypper install
