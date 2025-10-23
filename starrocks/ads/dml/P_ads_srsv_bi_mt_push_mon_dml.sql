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
insert into ads.ads_srsv_bi_mt_push_mon
-- 服务端下发信息
with svr_push_info as (
    select '${dt}'                                                                    as stat_time
          ,6833                                                                       as product_id
          ,a2.corever2                                                                as core
          ,case when a1.AppId % 2 = 1 then 1
                else 4
            end                                                                       as mt
          ,count(1)                                                                   as svr_push_tsk_num
          ,bitmap_union(to_bitmap(get_json_string(a1.Body, '$.custom.accountId')))    as svr_push_uv
          ,sum(case when a1.IsSuccess = 1 then 1 else 0 end)                          as svr_push_succ_tsk_num
      from ods.ods_tidb_unifypush_log_log_pushlog_sv                                  as a1
      join dim.dim_short_video_user_accountinfo                                       as a2
        on bitmap_union(to_bitmap(get_json_string(a1.Body, '$.custom.accountId'))) = a2.user_id
     where a1.dt = case when hour('${dt}') = 0 then date('${bf_1_dt}') else date('${dt}') end
       and a1.create_time >= case when hour('${dt}') = 0 then '${bf_1_dt}' else '${dt}' end
       and a1.create_time < '${dt}'
       and (a1.AppId % 2 = 1 or a1.AppId % 2 = 0)
       and get_json_string(get_json_string(a1.Body, '$.Data.custom'), '$.accountId') is not null
     group by 1, 2, 3, 4
)
-- 客户端到达信息
, cli_arr_dev_info as (
    select '${dt}'                                           as stat_time
          ,a1.app_product_id                                 as product_id
          ,a2.corever2                                       as core
          ,a3.cd_val                                         as mt
          ,bitmap_union(to_bitmap(a2.unique_cdreader_id))    as push_cli_arr_dev_num
      from ods_log.ods_sensors_cd_video_pushdelivery         as a1
      join dim.dim_short_video_user_accountinfo              as a2
        on a1.login_id = a2.user_id
      join dim.dim_pub_code_mapping_dict                     as a3
        on a3.app_plat = 'pub'
       and a3.cd_col = 'mt'
       and lower(a1.os) = lower(a3.cd_val_desc)
     where a1.dt = case when hour('${dt}') = 0 then date('${bf_1_dt}') else date('${dt}') end
       and a1.event_tm >= case when hour('${dt}') = 0 then '${bf_1_dt}' else '${dt}' end
       and a1.event_tm < '${dt}'
       and a1.app_product_id = 6833
     group by 1, 2, 3, 4
)
, cli_push_info as (
    select '${dt}'                                                  as stat_time
          ,6833                                                     as product_id
          ,a1.corever                                               as core
          ,a1.mt                                                    as mt
          ,bitmap_union(to_bitmap(a1.active_user_id))               as cli_push_uv
      from ads.ads_center_push_position_message_di_analysis_json    as a1
     where a1.dt = case when hour('${dt}') = 0 then date('${bf_1_dt}') else date('${dt}') end
       and a1.need_to_send_time >= case when hour('${dt}') = 0 then '${bf_1_dt}' else '${dt}' end
       and a1.need_to_send_time < '${dt}'
       and (a1.send_status = 1 or a1.push_position_id in (1,2))
       and coalesce(a1.mt,-99) in (1, 2)
)