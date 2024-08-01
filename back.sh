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
        echo "SQL Ordered by Elapsed Time"
        for file_name in ${file_list[@]}
        do
            echo "TPR File Name: $file_name"
            grep -A50000 "8.3 SQL" $file_name \
            |grep -B50000 "8.4 SQL" \
            |grep -A7 "Overall Stats" \
            |sed -n '/----------/ {n;p;}'  \
            |awk '{print $5"/"$6}' |awk '{print "TOP"NR" "$0}'
        done
    }

    function type2(){
        # 8.4 SQL Ordered by Elapsed Time per Execution
        echo "SQL Ordered by Elapsed Time per Execution"
        for file_name in ${file_list[@]}
        do
            echo "TPR File Name: $file_name"
            grep -A50000 "8.4 SQL" $file_name \
            |grep -B50000 "8.5 SQL" \
            |grep -A7 "Overall Stats" \
            |sed -n '/----------/ {n;p;}'  \
            |awk '{print $5"/"$6}' |awk '{print "TOP"NR" "$0}'
        done

    }

    function type3(){
        # 8.5 SQL Ordered by Executions
        echo "SQL Ordered by Executions"
        for file_name in ${file_list[@]}
        do
            echo "TPR File Name: $file_name"
            grep -A50000 "8.5 SQL" $file_name \
            |grep -B50000 "8.6 SQL" \
            |grep -A7 "Overall Stats" \
            |sed -n '/----------/ {n;p;}'  \
            |awk '{print $5"/"$6}' |awk '{print "TOP"NR" "$0}'
        done
    }    

    function type4(){
        # 8.6 SQL Ordered by Gets
        for file_name in ${file_list[@]}
        do
            echo "TPR File Name: $file_name"
            grep -A50000 "8.6 SQL" $file_name \
            |grep -B50000 "8.7 SQL" \
            |grep -A7 "Overall Stats" \
            |sed -n '/----------/ {n;p;}'  \
            |awk '{print $6"/"$7}' |awk '{print "TOP"NR" "$0}'
        done
    }

    function type5(){
        # 8.7 SQL Ordered by Reads                
        for file_name in ${file_list[@]}
        do
            echo "TPR File Name: $file_name"
            grep -A50000 "8.7 SQL" $file_name \
            |grep -B50000 "8.8 SQL" \
            |grep -A7 "Overall Stats" \
            |sed -n '/----------/ {n;p;}'  \
            |awk '{print $6"/"$7}' |awk '{print "TOP"NR" "$0}'
        done
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
        for file_name in ${file_list[@]}
        do
            echo "TPR File Name: $file_name"
            grep -A50000 "8.9 SQL" $file_name \
            |grep -B50000 " 9. Etc Section" \
            |grep -A7 "Overall Stats" \
            |sed -n '/----------/ {n;p;}'  \
            |awk '{print $4"/"$5}' |awk '{print "TOP"NR" "$0}'
        done
    }    

    function sql_text_filter(){
        filter_option=""
        if [ "Y" == "$sql_detail" ]
        then
            echo -n "TIBERO Parameter: TPR_SNAPSHOT_TOP_SQL_CNT (default 5) : "
            read top_sql_cnt
            echo "$top_sql_cnt"
                
            for num in {1..$top_sql_cnt}
            do
                filter_option="|grep TOP$num |sort |uniq -c"
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

    sql_text_filter
    case $sql_text_type in
        "0")
            type0
        ;;
        "1")
            type1
        ;;
        "2")
            type2
        ;;
        "3")
            type3
        ;;                        
        "4")
            type4
        ;;        
        "5")
            type5
        ;;
        "6")
            type6
        ;;        
        "7")
            type7
        ;;              
        *)
            sql_text
        ;;
    esac

}

function wait_event_text(){
    echo "wait event text"    
}

# args=("$@")
# arg1=${args[0]}
# arg2=${args[1]}
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
        sql_detail=Y
        tpr_file
        sql_text
        ;;
    *)
        tprtext
        ;;
esac
