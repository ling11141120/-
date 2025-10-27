----------------------------------------------------------------
-- 程序功能： BI-海剧海阅移动终端Push监控
-- 程序名： P_ads_srsv_bi_mt_push_mon_dml
-- 目标表： ads.ads_srsv_bi_mt_push_mon
-- 负责人： qhr
-- 开发日期：2025-10-21
-- 版本号： v0.0.0
----------------------------------------------------------------

-- ${bf_1_dt}：固定传入T-1日期的yyyy-MM-dd 00:00:00
-- ${dt}：传入当前调度时间的yyyy-MM-dd HH:00:00
insert into tmp.ads_srsv_bi_mt_push_mon
with act_user as (
    select a1.user_id
      from dwd.dwd_user_short_video_user_login_view    as a1    -- 海剧用户登录
     where a1.dt = case when hour('${dt}') = 0 then date(date_sub('${dt}', interval 1 day)) else date('${dt}') end
       and a1.create_time >= case when hour('${dt}') = 0 then date_sub('${dt}', interval 1 day) else date_trunc('day', '${dt}') end
       and a1.create_time < '${dt}'
       and a1.user_id >= 0
       and a1.product_id = 6833
     union all
    select a2.user_id
      from dwd.dwd_trade_short_video_payorder          as a2    -- 海剧用户支付
     where a2.dt = case when hour('${dt}') = 0 then date(date_sub('${dt}', interval 1 day)) else date('${dt}') end
       and a2.create_time >= case when hour('${dt}') = 0 then date_sub('${dt}', interval 1 day) else date_trunc('day', '${dt}') end
       and a2.create_time < '${dt}'
       and a2.user_id >= 0
       and a2.product_id = 6833
       and a2.status=0
       and a2.test_flag =0
     union all
    select a3.account_id    as user_id
      from dwd.dwd_sv_consume_user_consume_bill_pdi    as a3    -- 海剧用户消耗
     where a3.dt = case when hour('${dt}') = 0 then date(date_sub('${dt}', interval 1 day)) else date('${dt}') end
       and a3.create_time >= case when hour('${dt}') = 0 then date_sub('${dt}', interval 1 day) else date_trunc('day', '${dt}') end
       and a3.create_time < '${dt}'
       and a3.account_id >= 0
     union all
    select a4.account_id    as user_id
      from dwd.dwd_video_short_video_epis_history      as a4    -- 海剧用户观看
     where a4.dt = case when hour('${dt}') = 0 then date(date_sub('${dt}', interval 1 day)) else date('${dt}') end
       and a4.create_time >= case when hour('${dt}') = 0 then date_sub('${dt}', interval 1 day) else date_trunc('day', '${dt}') end
       and a4.create_time < '${dt}'
       and a4.account_id >= 0
)
select '${dt}'                                                                                    as stat_time
      ,6833                                                                                       as product_id
      ,a1.corever                                                                                 as core
      ,a1.mt                                                                                      as mt
      ,a7.cd_val_desc                                                                             as mt_name
      ,count(a2.Id)                                                                               as svr_push_tsk_num
      ,bitmap_union(to_bitmap(cast(get_json_string(a2.Body, '$.custom.accountId') as bigint)))    as svr_push_uv
      ,sum(case when a2.IsSuccess = 1 then 1 else 0 end)                                          as svr_push_succ_tsk_num
      ,bitmap_union(to_bitmap (case when a3.login_id is not null then a1.user_id
                                    else null
                                end
                              )
                   )                                                                              as push_cli_arr_dev_num
      ,bitmap_union(to_bitmap(a4.account_id))                                                     as cli_push_uv
      ,bitmap_union(to_bitmap(a5.login_id))                                                       as cli_clk_uv
      ,bitmap_union(to_bitmap(a6.user_id))                                                        as cli_dau
      ,bitmap_union(to_bitmap(a4.active_user_id))                                                 as cli_push_act_uv
  from dim.dim_short_video_user_accountinfo                          as a1
  left join ods.ods_tidb_unifypush_log_log_pushlog_sv                as a2
    on a2.dt = case when hour('${dt}') = 0 then date(date_sub('${dt}', interval 1 day)) else date('${dt}') end
   and a2.CreateTime >= case when hour('${dt}') = 0 then date_sub('${dt}', interval 1 day) else date_trunc('day', '${dt}') end
   and a2.CreateTime < '${dt}'
   and (a2.AppId % 2 = 1 or a2.AppId % 2 = 0)
   and a1.user_id = cast(get_json_string(a2.Body, '$.custom.accountId') as bigint)
  left join ods_log.ods_sensors_cd_video_pushdelivery                as a3
    on a3.dt = case when hour('${dt}') = 0 then date(date_sub('${dt}', interval 1 day)) else date('${dt}') end
   and a3.event_tm >= case when hour('${dt}') = 0 then date_sub('${dt}', interval 1 day) else date_trunc('day', '${dt}') end
   and a3.event_tm < '${dt}'
   and a3.app_product_id = 6833
   and a1.user_id = a3.login_id
  left join ads.ads_center_push_position_message_di_analysis_json    as a4
    on a4.dt = case when hour('${dt}') = 0 then date(date_sub('${dt}', interval 1 day)) else date('${dt}') end
   and a4.need_to_send_time >= case when hour('${dt}') = 0 then date_sub('${dt}', interval 1 day) else date_trunc('day', '${dt}') end
   and a4.need_to_send_time < '${dt}'
   and (a4.send_status = 1 or a4.push_position_id in (1,2))
   and a1.user_id = a4.active_user_id
  left join ads.ads_sensors_video_pushclick_view                     as a5
    on a5.dt = case when hour('${dt}') = 0 then date(date_sub('${dt}', interval 1 day)) else date('${dt}') end
   and a5.event_tm >= case when hour('${dt}') = 0 then date_sub('${dt}', interval 1 day) else date_trunc('day', '${dt}') end
   and a5.event_tm < '${dt}'
   and a1.user_id = a5.login_id
  left join act_user                                                 as a6
    on a1.user_id = a6.user_id
  left join dim.dim_pub_code_mapping_dict                            as a7
    on a7.app_plat = 'pub'
   and a7.cd_col = 'mt'
   and a1.mt = a7.cd_val
 where coalesce(a1.mt,-99) in (1, 4)
   and a1.corever is not null
 group by 1, 2, 3, 4, 5
;