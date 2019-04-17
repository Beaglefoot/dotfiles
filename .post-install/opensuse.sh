#!/bin/bash

zypper refresh
cat opensuse-list.txt | xargs zypper install -yl --no-recommends

cat npm-list.txt | xargs npm install -g

pip install --upgrade pip setuptools

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

zypper remove --clean-deps -y -t pattern games
zypper remove --clean-deps -y git-gui marble-kde
