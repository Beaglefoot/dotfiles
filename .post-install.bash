#!/bin/bash

apt-get update
curl -sL https://deb.nodesource.com/setup_8.x | bash -
apt-get install -y nodejs
npm install -g babel-eslint dumper eslint eslint-plugin-import eslint-plugin-react gulp js-beautify webpack webpack-dev-server yarn nodemon
apt-get install -y vim vim-gtk git tmux
apt-get autoremove -y --purge
git clone --depth 1 --branch release https://github.com/adobe-fonts/source-code-pro.git /usr/share/fonts/SourceCodePro
fc-cache -f
cp /usr/lib/git-core/git-sh-prompt ~/.git-prompt.sh
