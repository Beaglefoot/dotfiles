# .rc

Use symlinks for .vimrc and .brackets.json.

This allows having the same config for several editors installed in different places.

In windows run cmd as administrator:

    mklink /prefix link_path file/folder_path

    /D – creates a soft symbolic link, which is similar to a standard folder or file shortcut in Windows. (Default)
    /H – creates a hard link to a file
    /J – creates a hard link to a directory or folder

Don't foget to install [PowerlineSymbols.otf](https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf) for airline plugin.