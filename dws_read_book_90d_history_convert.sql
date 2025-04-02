#!/bin/bash
starttime='2023-06-21'
endday='2023-07-11'
i=${starttime}
daynum=1
while [[ $i < `date -d "+1 day $endday" +%Y-%m-%d`  ]]
do
starttime=$(date -d "$i -$daynum day" +"%Y-%m-%d")
today=${starttime}
endtime=$(date -d "$i 0 hour" +"%Y-%m-%d")
echo "----------------=================${today} === ${starttime}"

sql="
insert into dws.dws_read_book_90d
select '${today}' as dt, site_id, book_id, bitmap_union(to_bitmap(user_id)) as read_user_90d
from dws.dws_read_user_readbook_1d
where dt >= date_sub('${today}', interval 93 day)
  and dt < '${today}'
group by site_id, book_id;
"
echo "???sql:\t ${sql}"
  mysql -h idc-starrocks-proxysql.changdu.vip -P 19030 -u lq -p21DdD9db2Y -e "${sql}"

i=`date -d "+$daynum day $i" +%Y-%m-%d`
done