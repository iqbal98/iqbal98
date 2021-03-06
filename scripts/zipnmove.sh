#!/usr/bin/env bash
#
#   Simple script that makes zip files from folders without
#   keeping the source directory
#
#   Example:
#   Source Dir: dir_a/
#   --/home/user/dir_a/
#   ------------|______subdir1/
#   ------------|______subdir2/
#   ------------|______subdir3/
#   ------------|______file1.txt
#
#   If run `zipnmove /home/user/dir_a` then 3 zip files will be created subdir{1,2,3}.zip, each one containing their
#   respective root folder e.g: subdir2.zip contents would be -> /subdir1/ . Avoiding using abs path for the root folder
#

source ~/1w3j/functions.sh

SOURCE_DIR="${1}"
FOLDERS=()

find_folders() {
    for d in "${1}"/*; do
        if [[ -d "${d}" ]]; then
            FOLDER=$(realpath "${d}")
            #echo adding folder: "$FOLDER"
            FOLDERS=("${FOLDER}" "${FOLDERS[@]}")
        fi
    done
}

zip_folders(){
    QTY_FOLDERS=$((${#FOLDERS[@]}))
    if [[ ${QTY_FOLDERS} -gt 0 ]]; then
        echo "${QTY_FOLDERS} folders found, showing first 10: "
        for (( i=0; i<=$((${QTY_FOLDERS}-1)); i++ )); do
            echo -e "\t$((${i}+1)) $(basename "${FOLDERS[$i]}")"
            [[ ${i} -eq 10 ]] && break
        done
        read -p "Press ENTER to continue to zip or Ctrl-c the shit out of here"
        cd "${SOURCE_DIR}" || err "${SOURCE_DIR} does not exist"
        for (( i=0; i<=$((${QTY_FOLDERS}-1)); i++ )); do
            CURRENT_FOLDER=`basename "${FOLDERS[$i]}"`
            echo -e "\t<=====================" "${CURRENT_FOLDER}" "========================>"
            zip -m -r -9 "${CURRENT_FOLDER}".zip "${CURRENT_FOLDER}"
        done
    else
        warn "0 folders found.. Nothing to do !";
        exit 2
    fi
}

zipnmove(){
    if [[ -n "${SOURCE_DIR}" ]]; then
        if [[ -e "${SOURCE_DIR}" ]]; then
            find_folders "${SOURCE_DIR}"
            zip_folders
        else
            err "Folder doesn\'t exist"
        fi
    else
        err "What folder did you say?"
    fi
}

zipnmove "${@}"