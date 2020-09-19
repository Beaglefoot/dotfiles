#!/bin/bash

zypper refresh
cat opensuse.txt | xargs zypper install -yl --no-recommends

npm set prefix "$HOME/.npm"
npm set save-exact true
cat npm.txt | xargs npm install -g

pip install --upgrade pip setuptools

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

zypper remove --clean-deps -y -t pattern games
zypper remove --clean-deps -y -t pattern kde_pim
cat opensuse-remove.txt| xargs zypper remove --clean-deps -y
