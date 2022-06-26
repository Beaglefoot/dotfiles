#!/bin/bash

zypper ar -f http://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ packman
zypper ar -f http://opensuse-guide.org/repo/openSUSE_Tumbleweed/ libdvdcss
rpm --import https://rpm.opera.com/rpmrepo.key
zypper ar -f https://rpm.opera.com/rpm opera
rpm --import https://packages.microsoft.com/keys/microsoft.asc
zypper ar -f https://packages.microsoft.com/yumrepos/vscode vscode
zypper ar -f https://packages.microsoft.com/opensuse/15/prod/ packages-microsoft-com-prod

zypper refresh

cat opensuse.txt | xargs zypper install -yl --no-recommends --allow-vendor-change

# NPM

npm set prefix "$HOME/.npm"
npm set save-exact true

cat npm.txt | xargs npm install -g

# Pip

pip install --upgrade pip setuptools

# Vim

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Clean up

zypper remove --clean-deps -y -t pattern games
zypper remove --clean-deps -y -t pattern kde_pim

cat opensuse-remove.txt | xargs zypper remove --clean-deps -y

