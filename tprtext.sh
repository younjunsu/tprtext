#!/bin/bash

function tprtext(){
    echo "------------------------------------"
    echo " Tibero Performance Report Text Analyzer"
    echo "$ ./tprtext \$1 \$2"
    echo "ex $"
    echo ""
    echo "\$1"
    echo " -sql: SQL Text Analyzer"
    echo " -sql-detail: SQL TOP Pattern"
    echo " -wait : Wait Event Analyzer"
    echo ""
    echo "\$2"
    echo " TPR Text File or TPR File Path (only tpr file)"
    echo "------------------------------------"
}

function tpr_file(){
    file_list=(`ls $arg2`)
}

function sql_text(){
    function type0(){
        echo "type0"
    }

    function type1(){
        # 8.3 SQL Ordered by Elapsed Time
        echo "TPR File Name: $file_name"
        grep -A50000 "8.3 SQL" $file_name \
        |grep -B50000 "8.4 SQL" \
        |grep -A7 "Overall Stats" \
        |sed -n '/----------/ {n;p;}'  \
        |awk '{print $5"/"$6}' |awk '{print "TOP"NR" "$0}'
    }

    function type2(){
        # 8.4 SQL Ordered by Elapsed Time per Execution
        echo "TPR File Name: $file_name"
        grep -A50000 "8.4 SQL" $file_name \
        |grep -B50000 "8.5 SQL" \
        |grep -A7 "Overall Stats" \
        |sed -n '/----------/ {n;p;}'  \
        |awk '{print $5"/"$6}' |awk '{print "TOP"NR" "$0}'
    }

    function type3(){
        # 8.5 SQL Ordered by Executions
        echo "TPR File Name: $file_name"
        grep -A50000 "8.5 SQL" $file_name \
        |grep -B50000 "8.6 SQL" \
        |grep -A7 "Overall Stats" \
        |sed -n '/----------/ {n;p;}'  \
        |awk '{print $5"/"$6}' |awk '{print "TOP"NR" "$0}'
    }    

    function type4(){
        # 8.6 SQL Ordered by Gets
        echo "TPR File Name: $file_name"
        grep -A50000 "8.6 SQL" $file_name \
        |grep -B50000 "8.7 SQL" \
        |grep -A7 "Overall Stats" \
        |sed -n '/----------/ {n;p;}'  \
        |awk '{print $6"/"$7}' |awk '{print "TOP"NR" "$0}'
    }

    function type5(){
        # 8.7 SQL Ordered by Reads                
        echo "TPR File Name: $file_name"
        grep -A50000 "8.7 SQL" $file_name \
        |grep -B50000 "8.8 SQL" \
        |grep -A7 "Overall Stats" \
        |sed -n '/----------/ {n;p;}'  \
        |awk '{print $6"/"$7}' |awk '{print "TOP"NR" "$0}'
    }

    function type6(){
        echo "type6"
        # 8.8 SQL Ordered by Extra I/O
        #file_list=(`ls thread0*`)
        #for file_name in ${file_list[@]}
        #do
        #    grep -A50000 "8.8 SQL" $file_name \
        #    |grep -B50000 "8.9 SQL" \
        #    |grep -A7 "Overall Stats" \
        #    |sed -n '/----------/ {n;p;}'  \
        #    |awk '{print $4"/"$5}' |awk '{print "TOP"NR" "$0}'
        #done        
    }            

    function type7(){
        # 8.9 SQL Ordered by CPU
        echo "TPR File Name: $file_name"
        grep -A50000 "8.9 SQL" $file_name \
        |grep -B50000 " 9. Etc Section" \
        |grep -A7 "Overall Stats" \
        |sed -n '/----------/ {n;p;}'  \
        |awk '{print $4"/"$5}' |awk '{print "TOP"NR" "$0}'
    }

    function sql_text_filter(){
        if [ "yes" == "$sql_detail" ]
        then
            echo -n "TIBERO Parameter: TPR_SNAPSHOT_TOP_SQL_CNT (default 5) : "
            read top_sql_cnt
        fi
    }

    function sql_text_loop(){
        if [ "yes" == "$sql_detail" ]
        then
            for file_name in ${file_list[@]}
            do
                type$sql_text_type
            done |grep TOP$top_sql_cnt |sort |uniq -c |sort
        else
            for file_name in ${file_list[@]}
            do
                type$sql_text_type
            done
        fi
    }

    echo "0 - ALL"
    echo "1 - SQL Ordered by Elapsed Time"
    echo "2 - SQL Ordered by Elapsed Time per Execution"
    echo "3 - SQL Ordered by Executions"
    echo "4 - SQL Ordered by Gets"
    echo "5 - SQL Ordered by Reads"
    echo "6 - SQL Ordered by Extra I/O"
    echo "7 - SQL Ordered by CPU"
    echo -n "select: "
    echo ""

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
    wait_event_text_loop(){

    }
    wait_event_text_filter(){

    }
    grep -A10 "3.3 Top 5" thread0_20240719_203411_20240719_213411|grep -A6 "\--" |tail -n 5
}

arg1="$1"
arg2="$2"

 
case $arg1 in 
    "-wait")
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
