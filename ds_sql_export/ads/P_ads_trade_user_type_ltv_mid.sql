----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_trade_user_type_ltv_mid
-- workflow_version : 14
-- create_user      : linq
-- task_name        : ads_trade_user_type_ltv_mid
-- task_version     : 12
-- update_time      : 2026-01-26 15:50:33
-- sql_path         : \starrocks\tbl_ads_trade_user_type_ltv_mid\ads_trade_user_type_ltv_mid
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_trade_user_type_ltv_mid
WITH pay_detail AS (
    SELECT dt,
           Productid,
           userid,
           chargeitemcount,
           chargemoney
    FROM dws.dws_trade_user_shopitem_charge_ed
    WHERE dt>=date_sub('${dt}',interval 120 day) and dt<='${dt}'

    UNION ALL
    SELECT dt,
           Product_id,
           user_id,
           charge_itemcount,
           charge_money
    FROM dws.dws_trade_short_viedo_payorder_ed
    WHERE dt>=date_sub('${dt}',interval 120 day) and dt<='${dt}'

    UNION ALL
    SELECT dt,
           Product_id,
           user_id,
           charge_itemcount * 7,   -- 业务折算系数
           charge_money_rmb
    FROM dws.dws_trade_viedo_cn_payorder_ed
    WHERE dt>=date_sub('${dt}',interval 120 day) and dt<='${dt}'
      AND self_type = 0

    union all
    select
        settle_dt, product_id, user_id, monthly_recharge_amt, monthly_net_amt
    from dwd.dwd_sv_tt_payorder_info
    where is_refund = 0 and is_sandbox = 0 and settle_dt >= date_sub('${dt}', interval 120 day) and settle_dt <= '${dt}'
),tmp as(
    select generate_series as rn from TABLE(generate_series(0, 30))
),rmt as (
    select stat_period as dt,
           lead(stat_period,1,'9999-12-31') over (partition by product_id,user_id order by stat_period,mt,corever) as end_day,
           count(1) OVER (partition by product_id,user_id) num,
           product_id,weekofyear(last_day_of_week) as which_weeks,month(last_day_of_month) which_months,user_id,corever,mt,reg_country,country_level,current_language2,source,user_period
    from(
      select  dt as stat_period,product_id,
          date(date_sub(date_trunc('week',date_add(dt,interval 1 week)),interval 1 day )) as last_day_of_week,
          date(date_sub(date_trunc('month',date_add(dt,interval 1 month)),interval 1 day )) last_day_of_month ,
          user_id,corever,mt,reg_country,country_level,current_language2,source,user_period,
                   row_number() over (partition by dt,product_id,user_id order by mt,corever) rn
            from dws.dws_srsv_wide_user_type_info_di
            where      dt>=date_sub('${dt}',interval 120 day ) and dt<='${dt}'   and  user_period=3  and product_id not in(6883)
            union all
            select stat_period,product_id,last_day_of_week,last_day_of_month,user_id,corever,mt,reg_country,country_level,current_language2,source,user_period,
                   row_number() over (partition by stat_period,product_id,user_id order by mt,corever) rn
            from dws.dws_wide_video_cn_user_type_info_ed
            where period_types=1 and user_period=3 and stat_period>=date_sub('${dt}',interval 120 day ) and stat_period<='${dt}' and product_id in(6883)
        ) a where rn=1
),sacc as (
   select
        '${bf_1_dt}' as dt,date(a.create_time) as stat_period,6883 as product_id,YEAR(a.create_time) as years,1 as period_types,
        date(date_sub(date_trunc('week',date_add(a.create_time,interval 1 week)),interval 1 day )) as last_day_of_week,
        date(date_sub(date_trunc('month',date_add(a.create_time,interval 1 month)),interval 1 day ))  last_day_of_month ,
        a.account as user_id ,
        IF(a.CoreVer2 is null or a.corever2 = 0, 1, a.corever2)                                    as corever,a.mt2 ,
        IF(a.reg_country = '', 'unknown', a.reg_country)                                           as reg_country,
        null                                                                                          country_level  ,
        current_language2                                                                          as current_language2,
        1                                                                                          as source,
        1                                                                                          as user_period,
        now()                                                                                      as etl_time
   from dim.dim_video_cn_accountinfo_view a
   where date(a.create_time) >=date_sub('${dt}',interval 120 day ) and date(a.create_time)<='${dt}'
),acc as (
   select  dt,
           lead(dt,1,'9999-12-31') over (partition by product_id,user_id order by dt,mt,corever) as end_day,
           count(1) OVER (partition by product_id,user_id) num,
           product_id,
           weekofyear(date(date_sub(date_trunc('week',date_add(dt,interval 1 week)),interval 1 day ))) as which_weeks,
           month(date(date_sub(date_trunc('month',date_add(dt,interval 1 month)),interval 1 day ))) which_months,
           user_id,corever,mt,reg_country,country_level,current_language2,source,user_period
    from dws.dws_srsv_wide_user_type_info_di
    where  dt>=date_sub('${dt}',interval 120 day ) and dt<='${dt}' and user_period=1  and product_id not in(6883)
    union all
    select stat_period as dt,
           lead(stat_period,1,'9999-12-31') over (partition by product_id,user_id order by stat_period,mt2,corever) as end_day,
           count(1) OVER (partition by product_id,user_id) num,
           product_id,weekofyear(last_day_of_week) as which_weeks,month(last_day_of_month) which_months,user_id,corever,mt2,reg_country,country_level,current_language2,source,user_period
    from sacc
)
select dt,3 as user_period,product_id,user_id,ifnull(rn,-99) as pay_days,which_weeks,which_months,corever,mt,reg_country,country_level,current_language2,source,
       if(pay_days != rn,0,chargemoney) as amount,
       sum(if(pay_days != rn,0,chargemoney))
           over (partition by dt,product_id,user_id,which_weeks,which_months,corever,mt,reg_country,country_level,current_language2,source order by rn) as ltv,
       now() as etl_time
