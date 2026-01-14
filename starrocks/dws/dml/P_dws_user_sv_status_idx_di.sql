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
with svpt as (
    select svp.user_id
         , if(svp.shop_item in (810, 840), 1, 0)    as types
         , svp.item_count
         , svp.create_time
         , svp.shop_item
         , svp.id
         , svp.status
      from dwd.dwd_trade_short_video_payorder       as svp
     where svp.dt >= date_sub('${bf_1_dt}', interval 30 day)
       and svp.dt <= '${bf_1_dt}'
       and svp.status = 0
       and svp.test_flag = 0
)
, month_calc as (
    select svptrn.user_id                                                                as user_id
         , max(if(svptrn.rn = 1 and svptrn.types = 1, svptrn.item_count, null))          as first_subscribe_amt
         , max(if(svptrn.rn = 1 and svptrn.types = 1, svptrn.shop_item, null))           as first_subscribe_tp
         , max(if(svptrn.rn = 1 and svptrn.types = 1, svptrn.create_time, null))         as first_subscribe_tm
         , max(if(svptrn.rn_desc = 1 and svptrn.types = 1, svptrn.item_count, null))     as last_subscribe_amt
         , max(if(svptrn.rn_desc = 1 and svptrn.types = 1, svptrn.shop_item, null))      as last_subscribe_tp
         , max(if(svptrn.rn_desc = 1 and svptrn.types = 1, svptrn.create_time, null))    as last_subscribe_tm
         , max(if(svptrn.rn = 1 and svptrn.types = 0, svptrn.item_count, null))          as first_recharge_amt
         , max(if(svptrn.rn = 1 and svptrn.types = 0, svptrn.create_time, null))         as first_recharge_tm
         , max(if(svptrn.status = 0, svptrn.item_count, null))                           as recharge_max
         , max(if(svptrn.status = 0, svptrn.item_count, null))                           as month_recharge_max
         , max(if(svptrn.rn_desc = 1 and svptrn.types = 0, svptrn.item_count, null))     as last_recharge_amt
         , max(if(svptrn.rn_desc = 1 and svptrn.types = 0, svptrn.create_time, null))    as last_recharge_tm
         , max(mode.charge_mode)                                                         as charge_mode
      from (select svpt.user_id
                 , svpt.types
                 , svpt.item_count
                 , svpt.create_time
                 , svpt.shop_item
                 , svpt.id
                 , svpt.status
                 , row_number() over (partition by svpt.types, svpt.user_id order by svpt.create_time, svpt.id)              as rn
                 , row_number() over (partition by svpt.types, svpt.user_id order by svpt.create_time desc, svpt.id desc)    as rn_desc
              from svpt
            )                                       as svptrn
      left join (select tmode.user_id
                      , tmode.item_count            as charge_mode
                   from (select user_id
                              , item_count
                              , count(1)            as num
                              , max(create_time)    as create_time
                           from svpt
                          group by 1, 2
                         ) as tmode qualify row_number() over (partition by tmode.user_id order by tmode.num desc, tmode.create_time desc) = 1
                 )                                  as mode
        on svptrn.user_id = mode.user_id
     group by 1
)
select calc.user_id
     , if(ori.user_id is null, calc.first_subscribe_amt, ori.first_subscribe_amt)    as first_subscribe_amt
     , if(ori.user_id is null, calc.first_subscribe_tp, ori.first_subscribe_tp)      as first_subscribe_tp
     , ori.first_subscribe_tm                                                        as first_subscribe_tm
     , ori.last_subscribe_amt
     , ori.last_subscribe_tp
     , ori.last_subscribe_tm
     , if(ori.user_id is null, calc.first_recharge_amt, ori.first_recharge_amt)      as first_recharge_amt
     , ori.first_recharge_tm
     , ori.recharge_max
     , ori.month_recharge_max
     , ori.last_recharge_amt
     , ori.last_recharge_tm
     , ori.charge_mode
     , now()                                                                         as etl_time
  from month_calc                            as calc
  left join dws.dws_user_sv_status_idx_di    as ori
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