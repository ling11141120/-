----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_grant_user_giftlog_ed_lq
-- workflow_version : 8
-- create_user      : linq
-- task_name        : dws_grant_user_giftlog_ed
-- task_version     : 8
-- update_time      : 2024-01-25 18:24:49
-- sql_path         : \starrocks\tbl_dws_grant_user_giftlog_ed_lq\dws_grant_user_giftlog_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_grant_user_giftlog_ed where dt = '${bf_1_dt}';

-- SQL语句
insert into  dws.dws_grant_user_giftlog_ed
select a.dt,
       md5(concat_ws('-',a.product_id,user_id,op_type,gift_type,CoreVer,mt,ver,Current_Language,Current_Language,Reg_Country,AppVer,Create_Time)) as md5_key,
       a.product_id,
       a.user_id,
       ifnull(a.op_type,-99) as op_type,
       ifnull(a.gift_type,-99) as gift_type,
       ifnull(acc.CoreVer,-99) as CoreVer,
       ifnull(acc.mt,-99) as mt,
       ifnull(acc.Ver,-99) as Ver,
       ifnull(acc.Current_Language,-99) as CurrentLanguage,
           (case when acc.product_id = 3311 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  6
             when acc.product_id = 3322 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  5
             when acc.product_id = 3333 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  2
             when acc.product_id = 3366 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  3
             when acc.product_id = 3371 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  7
             when acc.product_id = 3388 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  4
             when acc.product_id = 3501 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  11
             when acc.product_id = 3511 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  12
             when acc.product_id = 3399 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  9
             else ifnull(acc.Current_Language2,-99) end ) as  currentlanguage2,
       ifnull(acc.Reg_Country,-99) as Reg_Country,
       ifnull(acc.appver,-99) as appver,
       ifnull(acc.Create_Time,'1970-01-01') as reg_time,
       datediff(dt,ifnull(acc.Create_Time,'1970-01-01')) as reg_days,
       ifnull(acc.sex,-99) as sex,
       sum(gift_num) as amount,
       now() as etl_time
from (
         select dt,product_id, user_id, op_type, gift_type, gift_num
         from dwd.dwd_grant_user_giftlog
         where dt>='${bf_1_dt}' and dt<'${dt}'
     )a left join (
    select product_id,id,CoreVer,mt,Ver,Current_Language,Current_Language2,Reg_Country,AppVer,Create_Time,sex
    from dim.dim_user_account_info_view
) acc on a.product_id=acc.product_id and a.user_id=acc.Id
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16;
