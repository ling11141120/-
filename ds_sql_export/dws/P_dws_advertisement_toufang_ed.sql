----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_advertisement_toufang_ed
-- workflow_version : 13
-- create_user      : yanxh
-- task_name        : dws_advertisement_toufang_ed
-- task_version     : 12
-- update_time      : 2024-11-18 15:38:19
-- sql_path         : \starrocks\tbl_dws_advertisement_toufang_ed\dws_advertisement_toufang_ed
----------------------------------------------------------------
-- SQL语句
insert overwrite dws.dws_advertisement_toufang_ed
select dt, type, ProductId, ifnull(Core,-99), ifnull(CurrentLanguage2,-99), ifnull(Mt,-99), sum(Spend) as spend ,now() as etl_time
from (
         select dt, type, ProductId, Core, CurrentLanguage2, Mt, Spend
         from (
                  select date_start as dt, 1 as type, ProductId, FbAccountId, Spend
                  from dim.dim_FbAdDailyInsight_view
                  where ProductId not in(7777,8888)
              ) t1
                  left join (
             select account, Core, CurrentLanguage2, Mt
             from dim.dim_FbAccount_view
         ) t2 on t1.FbAccountId = t2.Account
         union all
         -- ---------------------------------------------------
         select date_start as dt, 2 as type, ProductId, Core, CurrentLanguage2, Mt, Spend
         from dim.dim_LtvDailyInsight_view
         where ProductId not in(7777,8888,6833)
         union all
         -- -----------------------------------------------------------
              select a.date_start as dt, 2 as type, a.productid as product_id, b.core, b.current_language2, b.mt, a.spend
         from
             (
                 select a.productid, a.spend,adid,a.date_start
                 from dim.dim_LtvDailyInsight_view a
                 where a.productid =6833
             ) a
                 left join
     (select ad_id  ,fb_account ,core,current_language2, mt from dwd.dwd_advertisement_adext_view) b
               on a.adid = b.ad_id
         -- 修改-20241118
         where b.core = 1
              --  left join
          --   (select  account,product_id, current_language2, corever,mt from dim.dim_short_viedo_ads_accountinfo_view   group by 1,2,3,4,5 ) c
        --    on b.fb_account = c.account
        union all
        select  date(date_start) as dt,3 as type,product_id,core,current_language2,mt, spend/7 as spend
        from dwd.dwd_advertisement_video_cn_dailyinsightbyhour_view
        where product_id=6883
     ) t1
group by 1, 2, 3, 4, 5, 6;
