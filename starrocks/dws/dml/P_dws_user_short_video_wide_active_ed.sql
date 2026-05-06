----------------------------------------------------------------
-- 程序功能： 用户域登录观看充值消耗汇总活跃表
-- 程序名： P_dws_user_short_video_wide_active_ed
-- 目标表： dws.dws_user_short_video_wide_active_ed
-- 负责人： xjc
-- 开发日期： 2026-04-30
----------------------------------------------------------------

insert into dws.dws_user_short_video_wide_active_ed
-- 活跃用户
with active_user_tmp as (
    select a1.dt
          ,a1.product_id
          ,a1.user_id
          ,max(a1.create_time)    as max_active_time
      from (-- 海外短剧登录表
            select dt
                  ,product_id
                  ,user_id
                  ,create_time
              from dwd.dwd_user_short_video_user_login_view
             where dt >= '${bf_3_dt}'
               and dt <= '${dt}'
               and user_id >= 0
             union all
            -- 国内短剧登录表
            select dt
                  ,6883    as productid
                  ,user_id
                  ,create_time
              from dwd.dwd_user_video_cn_login_info
             where dt >= '${bf_3_dt}'
               and dt <= '${dt}'
               and user_id >= 0
             union all
            -- 海外短剧支付表
            select dt
                  ,product_id
                  ,user_id
                  ,create_time
              from dwd.dwd_trade_short_video_payorder
             where dt >= '${bf_3_dt}'
               and dt <= '${dt}'
               and product_id = 6833
               and status = 0
               and test_flag = 0
               and user_id >= 0
             union all
            -- 国内短剧支付表
            select dt
                  ,product_id
                  ,video_user_id    as user_id
                  ,create_time
              from dwd.dwd_trade_video_cn_payorder_view
             where dt >= '${bf_3_dt}'
               and dt <= '${dt}'
               and order_status = 1
               and test_flag = 0
               and video_user_id >= 0
             union all
            -- 海外短剧消耗表
            select dt
                  ,6833          as product_id
                  ,account_id    as user_id
                  ,create_time
              from dwd.dwd_sv_consume_user_consume_bill_pdi
             where dt >= '${bf_3_dt}'
               and dt <= '${dt}'
               and account_id >= 0
             union all
            -- 国内短剧消耗表
            select dt
                  ,6883           as product_id
                  ,ref_user_id    as user_id
                  ,create_time
              from dwd.dwd_consume_short_video_cn_consume_view
             where dt >= '${bf_3_dt}'
               and dt <= '${dt}'
               and ref_user_id >= 0
             union all
            -- 海外短剧观看记录表
            select date(create_time)    as dt
                  ,6833                 as product_id
                  ,account_id           as user_id
                  ,create_time
              from dwd.dwd_video_short_video_epis_history
             where date(create_time) >= '${bf_3_dt}'
               and date(create_time) <= '${dt}'
               and account_id >= 0
             union all
            -- 国内短剧观看记录表
            select dt
                  ,6883    as product_id
                  ,user_id
                  ,create_time
              from dwd.dwd_video_vedio_watch_cn_view
             where dt >= '${bf_3_dt}'
               and dt <= '${dt}'
               and user_id >= 0
             union all
            -- TT换币充值订单（tt_payorder）
            select settle_dt    as dt
                  ,product_id
                  ,user_id
                  ,settle_time
              from dwd.dwd_sv_tt_payorder_info
             where is_refund = 0
               and is_sandbox = 0
               and settle_dt >= '${bf_3_dt}'
               and settle_dt <= '${dt}'
               and user_id >= 0
             union all
            -- TT消耗订单（tt_consume）
            select date(b1.create_time)    as dt
                  ,6833                    as product_id
                  ,b1.account_id           as user_id
                  ,b1.create_time
              from ods.ods_tidb_short_video_tt_consume    as b1
              left join (select get_json_string(content, '$.trade_order_id')               as trade_order_id
                               ,max(if(get_json_string(content, '$.is_sandbox'), 1, 0))    as is_sandbox
                           from ods.ods_tidb_short_video_tt_vip_subscribe_event_log
                          where date(create_time) >= '${bf_3_dt}'
                            and date(create_time) <= '${dt}'
                            and get_json_string(content, '$.trade_order_id') is not null
                          group by 1
                        )    as b2
                on b1.trade_order_id = b2.trade_order_id
             where date(b1.create_time) >= '${bf_3_dt}'
               and date(b1.create_time) <= '${dt}'
               and b1.account_id >= 0
               and ifnull(b2.is_sandbox, 0) = 0    -- 剔除沙盒数据
           )    as a1
     group by 1, 2, 3
)
-- 用户信息
, user_info_tmp as (
    -- 海外短剧用户信息
    select a1.product_id
          ,a1.user_id
          ,a1.corever
          ,a1.mt2                  as mt
          ,a1.current_language
          ,a1.current_language2
          ,a1.reg_country
          ,ifnull(a2.level, 2)     as level
          ,a1.create_time
          ,a1.sex
          ,a1.third_party_id
          ,a1.pass_word
          ,a1.email
          ,a1.bind_email
      from dim.dim_short_video_user_accountinfo    as a1
      left join (select product_id
                       ,short_name
                       ,level
                   from dim.dim_countrylevel
                  where product_id = 6833
                )                                  as a2
        on a1.product_id = a2.product_id
       and a1.reg_country = a2.short_name
     union all
    -- 国内短剧用户信息
    select 6883        as product_id
          ,account     as user_id
          ,corever2    as corever
          ,mt2         as mt
          ,null        as current_language
          ,current_language2
          ,reg_country
          ,null        as level
          ,create_time
          ,sex
          ,null        as third_party_id
          ,null        as pass_word
          ,null        as email
          ,null        as bind_email
      from dim.dim_video_cn_accountinfo_view
)
-- 用户第一次安装时的剧ID
, sv_user_series_id as (
    select user_id
          ,series_id
      from (select user_id
                  ,book_id                                                           as series_id
                  ,row_number() over (partition by user_id order by install_date)    as `rank`
              from ads.ads_user_install_info_view
             where product_id = 6833
           )    as a1
     where a1.rank = 1
)
-- 关联剧编码
, sv_user_video_code as (
    select a1.user_id               as user_id
          ,a1.series_id             as series_id
          ,a2.source_series_code    as series_code
      from sv_user_series_id            as a1
      left join dim.dim_sv_series_hi    as a2
        on a1.series_id = a2.series_id
)
select a1.dt
      ,a1.product_id
      ,a1.user_id
      ,a2.corever
      ,a2.mt
      ,a2.current_language                                                    as current_language
      ,a2.currentlanguage2                                                    as currentlanguage2
      ,a2.reg_country
      ,a2.level
      ,a2.create_time
      ,datediff(a1.dt, a2.create_time)                                        as reg_days
      ,a2.sex
      ,if(a2.third_party_id in(1, 2, 3) or a2.pass_word is not null, 1, 0)    as is_acc_login
      ,if(a2.email is not null or a2.bind_email is not null, 1, 0)            as is_has_email
      ,a3.series_code
      ,now()                                                                  as etl_time
      ,a1.max_active_time
  from active_user_tmp            as a1
  left join (select b1.product_id
                   ,b1.user_id
                   ,if(b1.corever is null or b1.corever = 0, 1, b1.corever)    as corever
                   ,b1.mt
                   ,b1.current_language
                   ,case when (b1.current_language2 is null or b1.current_language2 = 0) and b1.product_id = 3311 then 6
                         when (b1.current_language2 is null or b1.current_language2 = 0) and b1.product_id = 3322 then 5
                         when (b1.current_language2 is null or b1.current_language2 = 0) and b1.product_id = 3333 then 2
                         when (b1.current_language2 is null or b1.current_language2 = 0) and b1.product_id = 3366 then 3
                         when (b1.current_language2 is null or b1.current_language2 = 0) and b1.product_id = 3371 then 7
                         when (b1.current_language2 is null or b1.current_language2 = 0) and b1.product_id = 3388 then 4
                         when (b1.current_language2 is null or b1.current_language2 = 0) and b1.product_id = 3501 then 11
                         when (b1.current_language2 is null or b1.current_language2 = 0) and b1.product_id = 3511 then 12
                         else b1.current_language2
                     end                                                       as currentlanguage2
                   ,b1.reg_country
                   ,b1.level
                   ,b1.create_time
                   ,b1.sex
                   ,b1.third_party_id
                   ,b1.pass_word
                   ,b1.email
                   ,b1.bind_email
               from user_info_tmp    as b1
            )                     as a2
    on a1.product_id = a2.product_id
   and a1.user_id = a2.user_id
  left join sv_user_video_code    as a3
    on a1.user_id = a3.user_id
;
