#!/bin/bash

# Purpose
#   Use trashbox from command line
#
# How to use
#   trash.sh put [OPTION]... FILE...
#   trash.sh list [OPTION]...
#   trash.sh restore [OPTION]... FILE [NUMBER]
#
# Description
#   1. Dump file
#   2. Display list of files in trashbox
#   3. Restore a file to the original place

readonly SCRIPT_NAME=${0##*/}
readonly VERSION=1.0.0
readonly DEFAULT_TRASH_BASE_DIRECTORY=$HOME/.Trash
readonly TRASH_FILE_DIRECTORY_NAME=files
readonly TRASH_INFO_DIRECTORY_NAME=info

print_help()
{
    cat << END
Usage: $SCRIPT_NAME put [OPTION]... FILE...
or:    $SCRIPT_NAME list [OPTION]...
or:    $SCRIPT_NAME restore [OPTION]... FILE [NUMBER]

In the 1st form, put FILE to the trashbox.
In the 2nd form, list items in the trashbox.
In the 3rd form, restore FILE from the trashbox.

OPTIONS
    -d, --directory=DIRECTORY   specify trashbox directory
    --help                      display this help and exit
    --version                   display version information and exit

Default trashbox directory is "$DEFAULT_TRASH_BASE_DIRECTORY".
You can specify the directory with TRASH_DIRECTORY environment variable
or -d/--directory option.
END
}

print_version()
{
    cat << END
$SCRIPT_NAME version $VERSION
END
}

escape_basic_regex()
{
    printf '%s\n' "$1" | sed 's/[.*\^$[]/\\&/g'
}

trash_init()
{
    local trash_base_directory=$1


}
