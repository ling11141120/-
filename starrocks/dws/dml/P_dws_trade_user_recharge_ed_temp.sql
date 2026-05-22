----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_trade_user_recharge_roll_a
-- workflow_version : 16
-- create_user      : linq
-- task_name        : dws_trade_user_recharge_ed_temp
-- task_version     : 10
-- update_time      : 2024-10-16 11:57:09
-- sql_path         : \starrocks\tbl_dws_trade_user_recharge_roll_a\dws_trade_user_recharge_ed_temp
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_trade_user_recharge_ed_temp where dt >= '${bf_1_dt}';

-- SQL语句
insert into dws.`dws_trade_user_recharge_ed_temp`
with today_recharge as (
    select dt,
           UserId,
           ProductId,
           max(first_recharge_money_Day)  as first_recharge_money_Day,
           max(first_recharge_time_day)   as first_recharge_time_day,
           max(last_recharge_money_day)   as last_recharge_money_day,
           max(last_recharge_time_day)    as last_recharge_time_day
    from (
             select dt,
                    UserId,
                    ProductId,
                    case rk_a when 1 then ItemCount end  as first_recharge_money_day,
                    case rk_a when 1 then CreateTime end as first_recharge_time_day,
                    case rk_d when 1 then ItemCount end  as last_recharge_money_day,
                    case rk_d when 1 then CreateTime end as last_recharge_time_day
             from (
                      select dt,
                             UserId,
                             ProductId,
                             ItemCount,
                             ShopItem,
                             CreateTime,
                             row_number() over (partition by dt,UserId, ProductId order by CreateTime,AutoId )     rk_a,
                             row_number() over (partition by dt,UserId, ProductId order by CreateTime desc,AutoId desc) rk_d
                      from dwd.dwd_trade_user_payorder
                      where dt >= '${bf_1_dt}' and dt<='${dt}'
                      and TestFlag = 0
                  ) a
             where rk_a = 1
                or rk_d = 1
         ) t1
    group by 1, 2, 3
),
     today_subscribe as (
         select dt,
                UserId,
                ProductId,
                max(first_subscribe_money_Day)  as first_subscribe_money_day,
                max(first_subscribe_type_Day)   as first_subscribe_type_day,
                max(first_subscribe_time_day)   as first_subscribe_time_day,
                max(last_subscribe_money_day)   as last_subscribe_money_day,
                max(last_subscribe_type_day)    as last_subscribe_type_day,
                max(last_subscribe_time_day)    as last_subscribe_time_day
         from (
                  select dt,
                         UserId,
                         ProductId,
                         case rk_a when 1 then ItemCount  end  as first_subscribe_money_day,
                         case rk_a when 1 then ShopItem   end  as first_subscribe_type_day,
                         case rk_a when 1 then CreateTime end  as first_subscribe_time_day,
                         case rk_d when 1 then ItemCount  end  as last_subscribe_money_day,
                         case rk_d when 1 then ShopItem   end  as last_subscribe_type_day,
                         case rk_d when 1 then CreateTime end  as last_subscribe_time_day
                  from (
                           select dt,
                                  UserId,
                                  ProductId,
                                  ItemCount,
                                  ShopItem,
                                  CreateTime,
                                  row_number() over (partition by dt,UserId, ProductId order by CreateTime,AutoId )     rk_a,
                                  row_number() over (partition by dt,UserId, ProductId order by CreateTime desc,AutoId desc) rk_d
                           from dwd.dwd_trade_user_payorder
                           where dt >= '${bf_1_dt}' and dt<='${dt}'
                             and ShopItem in (800, 801, 802, 830, 840)
                             and TestFlag = 0
                       ) a
                  where rk_a = 1
                     or rk_d = 1
              ) t1
         group by 1, 2, 3
     ),
     todayOtherRecharge as (
         select dt,
                UserId,
                ProductId,
                max(ItemCount) as max_recharge_money_day,
                min(ItemCount) as min_recharge_money_day,
                count(1)       as recharge_cnt_day,
                sum(ItemCount) as recharge_money_day
         from dwd.dwd_trade_user_payorder
         where dt >= '${bf_1_dt}' and dt<='${dt}'
           and TestFlag = 0
         group by 1, 2, 3
     ),
     todayOtherSubscribe as (
         select dt,
                UserId,
                ProductId,
                count(shopitem) - 1 as subscribe_cnt_day,
                array_distinct(array_agg(ShopItem)) as shopitems_day
               ,sum(ItemCount) as subscribe_money -- 订阅金额
         from dwd.dwd_trade_user_payorder
         where dt >= '${bf_1_dt}' and dt<='${dt}'
           and ShopItem in (800, 801, 802, 830, 840)
           and TestFlag = 0
         group by 1, 2, 3
     )
select today_recharge.dt,
       today_recharge.ProductId                                            as Product_Id,
       today_recharge.UserId                                               as User_Id,
       today_recharge.first_recharge_time_day,
       today_recharge.first_recharge_money_day,
       today_recharge.last_recharge_time_day,
       today_recharge.last_recharge_money_day,
       today_subscribe.first_subscribe_time_day ,
       today_subscribe.first_subscribe_money_day,
       today_subscribe.first_subscribe_type_day,
       today_subscribe.last_subscribe_time_day  ,
       today_subscribe.last_subscribe_money_day ,
       today_subscribe.last_subscribe_type_day,
       todayOtherSubscribe.subscribe_money, -- 订阅金额
       todayOtherSubscribe.subscribe_cnt_day,
       todayOtherSubscribe.shopitems_day,
       todayOtherRecharge.max_recharge_money_day,
       todayOtherRecharge.min_recharge_money_day,
       todayOtherRecharge.recharge_Cnt_day,
       todayOtherRecharge.recharge_money_day,
       current_timestamp() as  etl_time
from today_recharge
         left join today_subscribe  on today_recharge.dt = today_subscribe.dt and today_recharge.ProductId = today_subscribe.ProductId and today_recharge.UserId = today_subscribe.UserId
         left join todayOtherSubscribe  on today_recharge.dt = todayOtherSubscribe.dt and today_recharge.ProductId = todayOtherSubscribe.ProductId and today_recharge.UserId = todayOtherSubscribe.UserId
         left join todayOtherRecharge  on today_recharge.dt = todayOtherRecharge.dt and today_recharge.ProductId = todayOtherRecharge.ProductId and today_recharge.UserId = todayOtherRecharge.UserId;
