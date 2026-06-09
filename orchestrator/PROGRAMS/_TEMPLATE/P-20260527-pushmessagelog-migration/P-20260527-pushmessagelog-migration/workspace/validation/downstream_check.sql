----------------------------------------------------------------
-- 验证脚本：下游 ADS/DWS 表数据检查
-- Program: P-20260527-pushmessagelog 迁移
-- 负责人：qhr
-- 日期：2026-05-27
-- 目的：确认下游表改造后数据正确
-- 前提：DWD 表已上线至少一天，下游 DML 已在 DolphinScheduler 执行
--
-- 注意：新链路数据与旧链路数据口径不同，以下对比仅作参考，
--      重点看数据量级是否在合理范围内（不应为零或异常暴涨）。
----------------------------------------------------------------


-- ============================================================
-- 1. ads_sr_push_message_log 数据检查
-- ============================================================

-- 1.1 数据量级（按日期）
select dt
     , count(*)               as row_cnt
     , count(distinct user_id)    as user_cnt
     , count(distinct batch_id)   as batch_cnt
  from ads.ads_sr_push_message_log
 where dt >= date_sub(curdate(), 7)
 group by dt
 order by dt desc
;


-- 1.2 删除字段确认（应为全 null）
select dt
     , count(*)                                             as total_rows
     , sum(case when param is null then 1 else 0 end)       as param_null_cnt
     , sum(case when state is null then 1 else 0 end)       as state_null_cnt
     , sum(case when update_time is null then 1 else 0 end) as update_time_null_cnt
     , sum(case when token_type is null then 1 else 0 end)  as token_type_null_cnt
     , sum(case when is_silent is null then 1 else 0 end)   as is_silent_null_cnt
  from ads.ads_sr_push_message_log
 where dt = (select max(dt) from ads.ads_sr_push_message_log)
 group by dt
;


-- 1.3 字段映射确认（应均为非 null，说明映射成功）
select dt
     , count(*)                                              as total_rows
     , sum(case when push_response is not null then 1 else 0 end) as push_response_filled
     , sum(case when push_time is not null then 1 else 0 end)     as push_time_filled
     , sum(case when message_id is not null then 1 else 0 end)    as message_id_filled
     , sum(case when prod_id is not null then 1 else 0 end)       as prod_id_filled
  from ads.ads_sr_push_message_log
 where dt = (select max(dt) from ads.ads_sr_push_message_log)
 group by dt
;


-- ============================================================
-- 2. ads_bi_tag_push_result_info 数据检查
-- ============================================================

-- 2.1 数据量级（按日期）
select dt
     , count(*)               as row_cnt
     , count(distinct push_id)    as push_cnt
     , sum(actual_push_unt)       as total_actual_push
     , sum(send_unt)              as total_send
  from ads.ads_bi_tag_push_result_info
 where dt >= date_sub(curdate(), 7)
 group by dt
 order by dt desc
;


-- 2.2 检查 actual_push_unt 和 send_unt 是否 > 0
-- （如果全为 0，可能底表没有 is_success=1 的数据）
select dt
     , sum(case when actual_push_unt > 0 then 1 else 0 end) as push_with_data
     , sum(case when send_unt > 0 then 1 else 0 end)        as send_with_data
     , count(*)                                              as total_records
  from ads.ads_bi_tag_push_result_info
 where dt >= date_sub(curdate(), 7)
 group by dt
 order by dt desc
;


-- ============================================================
-- 3. dws_user_push_behavior_detail_df 数据检查
-- ============================================================

-- 3.1 数据量级（按事件类型和日期）
select dt
     , event
     , count(*)                    as row_cnt
     , count(distinct user_id)     as user_cnt
     , count(distinct push_id)     as push_cnt
  from dws.dws_user_push_behavior_detail_df
 where dt >= date_sub(curdate(), 7)
   and product_id not in (6833, 6883)  -- 只看海阅数据
 group by dt, event
 order by dt desc, event
;


-- 3.2 海阅部分「下发」事件量级（应与 DWD is_success=1 量级接近）
select a.dt
     , a.dwd_push_cnt
     , b.dws_send_cnt
     , a.dwd_push_cnt - b.dws_send_cnt as diff
  from (select dt
             , count(distinct user_id) as dwd_push_cnt
          from dwd.dwd_market_sr_push_msg_log_di
         where is_success = 1
           and product_id not in (6833, 6883)
           and dt >= date_sub(curdate(), 7)
         group by dt
       ) as a
  left join (select dt
                  , count(distinct user_id) as dws_send_cnt
               from dws.dws_user_push_behavior_detail_df
              where event = '下发'
                and product_id not in (6833, 6883)
                and dt >= date_sub(curdate(), 7)
              group by dt
            ) as b
    on a.dt = b.dt
 order by a.dt desc
;


-- 3.3 检查是否有 product_id 为 null 或异常值
select dt
     , product_id
     , count(*)    as row_cnt
  from dws.dws_user_push_behavior_detail_df
 where dt = (select max(dt) from dws.dws_user_push_behavior_detail_df)
   and product_id not in (6833, 6883)
 group by dt, product_id
 order by row_cnt desc
 limit 20
;
