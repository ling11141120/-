----------------------------------------------------------------
-- 程序功能： 交易域-支付成功充值订单
-- 程序名： P_dwd_trade_pay_succ_recharge_order_hi
-- 目标表： dwd.dwd_trade_pay_succ_recharge_order_hi
-- 开发人： qhr
-- 开发日期： 2026-01-22
----------------------------------------------------------------

-- 海剧
insert into tmp.dwd_trade_pay_succ_recharge_order_hi
select dt
     , 6833                                                        as product_id
     , orderid                                                     as order_id
     , userid                                                      as user_id
     , createtime                                                  as create_time
     , itemcount                                                   as recharge_amt
     , MT                                                          as mt
     , ShopItem                                                    as recharge_type_cd
     , case when ShopItem = '0'   then '普通充值'
            when ShopItem = '810' then 'SVIP'
            when ShopItem = '840' then '签到卡'
            when ShopItem = '860' then 'NSVIP'
            else '其他'
        end                                                        as recharge_type
     , RealMoney                                                   as token_num
     , BaseAmount                                                  as base_amount
     , SubPayType                                                  as recharge_channel
     , case when split(get_json_string(CustomData, '$.sendId'), '_')[1] = '201300'    then '商店页'
            when split(get_json_string(CustomData, '$.sendId'), '_')[1] = '200900'    then '半屏'
            when     split(get_json_string(CustomData, '$.sendId'), '_')[1] = '200800'
                 and split(get_json_string(CustomData, '$.sendId'), '_')[2] = '0'     then '解锁页VIP'
            when split(get_json_string(CustomData, '$.sendId'), '_')[1] = '203300'    then 'H5'
            when split(get_json_string(CustomData, '$.sendId'), '_')[1] is null
                 then (case when     split(get_json_string(CustomData, '$.activityLink'), '_')[1] = 202100
                                 and split(get_json_string(CustomData, '$.activityLink'), '_')[2] in (0, 1) then '普通弹窗'
                            when     split(get_json_string(CustomData, '$.activityLink'), '_')[1] = 202100
                                 and split(get_json_string(CustomData, '$.activityLink'), '_')[2] = 3       then '充值返回推弹窗'
                            when     split(get_json_string(CustomData, '$.activityLink'), '_')[1] = 202100
                                 and split(get_json_string(CustomData, '$.activityLink'), '_')[2] = 12      then '充值弹层'
                            when     split(get_json_string(CustomData, '$.activityLink'), '_')[1] = 200800
                                 and split(get_json_string(CustomData, '$.sendId'), '_')[2] = '0'           then '解锁页VIP'
                            when split(get_json_string(CustomData, '$.activityLink'), '_')[1] = 205000      then '会员中心页'
                            when split(get_json_string(CustomData, '$.activityLink'), '_')[1] = 203200      then '悬浮窗'
                            when split(get_json_string(CustomData, '$.activityLink'), '_')[1] = 204000      then 'TAB栏'
                            when split(get_json_string(CustomData, '$.activityLink'), '_')[1] = 204100      then 'banner'
                            when split(get_json_string(CustomData, '$.activityLink'), '_')[1] = 210010      then 'push'
                            when split(get_json_string(CustomData, '$.activityLink'), '_')[1] = 203600      then '开屏页'
                            when split(get_json_string(CustomData, '$.activityLink'), '_')[1] is null       then '其他'
                            else split(get_json_string(CustomData, '$.activityLink'), '_')[1]
                       end
                      )
            when     split(get_json_string(CustomData, '$.sendId'), '_')[1] = '202100'
                 and split(get_json_string(CustomData, '$.sendId'), '_')[2] in ('0', '1') then '普通弹窗'
            when     split(get_json_string(CustomData, '$.sendId'), '_')[1] = '202100'
                 and split(get_json_string(CustomData, '$.sendId'), '_')[2] = '3'         then '充值返回推弹窗'
            when     split(get_json_string(CustomData, '$.sendId'), '_')[1] = '202100'
                 and split(get_json_string(CustomData, '$.sendId'), '_')[2] = '12'        then '充值弹层'
            else '其他'
        end                                                        as recharge_src
     , get_json_string(CustomData, '$.strategyId')                 as strategy_id
     , get_json_string(CooOrderExtInfo, '$.SubscribeStatus')       as subscribe_status
     , VipExpireTime                                               as card_expire_time
     , substring_index(
          substring_index(
              substring_index(
                  substring_index(
                      substring_index(ExtInfo, '|', -1), 'com.changdu.mobovideo.', -1
                  ), 'com.changdu.moboshort.', -1
              ), 'com.changjian.moboshortcj.', -1
          ), 'third.', -1
       )                                                           as item_id
     , now()                                                       as etl_time
  from ods.ods_tidb_short_video_payorder
 where dt >= '${bf_1_dt}'
   and dt <= '${dt}'
   and TestFlag = 0
;