----------------------------------------------------------------
-- 验证脚本：DWD 层数据检查
-- Program: P-20260527-pushmessagelog 迁移
-- 负责人：qhr
-- 日期：2026-05-27
-- 目的：确认 DWD 新表 dwd_market_sr_push_msg_log_di 数据正常
-- 前提：DWD 表 DML 已在 DolphinScheduler 执行至少一次
----------------------------------------------------------------

-- 1. DWD 表数据量级（按日期）
select dt
     , count(*)               as row_cnt
     , count(distinct product_id) as product_cnt
     , count(distinct user_id)    as user_cnt
     , count(distinct batch_id)   as batch_cnt
  from dwd.dwd_market_sr_push_msg_log_di
 where dt >= date_sub(curdate(), 7)
 group by dt
 order by dt desc
;


-- 2. DWD 表 is_success 分布（确认口径：is_success=1 = 推送成功）
select dt
     , is_success
     , count(*)         as row_cnt
     , count(distinct user_id) as user_cnt
  from dwd.dwd_market_sr_push_msg_log_di
 where dt >= date_sub(curdate(), 7)
 group by dt, is_success
 order by dt desc, is_success
;


-- 3. DWD 表字段非空率检查（确认关键字段不丢数据）
select dt
     , count(*)                                            as total_rows
     , count(user_id)                                      as user_id_filled
     , count(app_id)                                       as app_id_filled
     , count(batch_id)                                     as batch_id_filled
     , count(err_msg_id)                                   as err_msg_id_filled
     , count(token)                                        as token_filled
     , count(schedule_time)                                as schedule_time_filled
     , round(count(user_id) / count(*) * 100, 2)           as user_id_pct
     , round(count(app_id) / count(*) * 100, 2)            as app_id_pct
     , round(count(batch_id) / count(*) * 100, 2)          as batch_id_pct
     , round(count(err_msg_id) / count(*) * 100, 2)        as err_msg_id_pct
  from dwd.dwd_market_sr_push_msg_log_di
 where dt >= date_sub(curdate(), 3)
 group by dt
 order by dt desc
;


-- 4. DWD vs ODS 数据量级对比（同一天）
-- 注意：DWD 用 bf_1_dt 分区，ODS 用 dt 分区，可能存在时间偏差
select a.dt
     , a.dwd_cnt
     , b.ods_cnt
     , a.dwd_cnt - b.ods_cnt          as diff
     , round((a.dwd_cnt - b.ods_cnt) / b.ods_cnt * 100, 2) as diff_pct
  from (select dt
             , count(*) as dwd_cnt
          from dwd.dwd_market_sr_push_msg_log_di
         where dt >= date_sub(curdate(), 7)
         group by dt
       ) as a
  left join (select dt
                  , count(*) as ods_cnt
               from ods.ods_tidb_unifypush_log_log_pushlog_sr
              where dt >= date_sub(curdate(), 7)
              group by dt
            ) as b
    on a.dt = b.dt
 order by a.dt desc
;


-- 5. DWD 表枚举值检查
-- app_id 分布
select app_id
     , count(*)       as row_cnt
  from dwd.dwd_market_sr_push_msg_log_di
 where dt = (select max(dt) from dwd.dwd_market_sr_push_msg_log_di)
 group by app_id
 order by row_cnt desc
;

-- mt (平台) 分布：1=iOS, 4=Android
select dt
     , mt
     , count(*)    as row_cnt
  from dwd.dwd_market_sr_push_msg_log_di
 where dt >= date_sub(curdate(), 3)
 group by dt, mt
 order by dt desc, mt
;

-- task_type 分布
select dt
     , task_type
     , count(*)       as row_cnt
  from dwd.dwd_market_sr_push_msg_log_di
 where dt >= date_sub(curdate(), 3)
 group by dt, task_type
 order by dt desc, task_type
;
