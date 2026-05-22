----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_AB_experiment_mul
-- workflow_version : 73
-- create_user      : linq
-- task_name        : ads_report_AB_experiment_mul_ltv_mid1
-- task_version     : 3
-- update_time      : 2024-10-22 19:54:22
-- sql_path         : \starrocks\tbl_ads_report_AB_experiment_mul\ads_report_AB_experiment_mul_ltv_mid1
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_report_AB_experiment_mul_ltv_mid1 where dt>=date_sub('${bf_1_dt}',interval 30 day) and dt<='${bf_1_dt}';

-- SQL语句
insert into ads.ads_report_AB_experiment_mul_ltv_mid1
with r as (
    select dt, source_types, product_id, user_id, book_id
    from ads.ads_report_AB_experiment_mul_base_read_mid
    where dt>=date_sub('${bf_1_dt}',interval 30 day) and dt<='${bf_1_dt}'
)
select dt,process_types,source_types,product_id,user_id,book_id,is_read,ltv0,ltv1,ltv3,ltv5,ltv7,ltv15,ltv30,etl_time
from(
    select r.dt,1 as process_types,r.source_types,r.product_id,r.user_id,r.book_id,1 as is_read,
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
        select dt,product_id, user_id,book_id,sum(amount) as total_consume
        from dws.dws_consume_user_consume_ed
        where dt>=date_sub('${bf_1_dt}',interval 30 day) and dt<='${bf_1_dt}' and types in(1,2,3)
        group by 1,2,3,4
    )csum on r.product_id=csum.product_id and r.user_id = csum.user_id and r.book_id = csum.book_id and r.dt <= csum.dt
    group by 1,2,3,4,5,6,7
    union all
    select r.dt,2 as process_types,r.source_types,r.product_id,r.user_id,r.book_id,1 as is_read,
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
        select dt,Productid,userid,split(packageid, '_')[3] as book_id,sum(chargeitemcount) as charge_money
        from dws.dws_trade_user_shopitem_charge_ed
        where dt>=date_sub('${bf_1_dt}',interval 30 day) and dt<='${bf_1_dt}' and packageid like 'Ps_Half%'
        group by 1,2,3,4
    ) charge on r.product_id=charge.Productid and r.user_id=charge.userid and r.book_id=charge.book_id and r.dt<=charge.dt
    group by 1,2,3,4,5,6,7
)t1;
