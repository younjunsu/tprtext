#!/bin/bash

function tprtext(){
    echo "###############################"
    echo " TPR Text Analyzer"
    echo "###############################"
    echo "$ ./tprtext.sh [option1] [TPR]"
    echo "-----------------------------"
    echo " usage: ./tprtext.sh -sql \"text.tpr\""
    echo "-----------------------------"
    echo "[option1]"
    echo " -sql: SQL Text TOP Order by"
    echo " -sql-detail: SQL TOP Line Number Count"
    echo " -wait : Wait Event Analyzer"
    echo " -wait-detail: Wait Event Linue Number Count"
    echo ""
    echo "[TPR]"
    echo " \"text.tpr\" \#TPR File "
    echo " \"text07*\" \#TPR File List "
    echo "-----------------------------"
}

function tpr_file(){
    file_list=(`ls $arg2`)
}

function sql_text(){
    function type_head(){
        if [ "yes" == "$sql_detail" ]
        then
            printf "%-10s\t%-40s\n" " Count" "SQL VALUE" 
            printf "%-10s\t" | tr ' ' '-'    
            printf "%-40s\n" | tr ' ' '-'
        else
            printf "%-10s\t%-40s\n" " Number" "SQL VALUE" 
            printf "%-10s\t" | tr ' ' '-'    
            printf "%-40s\n" | tr ' ' '-'
        fi
    }
    function type0(){
        echo "type0"
        echo ""
    }

    function type1(){
        # 8.3 SQL Ordered by Elapsed Time
        grep -A50000 "8.3 SQL" $file_name \
        |grep -B50000 "8.4 SQL" \
        |grep -A7 "Overall Stats" \
        |sed -n '/----------/ {n;p;}'  \
        |awk '{print $5"/"$6}' |awk '{print "TOP"NR"  "$0}' |awk '{printf " %-10s\t%-40s\n", $1, $2}'
    }

    function type2(){
        # 8.4 SQL Ordered by Elapsed Time per Execution
        grep -A50000 "8.4 SQL" $file_name \
        |grep -B50000 "8.5 SQL" \
        |grep -A7 "Overall Stats" \
        |sed -n '/----------/ {n;p;}'  \
        |awk '{print $5"/"$6}' |awk '{print "TOP"NR"  "$0}' |awk '{printf " %-10s\t%-40s\n", $1, $2}'
    }

    function type3(){
        # 8.5 SQL Ordered by Executions
        grep -A50000 "8.5 SQL" $file_name \
        |grep -B50000 "8.6 SQL" \
        |grep -A7 "Overall Stats" \
        |sed -n '/----------/ {n;p;}'  \
        |awk '{print $5"/"$6}' |awk '{print "TOP"NR"  "$0}' |awk '{printf " %-10s\t%-40s\n", $1, $2}'
    }    

    function type4(){
        # 8.6 SQL Ordered by Gets
        grep -A50000 "8.6 SQL" $file_name \
        |grep -B50000 "8.7 SQL" \
        |grep -A7 "Overall Stats" \
        |sed -n '/----------/ {n;p;}'  \
        |awk '{print $6"/"$7}' |awk '{print "TOP"NR"  "$0}' |awk '{printf " %-10s\t%-40s\n", $1, $2}'
    }

    function type5(){
        # 8.7 SQL Ordered by Reads                
        grep -A50000 "8.7 SQL" $file_name \
        |grep -B50000 "8.8 SQL" \
        |grep -A7 "Overall Stats" \
        |sed -n '/----------/ {n;p;}'  \
        |awk '{print $6"/"$7}' |awk '{print "TOP"NR"  "$0}' |awk '{printf " %-10s\t%-40s\n", $1, $2}'
    }

    function type6(){
        echo "type6"
        echo ""
        # 8.8 SQL Ordered by Extra I/O
        #file_list=(`ls thread0*`)
        #for file_name in ${file_list[@]}
        #do
        #    grep -A50000 "8.8 SQL" $file_name \
        #    |grep -B50000 "8.9 SQL" \
        #    |grep -A7 "Overall Stats" \
        #    |sed -n '/----------/ {n;p;}'  \
        #    |awk '{print $4"/"$5}' |awk '{print "TOP"NR"  "$0}'
        #done        
    }            

    function type7(){
        # 8.9 SQL Ordered by CPU
        grep -A50000 "8.9 SQL" $file_name \
        |grep -B50000 " 9. Etc Section" \
        |grep -A7 "Overall Stats" \
        |sed -n '/----------/ {n;p;}'  \
        |awk '{print $4"/"$5}' |awk '{print "TOP"NR"  "$0}' |awk '{printf " %-10s\t%-40s\n", $1, $2}'
    }

    function sql_text_filter(){
        if [ "yes" == "$sql_detail" ]
        then
            echo "** Depends on TPR_SNAPSHOT_TOP_SQL_CNT setting."
            echo -n "Enter a number (default 1-5): "
            read top_sql_cnt
            echo
        fi
    }

    function sql_text_loop(){
        if [ "yes" == "$sql_detail" ]
        then
            type_head
            for file_name in ${file_list[@]}
            do
                type$sql_text_type
            done |grep TOP$top_sql_cnt |sort |uniq -c |sort |awk '{printf " %-10s\t%-40s\n", $1, $3}'
        else
            for file_name in ${file_list[@]}
            do
                echo ""
                echo "TPR File Name: $file_name"
                type_head            
                type$sql_text_type
            done
        fi
    }

    echo "-----------------------------"
    echo "0 - ALL"
    echo "1 - SQL Ordered by Elapsed Time"
    echo "2 - SQL Ordered by Elapsed Time per Execution"
    echo "3 - SQL Ordered by Executions"
    echo "4 - SQL Ordered by Gets"
    echo "5 - SQL Ordered by Reads"
    echo "6 - SQL Ordered by Extra I/O"
    echo "7 - SQL Ordered by CPU"
    echo "-----------------------------"
    echo -n "Select a number (0-7): "
    read sql_text_type

    case $sql_text_type in
        "0")
            sql_text_filter        
            echo "SQL: ALL"
            sql_text_loop
        ;;
        "1")
            sql_text_filter        
            echo "SQL Ordered by Elapsed Time"        
            sql_text_loop
        ;;
        "2")
            sql_text_filter        
            echo "SQL Ordered by Elapsed Time per Execution"
            sql_text_loop
        ;;
        "3")
            sql_text_filter            
            echo "SQL Ordered by Executions"  
            sql_text_loop
        ;;                        
        "4")
            sql_text_filter            
            echo "SQL Ordered by Gets"        
            sql_text_loop
        ;;        
        "5")
            sql_text_filter            
            echo "SQL Ordered by Reads"
            sql_text_loop
        ;;
        "6")
            sql_text_filter
            echo "SQL Ordered by Extra I/O"
            sql_text_loop
        ;;        
        "7")
            sql_text_filter
            echo "SQL Ordered by CPU"
            sql_text_loop
        ;;              
        *)
            sql_text
        ;;
    esac

}

