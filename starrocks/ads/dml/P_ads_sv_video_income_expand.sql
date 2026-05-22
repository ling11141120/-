----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_video_income_expand
-- workflow_version : 23
-- create_user      : linq
-- task_name        : ads_sv_video_income_expand
-- task_version     : 9
-- update_time      : 2024-06-20 10:48:52
-- sql_path         : \starrocks\tbl_ads_sv_video_income_expand\ads_sv_video_income_expand
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_sv_video_income_expand where dt>=date_sub('${dt}',interval 3 day) and dt<date_sub('${dt}',interval 2 day);

-- SQL语句
insert into ads.ads_sv_video_income_expand
with sv as(
    select dt, source_series_id, lang_ids,coef,rights_holder_id,
           array_join(array_agg(language),',') as languages,
           array_join(array_agg(series_id),',') as series_ids,
           round(sum(sv_income_amt/100 * 0.7 * coef),2) as sv_income_amt,
           round(sum(sv_income_amt),2) as sv_income_amt2,
           round(sum(sv_expand),2) as sv_expand
    from(
        select a.dt, a.series_id, a.source_series_id, a.language,a.rights_holder_id,
               transform(split(coalesce(b.lang_ids,c.lang_ids),','),x -> cast(x as int)) as lang_ids,
               round(ifnull(coalesce(b.coef,c.coef),0)/100,2) as coef,
               a.sv_income_amt, a.sv_expand
        from ads.ads_sv_video_income_expand_mid a
        left join dim.dim_short_video_source_series_view b on a.source_series_id=b.series_id
        left join dim.short_video_rights_holder_view c on a.rights_holder_id=c.id
        where dt>=date_sub('${dt}',interval 3 day) and dt<date_sub('${dt}',interval 2 day)
    )t1
    where array_contains(lang_ids,language)
    group by 1,2,3,4,5
),cn as (
    select dt, video_id, cn_coef,rights_holder_id,
           array_join(array_agg(tv_id),',') as tv_ids,
           round(sum(cn_income_amt * cn_coef),2) as cn_income_amt,
           round(sum(cn_income_amt),2) as cn_income_amt2,
           round(sum(cn_expand),2) as cn_expand
    from(
        select a.dt, a.tv_id, a.video_id,a.rights_holder_id,
               round(ifnull(coalesce(b.coef,c.cn_coef),0)/100,2) as cn_coef,
               a.cn_income_amt, a.cn_expand
        from ads.ads_sv_video_income_expand_cnmid a
        left join dim.dim_cn_video_info_view b on a.video_id=b.id
        left join dim.short_video_rights_holder_view c on a.rights_holder_id=c.id
        where dt>=date_sub('${dt}',interval 3 day) and dt<date_sub('${dt}',interval 2 day)
    )t1
    group by 1,2,3,4
),mapping as (
    select rights_holder_id,source_series_id,cn_source_series_id
    from dim.dim_short_video_mapping_view
    where is_delete=0
)
select coalesce(a.dt,b.dt) as dt,
       ifnull(a.source_series_id,-99) as source_series_id,
       ifnull(b.video_id,-99) as cn_source_series_id,
       coalesce(a.rights_holder_id,b.rights_holder_id) as rights_holder_id,
       ifnull(a.sv_income_amt,0) as sv_income_amt,
       ifnull(a.sv_income_amt2,0) as sv_income_amt2,
       ifnull(a.sv_expand,0) as sv_expand,
       ifnull(b.cn_income_amt,0) as cn_income_amt,
       ifnull(b.cn_income_amt2,0) as cn_income_amt2,
       ifnull(b.cn_expand,0) as cn_expand,
       null as cn_distribute_expand,
       now() as createtime,
       coalesce(a.mapping,b.mapping) as revenue_mapping,
       a.coef,
       b.cn_coef,
       array_join(a.lang_ids,',') as lang_ids,
       b.tv_ids,
       now() as etl_time
from(
    select sv.dt,sv.source_series_id,sv.lang_ids,coef,sv.rights_holder_id,sv.languages,sv.series_ids,sv.sv_income_amt,
           sv.sv_income_amt2,sv.sv_expand,mapping.cn_source_series_id,
           if(mapping.cn_source_series_id is not null,json_string(json_object(cast(sv.source_series_id as string),cast(mapping.cn_source_series_id as string))),null) as mapping
    from sv
    left join mapping on sv.source_series_id=mapping.source_series_id and sv.rights_holder_id=mapping.rights_holder_id
)a
full join (
    select cn.dt,cn.video_id,cn.cn_coef,cn.rights_holder_id,cn.tv_ids,cn.cn_income_amt,cn.cn_income_amt2,cn.cn_expand,
           if(mapping.source_series_id is not null,json_string(json_object(cast(mapping.source_series_id as string),cast(cn.video_id as string))),null) as mapping
    from cn left join mapping on cn.video_id=mapping.cn_source_series_id and cn.rights_holder_id=mapping.rights_holder_id
)b on a.cn_source_series_id=b.video_id and a.rights_holder_id=b.rights_holder_id;
