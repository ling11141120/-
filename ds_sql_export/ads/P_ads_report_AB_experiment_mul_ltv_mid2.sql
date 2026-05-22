----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_AB_experiment_mul
-- workflow_version : 73
-- create_user      : linq
-- task_name        : ads_report_AB_experiment_mul_ltv_mid2
-- task_version     : 5
-- update_time      : 2024-10-22 19:54:22
-- sql_path         : \starrocks\tbl_ads_report_AB_experiment_mul\ads_report_AB_experiment_mul_ltv_mid2
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_report_AB_experiment_mul_ltv_mid2 where dt = date_sub('${bf_1_dt}', interval 60 day) or dt = date_sub('${bf_1_dt}', interval 90 day) or dt = date_sub('${bf_1_dt}', interval 120 day);

-- SQL语句
insert into ads.ads_report_AB_experiment_mul_ltv_mid2
with r as (
    select dt, source_types,  product_id, user_id, book_id
    from ads.ads_report_AB_experiment_mul_base_read_mid
    where dt = date_sub('${bf_1_dt}', interval 60 day) or dt = date_sub('${bf_1_dt}', interval 90 day) or dt = date_sub('${bf_1_dt}', interval 120 day)
)
select dt,process_types,source_types,product_id,user_id,book_id,is_read,ltv60,ltv90,ltv120,etl_time
from(
    select r.dt,1 as process_types,r.source_types,r.product_id,r.user_id,r.book_id,1 as is_read,
           sum(if(datediff(csum.dt,r.dt)<=60,csum.total_consume,0)) as ltv60,
           sum(if(datediff(csum.dt,r.dt)<=90,csum.total_consume,0)) as ltv90,
           sum(if(datediff(csum.dt,r.dt)<=120,csum.total_consume,0)) as ltv120,
           now() as etl_time
    from r
    left join (
        -- 消耗
        select dt,product_id, user_id,book_id,sum(amount) as total_consume
        from dws.dws_consume_user_consume_ed
        where dt>=date_sub('${bf_1_dt}', interval 120 day) and dt<='${bf_1_dt}' and types in(1,2,3)
        group by 1,2,3,4
    )csum on r.product_id=csum.product_id and r.user_id = csum.user_id and r.book_id = csum.book_id and r.dt <= csum.dt
    group by 1,2,3,4,5,6,7
    union all
    select r.dt,2 as process_types,r.source_types,r.product_id,r.user_id,r.book_id,1 as is_read,
           sum(if(datediff(charge.dt,r.dt)<=60,charge.charge_money,0)) as ltv60,
           sum(if(datediff(charge.dt,r.dt)<=90,charge.charge_money,0)) as ltv90,
           sum(if(datediff(charge.dt,r.dt)<=120,charge.charge_money,0)) as ltv120,
           now() as etl_time
    from r
    left join (
        select dt,Productid,userid,split(packageid, '_')[3] as book_id,sum(chargeitemcount) as charge_money
        from dws.dws_trade_user_shopitem_charge_ed
        where dt>=date_sub('${bf_1_dt}', interval 120 day) and dt<='${bf_1_dt}'
          and packageid like 'Ps_Half%'
        group by 1,2,3,4
    ) charge on r.product_id=charge.Productid and r.user_id=charge.userid and r.book_id=charge.book_id and r.dt<=charge.dt
    group by 1,2,3,4,5,6,7
)t1;
