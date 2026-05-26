----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_cvsv_video_income_expand
-- workflow_version : 14
-- create_user      : linq
-- task_name        : ads_cvsv_video_income_expand_mid
-- task_version     : 5
-- update_time      : 2025-07-08 11:02:28
-- sql_path         : \starrocks\tbl_ads_cvsv_video_income_expand\ads_cvsv_video_income_expand_mid
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_cvsv_video_income_expand_mid where dt>=date_sub('${dt}',interval 3 day) and dt<date_sub('${dt}',interval 2 day);

-- SQL语句
insert into ads.ads_cvsv_video_income_expand_mid
with inex as(
    select dt, series_id, max(sv_income_amt) as sv_income_amt, max(sv_expand) as sv_expand
    from(
        select dt,series_id,sum(consume_money_amt) as sv_income_amt,0 as sv_expand
        from dws.dws_consume_short_video_epis_consume_ed
        where dt>=date_sub('${dt}',interval 3 day ) and dt<date_sub('${dt}',interval 2 day ) and consume_money_amt>0
        group by 1,2
        union all
        select dt, series_id, 0 as sv_income_amt,sv_expand
        from(
            select a.dt,b.book_id as series_id,sum(a.cost_amount) as sv_expand
            from dwd.dwd_advertisement_fbadroiinstallreferrer_view a
            left join dwd.dwd_advertisement_adext_view b
                on a.ad_id = b.ad_id and a.product_id = b.product_id
            where dt>=date_sub('${dt}',interval 3 day ) and dt<date_sub('${dt}',interval 2 day ) and a.product_id=6833 and a.core = 1
            group by 1,2
        )t1
        where series_id is not null and sv_expand>0
    )t2
    group by 1,2
)
select t1.dt,t1.series_id,
       max(t1.source_series_id) as source_series_id,
       max(t1.language) as language,
       max(t2.rights_holder_id) as rights_holder_id,
       sum(t1.sv_income_amt) as sv_income_amt,
       sum(t1.sv_expand) as sv_expand,
       now() as etl_time
from(
    select inex.dt,inex.series_id,
           if(c.is_main=0,c.main_series_id,b.source_series_id) as source_series_id, -- 找到源剧对应的主剧
           b.language,inex.sv_income_amt,inex.sv_expand
    from inex
    left join dim.dim_short_video_series_view b on inex.series_id=b.series_id
    left join dim.dim_short_video_source_series_view c on b.source_series_id=c.series_id
)t1
left join(
    select story_id,cp_userinfo_uuid as rights_holder_id
    from dim.dim_sr_cp_story_view
    where product_type=1 and story_type=2 -- -------海剧------
)t2 on t1.source_series_id=t2.story_id
group by 1,2;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_cvsv_video_income_expand_mid
-- workflow_version : 2
-- create_user      : chenmo
-- task_name        : ads_cvsv_video_income_expand_mid
-- task_version     : 2
-- update_time      : 2024-12-09 11:18:39
-- sql_path         : \starrocks\tbl_ads_cvsv_video_income_expand_mid\ads_cvsv_video_income_expand_mid
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_cvsv_video_income_expand_mid where dt>=date_sub('${dt}',interval 3 day) and dt<date_sub('${dt}',interval 2 day);

-- SQL语句
insert into ads.ads_cvsv_video_income_expand_mid
with inex as(
    select dt, series_id, max(sv_income_amt) as sv_income_amt, max(sv_expand) as sv_expand
    from(
        select dt,series_id,sum(consume_money_amt) as sv_income_amt,0 as sv_expand
        from dws.dws_consume_short_video_epis_consume_ed
        where dt>=date_sub('${dt}',interval 3 day ) and dt<date_sub('${dt}',interval 2 day ) and consume_money_amt>0
        group by 1,2
        union all
        select dt, series_id, 0 as sv_income_amt,sv_expand
        from(
            select a.dt,b.book_id as series_id,sum(a.cost_amount) as sv_expand
            from dwd.dwd_advertisement_fbadroiinstallreferrer_view a
            left join dwd.dwd_advertisement_adext_view b
                on a.ad_id = b.ad_id and a.product_id = b.product_id
            where dt>=date_sub('${dt}',interval 3 day ) and dt<date_sub('${dt}',interval 2 day ) and a.product_id=6833
            group by 1,2
        )t1
        where series_id is not null and sv_expand>0
    )t2
    group by 1,2
)
select t1.dt,t1.series_id,
       max(t1.source_series_id) as source_series_id,
       max(t1.language) as language,
       max(t2.rights_holder_id) as rights_holder_id,
       sum(t1.sv_income_amt) as sv_income_amt,
       sum(t1.sv_expand) as sv_expand,
       now() as etl_time
from(
    select inex.dt,inex.series_id,
           if(c.is_main=0,c.main_series_id,b.source_series_id) as source_series_id, -- 找到源剧对应的主剧
           b.language,inex.sv_income_amt,inex.sv_expand
    from inex
    left join dim.dim_short_video_series_view b on inex.series_id=b.series_id
    left join dim.dim_short_video_source_series_view c on b.source_series_id=c.series_id
)t1
left join(
    select story_id,cp_userinfo_uuid as rights_holder_id
    from dim.dim_sr_cp_story_view
    where product_type=1 and story_type=2 -- -------海剧------
)t2 on t1.source_series_id=t2.story_id
group by 1,2;
