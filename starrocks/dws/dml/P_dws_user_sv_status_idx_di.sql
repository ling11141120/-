----------------------------------------------------------------
-- 程序功能： 用户域-海剧用户状态指标表
-- 程序名： P_dws_user_sv_status_idx_di
-- 目标表： dws.dws_user_sv_status_idx_di
-- 负责人： qhr
-- 开发日期： 2025-12-26
----------------------------------------------------------------

-- 登录
insert into dws.dws_user_sv_status_idx_di (
     user_id         -- 用户id
    ,fst_login_tm    -- 首次登录时间
    ,lst_login_tm    -- 上一次登录时间
    ,new_login_tm    -- 最新登录时间
    ,remain_day      -- 登录留存天数
    ,etl_time        -- etl时间
)
select ultm.user_id
     , ultm.fst_login_tm
     , ultm.lst_login_tm
     , ultm.new_login_tm
     , datediff(ultm.new_login_tm, svacc.create_time)                                        as remain_day
     , now()                                                                                 as etl_time
  from (select user_id
             , min(create_time)                                                              as fst_login_tm
             , max(case when rank_desc = 2 then create_time end)                             as lst_login_tm
             , max(create_time)                                                              as new_login_tm
          from (select user_id
                     , create_time
                     , row_number() over (partition by user_id order by create_time desc)    as rank_desc
                  from dwd.dwd_user_short_video_user_login_view
                 where dt = '${bf_1_dt}'
                   and user_id is not null
                )                                   as ulrn
         group by 1
       )                                            as ultm
  left join dim.dim_short_video_user_accountinfo    as svacc
    on ultm.user_id = svacc.user_id
;

-- 消费
insert into dws.dws_user_sv_status_idx_di (
     user_id                 -- 用户id
    ,fst_consume_tm          -- 首次消费时间
    ,lst_consume_tm          -- 最近一次消费时间
    ,consume_tv_td           -- 消费剧集bitmap(剧id+集序号)
    ,fst_consume_money_tm    -- 首次消费代币时间
    ,lst_consume_money_tm    -- 最近一次消费代币时间
    ,consume_money_tv_td     -- 代币消费剧集bitmap(剧id+集序号)
    ,fst_consume_cert_tm     -- 首次消费赠币时间
    ,lst_consume_cert_tm     -- 最近一次消费赠币时间
    ,consume_cert_tv_td      -- 赠币消费剧集bitmap(剧id+集序号)
    ,etl_time                -- etl时间
)
select cbp.account_id                                                                                  as user_id
     , min(cbp.create_time)                                                                            as fst_consume_tm
     , min(cbp.create_time)                                                                            as lst_consume_tm
     , bitmap_union(to_bitmap(concat(svev.series_id, cbp.epis_num)))                                   as consume_tv_td
     , if( min(if(cbp.consume_type = 0, cbp.create_time, '9999-12-31')) < '9999-12-31'
          ,min(if(cbp.consume_type = 0, cbp.create_time, '9999-12-31'))
          ,null
         )                                                                                             as fst_consume_money_tm
     , if( max(if(cbp.consume_type = 0, cbp.create_time, '0000-01-01')) > '0000-01-01'
          ,max(if(cbp.consume_type = 0, cbp.create_time, '0000-01-01'))
          ,null
         )                                                                                             as lst_consume_money_tm
     , bitmap_union(if(cbp.consume_type = 0, to_bitmap(concat(svev.series_id, cbp.epis_num)),null))    as consume_money_tv_td
     , if( min(if(cbp.consume_type = 1, cbp.create_time, '9999-12-31')) < '9999-12-31'
          ,min(if(cbp.consume_type = 1, cbp.create_time, '9999-12-31'))
          ,null)                                                                                       as fst_consume_cert_tm
     , if( max(if(cbp.consume_type = 1, cbp.create_time, '0000-01-01')) > '0000-01-01'
          ,max(if(cbp.consume_type = 1, cbp.create_time, '0000-01-01'))
          ,null)                                                                                       as lst_consume_cert_tm
     , bitmap_union(if(cbp.consume_type = 1, to_bitmap(concat(svev.series_id, cbp.epis_num)),null))    as consume_cert_tv_td
     , now()                                                                                           as etl_time
  from dwd.dwd_sv_consume_user_consume_bill_pdi    as cbp
  left join dim.dim_short_video_epis_view          as svev
    on cbp.epis_id = svev.epis_id
 where cbp.dt = '${bf_1_dt}'
   and cbp.epis_id <> 0
   and svev.series_id is not null
 group by 1
