----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_sv_AB_experiment_mul
-- workflow_version : 22
-- create_user      : linq
-- task_name        : ads_report_sv_AB_experiment_mul_ltv_mid2
-- task_version     : 6
-- update_time      : 2024-10-16 16:00:43
-- sql_path         : \starrocks\tbl_ads_report_sv_AB_experiment_mul\ads_report_sv_AB_experiment_mul_ltv_mid2
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_report_sv_AB_experiment_mul_ltv_mid2 where dt = date_sub('${bf_1_dt}', interval 60 day) or dt = date_sub('${bf_1_dt}', interval 90 day) or dt = date_sub('${bf_1_dt}', interval 120 day);

-- SQL语句
insert into ads.ads_report_sv_AB_experiment_mul_ltv_mid2
with r as (
    select dt, source_types, product_id, user_id, series_id
    from ads.ads_report_sv_AB_experiment_mul_base_watch_mid
    where dt = date_sub('${bf_1_dt}', interval 60 day) or dt = date_sub('${bf_1_dt}', interval 90 day) or dt = date_sub('${bf_1_dt}', interval 120 day)
)
select dt,process_types,source_types,product_id,user_id,series_id,is_watch,ltv60,ltv90,ltv120,etl_time
from(
    select r.dt,1 as process_types,r.source_types,r.product_id,r.user_id,r.series_id,1 as is_watch,
           sum(if(datediff(csum.dt,r.dt)<=60,csum.total_consume,0)) as ltv60,
           sum(if(datediff(csum.dt,r.dt)<=90,csum.total_consume,0)) as ltv90,
           sum(if(datediff(csum.dt,r.dt)<=120,csum.total_consume,0)) as ltv120,
           now() as etl_time
    from r
    left join (
        -- 消耗
        select a.dt, 6833 as product_id, a.account_id as user_id,a.series_id,
               sum(consume_value) as total_consume
        from dwd.dwd_sv_consume_user_consume_bill_pdi a
        -- left join dim.dim_short_video_epis_view b  on a.epis_id=b.epis_id
        where dt>=date_sub('${bf_1_dt}', interval 120 day) and dt<='${bf_1_dt}' and consume_type in(0,1)
        group by 1,2,3,4
    )csum on r.product_id=csum.product_id and r.user_id = csum.user_id and r.series_id = csum.series_id and r.dt <= csum.dt
    group by 1,2,3,4,5,6,7
    union all
    select r.dt,2 as process_types,r.source_types,r.product_id,r.user_id,r.series_id,1 as is_watch,
           sum(if(datediff(charge.dt,r.dt)<=60,charge.charge_money,0)) as ltv60,
           sum(if(datediff(charge.dt,r.dt)<=90,charge.charge_money,0)) as ltv90,
           sum(if(datediff(charge.dt,r.dt)<=120,charge.charge_money,0)) as ltv120,
           now() as etl_time
    from r
    left join (
        select dt,product_id,user_id,cast(get_json_string(custom_data,'$.seriesId') as bigint) as series_id,sum(item_count) as charge_money
        from dwd.dwd_trade_short_video_payorder
        where dt>=date_sub('${bf_1_dt}', interval 120 day) and dt<='${bf_1_dt}' and test_flag=0 and status=0
              and cast(get_json_string(custom_data,'$.seriesId') as bigint)>0
        group by 1,2,3,4
    ) charge on r.product_id=charge.product_id and r.user_id=charge.user_id and r.series_id=charge.series_id and r.dt<=charge.dt
    group by 1,2,3,4,5,6,7
)t1;
