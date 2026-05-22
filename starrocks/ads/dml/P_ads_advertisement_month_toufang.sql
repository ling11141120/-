----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_advertisement_month_toufang
-- workflow_version : 6
-- create_user      : linq
-- task_name        : ads_advertisement_month_toufang
-- task_version     : 6
-- update_time      : 2024-11-18 15:25:55
-- sql_path         : \starrocks\tbl_ads_advertisement_month_toufang\ads_advertisement_month_toufang
----------------------------------------------------------------
-- SQL语句
insert overwrite ads.ads_advertisement_month_toufang
select datetypes,productid as product_id,sum(spends) as month_spend ,now() as etl_time
from (
         select
             1 as datetypes,productid, coalesce(b.core, -99) as core,sum(a.Spend) as spends
         from (
             select productid,AdId, Spend
             from dim.dim_FbAdDailyInsight_view
             where date_start >= DATE_SUB(CURDATE(), INTERVAL dayofmonth(now()) - 1 DAY)
         ) a
         left join dwd.dwd_advertisement_adext_view b on a.AdId = b.ad_id
         group by 1,2,3
         union all
         select 1 as datetypes,productid,Core, sum(Spend) as spends
         from dim.dim_LtvDailyInsight_view
         where date_start >= DATE_SUB(CURDATE(), INTERVAL dayofmonth(now()) - 1 DAY) group by 1,2,3
         union all
         select
             2 as datetypes,productid, coalesce(b.core, -99) as core,sum(a.Spend) as spends
         from (
             select productid,AdId, Spend
             from dim.dim_FbAdDailyInsight_view
             where date_start >= date_sub(date_sub(curdate(), interval day(curdate()) - 1 day), interval 1 month)
             and date_start <= case when day(now()) > day(date_sub(now(),interval 1 month))
             then DATE_FORMAT(date_sub(now(),interval 1 month),'%Y-%m-%d 23:59:59')
             else date_sub(now(),interval 1 month) end
         ) a
         left join dwd.dwd_advertisement_adext_view b on a.AdId = b.ad_id
         group by 1,2,3
         union all
         select 2 as datetypes, productid,Core,sum(Spend) as spends
         from dim.dim_LtvDailyInsight_view
         where date_start >= date_sub(date_sub(curdate(), interval day(curdate()) - 1 day), interval 1 month)
           and date_start <=case when day(now()) > day(date_sub(now(),interval 1 month))
 then DATE_FORMAT(date_sub(now(),interval 1 month),'%Y-%m-%d 23:59:59')
 else date_sub(now(),interval 1 month) end
         group by 1,2,3
         union all
         select 1 as datetypes,product_id,core,sum(spend)/7 as spends
         from dwd.dwd_advertisement_video_cn_dailyinsightbyhour_view
         where date_start >= DATE_SUB(CURDATE(), INTERVAL dayofmonth(now()) - 1 DAY) group by 1,2,3
         union all
         select 2 as datetypes,product_id,core,sum(spend)/7 as spends
         from dwd.dwd_advertisement_video_cn_dailyinsightbyhour_view
         where date_start >= date_sub(date_sub(curdate(), interval day(curdate()) - 1 day), interval 1 month)
         and date_start <= case when day(now()) > day(date_sub(now(),interval 1 month))
 then DATE_FORMAT(date_sub(now(),interval 1 month),'%Y-%m-%d 23:59:59')
 else date_sub(now(),interval 1 month) end
         group by 1,2,3
     )t1
where ProductId != 6833 or (ProductId = 6833 AND core = 1)
group by 1,2;
