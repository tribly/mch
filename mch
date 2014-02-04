#!/bin/bash

#######################################
###     Initialize everyhing        ###
#######################################
function init
{
    s_number=$(mpc playlist | wc -l)
    tmp_file=/tmp/playlist

    # Put the playlist in a tmp file
    mpc playlist -f "%position%\t%title%" | tee $tmp_file > /dev/null

    # Shuffle the playlist
    shuf $tmp_file -o $tmp_file

    # Show only 10 songs
    if [[ $s_number -gt 10 ]]; then
        s_number=10
    fi
}

function play
{
    selected=$(head -n 10 $tmp_file | cut -f2 | \
        dmenu -l $s_number -y 425 -x 690 -w 300 \
        -fn "Monospace-12:normal" -nb "#002A35")

    #if [[ -z $selected ]]; then
        #exit
    #fi

    number=$(grep "$selected" $tmp_file | cut -f1)

    mpc play $number > /dev/null
}

init
play
