#!/bin/bash

while read ext; do
    code --install-extension $ext
done < vscode-extensions.txt


if [[ "$OSTYPE" == "darwin"* ]]; then
    filename="$HOME/Library/Application Support/Code/User/settings.json"
    rm "$filename"
    ln -s "$HOME/.config/Code/User/settings.json" "$filename"
fi


if [[ "$OSTYPE" == "cygwin" ]]; then
    filename="$(cygpath -u $USERPROFILE)/AppData/Roaming/Code/User/settings.json"
    rm "$filename"
    ln -P "$HOME/.config/Code/User/settings.json" "$filename"
fi
