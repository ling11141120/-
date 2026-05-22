----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_srsv_user_ads_book_a
-- workflow_version : 11
-- create_user      : yanxh
-- task_name        : dws_srsv_user_ads_book_a_part1
-- task_version     : 11
-- update_time      : 2025-02-08 10:16:52
-- sql_path         : \starrocks\tbl_dws_srsv_user_ads_book_a\dws_srsv_user_ads_book_a_part1
----------------------------------------------------------------
-- SQL语句
insert into  dws.dws_srsv_user_ads_book_a
-- 筛选出前天到现在的数据-----------
with now_user as (
 select concat(product_id ,user_id ,mt,core,current_language2 ) as user_id
  from dwd.dwd_advertisement_if_user_attribution_queue_view
 where install_date>='${bf_2_dt}' and install_date< date_add(now(),interval -1 minute)
   and  book_id  is not null  and book_id !=0 and user_id >0
 group by 1
),

yesterday_data as (
select product_id ,user_id ,mt,corever,lang2,last_bookid ,lst_install_date
from  dws.dws_srsv_user_ads_book_a
where dt='${bf_1_dt}'
  and concat(product_id,user_id,mt,corever,lang2) in ( select user_id from now_user )
),

all_data_tmp as (
select product_id ,user_id ,mt,corever,lang2,last_bookid ,lst_install_date
 from yesterday_data
union all
-- 合并前天至当前最新的数据------------------
select product_id ,user_id ,mt,core as corever,current_language2 as lang2,book_id,install_date
from dwd.dwd_advertisement_if_user_attribution_queue_view
where install_date>='${bf_2_dt}' and install_date<  date_add(now(),interval -1 minute)
  and  book_id  is not null  and book_id !=0 and user_id >0
)

-- -------------- 每次更新前前天至今天当前时间截止1分钟的数据 更新updatetime 字段---------------------------------
select '${dt}' as dt, product_id ,user_id ,mt,corever,lang2,last_bookid,lst_install_date,now() as updatetime
from (
         select product_id ,user_id ,mt,corever,lang2,last_bookid,lst_install_date,
                row_number() over(partition by  product_id,user_id,mt,corever,lang2  order by lst_install_date desc  ) as rank_1
         from all_data_tmp v
     ) b
where rank_1=1;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_srsv_user_ads_book_a
-- workflow_version : 11
-- create_user      : yanxh
-- task_name        : dws_srsv_user_ads_book_a_part2
-- task_version     : 1
-- update_time      : 2025-02-08 10:16:52
-- sql_path         : \starrocks\tbl_dws_srsv_user_ads_book_a\dws_srsv_user_ads_book_a_part2
----------------------------------------------------------------
-- SQL语句
insert into  dws.dws_srsv_user_ads_book_a
-- -------------筛选出没有更新的历史数据,updatetime的值不变 ----------------------
select '${dt}' as dt,  a.product_id ,a.user_id ,a.mt,a.corever,a.lang2,a.last_bookid,a.lst_install_date,a.updatetime
from  dws.dws_srsv_user_ads_book_a a
left join
    (  -- 筛选出前天至现在最新的数据-----------
        select product_id ,user_id ,mt,core as corever,current_language2 as lang2,book_id,install_date
        from dwd.dwd_advertisement_if_user_attribution_queue_view
        where install_date>='${bf_2_dt}' and install_date<  date_add(now(),interval -1 minute)
          and  book_id  is not null  and book_id !=0 and user_id >0
    ) b
on a.product_id=b.product_id  and a.user_id=b.user_id and a.mt=b.mt and a.corever=b.corever and a.lang2=b.lang2
where a.dt='${bf_1_dt}'  and b.product_id is null and b.user_id is null and b.mt is null and b.corever is null  and b.lang2 is null;
