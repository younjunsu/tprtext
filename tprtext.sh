#!/bin/bash

function tprtext(){
    echo "------------------------------------"
    echo " Tibero Performance Report Text Analyzer"
    echo "$ ./tprtext \$1 \$2"
    echo ""
    echo "\$1"
    echo " -sql : SQL Text Analyzer"
    echo " -wait : Wait Event Analyzer"
    echo ""
    echo "\$2"
    echo " TPR Text File or TPR File Path (only tpr file)"
    echo "------------------------------------"
}

function tpr_file(){

}

function sql_text(){
    
}

function wait_event_text(){
    
}

arg1=$1
arg2=$2

case $arg1 in 
    "-wait")
        tpr_file
        wait_event_text
        ;;    
    "-sql")
        tpr_file
        sql_text
        ;;
    *)
        tprtext
        
        ;;
esac