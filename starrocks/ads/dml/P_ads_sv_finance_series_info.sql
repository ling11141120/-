----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_srsv_finance_book_info
-- workflow_version : 3
-- create_user      : chenmo
-- task_name        : ads_sv_finance_series_info
-- task_version     : 1
-- update_time      : 2025-03-19 16:09:23
-- sql_path         : \starrocks\tbl_ads_srsv_finance_book_info\ads_sv_finance_series_info
----------------------------------------------------------------
-- SQL语句
-- TODO 短剧明细字段需求
insert overwrite ads.ads_sv_finance_series_info
select
    '6833' as '产品id',
    a.series_id as '短剧id',
    b.series_code as '短剧代号',
    a.series_name as '短剧名称',
    a.all_epis as '总集数',
    a.language as '语言id',
    d.abbreviation as '短剧语言',
    c.type_name as '分类',
    b.rightsholder_id as '版权方',
    b.series_id as '源剧id',
    b.series_name as '源剧名称',
    b.language as '源剧语言id',
    e.abbreviation as '源剧语言',
    b.begin_date as '源剧合作开始日期',
    b.end_date as '源剧合作结束日期',
    a.publish_status as '上下架状态',
    case when a.publish_status = 1 then '上架'
        when a.publish_status = 2 then '下架'
        when a.publish_status = 3 then '软下架'
        else '未知'
    end as '短剧上下架状态',
    a.publish_edat as '上架日期',
    b.local_type as '来源id',
    case when b.local_type = 1 then '本土剧'
        when b.local_type = 2 then '译制剧'
        else '未知'
    end as '来源类型',
    now() as etl_time
from dim.dim_short_video_series_view a
left join dim.dim_short_video_source_series_view b
on a.source_series_id = b.series_id
left join (
    select
        a.series_id,
        group_concat(c.name) as type_name
    from dim.dim_short_video_series_view a
    left join dim.dim_short_video_series_ref_type_view b
    on a.series_id = b.series_id
    left join dim.dim_short_video_series_type_view c
    on b.series_type_id = c.id
    group by a.series_id
) c
on a.series_id = c.series_id
left join dim.DIM_ProductType d
on a.language = d.langid and d.abbreviation != 'and2'
left join dim.DIM_ProductType e
on b.language = e.langid and e.abbreviation != 'and2'
where a.series_name not rlike '作废|废弃|测试|文案书|素材';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总
-- workflow_version : 36
-- create_user      : chenmo
-- task_name        : 海剧书籍明细
-- task_version     : 2
-- update_time      : 2026-02-16 11:47:07
-- sql_path         : \starrocks\审计测试-总\海剧书籍明细
----------------------------------------------------------------
-- SQL语句
-- TODO 海剧
drop table ads.ads_sv_finance_series_info_1;

-- SQL语句
create table ads.ads_sv_finance_series_info_1 like ads.ads_sv_finance_series_info;

-- SQL语句
-- TODO 短剧明细字段需求
insert into ads.ads_sv_finance_series_info
select
    '6833' as '产品id',
    a.series_id as '短剧id',
    b.series_code as '短剧代号',
    a.series_name as '短剧名称',
    a.all_epis as '总集数',
    a.language as '语言id',
    d.abbreviation as '短剧语言',
    c.type_name as '分类',
    b.rightsholder_id as '版权方',
    b.series_id as '源剧id',
    b.series_name as '源剧名称',
    b.language as '源剧语言id',
    e.abbreviation as '源剧语言',
    b.begin_date as '源剧合作开始日期',
    b.end_date as '源剧合作结束日期',
    a.publish_status as '上下架状态',
    case when a.publish_status = 1 then '上架'
        when a.publish_status = 2 then '下架'
        when a.publish_status = 3 then '软下架'
        else '未知'
    end as '短剧上下架状态',
    a.publish_edat as '上架日期',
    b.local_type as '来源id',
    case when b.local_type = 1 then '本土剧'
        when b.local_type = 2 then '译制剧'
        else '未知'
    end as '来源类型',
    a.create_tm,
    now() as etl_time
from dim.dim_short_video_series_view a
left join dim.dim_short_video_source_series_view b
on a.source_series_id = b.series_id
left join (
    select
        a.series_id,
        group_concat(c.name) as type_name
    from dim.dim_short_video_series_view a
    left join dim.dim_short_video_series_ref_type_view b
    on a.series_id = b.series_id
    left join dim.dim_short_video_series_type_view c
    on b.series_type_id = c.id
    group by a.series_id
) c
on a.series_id = c.series_id
left join dim.DIM_ProductType d
on a.language = d.langid and d.abbreviation != 'and2'
left join dim.DIM_ProductType e
on b.language = e.langid and e.abbreviation != 'and2'
where a.series_name not rlike '作废|废弃|测试|文案书|素材';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总_改
-- workflow_version : 11
-- create_user      : xiejc
-- task_name        : 海剧书籍明细
-- task_version     : 3
-- update_time      : 2026-04-08 11:46:36
-- sql_path         : \starrocks\审计测试-总_改\海剧书籍明细
----------------------------------------------------------------
-- SQL语句
-- TODO 海剧
drop table ads.ads_sv_finance_series_info_1;

-- SQL语句
create table ads.ads_sv_finance_series_info_1 like ads.ads_sv_finance_series_info;

-- SQL语句
-- TODO 短剧明细字段需求
insert into ads.ads_sv_finance_series_info
select
    '6833' as '产品id',
    a.series_id as '短剧id',
    b.series_code as '短剧代号',
    a.series_name as '短剧名称',
    a.all_epis as '总集数',
    a.language as '语言id',
    d.abbreviation as '短剧语言',
    c.type_name as '分类',
    b.rightsholder_id as '版权方',
    b.series_id as '源剧id',
    b.series_name as '源剧名称',
    b.language as '源剧语言id',
    e.abbreviation as '源剧语言',
    b.begin_date as '源剧合作开始日期',
    b.end_date as '源剧合作结束日期',
    a.publish_status as '上下架状态',
    case when a.publish_status = 1 then '上架'
        when a.publish_status = 2 then '下架'
        when a.publish_status = 3 then '软下架'
        else '未知'
    end as '短剧上下架状态',
    a.publish_edat as '上架日期',
    b.local_type as '来源id',
    case when b.local_type = 1 then '本土剧'
        when b.local_type = 2 then '译制剧'
        else '未知'
    end as '来源类型',
    a.create_tm,
    now() as etl_time
from dim.dim_short_video_series_view a
left join dim.dim_short_video_source_series_view b
on a.source_series_id = b.series_id
left join (
    select
        a.series_id,
        group_concat(c.name) as type_name
    from dim.dim_short_video_series_view a
    left join dim.dim_short_video_series_ref_type_view b
    on a.series_id = b.series_id
    left join dim.dim_short_video_series_type_view c
    on b.series_type_id = c.id
    group by a.series_id
) c
on a.series_id = c.series_id
left join dim.DIM_ProductType d
on a.language = d.langid and d.abbreviation != 'and2'
left join dim.DIM_ProductType e
on b.language = e.langid and e.abbreviation != 'and2'
where a.series_name not rlike '作废|废弃|测试|文案书|素材';
