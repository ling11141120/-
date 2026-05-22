----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_trade_user_recharge_1d
-- workflow_version : 4
-- create_user      : yanxh
-- task_name        : tbl_dws_trade_user_recharge_1d
-- task_version     : 4
-- update_time      : 2023-10-27 10:23:50
-- sql_path         : \starrocks\tbl_dws_trade_user_recharge_1d\tbl_dws_trade_user_recharge_1d
----------------------------------------------------------------
-- SQL语句
insert overwrite dws.dws_trade_user_recharge_1d partition (p'${pname}')
with todayRecharge as (
    select dt,
           UserId,
           ProductId,
           ItemCount,
           CreateTime
    from dwd.dwd_trade_user_payorder
    where dt = '${bf_1_dt}'
),
     todayFirstRecharge as (
         select dt, UserId, ProductId, ItemCount as FirstRechargeMoneyDay, CreateTime as FirstRechargeTimeDay
         from (
                  select dt,
                         UserId,
                         ProductId,
                         ItemCount,
                         CreateTime,
                         row_number() over (partition by UserId, ProductId order by CreateTime) rk
                  from todayRecharge
              ) t1
         where rk = 1
     ),
     todayLastRecharge as (
         select UserId, ProductId, ItemCount as LastRechargeMoneyDay, CreateTime as LastRechargeTimeDay
         from (
                  select UserId,
                         ProductId,
                         ItemCount,
                         CreateTime,
                         row_number() over (partition by UserId, ProductId order by CreateTime desc) rk
                  from todayRecharge
              ) t1
         where rk = 1
     ),
     todayOtherRecharge as (
         select UserId,
                ProductId,
                max(ItemCount) as MaxRechargeMoneyDay,
                count(1)       as RechargeCntDay,
                sum(ItemCount) as RechargeMoneyDay
         from todayRecharge
         group by UserId, ProductId
     ),
     todaySubscrebe as (
         select UserId,
                ProductId,
                ItemCount,
                CreateTime
         from dwd.dwd_trade_user_payorder
         where dt = '${bf_1_dt}'
           and ShopItem in (800, 801, 802, 830, 840)
     ),
     todayFirstSubscrebe as (
         select UserId, ProductId, ItemCount as FirstSubscribeMoneyDay, CreateTime as FirstSubscribeTimeDay
         from (
                  select UserId,
                         ProductId,
                         ItemCount,
                         CreateTime,
                         row_number() over (partition by UserId, ProductId order by CreateTime) rk
                  from todaySubscrebe
              ) t1
         where rk = 1
     ),
     todayLastSubscrebe as (
         select UserId, ProductId, ItemCount as LastSubscribeMoneyDay, CreateTime as LastSubscribeTimeDay
         from (
                  select UserId,
                         ProductId,
                         ItemCount,
                         CreateTime,
                         row_number() over (partition by UserId, ProductId order by CreateTime desc) rk
                  from todaySubscrebe
              ) t1
         where rk = 1
     )
select tfr.dt as dt,
       tfr.ProductId,
       tfr.UserId,
       FirstRechargeTimeDay,
       FirstRechargeMoneyDay,
       LastRechargeTimeDay,
       LastRechargeMoneyDay,
       FirstSubscribeTimeDay,
       FirstSubscribeMoneyDay,
       LastSubscribeTimeDay,
       LastSubscribeMoneyDay,
       MaxRechargeMoneyDay,
       RechargeCntDay,
       RechargeMoneyDay
from todayFirstRecharge tfr
         left join todayLastRecharge tlr on tfr.ProductId = tlr.ProductId and tfr.UserId = tlr.UserId
         left join todayOtherRecharge tor on tfr.ProductId = tor.ProductId and tfr.UserId = tor.UserId
         left join todayFirstSubscrebe tfs on tfr.ProductId = tfs.ProductId and tfr.UserId = tfs.UserId
         left join todayLastSubscrebe tls on tfr.ProductId = tls.ProductId and tfr.UserId = tls.UserId;
