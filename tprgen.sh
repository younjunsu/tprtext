#!/bin/bash

function tprgen(){
    echo "###############################"
    echo " TPR Text Report Generator"
    echo "###############################"
    echo "$ ./tprtext.sh [option1]"
    echo "-----------------------------"
    echo " usage: ./tprgen.sh [option1] "
    echo "-----------------------------"
    echo " [option1]"
    echo " -all"
    echo " -time YYYMMDDhh24:mi:ss YYYYYMMDDhh24:mi:ss"
    echo "-----------------------------"
}


function all_generator(){
    echo ""
}

function time_generator(){
    function arg_format(){
        begin_time=$arg2
        end_time=$arg3
        
        if [[ ! "$begin_time" =~ ^[0-9]{14}$ ]] || [[ ! "$end_time" =~ ^[0-9]{14}$ ]] 
        then
            echo "error"
        fi
    }
    echo "gen"
    arg_format

}

arg1=$1
arg2=$2
arg3=$3

case $arg1 in
    "-all")
        all_generator
    ;;
    "-time")
        time_generator
    ;;
    *)
        echo "EXIT"
        exit
    ;;
esac 