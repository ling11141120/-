----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_AB_experiment
-- workflow_version : 13
-- create_user      : admin
-- task_name        : ads_report_AB_experiment_mid
-- task_version     : 10
-- update_time      : 2024-02-01 17:13:14
-- sql_path         : \starrocks\tbl_ads_report_AB_experiment\ads_report_AB_experiment_mid
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_report_AB_experiment_mid
with read_event as (
    select dt, distinct_id as user_id, book_id,chapter_id, event_tm,read_chapter_sort,is_first_read_book
    from dwd.dwd_sensors_production_startreadingchapter_view
    where dt >=date_sub('${dt}',interval 15 day) and dt<'${dt}'
    union all
    select dt, distinct_id as user_id, book_id,chapter_id, event_tm,read_chapter_sort,-99 as is_first_read_book
    from dwd.dwd_sensors_production_endreadingchapter_view
    where dt >=date_sub('${dt}',interval 15 day) and dt<'${dt}'
)
select rec.dt,
       rec.app_lang_id,
       ss as page_name,
       rec.user_id,
       bitmap_union(total_read_chpts) as total_read_chpts,
       bitmap_union(total_consume_chpts) as total_consume_chpts,
       now() as etl_time
from (
    select dt, app_lang_id, distinct_id as user_id, book_id, if(list_id = '2010001','may_like-experimental_group','may_like-compare_group') ss
    from dwd.dwd_sensors_production_itemexposure_view
    where dt >=date_sub('${dt}',interval 15 day) and dt<'${dt}'
        and page_name = '频道分页'
        and list_id in ('1290005', '2010001', '1290007', '1290006', '1230018', '1230017', '1230016', '1200014', '1200016')
        and (distinct_id+1) is not NULL
    group by 1, 2, 3, 4, 5
)rec
left join (
    -- 阅读
    select x1.dt, x1.user_id,x1.book_id
    from(
        select dt, user_id, book_id, min(unix_timestamp(event_tm)) tt2
        from read_event
        where dt >=date_sub('${dt}',interval 15 day) and dt<'${dt}' and read_chapter_sort='1' and is_first_read_book='true'
        group by 1,2,3
    )x1 join(
        select dt, distinct_id as user_id, book_id, unix_timestamp(event_tm) tt1
        from dwd.dwd_sensors_production_itemexposure_view
        where dt >=date_sub('${dt}',interval 15 day) and dt<'${dt}' and page_name='频道分页'
          and list_id in('1290005', '2010001', '1290007', '1290006', '1230018', '1230017', '1230016', '1200014', '1200016')
        group by 1,2,3,4
    )x2 on x1.dt=x2.dt and x1.user_id=x2.user_id and x1.book_id=x2.book_id and tt2-tt1<20 and tt2-tt1>=0
    group by 1,2,3
) r on rec.dt=r.dt and rec.user_id=r.user_id and rec.book_id=r.book_id
left join (
    select dt, user_id ,book_id,bitmap_union(to_bitmap(concat(book_id,chapter_id))) as total_read_chpts
    from read_event
    group by 1,2,3
)r1 on r.dt=r1.dt and r.user_id=r1.user_id and r.book_id=r1.book_id
left join (
    select dt, user_id ,book_id,bitmap_union(to_bitmap(concat(book_id,chapter_id))) as total_consume_chpts
    from dwm.dwm_consume_user_consume_mild_ed
    where dt >=date_sub('${dt}',interval 15 day) and dt<'${dt}' and types in(1,2,3)
    group by 1,2,3
)c1 on r.dt=c1.dt and r.user_id=c1.user_id and r.book_id=c1.book_id
group by 1,2,3,4;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_AB_experiment_mul
-- workflow_version : 73
-- create_user      : linq
-- task_name        : ads_report_AB_experiment_mid
-- task_version     : 1
-- update_time      : 2024-02-04 18:03:43
-- sql_path         : \starrocks\tbl_ads_report_AB_experiment_mul\ads_report_AB_experiment_mid
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_report_AB_experiment_mid
with read_event as (
    select dt, distinct_id as user_id, book_id,chapter_id, event_tm,read_chapter_sort,is_first_read_book
    from dwd.dwd_sensors_production_startreadingchapter_view
    where dt >=date_sub('${bf_1_dt}',interval 10 day) and dt<'${bf_1_dt}'
    union all
    select dt, distinct_id as user_id, book_id,chapter_id, event_tm,read_chapter_sort,-99 as is_first_read_book
    from dwd.dwd_sensors_production_endreadingchapter_view
    where dt >=date_sub('${bf_1_dt}',interval 10 day) and dt<'${bf_1_dt}'
)
select rec.dt,
       rec.app_lang_id,
       ss as page_name,
       rec.user_id,
       bitmap_union(total_read_chpts) as total_read_chpts,
       bitmap_union(total_consume_chpts) as total_consume_chpts,
       now() as etl_time
from (
    select dt, lang_id as app_lang_id, user_id, book_id, if(array_contains(list_id,'2010001'),'may_like-experimental_group','may_like-compare_group') ss
    from ads.ads_report_AB_experiment_mul_base_mid
    where dt >=date_sub('${bf_1_dt}',interval 10 day) and dt<'${bf_1_dt}' and source_types=1
    group by 1, 2, 3, 4, 5
)rec
left join (
    -- 阅读
    select dt, user_id,book_id
    from ads.ads_report_AB_experiment_mul_base_read_mid
    where dt >=date_sub('${bf_1_dt}',interval 10 day) and dt<'${bf_1_dt}' and source_types=1
    group by 1,2,3
) r on rec.dt=r.dt and rec.user_id=r.user_id and rec.book_id=r.book_id
left join (
    select dt, user_id ,book_id,bitmap_union(to_bitmap(concat(book_id,chapter_id))) as total_read_chpts
    from read_event
    group by 1,2,3
)r1 on r.dt=r1.dt and r.user_id=r1.user_id and r.book_id=r1.book_id
left join (
    select dt, user_id ,book_id,bitmap_union(to_bitmap(concat(book_id,chapter_id))) as total_consume_chpts
    from dwm.dwm_consume_user_consume_mild_ed
    where dt >=date_sub('${bf_1_dt}',interval 10 day) and dt<'${bf_1_dt}' and types in(1,2,3)
    group by 1,2,3
)c1 on r.dt=c1.dt and r.user_id=c1.user_id and r.book_id=c1.book_id
group by 1,2,3,4;
