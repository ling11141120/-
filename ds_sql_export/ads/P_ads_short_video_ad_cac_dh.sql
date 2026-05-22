----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_short_video_ad_cac_dh
-- workflow_version : 16
-- create_user      : linq
-- task_name        : ads_short_video_ad_cac_dh
-- task_version     : 6
-- update_time      : 2024-06-05 10:55:59
-- sql_path         : \starrocks\tbl_ads_short_video_ad_cac_dh\ads_short_video_ad_cac_dh
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_short_video_ad_cac_dh where dt='${dt}';

-- SQL语句
insert into ads.ads_short_video_ad_cac_dh
with first_dt as (
    select AdId, max(AdSetId) as AdSetId, max(account_tz) as account_tz, min(first_spand_dt) as first_spand_dt
    from(
        select a.AdId,a.AdSetId,if(b.account_tz is null or b.account_tz='',-13,b.account_tz) as account_tz,
               date(min(date_start)) as first_spand_dt
        from dim.dim_FbAdDailyInsight_view a
        left join (
            select account,account_tz from dim.dim_ad_account where types=1
        ) b on a.FbAccountId = b.account
        group by 1,2,3
        union all
        select a.AdId,a.AdSetId,if(b.account_tz is null or b.account_tz='',-13,b.account_tz) as account_tz,
               date(min(date_start)) as first_spand_dt
        from dim.dim_LtvDailyInsight_view a
        left join (
            select account,account_tz from dim.dim_ad_account where types=2
        ) b on a.Account = b.account
        where ProductId=6833 and SourceChl='tt' and Spend>0
        group by 1,2,3
        union all
        select a.AdId,a.AdSetId,if(b.account_tz is null or b.account_tz='',-13,b.account_tz) as account_tz,
               date(min(date_start)) as first_spand_dt
        from dim.dim_LtvDailyInsight_view a
        left join (
            select account,account_tz from dim.dim_ad_account where types=4
        ) b on a.Account = b.account
        where ProductId=6833 and SourceChl='adwords' and Spend>0
        group by 1,2,3
    )t1
    group by 1
)
select '${dt}' as dt,AdSetId,cac,now() as etl_time
from(
    select if(first_dt.AdSetId=-99 or first_dt.AdSetId is null,a.ad_set_id,first_dt.AdSetId) as AdSetId,IFNULL(account_tz,-13) as account_tz,
           sum(cost_amount) as cost_amount,sum(day150_first_pay_num) as day150_first_pay_num,
           round(sum(cost_amount)/sum(day150_first_pay_num),2) as cac,
           if(min(if(cost_amount>0,dt,null))=date(date_add('${dt_time}',interval IFNULL(account_tz,-13) hour )),1,0) as is_new_ad_set
    from(
        select ad_id,ad_set_id,date(create_time) as dt,sum(cost_amount) as cost_amount,sum(day150_first_pay_num) as day150_first_pay_num
        from dwd.dwd_ad_fb_ad_roi_install_referrer_timezone_di_view
        where product_id=6833
        group by 1,2,3
    ) a
    left join first_dt on a.ad_id=first_dt.AdId
    group by 1,2
)c
where is_new_ad_set=0 and cac>0 and cast(AdSetId as bigint)>0;