from(
    select dt,end_day,product_id,user_id,which_weeks,which_months,corever,mt,reg_country,country_level,current_language2,source,
           pay_days,chargeitemcount,chargemoney,
           lead(pay_days) over ( partition by dt,product_id,user_id,which_weeks,which_months,corever,mt,reg_country,country_level,current_language2,source order by pay_days) lead_pay_days
    from(
            select rmt.dt,rmt.end_day,rmt.product_id,user_id,rmt.which_weeks,rmt.which_months,rmt.corever,rmt.mt,rmt.reg_country,rmt.country_level,rmt.current_language2,rmt.source,
                   datediff(b.dt,rmt.dt) as pay_days,sum(b.chargeitemcount) as chargeitemcount, -- 分层前
                   sum(b.chargemoney) as chargemoney -- 分层后
            from rmt
            left join pay_detail b on rmt.dt<=b.dt and rmt.dt>= date_sub(b.dt,interval 30 day )
                                  and rmt.product_id=b.Productid and rmt.user_id=b.userid and b.dt<end_day
            where rmt.dt>=date_sub('${dt}',interval 30 day ) and rmt.dt<='${dt}'
            group by 1,2,3,4,5,6,7,8,9,10,11,12,13
        )c
     )d left join tmp  on d.pay_days <= tmp.rn and datediff(d.end_day,d.dt)>rn
        and if(d.lead_pay_days is null, if(datediff('${dt}',d.dt)<31,datediff('${dt}',d.dt)+1,31),d.lead_pay_days) > rn
union all
select d.dt,3 as user_period,d.product_id,d.user_id,ifnull(pay_days,-99) as pay_days,d.which_weeks,d.which_months,d.corever,d.mt,d.reg_country,d.country_level,d.current_language2,d.source,amount,ltv,now() as etl_time
from(
          select dt,product_id,user_id,which_weeks,which_months,corever,mt,reg_country,country_level,current_language2,source,
                 split(tmp2.unnest,'_')[1] pay_days ,null as amount,split(tmp2.unnest,'_')[2] as ltv
          from(
                    select rmt.dt,rmt.product_id,user_id,rmt.which_weeks,rmt.which_months,rmt.corever,rmt.mt,rmt.reg_country,rmt.country_level,rmt.current_language2,rmt.source,
                           sum(if(datediff(b.dt,rmt.dt)<=45,b.chargemoney,0)) as ltv45,
                           sum(if(datediff(b.dt,rmt.dt)<=60,b.chargemoney,0)) as ltv60,
                           sum(if(datediff(b.dt,rmt.dt)<=90,b.chargemoney,0)) as ltv90,
                           sum(if(datediff(b.dt,rmt.dt)<=120,b.chargemoney,0)) as ltv120,
                           split(concat_ws('$',
                                   concat_ws('_',45,sum(if(datediff(b.dt,rmt.dt)<=45,b.chargemoney,0))),
                                   concat_ws('_',60,sum(if(datediff(b.dt,rmt.dt)<=60,b.chargemoney,0))),
                                   concat_ws('_',90,sum(if(datediff(b.dt,rmt.dt)<=90,b.chargemoney,0))),
                                   concat_ws('_',120,sum(if(datediff(b.dt,rmt.dt)<=120,b.chargemoney,0)))
                                         ),
                               '$') as arr
                    from rmt
                    left join pay_detail b on rmt.dt<=b.dt and rmt.dt>= date_sub(b.dt,interval 120 day )
                                          and rmt.product_id=b.Productid and rmt.user_id=b.userid and b.dt<end_day
                    group by 1,2,3,4,5,6,7,8,9,10,11
          )c,unnest(arr) tmp2
    )d inner join rmt on d.dt=rmt.dt and d.product_id=rmt.product_id and d.user_id=rmt.user_id and d.pay_days<datediff(rmt.end_day,rmt.dt) -- 处理不超过end_day的逻辑
