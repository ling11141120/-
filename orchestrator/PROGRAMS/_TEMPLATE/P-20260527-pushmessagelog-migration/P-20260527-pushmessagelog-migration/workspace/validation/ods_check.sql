----------------------------------------------------------------
-- 验证脚本：ODS 层数据检查
-- Program: P-20260527-pushmessagelog 迁移
-- 负责人：qhr
-- 日期：2026-05-27
-- 目的：确认 unifypush_log 数据是否正常，是否有圣经之外的数据进入
----------------------------------------------------------------

-- 1. ODS 表数据量级（按日期）
select dt
     , count(*)        as row_cnt
     , count(distinct productid) as product_cnt
  from ods.ods_tidb_unifypush_log_log_pushlog_sr
 where dt >= date_sub(curdate(), 7)
 group by dt
 order by dt desc
;


-- 2. ODS 表 product_id 分布（判断是否有圣经之外的数据）
-- 圣经 product_id: 3371
select productid  as product_id
     , count(*)   as row_cnt
     , count(distinct accountid) as user_cnt
     , min(dt)    as min_dt
     , max(dt)    as max_dt
  from ods.ods_tidb_unifypush_log_log_pushlog_sr
 where dt >= date_sub(curdate(), 7)
 group by productid
 order by productid
;


-- 3. ODS 表 is_success 分布（确认数据质量）
select productid   as product_id
     , issuccess   as is_success
     , count(*)    as row_cnt
  from ods.ods_tidb_unifypush_log_log_pushlog_sr
 where dt >= date_sub(curdate(), 7)
 group by productid, issuccess
 order by productid, issuccess
;


-- 4. ODS 关键字段非空率
select dt
     , count(*)                                              as total_rows
     , count(accountid)                                      as user_id_filled
     , count(batchid)                                        as batchid_filled
     , count(errormessage)                                   as errormessage_filled
     , round(count(accountid) / count(*) * 100, 2)           as user_id_fill_pct
     , round(count(errormessage) / count(*) * 100, 2)        as errormessage_fill_pct
  from ods.ods_tidb_unifypush_log_log_pushlog_sr
 where dt >= date_sub(curdate(), 3)
 group by dt
 order by dt desc
;


-- 5. ODS apps 表数据检查
select count(*)    as total_rows
     , count(distinct id) as app_cnt
  from ods.ods_tidb_unifypush_log_apps
;
