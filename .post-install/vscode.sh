#!/bin/bash

while read ext; do
    code --install-extension $ext
done < vscode-extensions-list.txt
