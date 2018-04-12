# .rc

Use symlinks for .vimrc

This allows having the same config for several editors installed in different places.

In windows run cmd as administrator:

    mklink /prefix link_path file/folder_path

    /D – creates a soft symbolic link, which is similar to a standard folder or file shortcut in Windows. (Default)
    /H – creates a hard link to a file
    /J – creates a hard link to a directory or folder
