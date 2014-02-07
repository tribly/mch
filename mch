#!/bin/bash

#######################################
###     Initialize everything        ###
#######################################
function init
{
    # Number of songs in the playlist
    s_number=$(mpc playlist | wc -l)
    tmp_file=/tmp/playlist
    s_number=10

    # Put the playlist in a tmp file
    mpc playlist -f "%position%\t%artist%\t%title%" | tee $tmp_file > /dev/null

    cur_song=$(mpc current -f "%position%\t%artist%\t%title%")
    cur_song_nr=`echo "$cur_song" | cut -f1`
    next_song_nr=`expr $cur_song_nr + 1`
    next_song=

    echo $next_song_nr

    next_song=

    # Shuffle the playlist
    #shuf $tmp_file -o $tmp_file

    # Show only 10 songs
    #if [[ $s_number -gt 10 ]]; then
        #s_number=10
    #fi
}

function menu
{
    menu="play
random
shuffle
next: "

    option=$(echo "$menu" | dmenu -l $s_number -y 425 -x 690 -w 300 \
                            -fn "Monospace-12:normal" -nb "#002A35")

    case "$option" in
        play)
            mpc toggle > /dev/null
        ;;
        random)
            mpc random > /dev/null
            is_random=$(mpc | grep "random" | cut -d ' ' -f11)
            mpc | grep "random" | cut -d ' ' -f11 | \
                notify-send "random: $is_random"
        ;;
        shuffle)
            notify-send "Shuffled playlist"
        ;;
    esac

}

function play
{
    selected=$(head -n 10 $tmp_file | cut -f2 | \
        dmenu -l $s_number -y 425 -x 690 -w 300 \
        -fn "Monospace-12:normal" -nb "#002A35")

    if [[ -z $selected ]]; then
        exit
    fi

    number=$(grep "$selected" $tmp_file | cut -f1)

    mpc play $number > /dev/null
}

init
menu
