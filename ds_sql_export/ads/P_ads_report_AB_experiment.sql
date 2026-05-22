----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_AB_experiment
-- workflow_version : 13
-- create_user      : admin
-- task_name        : ads_report_AB_experiment
-- task_version     : 10
-- update_time      : 2024-02-01 17:13:14
-- sql_path         : \starrocks\tbl_ads_report_AB_experiment\ads_report_AB_experiment
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_report_AB_experiment
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
       concat('may_like-', rec.ss) page_name,
       bitmap_union(to_bitmap(rec.user_id)) as recommet_unt,
       bitmap_union(to_bitmap(r.user_id)) as read_unt,
       bitmap_union(to_bitmap(csum.user_id)) as consume_unt,
       sum(csum.total_consume) as total_consume,
       sum(csum.csum_num) as total_csum_num,
       round(sum(csum.total_consume)/bitmap_union_count(to_bitmap(rec.user_id)),2) as csum_avg_exposure,
       round(sum(csum.total_consume)/bitmap_union_count(to_bitmap(r.user_id)),2) as csum_avg_read,
       round(sum(csum.total_consume)/bitmap_union_count(to_bitmap(csum.user_id)),2) as csum_avg_csum,
       sum(csum.user_money_consume) as user_money_consume,
       bitmap_union(csum.user_money_consume_unt) as user_money_consume_unt,
       bitmap_union(to_bitmap(charge.userid)) as charge_unt,
       sum(charge_money) as charge_money,
       now() as etl_time
from (
    select dt, app_lang_id, distinct_id as user_id, book_id, if(list_id = '2010001','experimental_group','compare_group') ss
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
    select dt, user_id ,book_id,bitmap_union(to_bitmap(null)) as total_read_chpts
    from read_event
    group by 1,2,3
)r1 on r.dt=r1.dt and r.user_id=r1.user_id and r.book_id=r1.book_id
left join (
    -- 消耗
    select dt, user_id,book_id,
           sum(amount) as total_consume,sum(con_chapter_nums) as csum_num,
           sum(if(types=1,amount,0)) as user_money_consume, bitmap_union(to_bitmap(if(types=1,user_id,null))) as user_money_consume_unt
    from dws.dws_consume_user_consume_ed
    where dt >=date_sub('${dt}',interval 15 day) and dt<'${dt}' and types in(1,2,3)
    group by 1,2,3
)csum on r.dt=csum.dt and r.user_id=csum.user_id and r.book_id=csum.book_id
left join (
    select dt,userid,split(packageid, '_')[3] as book_id,sum(chargeitemcount) as charge_money
    from dws.dws_trade_user_shopitem_charge_ed
    where dt >=date_sub('${dt}',interval 15 day) and dt<'${dt}' and packageid like 'Ps_Half%'
    group by 1,2,3
) charge on r.dt=charge.dt and r.user_id=charge.userid and r.book_id=charge.book_id
group by 1,2,3;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_AB_experiment_mul
-- workflow_version : 73
-- create_user      : linq
-- task_name        : ads_report_AB_experiment
-- task_version     : 2
-- update_time      : 2025-03-25 21:45:45
-- sql_path         : \starrocks\tbl_ads_report_AB_experiment_mul\ads_report_AB_experiment
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_report_AB_experiment
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
       concat('may_like-', rec.ss) page_name,
       bitmap_union(to_bitmap(rec.user_id)) as recommet_unt,
       bitmap_union(to_bitmap(r.user_id)) as read_unt,
       bitmap_union(to_bitmap(csum.user_id)) as consume_unt,
       sum(csum.total_consume) as total_consume,
       sum(csum.csum_num) as total_csum_num,
       round(sum(csum.total_consume)/bitmap_union_count(to_bitmap(rec.user_id)),2) as csum_avg_exposure,
       round(sum(csum.total_consume)/bitmap_union_count(to_bitmap(r.user_id)),2) as csum_avg_read,
       round(sum(csum.total_consume)/bitmap_union_count(to_bitmap(csum.user_id)),2) as csum_avg_csum,
       sum(csum.user_money_consume) as user_money_consume,
       bitmap_union(csum.user_money_consume_unt) as user_money_consume_unt,
       bitmap_union(to_bitmap(charge.userid)) as charge_unt,
       sum(charge_money) as charge_money,
       now() as etl_time
from (
    select dt, lang_id as app_lang_id, user_id, book_id, if(array_contains(list_id,'2010001'),'experimental_group','compare_group') ss
    from ads.ads_report_AB_experiment_mul_base_mid
    where dt >=date_sub('${bf_1_dt}',interval 10 day) and dt<'${bf_1_dt}' and source_types=1
    group by 1, 2, 3, 4, 5
)rec
left join (
    -- 阅读
    select dt, user_id,book_id
    from ads.ads_report_AB_experiment_mul_base_read_mid
    where dt>=date_sub('${bf_1_dt}',interval 10 day) and dt<'${bf_1_dt}' and source_types=1
    group by 1,2,3
) r on rec.dt=r.dt and rec.user_id=r.user_id and rec.book_id=r.book_id
left join (
    select dt, user_id ,book_id,bitmap_union(to_bitmap(null)) as total_read_chpts
    from read_event
    group by 1,2,3
)r1 on r.dt=r1.dt and r.user_id=r1.user_id and r.book_id=r1.book_id
left join (
    -- 消耗
    select dt, user_id,book_id,
           sum(amount) as total_consume,sum(con_chapter_nums) as csum_num,
           sum(if(types=1,amount,0)) as user_money_consume, bitmap_union(to_bitmap(if(types=1,user_id,null))) as user_money_consume_unt
    from dws.dws_consume_user_consume_ed
    where dt >=date_sub('${bf_1_dt}',interval 10 day) and dt<'${bf_1_dt}' and types in(1,2,3)
    group by 1,2,3
)csum on r.dt=csum.dt and r.user_id=csum.user_id and r.book_id=csum.book_id
left join (
    select dt,userid,split(packageid, '_')[3] as book_id,sum(chargeitemcount) as charge_money
    from dws.dws_trade_user_shopitem_charge_ed
    where dt >=date_sub('${bf_1_dt}',interval 10 day) and dt<'${bf_1_dt}' and packageid like 'Ps_Half%'
    group by 1,2,3
) charge on r.dt=charge.dt and r.user_id=charge.userid and r.book_id=charge.book_id
group by 1,2,3;
