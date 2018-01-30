#!/bin/bash

curl -sL https://deb.nodesource.com/setup_8.x | bash -

apt-get update
apt-get install -y nodejs vim vim-gtk git tmux ubuntu-make

npm install -g babel-eslint dumper eslint eslint-plugin-import eslint-plugin-react gulp js-beautify webpack webpack-dev-server yarn nodemon browser-sync

apt-get autoremove -y --purge

git clone --depth 1 --branch release https://github.com/adobe-fonts/source-code-pro.git /usr/share/fonts/SourceCodePro
fc-cache -f
