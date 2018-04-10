#!/bin/bash

curl -sL https://deb.nodesource.com/setup_8.x | bash -

apt-get update
apt-get install -y nodejs vim vim-gtk git tmux gpick shutter

npm install -g dumper js-beautify webpack webpack-dev-server yarn nodemon browser-sync serve

apt-get autoremove -y --purge

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone --depth 1 --branch release https://github.com/adobe-fonts/source-code-pro.git /usr/share/fonts/SourceCodePro
fc-cache -f
