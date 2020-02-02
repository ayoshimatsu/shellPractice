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
    local trash_file_directory=${trash_base_directory}/${TRASH_FILE_DIRECTORY_NAME}
    local trash_info_directory=${trash_base_directory}/${TRASH_INFO_DIRECTORY_NAME}

    if [[ ! -d $trash_base_directory ]]; then
        mkdir -p -- "$trash_base_directory" || return 1
    fi

    if [[ ! -d $trash_file_directory ]]; then
        mkdir -p -- "$trash_info_directory" || return 1
    fi
}

trash_directory_is_exits()
{
    local trash_base_directory=$1
    local trash_file_directory=${trash_base_directory}/${TRASH_FILE_DIRECTORY_NAME}
    local trash_info_directory=${trash_base_directory}/${TRASH_INFO_DIRECTORY_NAME}

    if [[ ! -d $trash_base_directory ]]; then
        print_error "'$trash_base_directory': Trash directory not found"
        return 1
    fi

    if [[ ! -d $trash_file_directory ]]; then
        print_error "'$trash_file_directory': Trash directory not found" || return 1
        return 1
    fi

    if [[ ! -d $trash_info_directory ]]; then
        print_error "'$trash_info_directory': Trash directory not found" || return 1
        return 1
    fi

    return 0
}

trash_put()
{
    local trash_base_directory=$1
    local file_path=$2

    if [[ ! -e $file_path ]]; then
        print_error "'$file_path': File not found"
        return 1
    fi

    file_path=$(realpath -- "$file_path")
    local file=${file_path##*/}

    if [[ -z $file ]]; then
        print_error "'$file_path': Can not trash file or directory"
        return 1
    fi

    local trash_file_directory=${trash_base_directory}/${TRASH_FILE_DIRECTORY_NAME}
    local trash_info_directory=${trash_base_directory}/${TRASH_INFO_DIRECTORY_NAME}

    ## File name in trashbox
    local trashed_file_name=$file

    ## In case that the same file already exists in trashbox 
    if [[ -e ${trash_file_directory}/${trashed_file_name} ]]; then
        local rescape_file_name
        rescape_file_name=$(escape_basic_regex "$file")
        local current_max_number
        current_max_number=$(find -- "$trash_file_directory" -mindepth 1 -maxdepth 1 -printf '%f\n'
            | grep -e "^${rescape_file_name}\$" -e "^${rescape_file_name}_[0-9][0-9]*\$"
            | sed "s/^${rescape_file_name}_\\{0,1\\}//"
            | sed 's/^$/0/'
            | sort -n -r 
            | head -n 1)
            
        trashed_file_name+="_$((current_max_number + 1))"
    fi

    trash_init "$trash_base_directory" || return 2

    mv -- "$file_path" "${trash_file_directory}/${trashed_file_name}" || return 3

    #Define deletion date YYYY-MM-DDThh:mm:ss
    cat <<END > "${trash_info_directory}/${trashed_file_name}.trashinfo"
[Trash Info]
Path=$file_path
DeletionDate=$(date '+%Y-%m-%dT%H:%M:%S')
END
}


# Display info in trashinfo.
print_trashinfo(){
    local trashinfo_file_path=$1
    local line=
    local -A info

    while IFS= read -r line
    do
        if [[ $line =~ ^([^=]+)=(.*)$ ]]; then
            info["${BASH_REMATCH[1]}"]=${BASH_REMATCH[2]}
        fi
    done < "$trashinfo_file_path"

    local trashinfo_file_name=${trashinfo_file_path##*/}
    local restore_file_name=${info[Path]##*/}
    local rescape_restore_file_name
    rescape_restore_file_name=$(escape_basic_regex "$restore_file_name")

    local file_number
    file_number=$(printf '%s' "$trashinfo_file_name"
        | sed -e 's/\.trashinfo$//' -e "s/^${rescape_restore_file_name}_\\{0,1\\}//")

    printf '%s %s %s\n' "${info[DeletionDate]}" "${info[Path]}" "$file_number"
}


# Display file in trashbox
trash_list()
{
    local trash_base_directory=$1
    local trash_info_directory=${trash_base_directory}/${TRASH_INFO_DIRECTORY_NAME}
    
    trash_directory_is_exits "$trash_base_directory" || return 1

    local path=
    find -- "$trash_info_directory" -mindepth 1 -maxdepth 1 -type f -name '*.trashinfo' -print
        | sort
        | while IFS= read -r path
            do
                print_trashinfo "$path"
            done
}

# Restore files in trashbox where it was
trash_restore()
{
    local trash_base_directory=$1
    local file_name=$2
    local file_number=$3
    local trash_file_directory=${trash_base_directory}/${TRASH_FILE_DIRECTORY_NAME}
    local trash_info_directory=${trash_base_directory}/${TRASH_INFO_DIRECTORY_NAME}

    trash_directory_is_exits "$trash_base_directory" || return 1

    if [[ -z $file_name ]]; then
        print_error 'missing file operand'
        return 1
    fi

    local restore_target_name=








