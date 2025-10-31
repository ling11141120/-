----------------------------------------------------------------
-- 程序功能： BI-海剧海阅移动终端服务端Push监控
-- 程序名： P_ads_srsv_bi_mt_svr_push_mon
-- 目标表： ads.ads_srsv_bi_mt_svr_push_mon
-- 负责人： qhr
-- 开发日期：2025-10-21
-- 版本号： v0.0.0
----------------------------------------------------------------

-- ${dt}：传入当前调度时间的yyyy-MM-dd HH:00:00
insert into tmp.ads_srsv_bi_mt_svr_push_mon
select date_trunc('hour', '${dt}')                          as stat_time                -- 统计时间
      ,6833                                                 as product_id               -- product_id
      ,case when a1.AppId % 2 = 1 then 1 else 4 end         as mt                       -- 移动终端
      ,a2.cd_val_desc                                       as mt_name                  -- 移动终端名称
      ,count(a1.Id)                                         as svr_push_tsk_num         -- 服务端下发任务数
      ,bitmap_union(to_bitmap(case when coalesce(a1.AccountId,0) = 0 then
                                        case when a1.AppId % 2 = 0 then cast(get_json_string(get_json_string(a1.Body, '$.Data.custom'), '$.accountId') as bigint)
                                             else cast(get_json_string(a1.Body, '$.custom.accountId') as bigint)
                                         end
                                   else a1.AccountId
                              end
                             )
                   )                                        as svr_push_uv              -- 服务端下发UV
      ,sum(case when a1.IsSuccess = 1 then 1 else 0 end)    as svr_push_succ_tsk_num    -- 服务端下发成功任务数
  from ods.ods_tidb_unifypush_log_log_pushlog_sv            as a1
  left join dim.dim_pub_code_mapping_dict                   as a2
    on a2.app_plat = 'pub'
   and a2.cd_col = 'mt'
   and case when a1.AppId % 2 = 1 then 1 else 4 end = a2.cd_val
 where a1.dt = case when hour('${dt}') = 0 then date(date_sub('${dt}', interval 1 day)) else date('${dt}') end
   and a1.CreateTime >= case when hour('${dt}') = 0 then date_sub('${dt}', interval 1 day) else date_trunc('day', '${dt}') end
   and a1.CreateTime < '${dt}'
   and a1.AppId % 2 in (1, 0)
 group by 1, 2, 3, 4
