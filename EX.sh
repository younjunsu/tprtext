# 8.3 SQL Ordered by Elapsed Time
file_list=(`ls thread0*`)
for file_name in ${file_list[@]}
do
    grep -A1000 "8.3 SQL" $file_name \
    |grep -B1000 "8.4 SQL" \
    |grep -A7 "Overall Stats" \
    |sed -n '/----------/ {n;p;}'  \
    |awk '{print $5"/"$6}' |awk '{print "TOP"NR" "$0}'
done

# 8.4 SQL Ordered by Elapsed Time per Execution
for file_name in ${file_list[@]}
do
    grep -A1000 "8.4 SQL" $file_name \
    |grep -B1000 "8.5 SQL" \
    |grep -A7 "Overall Stats" \
    |sed -n '/----------/ {n;p;}'  \
    |awk '{print $5"/"$6}' |awk '{print "TOP"NR" "$0}'
done


# 8.5 SQL Ordered by Executions
file_list=(`ls thread0*`)
for file_name in ${file_list[@]}
do
    grep -A1000 "8.5 SQL" $file_name \
    |grep -B1000 "8.6 SQL" \
    |grep -A7 "Overall Stats" \
    |sed -n '/----------/ {n;p;}'  \
    |awk '{print $5"/"$6}' |awk '{print "TOP"NR" "$0}'
done


# 8.6 SQL Ordered by Gets
file_list=(`ls thread0*`)
for file_name in ${file_list[@]}
do
    grep -A1000 "8.6 SQL" $file_name \
    |grep -B1000 "8.7 SQL" \
    |grep -A7 "Overall Stats" \
    |sed -n '/----------/ {n;p;}'  \
    |awk '{print $6"/"$7}' |awk '{print "TOP"NR" "$0}'
done


# 8.7 SQL Ordered by Reads
for file_name in ${file_list[@]}
do
    grep -A1000 "8.7 SQL" $file_name \
    |grep -B1000 "8.8 SQL" \
    |grep -A7 "Overall Stats" \
    |sed -n '/----------/ {n;p;}'  \
    |awk '{print $6"/"$7}' |awk '{print "TOP"NR" "$0}'
done


# 8.8 SQL Ordered by Extra I/O
#file_list=(`ls thread0*`)
#for file_name in ${file_list[@]}
#do
#    grep -A1000 "8.8 SQL" $file_name \
#    |grep -B1000 "8.9 SQL" \
#    |grep -A7 "Overall Stats" \
#    |sed -n '/----------/ {n;p;}'  \
#    |awk '{print $4"/"$5}' |awk '{print "TOP"NR" "$0}'
#done


# 8.9 SQL Ordered by CPU
for file_name in ${file_list[@]}
do
    grep -A1000 "8.9 SQL" $file_name \
    |grep -B1000 " 9. Etc Section" \
    |grep -A7 "Overall Stats" \
    |sed -n '/----------/ {n;p;}'  \
    |awk '{print $4"/"$5}' |awk '{print "TOP"NR" "$0}'
done