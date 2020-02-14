#!/bin/bash

update_prefectures()
{
    local -a prefectures=(Iwate Miyagi)
    echo "${prefectures[@]}"
}

declare -a prefectures=(Hokkaido Amori)
echo "${prefectures[@]}"
update_prefectures
echo "${prefectures[@]}"
