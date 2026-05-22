----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_trade_user_recharge
-- workflow_version : 1
-- create_user      : yanxh
-- task_name        : tbl_ads_trade_user_recharge
-- task_version     : 1
-- update_time      : 2023-09-09 18:30:02
-- sql_path         : \starrocks\tbl_ads_trade_user_recharge\tbl_ads_trade_user_recharge
----------------------------------------------------------------
-- SQL语句
insert overwrite ads.ads_trade_user_recharge partition(p'${pname}')
with recharge_roll as (
    select date(date_add(dt, interval 1 day)) as dt,
           ProductId,
           UserId,
           recharged,
           first_recharge,
           first_recharge_time,
           total_recharge,
           recharge_cnt,
           recharge_avg,
           recharge_max,
           month_recharge_max,
           last_recharge,
           last_recharge_time
    from ads.ads_trade_user_recharge
    where dt = '${bf_1_dt}'
),
     todayRecharge as (
         select dt,
                ProductId,
                UserId,
                FirstRechargeTimeDay,
                FirstRechargeMoneyDay,
                LastRechargeTimeDay,
                LastRechargeMoneyDay,
                MaxRechargeMoneyDay,
                RechargeCntDay,
                RechargeMoneyDay
         from dws.dws_trade_user_recharge_1d
         where dt = '${dt}'
     ),
     allFirstRecharge as (
         select UserId, ProductId, first_recharge, first_recharge_time
         from (
                  select UserId,
                         ProductId,
                         first_recharge,
                         first_recharge_time,
                         row_number()
                                 over (partition by UserId,ProductId order by coalesce(first_recharge_time, '9999-12-31')) rk
                  from (
                           select UserId,
                                  ProductId,
                                  first_recharge,
                                  first_recharge_time
                           from recharge_roll
                           union all
                           select UserId, ProductId, FirstRechargeMoneyDay, FirstRechargeTimeDay
                           from todayRecharge
                       ) allFirstRecharge_t1
              ) allFirstRecharge_t2
         where rk = 1
     ),
     allLastRecharge as (
         select UserId, ProductId, last_recharge, last_recharge_time
         from (
                  select UserId,
                         ProductId,
                         last_recharge,
                         last_recharge_time,
                         row_number() over (partition by UserId,ProductId order by last_recharge_time desc) rk
                  from (
                           select UserId,
                                  ProductId,
                                  last_recharge,
                                  last_recharge_time
                           from recharge_roll
                           union all
                           select UserId, ProductId, LastRechargeMoneyDay, LastRechargeTimeDay
                           from todayRecharge
                       ) allFirstRecharge_t1
              ) allFirstRecharge_t2
         where rk = 1
     ),
     allOtherRecharge as (
         select UserId,
                ProductId,
                sum(total_recharge)                     as total_recharge,
                sum(recharge_cnt)                       as recharge_cnt,
                sum(total_recharge) / sum(recharge_cnt) as recharge_avg,
                max(recharge_max)                       as recharge_max
         from (
                  select UserId, ProductId, total_recharge, recharge_cnt, recharge_avg, recharge_max
                  from recharge_roll
                  union all
                  select UserId,
                         ProductId,
                         RechargeMoneyDay,
                         RechargeCntDay,
                         RechargeMoneyDay / RechargeCntDay as recharge_avg,
                         MaxRechargeMoneyDay
                  from todayRecharge
              ) allOtherRecharge_t1
         group by UserId, ProductId
     ),
     monthMaxRecharge as (
         select UserId, ProductId, max(MaxRechargeMoneyDay) as month_recharge_max
         from dws.dws_trade_user_recharge_1d
         where dt >= date_sub('${dt}', interval 30 day)
           and dt < date_add('${dt}', interval 1 day)
         group by UserId, ProductId
     )
select '${dt}'                 as dt,
       afr.ProductId,
       afr.UserId,
       if(total_recharge > 0, 1, 0) as recharged,
       first_recharge,
       first_recharge_time,
       total_recharge,
       recharge_cnt,
       recharge_avg,
       recharge_max,
       month_recharge_max,
       last_recharge,
       last_recharge_time
from allFirstRecharge afr
         left join allLastRecharge alr on afr.UserId = alr.UserId and afr.productid = alr.ProductId
         left join allOtherRecharge aor on afr.UserId = aor.UserId and afr.productid = aor.ProductId
         left join monthMaxRecharge mmr on afr.UserId = mmr.UserId and afr.productid = mmr.ProductId;
