#!/bin/bash

flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
cat flatpak.txt | xargs flatpak install --user --assumeyes