;

-- 观看
insert into dws.dws_user_sv_status_idx_di (
     user_id                 -- 用户id
    ,fst_watch_tm            -- 首次观看时间
    ,lst_watch_tm            -- 末次观看时间
    ,new_epis_series_td      -- 观看到了最新剧集的剧集
    ,etl_time                -- etl时间
)
select sveh.account_id                                                              as user_id
     , min(sveh.create_time)                                                        as fst_watch_tm
     , max(sveh.create_time)                                                        as lst_watch_tm
     , bitmap_union(to_bitmap(concat(mxen.series_id, 99999, mxen.max_epis_num)))    as new_epis_series_td
     ,now()                                                                         as etl_time
  from dwd.dwd_video_short_video_epis_history    as sveh
  left join (select series_id
                  , max(epis_num) as max_epis_num
               from dim.dim_short_video_epis_view
              where is_delete = 0
              group by 1
             )                                   as mxen
    on sveh.series_id = mxen.series_id
   and sveh.epis_num = mxen.max_epis_num
 where sveh.dt = '${bf_1_dt}'
   and right(sveh.account_id, 1) in (0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
 group by 1
;

-- 充值订阅
insert into dws.dws_user_sv_status_idx_di (
     user_id                 -- 用户id
    ,first_subscribe_amt     -- 首次订阅金额
    ,first_subscribe_tp      -- 首次订阅类型
    ,first_subscribe_tm      -- 首次订阅时间
    ,last_subscribe_amt      -- 最后订阅金额
    ,last_subscribe_tp       -- 最后订阅类型
    ,last_subscribe_tm       -- 最后订阅时间
    ,first_recharge_amt      -- 首次充值金额
    ,first_recharge_tm       -- 首次充值时间
    ,recharge_max            -- 最大充值金额
    ,month_recharge_max      -- 近一个月最大充值金额
    ,last_recharge_amt       -- 最后充值金额
    ,last_recharge_tm        -- 最近充值时间
    ,charge_mode             -- 充值众数（不考虑退款因素）
    ,etl_time                -- etl时间
)
with svp as (
    select user_id
         , if(shop_item in (810, 840), 1, 0)    as is_sub    -- 是否订阅
         , item_count
         , create_time
         , shop_item
         , id
      from dwd.dwd_trade_short_video_payorder
     where dt >= date_sub('${bf_1_dt}', interval 30 day)
       and dt <= '${bf_1_dt}'
       and status = 0
       and test_flag = 0
)
, month_calc as (
    select svptrn.user_id                                                                 as user_id
         , max(if(svptrn.rn = 1 and svptrn.is_sub = 1, svptrn.item_count, null))          as first_subscribe_amt
         , max(if(svptrn.rn = 1 and svptrn.is_sub = 1, svptrn.shop_item, null))           as first_subscribe_tp
         , max(if(svptrn.rn = 1 and svptrn.is_sub = 1, svptrn.create_time, null))         as first_subscribe_tm
         , max(if(svptrn.rn_desc = 1 and svptrn.is_sub = 1, svptrn.item_count, null))     as last_subscribe_amt
         , max(if(svptrn.rn_desc = 1 and svptrn.is_sub = 1, svptrn.shop_item, null))      as last_subscribe_tp
         , max(if(svptrn.rn_desc = 1 and svptrn.is_sub = 1, svptrn.create_time, null))    as last_subscribe_tm
         , max(if(svptrn.rn = 1, svptrn.item_count, null))                                as first_recharge_amt
         , max(if(svptrn.rn = 1, svptrn.create_time, null))                               as first_recharge_tm
         , max(svptrn.item_count)                                                         as recharge_max
         , max(svptrn.item_count)                                                         as month_recharge_max
         , max(if(svptrn.rn_desc = 1, svptrn.item_count, null))                           as last_recharge_amt
         , max(if(svptrn.rn_desc = 1, svptrn.create_time, null))                          as last_recharge_tm
         , max(mode.charge_mode)                                                          as charge_mode
      from (select svp.user_id
                 , svp.is_sub
                 , svp.item_count
                 , svp.create_time
                 , svp.shop_item
                 , svp.id
                 , row_number() over (partition by svp.user_id order by svp.create_time, svp.id)              as rn
                 , row_number() over (partition by svp.user_id order by svp.create_time desc, svp.id desc)    as rn_desc
              from svp
            )                                       as svptrn
      left join (select tmode.user_id
                      , tmode.item_count            as charge_mode
                   from (select user_id
                              , item_count
                              , count(1)            as num
                              , max(create_time)    as create_time
                           from svp
                          group by 1, 2
                         ) as tmode
                qualify row_number() over (partition by tmode.user_id order by tmode.num desc, tmode.create_time desc) = 1
                 )                                  as mode
        on svptrn.user_id = mode.user_id
     group by 1
)
select coalesce(calc.user_id, ori.user_id)                            as user_id
     , coalesce(ori.first_subscribe_amt, calc.first_subscribe_amt)    as first_subscribe_amt
     , coalesce(ori.first_subscribe_tp, calc.first_subscribe_tp)      as first_subscribe_tp
     , calc.first_subscribe_amt                                       as first_subscribe_tm
     , calc.last_subscribe_amt
     , calc.last_subscribe_tp
     , calc.last_subscribe_tm
     , coalesce(ori.first_recharge_amt, calc.first_recharge_amt)      as first_recharge_amt
     , calc.first_recharge_tm
     , calc.recharge_max
     , calc.month_recharge_max
     , calc.last_recharge_amt
     , calc.last_recharge_tm
     , coalesce(calc.charge_mode, ori.charge_mode)                    as charge_mode
     , now()                                                          as etl_time
  from month_calc                         as calc
  left join dws.dws_user_sv_status_idx_di as ori
    on calc.user_id = ori.user_id
;

-- 点赞
insert into dws.dws_user_sv_status_idx_di (
     user_id                 -- 用户id
    ,fst_like_tm             -- 首次点赞时间
    ,lst_like_tm             -- 末次点赞时间
    ,etl_time                -- etl时间
)
select user_id
     , min(create_time)      as fst_like_tm
     , max(create_time)      as lst_like_tm
     , now()                 as etl_time
  from dwd.dwd_video_short_video_account_like_view
 where dt = '${bf_1_dt}'
 group by 1
;

-- 安装激活
insert into dws.dws_user_sv_status_idx_di (
     user_id                 -- 用户id
    ,fst_install_book_id     -- 首次引流书籍
    ,lst_install_book_id     -- 最新引流书籍
    ,lst_source              -- 最新媒体值
    ,lst_install_date        -- 最新激活时间
    ,etl_time                -- etl时间
)
select calc.user_id
     , if(ori.user_id is null, calc.fst_install_book_id, ori.fst_install_book_id)    as fst_install_book_id
     , calc.lst_install_book_id
     , calc.lst_source
     , calc.lst_install_date
     , now()                                                                         as etl_time
  from (select iiev.user_id
             , max(if(iiev.rn = 1, iiev.book_id, null))              as fst_install_book_id
             , max(if(iiev.rn_desc = 1, iiev.book_id, null))         as lst_install_book_id
             , max(if(iiev.rn_desc = 1, iiev.source, null))          as lst_source
             , max(if(iiev.rn_desc = 1, iiev.install_date, null))    as lst_install_date
          from (select user_id
                     , book_id
                     , source
                     , install_date
                     , row_number() over (partition by user_id order by install_date)         as rn
                     , row_number() over (partition by user_id order by install_date desc)    as rn_desc
                  from dwd.dwd_user_install_info_ed_view
                 where dt = '${bf_1_dt}'
                   and product_id = 6833
                   and user_id <> -1
                   and isdelete = 0
               )                             as iiev
         group by 1
       )                                     as calc
  left join dws.dws_user_sv_status_idx_di    as ori
    on calc.user_id = ori.user_id
;

-- 用户支付扩展
insert into dws.dws_user_sv_status_idx_di(
     user_id                       -- 用户id
    ,fst_recharge_watch_series_num -- 首冲观看剧数
    ,fst_recharge_watch_epis_num   -- 首充观看集数
    ,lst_third_recharge_tm         -- 最近三方充值时间
    ,reg_fst_recharge_duration     -- 注册到首充的分钟数
    ,fst_sign_card_price           -- 首次签到卡金额
    ,fst_vip_price                 -- 首次VIP金额
    ,fst_svip_price                -- 首次SVIP金额
    ,max_bonus_ratio               -- 最高礼券加赠比例
    ,lst_bonus_ratio               -- 最近一次礼券加赠比例
    ,etl_time                      -- etl时间
)
select id                                  as user_id
     , first_recharge_watch_series_num     as fst_recharge_watch_series_num
     , first_recharge_watch_epis_num       as fst_recharge_watch_epis_num
     , latest_third_recharge_time          as lst_third_recharge_tm
     , registry_first_recharge_duration    as reg_fst_recharge_duration
     , first_sign_card_price               as fst_sign_card_price
     , first_vip_price                     as fst_vip_price
     , first_svip_price                    as fst_svip_price
     , max_bonus_ratio                     as max_bonus_ratio
     , latest_bonus_ratio                  as lst_bonus_ratio
     , now()                               as etl_time
  from ods.ods_tidb_short_video_account_pay_extend
;

-- 广告
insert into dws.dws_user_sv_status_idx_di (
     user_id                      -- 用户id
    ,fst_preload_reward_ecpm      -- 首次预加载激励视频eCPM
    ,lst_preload_reward_ecpm      -- 最近预加载激励视频eCPM
    ,fst_preload_intersitial_ecpm -- 首次预加载插屏eCPM
    ,lst_preload_intersitial_ecpm -- 最近预加载插屏eCPM
    ,etl_time                     -- etl时间
)
with curr as (
    select account_id    as user_id
         , ad_type       as ad_type
         , min_by(value_micros, create_time) * 1000 as fst_reward_ecpm
         , max_by(value_micros, create_time) * 1000 as lst_reward_ecpm
      from dwd.dwd_sv_advertise_ad_preload_revenue_di_view
     where create_time >= '${bf_1_dt}'
       and create_time < '${dt}'
     group by 1, 2
)
select coalesce(curra.user_id, ori.user_id)                                               as user_id
     , coalesce(curra.fst_preload_reward_ecpm, ori.fst_preload_reward_ecpm)               as fst_preload_reward_ecpm
     , coalesce(curra.lst_preload_reward_ecpm, ori.lst_preload_reward_ecpm)               as lst_preload_reward_ecpm
     , coalesce(curra.fst_preload_intersitial_ecpm, ori.fst_preload_intersitial_ecpm)     as fst_preload_intersitial_ecpm
     , coalesce(curra.lst_preload_intersitial_ecpm, ori.lst_preload_intersitial_ecpm)     as lst_preload_intersitial_ecpm
     , now()                                                                              as etl_time
  from (select user_id
             , sum(case when ad_type = 3 then fst_reward_ecpm else 0 end)    as fst_preload_reward_ecpm
             , sum(case when ad_type = 3 then lst_reward_ecpm else 0 end)    as lst_preload_reward_ecpm
             , sum(case when ad_type = 5 then fst_reward_ecpm else 0 end)    as fst_preload_intersitial_ecpm
             , sum(case when ad_type = 5 then lst_reward_ecpm else 0 end)    as lst_preload_intersitial_ecpm
          from curr
         group by 1
       )                                     as curra
  left join dws.dws_user_sv_status_idx_di    as ori
    on curra.user_id = ori.user_id
;