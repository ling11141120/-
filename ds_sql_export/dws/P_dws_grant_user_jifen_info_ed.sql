----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_grant_user_jifen_info_ed
-- workflow_version : 1
-- create_user      : yanxh
-- task_name        : dws_grant_user_jifen_info_ed
-- task_version     : 1
-- update_time      : 2024-01-26 14:12:33
-- sql_path         : \starrocks\tbl_dws_grant_user_jifen_info_ed\dws_grant_user_jifen_info_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_grant_user_jifen_info_ed  where dt>='${bf_1_dt}';

-- SQL语句
insert into dws.dws_grant_user_jifen_info_ed
  select  a.dt,a.product_id ,user_id,
  a.corever,a.mt,
           (case when acc.product_id = 3311 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  6
             when acc.product_id = 3322 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  5
             when acc.product_id = 3333 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  2
             when acc.product_id = 3366 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  3
             when acc.product_id = 3371 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  7
             when acc.product_id = 3388 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  4
             when acc.product_id = 3501 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  11
             when acc.product_id = 3511 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  12
             when acc.product_id = 3399 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  9
                else ifnull(acc.Current_Language2,-99) end ) as  current_language2,
       acc.current_language,
       acc.Create_Time as reg_time,datediff(a.dt,acc.Create_Time) as reg_days,acc.reg_country as reg_country,
  a.app_ver,a.source_tp,
  a.coin_tp,
  case when a.source_tp ='invite' then '好友邀请活动'
       when a.source_tp ='MealTask' then '吃饭任务'
       when a.source_tp ='CoinExchange' then '商城阅币兑换积分' else
  c.content end as source_name,
  a.cnt,a.amount as amt,
  now() as etl_tm
  from (
select a.dt,a.product_id ,a.user_id,
case when a.corever is null then -99 else a.corever end as corever,
case when a.mt is null then -99 else a.mt end as mt ,
case when a.app_ver is null then -99 else a.app_ver  end as app_ver,
 LTRIM(case when  a.source_key is null then a.source else a.source_key end)as source_tp,
4 as coin_tp,
count(1) as cnt,
sum(send_num) as amount
from dwd.dwd_grant_jifenitemmonthlog a
where a.dt >='${bf_1_dt}' and a.dt < '${dt}'--  and a.product_id not in (7777,8888)
     and a.op=1
   group by  1,2,3,4,5 ,6,7 ,8
     ) a
     left join (
    select product_id,id,CoreVer,mt,AppVer,Create_Time,reg_country,Current_Language2,current_language
    from dim.dim_user_account_info_view
) acc    on a.product_id=acc.product_id and a.user_id=acc.Id
left join
	dim.dim_apptranslationdb_translation_view c
	on a.source_tp=c.server_key
	;
