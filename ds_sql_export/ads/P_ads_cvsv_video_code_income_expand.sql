----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_cvsv_video_code_income_expand
-- workflow_version : 43
-- create_user      : chenmo
-- task_name        : ads_cvsv_video_code_income_expand
-- task_version     : 13
-- update_time      : 2025-05-30 15:08:46
-- sql_path         : \starrocks\tbl_ads_cvsv_video_code_income_expand\ads_cvsv_video_code_income_expand
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_cvsv_video_code_income_expand where dt>=date_sub('${dt}',interval 3 day) and dt<date_sub('${dt}',interval 2 day);

-- SQL语句
insert into ads.`ads_cvsv_video_code_income_expand`
with sv_series as (
    select
        a.story_code_source,
        max(if(a.is_source=1 and b.is_main = 1 and ifnull(coop_type, 0) > 0,b.series_id,null)) over(partition by a.story_code_source order by is_source desc, status desc) as story_id,
        b.series_id,
        max(if(a.is_source=1 and b.is_main = 1 and ifnull(coop_type, 0) > 0,a.coef,null)) over(partition by a.story_code_source order by is_source desc, status desc) as coef,
        max(if(a.is_source=1 and b.is_main = 1 and ifnull(coop_type, 0) > 0,a.lang_ids,null)) over(partition by a.story_code_source order by is_source desc, status desc) as lang_ids,
        max(if(a.is_source=1,a.language,null)) over(partition by a.story_code_source order by is_source desc, status desc) as language,
        max(if(a.is_source=1,a.cp_userinfo_uuid,null)) over(partition by a.story_code_source order by is_source desc, status desc) as rights_holder_id,
        a.is_source,b.is_main
    from (
        select story_code_source,story_code,story_id,cost_rate as coef,lang_cfgs as lang_ids,is_source,status,language,cp_userinfo_uuid,coop_type
        from dim.dim_sr_cp_story_view
        where product_type=1 and story_type=2 -- -------海剧------
    ) a
    left join dim.dim_short_video_source_series_view b on a.story_code = b.series_code and a.story_id = b.series_id
),
cn_series as (
    select
        a.story_code_source,
        max(if(a.is_source=1,a.story_id,null)) over(partition by a.story_code_source order by is_source desc, status desc) as story_id,
        a.story_id as series_id,
        max(if(a.is_source=1,a.coef,null)) over(partition by a.story_code_source order by is_source desc, status desc) as coef,
        max(if(a.is_source=1,a.lang_ids,null)) over(partition by a.story_code_source order by is_source desc, status desc) as lang_ids,
        max(if(a.is_source=1,a.cp_userinfo_uuid,null)) over(partition by a.story_code_source order by is_source desc, status desc) as rights_holder_id,
        a.is_source,status
    from (
        select story_code_source,story_id,cost_rate as coef,lang_cfgs as lang_ids,is_source,status,language,cp_userinfo_uuid
        from dim.dim_sr_cp_story_view
        where product_type=1 and story_type=1 -- -------国剧------
    ) a
),
-- 海剧完成
sv as(
    select dt, story_code_source, story_id as source_series_id, lang_ids,coef,rights_holder_id,
           array_join(array_agg(language),',') as languages,
           array_join(array_agg(series_id),',') as series_ids,
           round(sum(sv_income_amt/100 * 0.7 * coef),2) as sv_income_amt,
           round(sum(sv_income_amt),2) as sv_income_amt2,
           round(sum(sv_expand),2) as sv_expand
    from(
        select ifnull(a.dt, date(date_sub('${dt}',interval 3 day))) as dt,b.story_code_source, b.story_id,
               ifnull(a.series_id, b.series_id) as series_id, ifnull(a.language, b.language) as language,
               ifnull(max(if(b.is_source=1 and b.is_main = 1,ifnull(a.rights_holder_id, b.rights_holder_id),null)) over(partition by b.story_code_source), ifnull(a.rights_holder_id, b.rights_holder_id)) as rights_holder_id,
               transform(split(b.lang_ids,','),x -> cast(x as int)) as lang_ids,
               round(ifnull(b.coef,0)/100,2) as coef,
               ifnull(a.sv_income_amt, 0) as sv_income_amt, ifnull(a.sv_expand, 0) as sv_expand
        from (
            select * from ads.ads_cvsv_video_income_expand_mid
            where dt>=date_sub('${dt}',interval 3 day) and dt<date_sub('${dt}',interval 2 day)
        ) a
        right join sv_series b on a.source_series_id=b.series_id
    )t1
    where array_contains(lang_ids,language)
    group by dt,story_code_source,story_id,lang_ids,coef,rights_holder_id
),cn as (
    select dt,story_code_source, story_id as tv_id, cn_coef,rights_holder_id,
           null as tv_ids, -- 预留字段,先不用管
           round(sum(cn_income_amt * cn_coef),2) as cn_income_amt,
           round(sum(cn_income_amt),2) as cn_income_amt2,
           round(sum(cn_expand),2) as cn_expand,
           round(sum(cn_distribute_expand),2) as cn_distribute_expand
    from(
        select ifnull(a.dt, date(date_sub('${dt}',interval 3 day))) as dt, b.story_code_source, b.story_id, a.tv_id,
               ifnull(max(if(b.is_source=1,ifnull(a.rights_holder_id, b.rights_holder_id),null)) over(partition by b.story_code_source), ifnull(a.rights_holder_id, b.rights_holder_id)) as rights_holder_id,
               round(ifnull(b.coef,0)/100,2) as cn_coef,
               ifnull(a.cn_income_amt, 0) as cn_income_amt, ifnull(a.cn_expand, 0) as cn_expand,ifnull(a.cn_distribute_expand, 0) as cn_distribute_expand
        from (
            select * from ads.ads_cvsv_video_income_expand_cnmid
            where dt>=date_sub('${dt}',interval 3 day) and dt<date_sub('${dt}',interval 2 day)
        ) a
        right join cn_series b on a.tv_id=b.series_id
    )t1
    group by dt,story_code_source,story_id, cn_coef,rights_holder_id
),mapping as (
    select a.cp_userinfo_uuid as rights_holder_id, coalesce(c.story_code_source, b.story_code_source) as story_code_source, c.story_id as source_series_id , b.story_id as cn_source_series_id
    from ods.ods_tidb_sr_cdcreator_tidb_cn_cp_product_mapping a
    left join cn_series b on a.source_id=b.series_id
    left join sv_series c on a.target_id=c.series_id
    where product_type=1
    group by a.cp_userinfo_uuid, coalesce(c.story_code_source, b.story_code_source), c.story_id, b.story_id
)
select dt,
       story_code_source,
       source_series_id,
       cn_source_series_id,
       rights_holder_id,
       sum(sv_income) as sv_income,
       sum(sv_income2) as sv_income2,
       sum(sv_expand) as sv_expand,
       sum(cn_income) as cn_income,
       sum(cn_income2) as cn_income2,
       sum(cn_expand) as cn_expand,
       sum(cn_distribute_expand) as cn_distribute_expand,
       now() as createtime,
       revenue_mapping,
       income_coef,
       cn_income_coef,
       sv_lang_ids,
       cn_series_ids,
       now() as etl_time
