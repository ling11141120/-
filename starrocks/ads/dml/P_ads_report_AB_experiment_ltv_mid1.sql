----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_AB_experiment_mul
-- workflow_version : 73
-- create_user      : linq
-- task_name        : ads_report_AB_experiment_ltv_mid1
-- task_version     : 3
-- update_time      : 2025-03-25 21:45:45
-- sql_path         : \starrocks\tbl_ads_report_AB_experiment_mul\ads_report_AB_experiment_ltv_mid1
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_report_AB_experiment_ltv_mid1 where dt >= date_sub('${bf_1_dt}', interval 30 day) and dt <= '${bf_1_dt}';

-- SQL语句
insert into ads.ads_report_AB_experiment_ltv_mid1
with rec as(
    select dt, lang_id,user_id, book_id,ss
    from (
             select dt, lang_id,user_id, book_id,ss,
                    row_number() over (partition by dt,user_id,book_id order by if(ss = '实验组', 1, 2)) rn
             from (
                      select dt, lang_id,user_id, book_id, if(array_contains(list_id,'2010001'), '实验组', '对照组') ss
                      from ads.ads_report_AB_experiment_mul_base_mid
                      where dt >= date_sub('${bf_1_dt}', interval 30 day) and dt <= '${bf_1_dt}' and source_types=1
                      group by 1, 2, 3, 4,5
                  ) t1
         )t2
    where rn=1
),r as (
    select product_id,user_id,book_id,min(dt) as dt
    from ads.ads_report_AB_experiment_mul_base_read_mid
    where dt >= date_sub('${bf_1_dt}', interval 30 day) and dt <= '${bf_1_dt}' and source_types=1
    group by 1,2,3
)
select dt,types,lang_id as app_lang_id,page_name,recommet_unt,read_unt,consume_unt,ltv0,ltv1,ltv3,ltv5,ltv7,ltv15,ltv30,etl_time
from(
    select rec.dt,
           1 as types,
           lang_id,
           concat('猜你喜欢-', rec.ss) page_name,
           bitmap_union(to_bitmap(rec.user_id)) as recommet_unt,
           bitmap_union(to_bitmap(r.user_id)) as read_unt,
           bitmap_union(to_bitmap(csum.user_id)) as consume_unt,
           if(datediff('${bf_1_dt}',rec.dt)>=0,sum(if(datediff(csum.dt,rec.dt)<=0,csum.total_consume,0)),null) as ltv0,
           if(datediff('${bf_1_dt}',rec.dt)>=1,sum(if(datediff(csum.dt,rec.dt)<=1,csum.total_consume,0)),null) as ltv1,
           if(datediff('${bf_1_dt}',rec.dt)>=3,sum(if(datediff(csum.dt,rec.dt)<=3,csum.total_consume,0)),null) as ltv3,
           if(datediff('${bf_1_dt}',rec.dt)>=5,sum(if(datediff(csum.dt,rec.dt)<=5,csum.total_consume,0)),null) as ltv5,
           if(datediff('${bf_1_dt}',rec.dt)>=7,sum(if(datediff(csum.dt,rec.dt)<=7,csum.total_consume,0)),null) as ltv7,
           if(datediff('${bf_1_dt}',rec.dt)>=15,sum(if(datediff(csum.dt,rec.dt)<=15,csum.total_consume,0)),null) as ltv15,
           if(datediff('${bf_1_dt}',rec.dt)>=30,sum(if(datediff(csum.dt,rec.dt)<=30,csum.total_consume,0)),null) as ltv30,
           now() as etl_time
    from rec
    left join r on rec.dt=r.dt and rec.user_id=r.user_id and rec.book_id=r.book_id
    left join (
        -- 消耗
        select dt, user_id,book_id,sum(amount) as total_consume
        from dws.dws_consume_user_consume_ed
        where dt >= date_sub('${bf_1_dt}', interval 30 day) and dt <= '${bf_1_dt}' and types in(1,2,3)
        group by 1,2,3
    )csum on r.user_id = csum.user_id and r.book_id = csum.book_id -- and r.dt <= csum.dt
    group by 1,2,3,4
    union all
    select rec.dt,
           2 as types,
           lang_id as app_lang_id,
           concat('猜你喜欢-', rec.ss) page_name,
           bitmap_union(to_bitmap(rec.user_id)) as recommet_unt,
           bitmap_union(to_bitmap(r.user_id)) as read_unt,
           bitmap_union(to_bitmap(charge.userid)) as consume_unt,
           if(datediff('${bf_1_dt}',rec.dt)>=0,sum(if(datediff(charge.dt,rec.dt)<=0,charge.charge_money,0)),null) as ltv0,
           if(datediff('${bf_1_dt}',rec.dt)>=1,sum(if(datediff(charge.dt,rec.dt)<=1,charge.charge_money,0)),null) as ltv1,
           if(datediff('${bf_1_dt}',rec.dt)>=3,sum(if(datediff(charge.dt,rec.dt)<=3,charge.charge_money,0)),null) as ltv3,
           if(datediff('${bf_1_dt}',rec.dt)>=5,sum(if(datediff(charge.dt,rec.dt)<=5,charge.charge_money,0)),null) as ltv5,
           if(datediff('${bf_1_dt}',rec.dt)>=7,sum(if(datediff(charge.dt,rec.dt)<=7,charge.charge_money,0)),null) as ltv7,
           if(datediff('${bf_1_dt}',rec.dt)>=15,sum(if(datediff(charge.dt,rec.dt)<=15,charge.charge_money,0)),null) as ltv15,
           if(datediff('${bf_1_dt}',rec.dt)>=30,sum(if(datediff(charge.dt,rec.dt)<=30,charge.charge_money,0)),null) as ltv30,
           now() as etl_time
    from rec
    left join r on rec.dt=r.dt and rec.user_id=r.user_id and rec.book_id=r.book_id
    left join (
        select dt,userid,split(packageid, '_')[3] as book_id,sum(chargeitemcount) as charge_money
        from dws.dws_trade_user_shopitem_charge_ed
        where dt >= date_sub('${bf_1_dt}', interval 30 day) and dt <= '${bf_1_dt}' and packageid like 'Ps_Half%'
        group by 1,2,3
    ) charge on r.user_id=charge.userid and r.book_id=charge.book_id -- and r.dt<=charge.dt
    group by 1,2,3,4
)t1;
