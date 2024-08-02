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
    echo " -time YYYMMDDhh24miss YYYYYMMDDhh24miss"
    echo "-----------------------------"
}

function tbsql_type(){
    if [ -z "$begin_time" ]
    then
        begin_time="00000000000000"
    fi

    if [ -z "$end_time" ]
    then
        end_time="99991231115959"
    fi


    function tpr_view_info(){
    tbsql sys/$sys_password <<EOF
        set pagesize 0
        set linesize 300
        select 
            snap_id, 
            to_char(begin_interval_time,'YYYYMMDDhh24miss') begin_interval_time,
            to_char(end_interval_time,'YYYYMMDDhh24miss') end_interval_time,
            thread#
        from
            _tpr_snapshot
        where
            to_char(begin_interval_time,'YYYYMMDDhh24miss') >= $begin_time and
            to_char(end_interval_time,'YYYYMMDDhh24miss') <= $end_time
        order by
            thread#,begin_interval_time;
EOF
    }
    
    function tpr_generator(){
    tbsql sys/$sys_password <<EOF

EOF
    }
    
}

function all_generator(){
    function tpr_view(){
        echo ""
    }
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

echo -n "Enter SYS Password: "
read sys_password

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