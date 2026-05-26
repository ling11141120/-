----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_sv_AB_experiment_mul
-- workflow_version : 22
-- create_user      : linq
-- task_name        : ads_report_sv_AB_experiment_mul_ltv_mid1
-- task_version     : 7
-- update_time      : 2024-10-16 16:00:43
-- sql_path         : \starrocks\tbl_ads_report_sv_AB_experiment_mul\ads_report_sv_AB_experiment_mul_ltv_mid1
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_report_sv_AB_experiment_mul_ltv_mid1 where dt>=date_sub('${bf_1_dt}',interval 30 day) and dt<='${bf_1_dt}';

-- SQL语句
insert into ads.ads_report_sv_AB_experiment_mul_ltv_mid1
with r as (
    select dt, source_types, product_id, user_id, series_id
    from ads.ads_report_sv_AB_experiment_mul_base_watch_mid
    where dt>=date_sub('${bf_1_dt}',interval 30 day ) and dt<='${bf_1_dt}'
)
select dt,process_types,source_types,product_id,user_id,series_id,is_watch,ltv0,ltv1,ltv3,ltv5,ltv7,ltv15,ltv30,etl_time
from(
    select r.dt,1 as process_types,r.source_types,r.product_id,r.user_id,r.series_id,1 as is_watch,
           sum(if(datediff(csum.dt,r.dt)<=0,csum.total_consume,0)) as ltv0,
           sum(if(datediff(csum.dt,r.dt)<=1,csum.total_consume,0)) as ltv1,
           sum(if(datediff(csum.dt,r.dt)<=3,csum.total_consume,0)) as ltv3,
           sum(if(datediff(csum.dt,r.dt)<=5,csum.total_consume,0)) as ltv5,
           sum(if(datediff(csum.dt,r.dt)<=7,csum.total_consume,0)) as ltv7,
           sum(if(datediff(csum.dt,r.dt)<=15,csum.total_consume,0)) as ltv15,
           sum(if(datediff(csum.dt,r.dt)<=30,csum.total_consume,0)) as ltv30,
           now() as etl_time
    from r
    left join (
        -- 消耗
        select a.dt, 6833 as product_id, a.account_id as user_id,a.series_id,
               sum(consume_value) as total_consume
        from dwd.dwd_sv_consume_user_consume_bill_pdi a
        -- left join dim.dim_short_video_epis_view b on a.epis_id=b.epis_id
        where dt>=date_sub('${bf_1_dt}',interval 30 day ) and dt<='${bf_1_dt}' and consume_type in(0,1)
        group by 1,2,3,4
    )csum on r.product_id=csum.product_id and r.user_id = csum.user_id and r.series_id = csum.series_id and r.dt <= csum.dt
    group by 1,2,3,4,5,6,7
    union all
    select r.dt,2 as process_types,r.source_types,r.product_id,r.user_id,r.series_id,1 as is_watch,
           sum(if(datediff(charge.dt,r.dt)<=0,charge.charge_money,0)) as ltv0,
           sum(if(datediff(charge.dt,r.dt)<=1,charge.charge_money,0)) as ltv1,
           sum(if(datediff(charge.dt,r.dt)<=3,charge.charge_money,0)) as ltv3,
           sum(if(datediff(charge.dt,r.dt)<=5,charge.charge_money,0)) as ltv5,
           sum(if(datediff(charge.dt,r.dt)<=7,charge.charge_money,0)) as ltv7,
           sum(if(datediff(charge.dt,r.dt)<=15,charge.charge_money,0)) as ltv15,
           sum(if(datediff(charge.dt,r.dt)<=30,charge.charge_money,0)) as ltv30,
           now() as etl_time
    from r
    left join (
        select dt,product_id,user_id,cast(get_json_string(custom_data,'$.seriesId') as bigint) as series_id,sum(item_count) as charge_money
        from dwd.dwd_trade_short_video_payorder
        where dt>=date_sub('${bf_1_dt}',interval 30 day ) and dt<='${bf_1_dt}' and test_flag=0 and status=0
              and cast(get_json_string(custom_data,'$.seriesId') as bigint)>0
        group by 1,2,3,4
    ) charge on r.product_id=charge.product_id and r.user_id=charge.user_id and r.series_id=charge.series_id and r.dt<=charge.dt
    group by 1,2,3,4,5,6,7
)t1;
