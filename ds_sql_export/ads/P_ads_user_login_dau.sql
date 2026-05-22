----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_user_login_dau
-- workflow_version : 6
-- create_user      : admin
-- task_name        : ads_user_login_dau
-- task_version     : 6
-- update_time      : 2025-04-07 18:41:39
-- sql_path         : \starrocks\tbl_ads_user_login_dau\ads_user_login_dau
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_user_login_dau
select
    dt,Productid,user_type,
    mt,
    core,
    regcountry,
    appver,
    dau,
    free_dau,
    pay_dau,
    etl_time
from(
        select dt,Productid,user_type,
               ifnull(mt,-99) as mt,ifnull(core,-99) as core,ifnull(regcountry,-99) as regcountry,ifnull(appver,-99) as appver,
               count(distinct userid)                          as dau,
               count(distinct if(ifnull(Has_Charge,0) = 0, userid, null)) as free_dau,
               count(distinct if(Has_Charge = 1, userid, null)) as pay_dau,
               now() as etl_time
        from (
                 select dt,login.Productid,login.userid,login.user_type,login.mt,login.core,login.regcountry,login.appver,acc.Has_Charge
                 from (
                          select dt,Productid,userid,if(regdays <= 7, 'n7', 'o7') user_type,mt,corever as core,regcountry,appver
                          from dws.dws_user_login_ed
                          where dt >= '${bf_1_dt}' and dt < '${dt}'
                      ) login
                          left join (
                     select product_id, id, Has_Charge from dim.dim_user_account_info_view
                 ) acc on login.Productid = acc.product_id and login.userid = acc.Id
             ) t1
        group by 1, 2, 3, 4, 5, 6, 7
        union all
        select dt,Productid,user_type,
               ifnull(mt,-99) as mt,ifnull(core,-99) as core,ifnull(regcountry,-99) as regcountry,ifnull(appver,-99) as appver,
               count(distinct userid)                          as dau,
               count(distinct if(ifnull(Has_Charge,0) = 0, userid, null)) as free_dau,
               count(distinct if(Has_Charge = 1, userid, null)) as pay_dau,
               now() as etl_time
        from (
                 select dt,login.Productid,login.userid,login.user_type,login.mt,login.core,login.regcountry,login.appver,acc.Has_Charge
                 from (
                          select dt,Productid,userid,if(regdays <= 30, 'n30', 'o30') user_type,mt,corever as core,regcountry,appver
                          from dws.dws_user_login_ed
                          where dt >= '${bf_1_dt}' and dt < '${dt}'
                      ) login
                          left join (
                     select product_id, id, Has_Charge from dim.dim_user_account_info_view
                 ) acc on login.Productid = acc.product_id and login.userid = acc.Id
             ) t1
        group by 1, 2, 3, 4, 5, 6, 7
        union all
        select dt,Productid,user_type,
               ifnull(mt,-99) as mt,ifnull(core,-99) as core,ifnull(regcountry,-99) as regcountry,ifnull(appver,-99) as appver,
               count(distinct userid)                          as dau,
               count(distinct if(ifnull(Has_Charge,0) = 0, userid, null)) as free_dau,
               count(distinct if(Has_Charge = 1, userid, null)) as pay_dau,
               now() as etl_time
        from (
                 select dt,login.Productid,login.userid,login.user_type,login.mt,login.core,login.regcountry,login.appver,acc.Has_Charge
                 from (
                          select dt,Productid,userid,if(regdays>7 and regdays <= 30, 'n7_30', 'o7_30') user_type,mt,corever as core,regcountry,appver
                          from dws.dws_user_login_ed
                          where dt >= '${bf_1_dt}' and dt < '${dt}'
                      ) login
                          left join (
                     select product_id, id, Has_Charge from dim.dim_user_account_info_view
                 ) acc on login.Productid = acc.product_id and login.userid = acc.Id
             ) t1
        group by 1, 2, 3, 4, 5, 6, 7
    )a ;
