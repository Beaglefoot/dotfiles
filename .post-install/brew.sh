#!/bin/bash

cat brew-list.txt| xargs brew install

brew tap homebrew/cask-fonts
cat brew-cask-list.txt| xargs brew cask install
