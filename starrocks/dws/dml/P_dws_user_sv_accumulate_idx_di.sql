----------------------------------------------------------------
-- 程序功能： 用户域-海剧用户累计指标表
-- 程序名： P_dws_user_sv_accumulate_idx_di
-- 目标表： dws.dws_user_sv_accumulate_idx_di
-- 负责人： qhr
-- 开发日期： 2025-12-24
----------------------------------------------------------------

-- 登录
insert into dws.dws_user_sv_accumulate_idx_di (
     user_id          -- 用户id
    ,login_days_td    -- 累计登录天数
    ,login_cnt_td     -- 累计登录次数
    ,idx_ddl          -- 指标截止日期
)
select user_id
     , count(distinct dt)    as login_days_td
     , count(1)              as login_cnt_td
     , '${bf_1_dt}'          as idx_ddl
  from dwd.dwd_user_short_video_user_login_view
 where dt = '${bf_1_dt}'
   and user_id is not null
 group by 1
;

-- 消耗
insert into dws.dws_user_sv_accumulate_idx_di (
     user_id                 -- 用户id
    ,consume_amt_td          -- 累计消耗(代币、赠币)
    ,consume_cnt_td          -- 累积消费次数
    ,consume_money_amt_td    -- 累计消耗代币数
    ,consume_money_cnt_td    -- 累积消费代币次数
    ,consume_cert_amt_td     -- 累计消耗赠币
    ,consume_cert_cnt_td     -- 累积消费赠币次数
    ,idx_ddl                 -- 指标截止日期
)
select account_id                                        as user_id
     , sum(consume_value)                                as consume_amt_td
     , count(distinct id)                                as consume_cnt_td
     , sum(if(consume_type = 0, consume_value, 0))       as consume_money_amt_td
     , count(distinct if(consume_type = 0, id, null))    as consume_money_cnt_td
     , sum(if(consume_type = 1, consume_value, 0))       as consume_cert_amt_td
     , count(distinct if(consume_type = 1, id, null))    as consume_cert_cnt_td
     , '${bf_1_dt}'                                      as idx_ddl
  from dwd.dwd_sv_consume_user_consume_bill_pdi
 where dt = '${bf_1_dt}'
   and epis_id != 0
 group by 1
;

-- 观看
insert into dws.dws_user_sv_accumulate_idx_di (
     user_id            -- 用户id
    ,watch_days_td      -- 累计观看天数
    ,watch_tv_td        -- 累计观看剧集bitmap(剧id+集序号)
    ,watch_cnt_td       -- 累计观看次数(需要除以2再向上取整)
    ,watch_series_td    -- 累计观看剧bitmap
    ,idx_ddl            -- 指标截止日期
)
select account_id                                                   as user_id
     , count(distinct date(create_time))                            as watch_days_td
     , bitmap_union(to_bitmap(concat(series_id,99999,epis_num)))    as watch_tv_td
     , count(1)                                                     as watch_cnt_td
     , bitmap_union(to_bitmap(series_id))                           as watch_series_td
     , '${bf_1_dt}'                                                 as idx_ddl
  from dwd.dwd_video_short_video_epis_history
 where dt = '${bf_1_dt}'
   and right(account_id,1) in (0,1,2,3,4)
 group by 1
;

-- 点赞
insert into dws.dws_user_sv_accumulate_idx_di (
     user_id          -- 用户id
    ,like_cnt_td      -- 累计点赞次数
    ,like_series_td   -- 累计点赞剧bitmap
    ,like_epis_td     -- 累计点赞剧集bitmap(剧id+集序号)
    ,idx_ddl          -- 指标截止日期
)
select sval.user_id                                                     as user_id
     , count(1)                                                         as like_cnt_td
     , bitmap_union(to_bitmap(sval.series_id))                          as like_series_td
     , bitmap_union(to_bitmap(concat(sval.series_id,svev.epis_num)))    as like_epis_td
     , '${bf_1_dt}'                                                     as idx_ddl
  from dwd.dwd_video_short_video_account_like_view as sval
  left join dim.dim_short_video_epis_view          as svev
    on sval.epis_id=svev.epis_id
 where sval.dt = '${bf_1_dt}'
 group by 1
;

-- 充值订阅
insert into dws.dws_user_sv_accumulate_idx_di (
     user_id                       -- 用户id
    ,total_subscribe_amt           -- 累计订阅金额
    ,total_subscribe_cnt           -- 累计订阅次数
    ,total_recharge_amt            -- 累计充值金额
    ,total_recharge_cnt            -- 累计充值次数
    ,recharge_avg                  -- 平均充值金额
    ,total_subscribe_refund_cnt    -- 累计退订次数
    ,total_refund_amt              -- 累计退款金额
    ,total_refund_cnt              -- 累计退款次数
    ,mul_subscribe_item            -- 累计订阅类型bitmap
    ,idx_ddl                       -- 指标截止日期
)
select user_id
     , sum(if(status = 0 and shop_item in (810, 840), item_count, 0))              as total_subscribe_amt
     , sum(if(status = 0 and shop_item in (810, 840) and item_count > 0, 1, 0))    as total_subscribe_cnt
     , sum(if(status = 0, item_count, 0))                                          as total_recharge_amt
     , sum(if(status = 0 and item_count > 0, 1, 0))                                as total_recharge_cnt
     , sum(if(status = 0, item_count, 0))
       / sum(if(status = 0 and item_count > 0, 1, 0))                              as recharge_avg
     , sum(if(status = 1 and shop_item in (810,840) and item_count < 0,1,0))       as total_subscribe_refund_cnt
     , sum(if(status = 1 and item_count < 0, abs(item_count), null))               as total_refund_amt
     , sum(if(status = 1 and item_count < 0, 1, 0))                                as total_refund_cnt
     , bitmap_union(to_bitmap(if( status = 0 and shop_item in (810,840) and item_count > 0
                                 ,shop_item
                                 ,null
                                )
                             )
                   )                                                               as mul_subscribe_item
     , '${bf_1_dt}'                                                                as idx_ddl
  from dwd.dwd_trade_short_video_payorder
 where dt = '${bf_1_dt}'
   and test_flag = 0
 group by 1
;

-- 用户支付拓展
insert into dws.dws_user_sv_accumulate_idx_di (
     user_id                  -- 用户id
    ,sign_card_total_price    -- 累计签到卡金额
    ,vip_total_price          -- 累计VIP金额
    ,svip_total_price         -- 累计SVIP金额
    ,idx_ddl                  -- 指标截止日期
)
select id              as user_id
     , sign_card_total_price
     , vip_total_price
     , svip_total_price
     , '${bf_1_dt}'    as idx_ddl
  from ods.ods_tidb_short_video_account_pay_extend
;