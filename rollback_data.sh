#!/bin/sh
#
#  回溯数据工具
#  
#  
#############

workspace=`pwd`
cd ${workspace}


i=1
j=40
# configure
#判断是否有输入的日期参数
if [[ -z $1 ]];then
   echo "未输入日期参数，运行昨天的数据"
   date_str=`date +"%Y-%m-%d" -d " -$i day"`
   date_str_40=`date +"%Y-%m-%d" -d " -$j day"`
   date_int=`date +"%Y%m%d" -d " -$i day"`
   date_int_40=`date +"%Y%m%d" -d " -$j day"`
else
   echo "已输入日期参数为：${1}"
   date_str=$1
   date_str_40=`date -d "$1 -40 day" +%Y-%m-%d`
   date_int=`echo $1|sed -e 's/-//g'`
   date_int_40=`echo ${date_str_40}|sed -e 's/-//g'`
fi


your_shell_script="your_shell_script.sh"

no_exe_arr=()
for ((i=0;i<=39;i++));do
dt=`date -d "${date_str_40} +${i} day" +%Y-%m-%d`
no_exe_arr[i]="nohup sh ${your_shell_script} ${dt} &"
done

done_exe_arr=()

while [ "1" = "1" ];do
sleep 3
pid_num=`ps -ef|grep ${your_shell_script}|grep -v grep|wc -l`

echo "executing progress number==="$pid_num
echo "wait to execute progress number==="${#no_exe_arr[@]}
echo "complete execute progress number==="${#done_exe_arr[@]}

if [ ${#no_exe_arr[@]} -gt 0  -a  $pid_num -lt 10 ]
then
for((i=${#done_exe_arr[@]};i<$((10-$(ps -ef|grep ${your_shell_script}|grep -v grep|wc -l)+${#done_exe_arr[@]}));i++));do
 sleep 3
 echo "begin run ... "${no_exe_arr[i]}
 eval ${no_exe_arr[i]}
 done_exe_arr[i]=no_exe_arr[i]
 unset no_exe_arr[i]
 done
fi

if [ ${#no_exe_arr[@]} -eq 0 -a $(ps -ef|grep ${your_shell_script}|grep -v grep|wc -l) -eq 0 ]
then 
break
fi
done



