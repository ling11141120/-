----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_grant_user_getmoneylog_ed_lq
-- workflow_version : 10
-- create_user      : linq
-- task_name        : dws_grant_user_getmoneylog_ed
-- task_version     : 10
-- update_time      : 2025-10-20 01:42:05
-- sql_path         : \starrocks\tbl_dws_grant_user_getmoneylog_ed_lq\dws_grant_user_getmoneylog_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_grant_user_getmoneylog_ed where dt = '${bf_1_dt}';

-- SQL语句
insert into dws.dws_grant_user_getmoneylog_ed
select a.dt,md5(concat_ws('-',a.product_id,user_id,CoreVer,mt,ver,Current_Language,Current_Language,Reg_Country,AppVer,Create_Time)),
       a.product_id,a.user_id,ifnull(acc.CoreVer,-99) as CoreVer,ifnull(acc.mt,-99) as mt,ifnull(acc.Ver,-99) as Ver,
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
       ifnull(acc.Reg_Country,-99) as RegCountry,ifnull(acc.appver,-99) as appver,ifnull(acc.Create_Time,'1970-01-01') as reg_time,
       datediff(dt,ifnull(acc.Create_Time,'1970-01-01')) as reg_days,ifnull(acc.sex,-99) as sex,
       sum(real_get) as money_amount,sum(gift_money) as gift_money_amount,sum(give) as give_amount,now() as etl_time
from (
         select dt,product_id, user_id, real_get, give, gift_money
         from dwd.dwd_grant_readernovel_getmoneylog_view
         where dt >= '${bf_1_dt}' and dt < '${dt}' and charge_type  not in (5,100)
     )a left join (
    select product_id,id,CoreVer,mt,Ver,Current_Language,Current_Language2,Reg_Country,AppVer,Create_Time,sex
    from dim.dim_user_account_info_view
) acc on a.product_id=acc.product_id and a.user_id=acc.Id
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14;
