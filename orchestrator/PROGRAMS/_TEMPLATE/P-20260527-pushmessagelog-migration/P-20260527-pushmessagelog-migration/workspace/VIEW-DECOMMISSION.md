# dwd_market_log_pushmessagelog_view 下线 CHECKLIST

## 背景

旧视图 `dwd.dwd_market_log_pushmessagelog_view` 基于 `ods_log.ods_tidb_readerlog_Log_PushMessageLog`，
新链路通过 `dwd.dwd_market_sr_push_msg_log_di` 提供数据。

## 下线前置条件

- [ ] 新 DWD 表 `dwd_market_sr_push_msg_log_di` 稳定运行 >= 3 天，数据量级正常
- [ ] `ads.ads_sr_push_message_log` 稳定运行，数据无异常
- [ ] `ads.ads_bi_tag_push_result_info` 稳定运行，数据无异常
- [ ] `dws.dws_user_push_behavior_detail_df` 稳定运行，数据无异常
- [ ] 确认无其他未改造的下游任务直接引用该 view

## 确认无下游依赖的方法

在 StarRocks 中执行以下查询，确认除已知下游外无其他引用：

```sql
-- 搜索所有引用该 view 的 SQL（需在 DolphinScheduler / Git 仓库中搜索）
-- 已知下游（已改造）：
--   ads.ads_sr_push_message_log (已切换至新 DWD)
--   ads.ads_bi_tag_push_result_info (已切换至新 DWD)
--   dws.dws_user_push_behavior_detail_df (已切换至新 DWD)
```

## 下线步骤

1. 在仓库中搜索 `dwd_market_log_pushmessagelog_view` 引用，确认无遗漏
2. 删除 DDL 文件：`starrocks/dwd/ddl/dwd_market_log_pushmessagelog_view.sql`
3. 在 DolphinScheduler 中下线相关旧任务（如有）
4. 在 StarRocks 中执行：`drop view if exists dwd.dwd_market_log_pushmessagelog_view;`
5. Commit: `chore(dwd): 下线 dwd_market_log_pushmessagelog_view，已迁移至 dwd_market_sr_push_msg_log_di`

## 回滚方案

如需回滚：DolphinScheduler 中恢复旧 DML 任务 + StarRocks 中重建 view（DDL 文件在 git 历史中可恢复）。
