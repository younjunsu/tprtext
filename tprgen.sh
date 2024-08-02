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
    echo " -time BEGINTIME ENDTIME"
    echo "   format: YYYYYMMDDhh24miss"
    echo "-----------------------------"
}

function tbsql_type(){
    function tpr_connect(){
        connected=`tbsql sys/$sys_password -s <<EOF
            set pagesize 0
            set head off
            set feedback off
            select 'connected' from dual;
EOF`
        if [ "connected" != "$connected" ]
        then
            echo "SYS Password Check"
            exit 1
        fi
    }

    function tpr_view_info(){
        tbsql sys/$sys_password -s <<EOF
            set pagesize 0
            set linesize 300
            set feedback off
            set head on
            select 
                snap_id, 
                to_char(begin_interval_time,'YYYY/MM/DD hh24:mi:ss') begin_interval_time,
                to_char(end_interval_time,'YYYY/MM/DD hh24:mi:ss') end_interval_time,
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
        function tpr_generator_command(){
            tbsql sys/$sys_password -s <<EOF
                set linesize 300
                set pagesize 0
                set feedback off
                alter session set nls_date_format='YYYYMMDD_hh24miss';
                select 
                    'exec dbms_tpr.report_text_id('||snap_id||','''||'thread'||thread#||'_'||snap_id||'_'||begin_interval_time||'_'||end_interval_time||'.tpr'');' AS text
                from
                    _tpr_snapshot
                where
                    to_char(begin_interval_time,'YYYYMMDDhh24miss') >= $begin_time and
                    to_char(end_interval_time,'YYYYMMDDhh24miss') <= $end_time
                order by
                    thread#,begin_interval_time;
EOF
        }

        function tpr_generator_execute(){
            tpr_generator_group="$1"
            tbsql sys/$sys_password -s <<EOF
                $tpr_generator_group
EOF
        }

        tpr_generator_array=$(tpr_generator_command)
        tpr_generator_execute "$tpr_generator_array"

    }
    
    tpr_connect
    tpr_view_info
    echo "run: yes, stop: others key"
    echo -n "Proceed ?"
    read generator_input
    if [ "yes" == "$generator_input" ]
    then
        tpr_generator
    else
        exit
    fi
    
}

function all_generator(){
    function all_arg_format(){
        if [ -z "$begin_time" ]
        then
            begin_time="00000000000000"
        fi

        if [ -z "$end_time" ]
        then
            end_time="99991231115959"
        fi
    }


    all_arg_format
    tbsql_type
}

function time_generator(){

    function time_arg_format(){
        begin_time=$arg2
        end_time=$arg3
        
        if [[ ! "$begin_time" =~ ^[0-9]{14}$ ]] || [[ ! "$end_time" =~ ^[0-9]{14}$ ]] || [ -z "$begin_time" ] || [ -z "$end_time" ]
        then
            echo "-----------------------------"
            echo "ERROR] Please check the time format."
            echo "-----------------------------"
            echo " ./tprgen.sh -time %d %d"
            echo "   %d: YYYYMMDDhh24miss"
            echo "-----------------------------"
            echo " BeginTime: $begin_time"
            echo " EndTime  : $end_time"
            echo "-----------------------------"

            exit 1
        fi
    }

    time_arg_format
    tbsql_type

}

arg1=$1
arg2=$2
arg3=$3

function tbsql_login(){
    echo -n "Enter SYS Password: "
    read sys_password
}


case $arg1 in
    "-all")
        tbsql_login
        all_generator
    ;;
    "-time")
        tbsql_login
        time_generator
    ;;
    *)
        tprgen
        exit 1
    ;;
esac 