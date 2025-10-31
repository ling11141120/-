----------------------------------------------------------------
-- 程序功能： BI-海剧海阅移动终端客户端Push监控
-- 程序名： P_ads_srsv_bi_mt_cli_push_mon
-- 目标表： ads.ads_srsv_bi_mt_cli_push_mon
-- 负责人： qhr
-- 开发日期：2025-10-21
-- 版本号： v0.0.0
----------------------------------------------------------------

-- ${dt}：传入当前调度时间的yyyy-MM-dd HH:00:00
insert into tmp.ads_srsv_bi_mt_cli_push_mon
with act_user as (
    select date_trunc('hour', '${dt}')                         as stat_time
          ,6833                                                as product_id
          ,a2.corever                                          as core
          ,a2.mt                                               as mt
          ,bitmap_union(to_bitmap(a1.user_id))                 as cli_dau
      from (select b1.user_id
              from dwd.dwd_user_short_video_user_login_view    as b1    -- 海剧用户登录
             where b1.dt = case when hour('${dt}') = 0 then date(date_sub('${dt}', interval 1 day)) else date('${dt}') end
               and b1.create_time >= case when hour('${dt}') = 0 then date_sub('${dt}', interval 1 day) else date_trunc('day', '${dt}') end
               and b1.create_time < '${dt}'
               and b1.user_id >= 0
               and b1.product_id = 6833
             union all
            select b2.user_id
              from dwd.dwd_trade_short_video_payorder          as b2    -- 海剧用户支付
             where b2.dt = case when hour('${dt}') = 0 then date(date_sub('${dt}', interval 1 day)) else date('${dt}') end
               and b2.create_time >= case when hour('${dt}') = 0 then date_sub('${dt}', interval 1 day) else date_trunc('day', '${dt}') end
               and b2.create_time < '${dt}'
               and b2.user_id >= 0
               and b2.product_id = 6833
               and b2.status=0
               and b2.test_flag =0
             union all
            select b3.account_id    as user_id
              from dwd.dwd_sv_consume_user_consume_bill_pdi    as b3    -- 海剧用户消耗
             where b3.dt = case when hour('${dt}') = 0 then date(date_sub('${dt}', interval 1 day)) else date('${dt}') end
               and b3.create_time >= case when hour('${dt}') = 0 then date_sub('${dt}', interval 1 day) else date_trunc('day', '${dt}') end
               and b3.create_time < '${dt}'
               and b3.account_id >= 0
             union all
            select b4.account_id    as user_id
              from dwd.dwd_video_short_video_epis_history      as b4    -- 海剧用户观看
             where b4.dt = case when hour('${dt}') = 0 then date(date_sub('${dt}', interval 1 day)) else date('${dt}') end
               and b4.create_time >= case when hour('${dt}') = 0 then date_sub('${dt}', interval 1 day) else date_trunc('day', '${dt}') end
               and b4.create_time < '${dt}'
               and b4.account_id >= 0
           )                                                   as a1
      join dim.dim_short_video_user_accountinfo                as a2
        on a1.user_id = a2.user_id
       and coalesce(a2.mt,-99) in (1, 4)
       and a2.corever is not null
     group by 1, 2, 3, 4
)
, cli_push_dev_arr as (
    select date_trunc('hour', '${dt}')                  as stat_time
          ,6833                                         as product_id
          ,a2.corever                                   as core
          ,a2.mt                                        as mt
          ,bitmap_union(to_bitmap(a1.login_id))         as push_cli_arr_dev_num
      from ods_log.ods_sensors_cd_video_pushdelivery    as a1
      join dim.dim_short_video_user_accountinfo         as a2
        on a1.login_id = a2.user_id
       and coalesce(a2.mt,-99) in (1, 4)
       and a2.corever is not null
     where a1.dt = case when hour('${dt}') = 0 then date(date_sub('${dt}', interval 1 day)) else date('${dt}') end
       and a1.event_tm >= case when hour('${dt}') = 0 then date_sub('${dt}', interval 1 day) else date_trunc('day', '${dt}') end
       and a1.event_tm < '${dt}'
       and a1.app_product_id = 6833
     group by 1, 2, 3, 4
)
, cli_push_uv as (
    select date_trunc('hour', '${dt}')                                      as stat_time
          ,6833                                                             as product_id
          ,a1.core                                                          as core
          ,a1.mt                                                            as mt
          ,bitmap_union(to_bitmap(a1.account_id))                           as cli_push_uv
          ,bitmap_union(to_bitmap(a1.active_user_id))                       as cli_push_act_uv
      from (select date_trunc('hour', '${dt}')                              as stat_time
                  ,b2.corever                                               as core
                  ,b2.mt                                                    as mt
                  ,b1.account_id                                            as account_id
                  ,b1.active_user_id                                        as active_user_id
              from ads.ads_center_push_position_message_di_analysis_json    as b1
              join dim.dim_short_video_user_accountinfo                     as b2
                on b1.account_id = b2.user_id
               and coalesce(b2.mt,-99) in (1, 4)
               and b2.corever is not null
             where b1.dt = case when hour('${dt}') = 0 then date(date_sub('${dt}', interval 1 day)) else date('${dt}') end
               and b1.need_to_send_time >= case when hour('${dt}') = 0 then date_sub('${dt}', interval 1 day) else date_trunc('day', '${dt}') end
               and b1.need_to_send_time < '${dt}'
               and (b1.send_status = 1 or b1.push_position_id in (1,2))
             union all
            select date_trunc('hour', '${dt}')                              as stat_time
                  ,cast(substr(b3.app_id,-4,1) as int)                      as corever
                  ,case when b3.os = 'Android' then 4 else 1 end            as mt
                  ,b3.login_id                                              as account_id
                  ,b3.login_id                                              as active_user_id
             from ads.ads_sensors_cd_video_ElmentExposure_view              as b3
             where b3.dt = case when hour('${dt}') = 0 then date(date_sub('${dt}', interval 1 day)) else date('${dt}') end
               and b3.event_tm >= case when hour('${dt}') = 0 then date_sub('${dt}', interval 1 day) else date_trunc('day', '${dt}') end
               and b3.event_tm < '${dt}'
               and (    (b3.element_id = 210015 and b3.project_id = 8)
                     or (b3.element_id = 210012 and b3.os = 'iOS')
                     or (b3.element_id = 210032 and b3.os = 'Android')
                   )
           )                                                                as a1
     group by 1, 2, 3, 4
)
, cli_clk_uv as (
    select date_trunc('hour', '${dt}')             as stat_time
          ,6833                                    as product_id
          ,a2.corever                              as core
          ,a2.mt                                   as mt
          ,bitmap_union(to_bitmap(a1.login_id))    as cli_clk_uv
      from ads.ads_sensors_video_pushclick_view    as a1
      join dim.dim_short_video_user_accountinfo    as a2
        on a1.login_id = a2.user_id
       and coalesce(a2.mt,-99) in (1, 4)
       and a2.corever is not null
     where a1.dt = case when hour('${dt}') = 0 then date(date_sub('${dt}', interval 1 day)) else date('${dt}') end
       and a1.event_tm >= case when hour('${dt}') = 0 then date_sub('${dt}', interval 1 day) else date_trunc('day', '${dt}') end
       and a1.event_tm < '${dt}'
     group by 1, 2, 3, 4
)
select a1.stat_time                as stat_time               -- 统计时间
      ,a1.product_id               as product_id              -- product_id
      ,a1.core                     as core                    -- core
      ,a1.mt                       as mt                      -- 移动终端
      ,a5.cd_val_desc              as mt_name                 -- 移动终端名称
      ,a2.push_cli_arr_dev_num     as push_cli_arr_dev_num    -- 下发到达客户端设备数
      ,a3.cli_push_uv              as cli_push_uv             -- 客户端下发UV
      ,a4.cli_clk_uv               as cli_clk_uv              -- 客户端点击UV
      ,a1.cli_dau                  as cli_dau                 -- 客户端dau
      ,a3.cli_push_act_uv          as cli_push_act_uv         -- 客户端下发活跃UV
  from act_user                              as a1
  left join cli_push_dev_arr                 as a2
    on a1.stat_time = a2.stat_time
   and a1.product_id = a2.product_id
   and a1.core = a2.core
   and a1.mt = a2.mt
  left join cli_push_uv                      as a3
    on a1.stat_time = a3.stat_time
   and a1.product_id = a3.product_id
   and a1.core = a3.core
   and a1.mt = a3.mt
  left join cli_clk_uv                       as a4
    on a1.stat_time = a4.stat_time
   and a1.product_id = a4.product_id
   and a1.core = a4.core
   and a1.mt = a4.mt
  left join dim.dim_pub_code_mapping_dict    as a5
    on a5.app_plat = 'pub'
   and a5.cd_col = 'mt'
   and a1.mt = a5.cd_val
;