function wait_event_text(){    
    function wait_event_text_loop(){
        if [ "yes" == "$wait_event_detail" ]
        then
            printf "%-10s%-30s\n" "Count" "Wait Event" 
            printf "%*s\n" 40 | tr ' ' '-'
            for file_name in ${file_list[@]}
            do
                grep -A10 "3.3 Top 5" $file_name |grep -A6 "\--" |tail -n 5 |awk '{print "TOP"NR"  "$0}' | grep TOP$line_number_wait_event |sed 's/ /_/g' |sed 's/__/ /g' |awk '{print $2}'
            done |sort |uniq -c |sort |awk '{print $2" "$1}' |sed 's/^_//g' |awk '{printf "%-10s%-30s\n", $2, $1}' |sed 's/_/ /g'
        else
            for file_name in ${file_list[@]}
            do
                echo
                echo "TPR File Name: $file_name"
                echo "-----------------------------"
                echo "                                                  Time          Wait          Avg           Waits       DB"
                echo "                         Event            Waits  -outs(%)       Time(s)      Wait(ms)           /TX   Time(%)"
                echo "------------------------------  ---------------  --------  ------------  ------------  ------------  --------"
                grep -A10 "3.3 Top 5" $file_name |grep -A6 "\--" |tail -n 5
            done
        fi
    }

    function wait_event_text_filter(){
        if [ "yes" == "$wait_event_detail" ]
        then
            echo -n "Enter a number (1-5): "
            read line_number_wait_event
            echo
        fi
    }
    wait_event_text_filter
    wait_event_text_loop
}

arg1="$1"
arg2="$2"

 
case $arg1 in 
    "-wait")
        tpr_file
        wait_event_text
        ;;
    "-wait-detail")
        wait_event_detail="yes"
        tpr_file
        wait_event_text
        ;;            
    "-sql")
        tpr_file
        sql_text
        ;;
    "-sql-detail")
        sql_detail="yes"
        tpr_file
        sql_text
        ;;
    *)
        tprtext
        ;;
esac