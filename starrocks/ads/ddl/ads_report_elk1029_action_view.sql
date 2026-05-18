-- ============================================================
-- 已废弃（2026-05-15）
-- 原因: 无人使用，且直接扫描 ods_readerlog_xx_log_commonactionlog 全量日志
-- 治理: P-20260515-存储治理，减少 ODS 日志表不必要的下游消费者
-- 注意: 仅添加废弃标记，未删除原代码文件
-- ============================================================
create view `ads_report_elk1029_action_view` (
    `dt`, `product_id`, `action`, `F3`, `f4`, `f5`, `imei`, `user_id`, `mt`, `corever`, `counts`
)
as
select `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`dt`
, `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`productid`              as `product_id`
, `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`action`
, `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`F3`
, `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`f4`
, `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`f5`
, `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`S4`                     as `imei`
, `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`userid`                 as `user_id`
, `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`mt`
, substring(`ods_log`.`ods_readerlog_xx_log_commonactionlog`.`appid`, 6, 1) as `corever`
, count(1)                                                                  as `counts`
from `ods_log`.`ods_readerlog_xx_log_commonactionlog`
where (`ods_log`.`ods_readerlog_xx_log_commonactionlog`.`action` in ('ELK1029', '1029')) and (
    `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`productid` in (3311, 3322, 3333, 3366, 3371, 3388, 3501, 3511))
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
;