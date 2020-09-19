#!/bin/bash

cat brew.txt| xargs brew install

brew tap homebrew/cask-fonts
cat brew-cask.txt| xargs brew cask install
