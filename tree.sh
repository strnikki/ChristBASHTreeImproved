#!/bin/bash

lin=2
col=$(($(tput cols) / 2))
c=$((col-1))
est=$c
size=10
trunk_height=2
trunk_width=1
n_lights=$((size*2))
synchrony=30
color=0
speed=10

# Check if there are any arguments
if [ $# -gt 0 ] 
then 
    while [[ "$#" -gt 0 ]]
    do
        case $1 in
        -s|--size)
            size=$2
            n_lights=$((size*2))
            ;;
        -tw|--trunk_width)
            trunk_width=$2
            ;;
        -th|--trunk_height)
            trunk_height=$2
            ;;   
        -nl|--number_lights)
            n_lights=$2
            ;;
        -sy|--synchrony)
            synchrony=$2
            ;;
        -sp|--speed)
            speed=$2
            ;;
        -h|--help)
            tput setaf 2
            echo "Options:"
            echo "  -s|--size: height of the tree. Default: 10"
            echo "  -tw|--trunk_width: width of the center of the trunk. Default: 1"
            echo "  -nl|--number_lights: number of lights generated in the tree. Default: size*2"
            echo "  -sy|--synchrony: synchrony of the lights in percentage. Default: 30"
            echo "  -sp|--speed: the speed which the lights blink (a smaller number is faster). Default: 10"
            echo "  -h|--help: shows this text"
            exit 0
            ;;
        esac
        shift
    done
fi 

# Setup
clear
tput civis
tput setaf 2; tput bold
trap "tput reset; tput cnorm; exit" 2

# Tree
for ((i=1; i<(($size*2)); i+=2))
{
    tput cup $lin $col
    for ((j=1; j<=i; j++))
    {
        echo -n \*
    }
    let lin++
    let col--
}

tput sgr0; tput setaf 3

# Trunk
if [ $(( trunk_width % 2 )) -eq 0 ]
then
    trunk_width=$(( trunk_width - 1 ))
fi

est=$(( est - (trunk_width / 2) ))

for ((i=1; i<=trunk_height; i++))
{
    tput cup $((lin++)) $est
    echo -n 'm'
    for ((j=1; j<=trunk_width; j++))
    {
        echo -n 'W'
    }
    echo -n 'm'
}
new_year=$(date +'%Y')
let new_year++
tput setaf 1; tput bold
tput cup $lin $((c - 6)); echo MERRY CHRISTMAS
tput cup $((lin + 1)) $((c - 10)); echo And lots of CODE in $new_year
let c++
k=1

for ((i=1; i<n_lights; i++)){
    li=$((RANDOM % (size - 1) + 3))
    start=$((c-li+2))
    co=$((RANDOM % (li-2) * 2 + 1 + start))
    tput setaf $color; tput bold   # Switch colors
    tput cup $li $co
    echo o
    line[$i]=$li
    column[$i]=$co
}

counter=0
# Lights and decorations
while true; do

    counter=$((counter+1))
    if [ $counter -gt $speed ]
    then
        for ((i=1; i<n_lights; i++)){
            if [ $((RANDOM % 100 )) -gt $((synchrony)) ]
            then
                color=$(((color+1)%8))
                tput setaf $color
            fi
            tput cup ${line[$i]} ${column[$i]}; echo o
        }
        counter=0
    fi
    color=$(((color+1)%8))
    tput setaf $color

    sh=1
    for l in C O D E
    do
        tput cup $((lin+1)) $((c+sh))
        echo $l
        let sh++
        sleep 0.01
    done
done