from (
    select dt,
           story_code_source,
           source_series_id,
           cn_source_series_id,
           rights_holder_id,
           0 as sv_income,
           0 as sv_income2,
           0 as sv_expand,
           0 as cn_income,
           0 as cn_income2,
           0 as cn_expand,
           0 as cn_distribute_expand,
           revenue_mapping,
           income_coef,
           cn_income_coef,
           sv_lang_ids,
           cn_series_ids
    from ads.`ads_cvsv_video_code_income_expand`
    where dt>=date_sub('${dt}',interval 3 day) and dt<date_sub('${dt}',interval 2 day)
    union all
    select coalesce(a.dt,b.dt) as dt,
           coalesce(a.story_code_source,b.story_code_source, -99) as story_code_source,
           ifnull(a.source_series_id,-99) as source_series_id,
           ifnull(b.tv_id,-99) as cn_source_series_id,
           coalesce(a.rights_holder_id,b.rights_holder_id) as rights_holder_id,
           ifnull(a.sv_income_amt,0) as sv_income_amt,
           ifnull(a.sv_income_amt2,0) as sv_income_amt2,
           ifnull(a.sv_expand,0) as sv_expand,
           ifnull(b.cn_income_amt,0) as cn_income_amt,
           ifnull(b.cn_income_amt2,0) as cn_income_amt2,
           ifnull(b.cn_expand,0) as cn_expand,
           ifnull(b.cn_distribute_expand,0) as cn_distribute_expand,
           coalesce(a.mapping,b.mapping) as revenue_mapping,
           a.coef,
           b.cn_coef,
           array_join(a.lang_ids,',') as lang_ids,
           b.tv_ids
    from(
        select sv.dt,sv.story_code_source,sv.source_series_id,sv.lang_ids,coef,sv.rights_holder_id,sv.languages,sv.series_ids,sv.sv_income_amt,
               sv.sv_income_amt2,sv.sv_expand,mapping.cn_source_series_id,
               if(mapping.cn_source_series_id is not null,json_string(json_object(cast(sv.source_series_id as string),cast(mapping.cn_source_series_id as string))),null) as mapping
        from sv
        left join mapping on sv.source_series_id=mapping.source_series_id and sv.rights_holder_id=mapping.rights_holder_id and sv.story_code_source = mapping.story_code_source
    )a
    full join (
        select cn.dt,cn.story_code_source,cn.tv_id,cn.cn_coef,cn.rights_holder_id,cn.tv_ids,cn.cn_income_amt,cn.cn_income_amt2,cn.cn_expand,cn.cn_distribute_expand,
               if(mapping.source_series_id is not null,json_string(json_object(cast(mapping.source_series_id as string),cast(cn.tv_id as string))),null) as mapping
        from cn
        left join mapping on cn.tv_id=mapping.cn_source_series_id and cn.rights_holder_id=mapping.rights_holder_id and cn.story_code_source = mapping.story_code_source
    )b on a.story_code_source = b.story_code_source
    where coalesce(a.rights_holder_id,b.rights_holder_id) is not null and coalesce(a.rights_holder_id,b.rights_holder_id) != ''
    and !(ifnull(a.sv_income_amt,0) = 0 and
    ifnull(a.sv_income_amt2,0) = 0 and
    ifnull(a.sv_expand,0) = 0 and
    ifnull(b.cn_income_amt,0) = 0 and
    ifnull(b.cn_income_amt2,0) = 0 and
    ifnull(b.cn_expand,0) = 0 and
    ifnull(b.cn_distribute_expand,0) = 0)
) a
group by dt, story_code_source, source_series_id, cn_source_series_id, rights_holder_id, revenue_mapping, income_coef, cn_income_coef, sv_lang_ids, cn_series_ids;
