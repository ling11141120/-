----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_translate_production
-- workflow_version : 5
-- create_user      : chenmo
-- task_name        : ads_sv_translate_production
-- task_version     : 5
-- update_time      : 2025-10-14 16:34:41
-- sql_path         : \starrocks\tbl_ads_sv_translate_production\ads_sv_translate_production
----------------------------------------------------------------
-- SQL语句
insert overwrite ads.ads_sv_translate_production
select
    a.id,
    c.series_id,
    a.BookCode,
    a.BookName,
    c.series_name,
    f.langid,
    a.Level,
    c.last_epis,
    a.CreateTime,
    a.BeginTime,
    a.EndTime,
    a.CheckTime,
    e.CheckInspectorsId,
    e.CheckInspectorsName,
    e.check_num,
    now() as etl_time
from ods.ods_tidb_shuangwen_tidb_en_shortvideobookmonitor a
left join ods.ods_tidb_shuangwen_en_objectbook b
on a.BookCode = b.BookCode and a.ObjectBookId = b.Id and a.ToLanguage = b.ToLanguage
left join dim.DIM_ProductType f
on a.ToLanguage = f.book_langid
left join dim.dim_short_video_series_view c
on a.BookCode = c.series_code and f.langid = c.language
left join (
    select
        product_id,
        ObjectBookId,
        group_concat(distinct CheckInspectorsId order by CheckInspectorsId) as CheckInspectorsId,
        group_concat(distinct CheckInspectorsName order by CheckInspectorsId) as CheckInspectorsName,
        count(1) as check_num
    from ods.ods_tidb_shuangwen_xx_objectchaptervice
    where CheckInspectorsId != 0
    group by product_id, ObjectBookId
) e on b.productid = e.product_id and a.ObjectBookId = e.ObjectBookId;
