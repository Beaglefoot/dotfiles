#!/bin/bash

zypper refresh
zypper install -yl --no-recommends nodejs8 vim gvim neovim git tmux gpick

npm install -g dumper js-beautify yarn nodemon browser-sync serve typescript opera

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

zypper remove --clean-deps -y -t pattern games
zypper remove --clean-deps -y git-gui marble-kde
