----------------------------------------------------------------
-- 程序功能： 交易域-支付成功充值订单
-- 程序名： P_dwd_trade_pay_succ_recharge_order_hi
-- 目标表： dwd.dwd_trade_pay_succ_recharge_order_hi
-- 开发人： qhr
-- 开发日期： 2026-01-22
----------------------------------------------------------------

-- 海剧
insert into dwd.dwd_trade_pay_succ_recharge_order_hi
select svp.dt                                                          as dt
     , 6833                                                            as product_id
     , svp.orderid                                                     as order_id
     , svp.userid                                                      as user_id
     , svp.createtime                                                  as create_time
     , svp.itemcount                                                   as recharge_amt
     , svp.MT                                                          as mt
     , svp.ShopItem                                                    as recharge_type_cd
     , case when svp.ShopItem = '0'   then '普通充值'
            when svp.ShopItem = '810' then 'SVIP'
            when svp.ShopItem = '840' then '签到卡'
            when svp.ShopItem = '860' then 'NSVIP'
            else '其他'
        end                                                            as recharge_type
     , svp.RealMoney                                                   as token_num
     , svp.BaseAmount                                                  as base_amount
     , svp.SubPayType                                                  as recharge_channel
     , case when split(get_json_string(svp.CustomData, '$.sendId'), '_')[1] = '201300'    then '商店页'
            when split(get_json_string(svp.CustomData, '$.sendId'), '_')[1] in('200900','210054','210051')     then '半屏'
            when     split(get_json_string(svp.CustomData, '$.sendId'), '_')[1] = '200800'
                 and split(get_json_string(svp.CustomData, '$.sendId'), '_')[2] = '0'     then '解锁页VIP'
            when split(get_json_string(svp.CustomData, '$.sendId'), '_')[1] = '203300'    then 'H5'
            when split(get_json_string(svp.CustomData, '$.sendId'), '_')[1] is null
                 then (case when     split(get_json_string(svp.CustomData, '$.activityLink'), '_')[1] = 202100
                                 and split(get_json_string(svp.CustomData, '$.activityLink'), '_')[2] in (0, 1) then '普通弹窗'
                            when     split(get_json_string(svp.CustomData, '$.activityLink'), '_')[1] = 202100
                                 and split(get_json_string(svp.CustomData, '$.activityLink'), '_')[2] = 3       then '充值返回推弹窗'
                            when     split(get_json_string(svp.CustomData, '$.activityLink'), '_')[1] = 202100
                                 and split(get_json_string(svp.CustomData, '$.activityLink'), '_')[2] = 12      then '充值弹层'
                            when     split(get_json_string(svp.CustomData, '$.activityLink'), '_')[1] = 200800
                                 and split(get_json_string(svp.CustomData, '$.sendId'), '_')[2] = '0'           then '解锁页VIP'
                            when split(get_json_string(svp.CustomData, '$.activityLink'), '_')[1] = 205000      then '会员中心页'
                            when split(get_json_string(svp.CustomData, '$.activityLink'), '_')[1] = 203200      then '悬浮窗'
                            when split(get_json_string(svp.CustomData, '$.activityLink'), '_')[1] = 204000      then 'TAB栏'
                            when split(get_json_string(svp.CustomData, '$.activityLink'), '_')[1] = 204100      then 'banner'
                            when split(get_json_string(svp.CustomData, '$.activityLink'), '_')[1] = 210010      then 'push'
                            when split(get_json_string(svp.CustomData, '$.activityLink'), '_')[1] = 203600      then '开屏页'
                            when split(get_json_string(svp.CustomData, '$.activityLink'), '_')[1] is null       then '其他'
                            else split(get_json_string(svp.CustomData, '$.activityLink'), '_')[1]
                       end
                      )
            when     split(get_json_string(svp.CustomData, '$.sendId'), '_')[1] = '202100'
                 and split(get_json_string(svp.CustomData, '$.sendId'), '_')[2] in ('0', '1') then '普通弹窗'
            when     split(get_json_string(svp.CustomData, '$.sendId'), '_')[1] = '202100'
                 and split(get_json_string(svp.CustomData, '$.sendId'), '_')[2] = '3'         then '充值返回推弹窗'
            when     split(get_json_string(svp.CustomData, '$.sendId'), '_')[1] = '202100'
                 and split(get_json_string(svp.CustomData, '$.sendId'), '_')[2] = '12'        then '充值弹层'
            else '其他'
        end                                                            as recharge_src
     , get_json_string(svp.CustomData, '$.strategyId')                 as strategy_id
     , get_json_string(svp.CooOrderExtInfo, '$.SubscribeStatus')       as subscribe_status
     , svp.VipExpireTime                                               as card_expire_time
     , substring_index(
          substring_index(
              substring_index(
                  substring_index(
                      substring_index(svp.ExtInfo, '|', -1), 'com.changdu.mobovideo.', -1
                  ), 'com.changdu.moboshort.', -1
              ), 'com.changjian.moboshortcj.', -1
          ), 'third.', -1
       )                                                               as item_id
     , now()                                                           as etl_time
     , svp.id                                                          as log_id
     , svp.ActualAmount                                                as actual_recharge_amt
     , svp.CoreVer                                                     as core
     , coalesce( svg.vip_type
                ,case when datediff(svp.VipExpireTime, svp.createtime) >= 25  and datediff(svp.VipExpireTime, svp.createtime) <= 35   then 1    -- 月卡
                      when datediff(svp.VipExpireTime, svp.createtime) >= 80  and datediff(svp.VipExpireTime, svp.createtime) <= 100  then 2    -- 季卡
                      when datediff(svp.VipExpireTime, svp.createtime) >= 350 and datediff(svp.VipExpireTime, svp.createtime) <= 380  then 3    -- 年卡
                      when datediff(svp.VipExpireTime, svp.createtime) >= 1   and datediff(svp.VipExpireTime, svp.createtime) <= 9    then 4    -- 周卡
                  end
               )                                            as vip_type_cd
     , get_json_string(svp.CustomData, '$.nodeIdPath')      as pay_wall_strategy_id
  from ods.ods_tidb_short_video_payorder    as svp
  left join (select ItemId                  as item_id
                  , ShopItemId              as shop_item_id
                  , VipType                 as vip_type
               from ods.ods_tidb_short_video_admin_goods
              where ShopItemId in (840,810,860)
                and IsRemove = 0
              group by 1, 2, 3
            )                               as svg
    on substring_index(
          substring_index(
              substring_index(
                  substring_index(
                      substring_index(svp.ExtInfo, '|', -1), 'com.changdu.mobovideo.', -1
                  ), 'com.changdu.moboshort.', -1
              ), 'com.changjian.moboshortcj.', -1
          ), 'third.', -1
       ) = svg.item_id
   and svp.ShopItem = svg.shop_item_id
 where svp.dt >= '${bf_1_dt}'
   and svp.dt <= '${dt}'
   and svp.TestFlag = 0
;