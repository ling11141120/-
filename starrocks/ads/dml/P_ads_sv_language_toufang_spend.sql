----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_language_toufang_spend
-- workflow_version : 11
-- create_user      : chenmo
-- task_name        : ads_sv_language_toufang_spend
-- task_version     : 9
-- update_time      : 2024-12-16 17:22:04
-- sql_path         : \starrocks\tbl_ads_sv_language_toufang_spend\ads_sv_language_toufang_spend
----------------------------------------------------------------
-- SQL语句
insert overwrite ads.ads_sv_language_toufang_spend
select
    md5(concat(series_id, put_language, core)) as id,
    series_id,
    core,
    put_language,
    spend,
    ifnull(spend/sum(spend) over(partition by put_language, core), 0.00) as spend_rate,
    now() as etl_time
from (
    select
        t3.series_id as series_id,
        t2.core,
        t3.language as put_language,
        sum(Spend) as spend
    from (
        select
            dt, type, AdId, ProductId, Core, CurrentLanguage2, Mt, Spend
        from (
            select
                date_start as dt, 1 as type, ProductId, FbAccountId, AdId, Spend
            from dim.dim_FbAdDailyInsight_view
            where ProductId = 6833 and date_start = '${bf_1_dt}'
        ) t1
        left join (
            select
                account, Core, CurrentLanguage2, Mt
            from dim.dim_FbAccount_view
        ) t2 on t1.FbAccountId = t2.Account
        union all
        -- -----------------------------------------------------------
        select
            a.date_start as dt, 2 as type, a.AdId, a.productid as product_id, b.core, b.current_language2, b.mt, a.spend
        from (
            select
                a.productid, a.spend,adid, a.date_start
            from dim.dim_LtvDailyInsight_view a
            where a.productid = 6833 and date_start = '${bf_1_dt}'
        ) a
        left join (
            select
                ad_id, fb_account, core, current_language2, mt
            from dwd.dwd_advertisement_adext_view
        ) b on a.adid = b.ad_id
    ) t1
    left join dwd.dwd_advertisement_adext_view as t2 on t1.AdId = t2.ad_id and t1.ProductId = t2.product_id
    left join dim.dim_short_video_series_view as t3 on t2.book_id = t3.series_id
    group by 1, 2, 3
) t
where series_id is not null and core is not null and put_language is not null and spend is not null;