where pay_days<=datediff('${dt}',rmt.dt) -- 过滤时间还没到的pay_days
union all
-- 新用户
select dt,1 as user_period,product_id,user_id,ifnull(rn,-99) as pay_days,which_weeks,which_months,corever,mt,reg_country,country_level,current_language2,source,
       if(pay_days != rn,0,chargemoney) as amount,
       sum(if(pay_days != rn,0,chargemoney))
           over (partition by dt,product_id,user_id,which_weeks,which_months,corever,mt,reg_country,country_level,current_language2,source order by rn) as ltv,
       now() as etl_time
from(
    select dt,end_day,product_id,user_id,which_weeks,which_months,corever,mt,reg_country,country_level,current_language2,source,
           pay_days,chargeitemcount,chargemoney,
           lead(pay_days) over ( partition by dt,product_id,user_id,which_weeks,which_months,corever,mt,reg_country,country_level,current_language2,source order by pay_days) lead_pay_days
    from(
            select acc.dt,acc.end_day,acc.product_id,user_id,acc.which_weeks,acc.which_months,acc.corever,acc.mt,acc.reg_country,acc.country_level,acc.current_language2,acc.source,
                   datediff(b.dt,acc.dt) as pay_days,sum(b.chargeitemcount) as chargeitemcount,sum(b.chargemoney) as chargemoney
            from acc
            left join pay_detail b on acc.dt<=b.dt and acc.dt>= date_sub(b.dt,interval 30 day )
                                  and acc.product_id=b.Productid and acc.user_id=b.userid and b.dt<acc.end_day
            where acc.dt>=date_sub('${dt}',interval 30 day ) and acc.dt<='${dt}'
            group by 1,2,3,4,5,6,7,8,9,10,11,12,13
        )c
     )d left join tmp  on d.pay_days <= tmp.rn and datediff(d.end_day,d.dt)>rn
        and if(d.lead_pay_days is null, if(datediff('${dt}',d.dt)<31,datediff('${dt}',d.dt)+1,31),d.lead_pay_days) > rn
union all
select d.dt,1 as user_period,d.product_id,d.user_id,ifnull(pay_days,-99) as pay_days,d.which_weeks,d.which_months,d.corever,d.mt,d.reg_country,d.country_level,d.current_language2,d.source,amount,ltv,now() as etl_time
from(
          select dt,product_id,user_id,which_weeks,which_months,corever,mt,reg_country,country_level,current_language2,source,
                 split(tmp2.unnest,'_')[1] pay_days ,null as amount,split(tmp2.unnest,'_')[2] as ltv
          from(
                    select acc.dt,acc.product_id,acc.user_id,acc.which_weeks,acc.which_months,acc.corever,acc.mt,acc.reg_country,acc.country_level,acc.current_language2,acc.source,
                           sum(if(datediff(b.dt,acc.dt)<=45,b.chargemoney,0)) as ltv45,
                           sum(if(datediff(b.dt,acc.dt)<=60,b.chargemoney,0)) as ltv60,
                           sum(if(datediff(b.dt,acc.dt)<=90,b.chargemoney,0)) as ltv90,
                           sum(if(datediff(b.dt,acc.dt)<=120,b.chargemoney,0)) as ltv120,
                           split(concat_ws('$',
                                   concat_ws('_',45,sum(if(datediff(b.dt,acc.dt)<=45,b.chargemoney,0))),
                                   concat_ws('_',60,sum(if(datediff(b.dt,acc.dt)<=60,b.chargemoney,0))),
                                   concat_ws('_',90,sum(if(datediff(b.dt,acc.dt)<=90,b.chargemoney,0))),
                                   concat_ws('_',120,sum(if(datediff(b.dt,acc.dt)<=120,b.chargemoney,0)))
                                         ),
                               '$') as arr
                    from acc
                    left join pay_detail b on acc.dt<=b.dt and acc.dt>= date_sub(b.dt,interval 120 day )
                                          and acc.product_id=b.Productid and acc.user_id=b.userid and b.dt<acc.end_day
                    group by 1,2,3,4,5,6,7,8,9,10,11
          )c,unnest(arr) tmp2
    )d inner join acc on d.dt=acc.dt and d.product_id=acc.product_id and d.user_id=acc.user_id and d.pay_days<datediff(acc.end_day,acc.dt) -- 处理不超过end_day的逻辑,新用户的不存在end_day
where pay_days<=datediff('${dt}',acc.dt);

-- SQL语句
-- 过滤时间还没到的pay_days;
