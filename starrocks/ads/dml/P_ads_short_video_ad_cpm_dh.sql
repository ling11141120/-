----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ads_optimize
-- workflow_version : 95
-- create_user      : xixg
-- task_name        : ads_short_video_ad_cpm_dh
-- task_version     : 2
-- update_time      : 2025-04-10 19:12:40
-- sql_path         : \starrocks\sch_ads_optimize\ads_short_video_ad_cpm_dh
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_short_video_ad_cpm_dh where dt='${bf_1_dt}';

-- SQL语句
insert into ads.ads_short_video_ad_cpm_dh
with ad as (
    select a.date_start as dt,a.ad_set_id,a.country,a.spend,a.impressions,
           if(b.account_tz is null or b.account_tz='',-13,b.account_tz) as account_tz
    from dwd.dwd_advertisement_fbad_country_daily_insight_view a
    left join (
        select account,account_tz from dim.dim_ad_account where types=1
    ) b on a.fb_account_id = b.account
    where product_id=6833
    union all
    -- tt
    select a.date_start as dt,a.ad_set_id,a.country,a.spend,a.impressions,
           if(b.account_tz is null or b.account_tz='',-13,b.account_tz) as account_tz
    from dwd.dwd_advertisement_ltv_country_daily_insight_view a
    left join(
        select account,account_tz from dim.dim_ad_account where types=2
        )b
    on a.account = b.account
    where product_id=6833 and a.source_chl='tt'
    union all
    -- adwords
    select a.date_start as dt,a.ad_set_id,a.country,a.spend,a.impressions,
           if(b.account_tz is null or b.account_tz='',-13,b.account_tz) as account_tz
    from dwd.dwd_advertisement_ltv_country_daily_insight_view a
    left join(
        select account,account_tz from dim.dim_ad_account where types=4
        )b
    on a.account = b.account
    where product_id=6833 and a.source_chl='adwords'
)
select dt, ad_set_id, country, cpm,now() as etl_time
from(
    select dt, ad_set_id, if(rn<=50,country,'other') as country,
           round(sum(spend)/sum(impressions)*1000,2) as cpm,
           min(is_new_ad_set) as is_new_ad_set
    from(
        select dt, ad_set_id, country,spend,impressions,is_new_ad_set,
               row_number() over (partition by dt,ad_set_id order by impressions desc ,spend desc,country) rn
        from(
            select '${bf_1_dt}' as dt,ad_set_id,country,account_tz,
                   sum(if(dt=date(date_add('${bf_1_dt_time}',interval account_tz hour )),Spend,0)) as spend,
                   sum(if(dt=date(date_add('${bf_1_dt_time}',interval account_tz hour )),Impressions,0)) as impressions,
                   if(min(if(Spend>0,dt,null))=date(date_add('${bf_1_dt_time}',interval account_tz hour )),1,0) as is_new_ad_set
            from(
                select date(dt) as dt,ad_set_id ,Country,Spend,impressions,account_tz
                from ad
                where dt<=date(date_add('${bf_1_dt_time}',interval account_tz hour )) and cast(ad_set_id as bigint)>0
            )t1
            group by 1,2,3,4
        )t2
        where is_new_ad_set=0
    )t3
    group by 1,2,3
)t4
where cpm>0;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_short_video_ad_cpm_dh
-- workflow_version : 30
-- create_user      : linq
-- task_name        : ads_short_video_ad_cpm_dh
-- task_version     : 15
-- update_time      : 2025-04-10 19:11:24
-- sql_path         : \starrocks\tbl_ads_short_video_ad_cpm_dh\ads_short_video_ad_cpm_dh
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_short_video_ad_cpm_dh where dt='${bf_1_dt}';

-- SQL语句
insert into ads.ads_short_video_ad_cpm_dh
with ad as (
    select a.date_start as dt,a.ad_set_id,a.country,a.spend,a.impressions,
           if(b.account_tz is null or b.account_tz='',-13,b.account_tz) as account_tz
    from dwd.dwd_advertisement_fbad_country_daily_insight_view a
    left join (
        select account,account_tz from dim.dim_ad_account where types=1
    ) b on a.fb_account_id = b.account
    where product_id=6833
    union all
    -- tt
    select a.date_start as dt,a.ad_set_id,a.country,a.spend,a.impressions,
           if(b.account_tz is null or b.account_tz='',-13,b.account_tz) as account_tz
    from dwd.dwd_advertisement_ltv_country_daily_insight_view a
    left join(
        select account,account_tz from dim.dim_ad_account where types=2
        )b
    on a.account = b.account
    where product_id=6833 and a.source_chl='tt'
    union all
    -- adwords
    select a.date_start as dt,a.ad_set_id,a.country,a.spend,a.impressions,
           if(b.account_tz is null or b.account_tz='',-13,b.account_tz) as account_tz
    from dwd.dwd_advertisement_ltv_country_daily_insight_view a
    left join(
        select account,account_tz from dim.dim_ad_account where types=4
        )b
    on a.account = b.account
    where product_id=6833 and a.source_chl='adwords'
)
select dt, ad_set_id, country, cpm,now() as etl_time
from(
    select dt, ad_set_id, if(rn<=50,country,'other') as country,
           round(sum(spend)/sum(impressions)*1000,2) as cpm,
           min(is_new_ad_set) as is_new_ad_set
    from(
        select dt, ad_set_id, country,spend,impressions,is_new_ad_set,
               row_number() over (partition by dt,ad_set_id order by impressions desc ,spend desc,country) rn
        from(
            select '${bf_1_dt}' as dt,ad_set_id,country,account_tz,
                   sum(if(dt=date(date_add('${bf_1_dt_time}',interval account_tz hour )),Spend,0)) as spend,
                   sum(if(dt=date(date_add('${bf_1_dt_time}',interval account_tz hour )),Impressions,0)) as impressions,
                   if(min(if(Spend>0,dt,null))=date(date_add('${bf_1_dt_time}',interval account_tz hour )),1,0) as is_new_ad_set
            from(
                select date(dt) as dt,ad_set_id ,Country,Spend,impressions,account_tz
                from ad
                where dt<=date(date_add('${bf_1_dt_time}',interval account_tz hour )) and cast(ad_set_id as bigint)>0
            )t1
            group by 1,2,3,4
        )t2
        where is_new_ad_set=0
    )t3
    group by 1,2,3
)t4
where cpm>0;
