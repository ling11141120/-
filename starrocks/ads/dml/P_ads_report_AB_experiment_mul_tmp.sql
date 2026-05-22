----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_AB_experiment_mul
-- workflow_version : 73
-- create_user      : linq
-- task_name        : ads_report_AB_experiment_mul_tmp
-- task_version     : 10
-- update_time      : 2024-10-22 19:54:22
-- sql_path         : \starrocks\tbl_ads_report_AB_experiment_mul\ads_report_AB_experiment_mul_tmp
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_report_AB_experiment_mul_tmp where dt >=date_sub('${dt}',interval 10 day) and dt<'${dt}';

-- SQL语句
insert into ads.ads_report_AB_experiment_mul_tmp
with read_event as (
    select dt, app_product_id as product_id,distinct_id as user_id, book_id,chapter_id, event_tm,read_chapter_sort,is_first_read_book
    from dwd.dwd_sensors_production_startreadingchapter_view
    where dt >=date_sub('${dt}',interval 10 day) and dt<'${dt}'
    union all
    select dt, app_product_id as product_id,distinct_id as user_id, book_id,chapter_id, event_tm,read_chapter_sort,-99 as is_first_read_book
    from dwd.dwd_sensors_production_endreadingchapter_view
    where dt >=date_sub('${dt}',interval 10 day) and dt<'${dt}'
),x1 as (
   select dt, product_id,user_id, book_id, min(unix_timestamp(event_tm)) tt2
   from read_event
   where read_chapter_sort='1' and is_first_read_book='true'
   group by 1,2,3,4
)
-- 阅读
select r.dt,r.source_types as types,r.product_id,r.user_id,r.book_id,r1.is_read,r1.total_read_chpts,csum.consume_amount,csum.consume_chpts,
       csum.user_money_consume,charge.charge_money,now() as etl_time
from ads.ads_report_AB_experiment_mul_base_read_mid r
left join (
    select dt, product_id,user_id ,book_id,1 as is_read,bitmap_union(to_bitmap(concat(book_id,chapter_id))) as total_read_chpts
    from read_event
    group by 1,2,3,4
)r1 on r.dt=r1.dt and r.product_id=r1.product_id and r.user_id=r1.user_id and r.book_id=r1.book_id
left join (
    -- 消耗
    select dt, product_id,user_id ,book_id,
           round(sum(con_chp_amount)) as consume_amount,
           bitmap_union(to_bitmap(concat(book_id,chapter_id))) as consume_chpts,
           round(sum(if(types=1,con_chp_amount,0))) as user_money_consume
    from dwm.dwm_consume_user_consume_mild_ed
    where dt >=date_sub('${dt}',interval 10 day) and dt<'${dt}' and types in(1,2,3)
    group by 1,2,3,4
)csum on r.dt=csum.dt and r.product_id=csum.product_id and r.user_id=csum.user_id and r.book_id=csum.book_id
left join (
    select dt,Productid as product_id,userid,split(packageid, '_')[3] as book_id,sum(chargemoney) as charge_money
    from dws.dws_trade_user_shopitem_charge_ed
    where dt >=date_sub('${dt}',interval 10 day) and dt<'${dt}' and packageid like 'Ps_Half%'
    group by 1,2,3,4
) charge on r.dt=charge.dt and r.product_id=charge.product_id and r.user_id=charge.userid and r.book_id=charge.book_id
where r.dt >=date_sub('${dt}',interval 10 day) and r.dt<'${dt}';
