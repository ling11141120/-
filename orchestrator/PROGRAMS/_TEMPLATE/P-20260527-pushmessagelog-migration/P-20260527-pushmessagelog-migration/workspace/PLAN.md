# Plan — pushmessagelog 迁移

## 1. 问题陈述

将 pushmessagelog 从旧 ODS 链路迁移到新 ODS 链路（SeaTunnel 同步），新增 DWD 清洗表，适配下游 ADS/DWS 表字段和口径变更。

| 属性 | 值 |
|------|----|
| Program 类型 | development |
| 分析子类型 | — |

## 2. 表分析

### 2.1 目标表

| 属性 | 值 |
|------|----|
| 分层 | dwd |
| 表名 | dwd.dwd_market_sr_push_msg_log_di |
| 操作类型 | 新建 |
| 粒度 | 日 di |
| 业务域 | 营销域 |

### 2.2 上游依赖

| 上游表 | 用途 | 是否有 DDL 可参考 |
|--------|------|-------------------|
| ods.ods_tidb_unifypush_log_log_pushlog_sr | 主数据源 | 是 |
| ods.ods_tidb_unifypush_log_apps | 获取 MT（平台） | 是 |

### 2.3 下游影响

| 下游表 | 影响方式 | 风险等级 |
|--------|----------|----------|
| ads.ads_sr_push_message_log | DML 底表切换 + 字段映射变更 | 中 |
| ads.ads_bi_tag_push_result_info | DML 底表切换 + 字段/口径变更 | 中 |
| dws.dws_user_push_behavior_detail_df | DML 底表切换 + 字段/口径变更 | 中 |
| ads.ads_user_push_behavior_df | 间接影响（依赖 DWS） | 低 |

## 3. 字段变更

### 新增字段（DWD 新表）

| 字段名 | 类型 | 来源表/计算逻辑 | 备注 |
|--------|------|----------------|------|
| dt | date | `${bf_1_dt}` | 分区日期 |
| product_id | int | ods.ProductId | |
| id | bigint | ods.Id | |
| create_time | datetime | ods.CreateTime | |
| user_id | bigint | ods.AccountId | |
| app_id | varchar(255) | ods.AppId | 替代旧 ProdId |
| mt | int | apps.MT | 关联 apps 表 |
| title | string | JSON 解析 Body | |
| token_id | bigint | ods.DeviceId | |
| token | string | ods.Token | |
| body | string | ods.Body | |
| customers | string | ods.CustomData | |
| batch_id | bigint | ods.BatchId | |
| is_success | int | ods.IsSuccess | 替代旧 PushResponse |
| push_type | int | JSON 解析 CustomData | |
| push_id | bigint | coalesce(Body.aps.attributes.pushId, CustomData.push_id) | 两个来源互补覆盖 |
| schedule_time | datetime | ods.ScheduleTime | 替代旧 PushTime |
| err_msg_id | string | ods.ErrorMessage | 替代旧 MessageId |
| task_type | int | JSON 解析 CustomData | |
| image_url | string | JSON 解析 Body | |
| etl_time | datetime | now() | |

### 口径变更

| 字段名 | 旧口径 | 新口径 | 变更原因 |
|--------|--------|--------|----------|
| app_id | 旧表 ProdId | 新表 AppId | 字段重命名 |
| is_success | 旧表 PushResponse | 新表 IsSuccess | 语义更清晰 |
| schedule_time | 旧表 PushTime | 新表 ScheduleTime | 字段重命名 |
| err_msg_id | 旧表 MessageId | 新表 ErrorMessage | 与 bigquerylog 的 message_id 区分 |
| 推送成功过滤 | State = 3 | is_success = 1 | 新表无 State 字段 |

## 4. 技术要点

### 关键设计决策

- DWD 表直接来源 ODS，不做复杂清洗，保持与原 ODS 视图结构对齐
- 删除字段（State/Param/UpdateTime/TokenType/IsSilent）在 DWD 层直接丢弃
- 下游 DML 改造采用最小变更原则：只改底表引用和必要字段映射，不改 CTE 结构
- 不回刷历史数据，从上线日开始跑增量

### Join 逻辑

- DWD: ods.ods_tidb_unifypush_log_log_pushlog_sr LEFT JOIN ods.ods_tidb_unifypush_log_apps ON AppId = Id
- ads_sr_push_message_log: DWD LEFT JOIN dws_user_wide_active_period_ed ON dt + user_id（获取 active_user_id）
- dws_user_push_behavior_detail_df: push_send_result 通过 err_msg_id + instance_id + product_id 关联 bigquerylog

### 数据质量措施

- user_id IS NOT NULL 过滤（dws_user_push_behavior_detail_df send_view）
- batch_id IS NOT NULL 过滤
- product_id NOT IN (6833, 6883) 排除短剧产品（海阅推送专用）

## 5. 回刷评估

| 项目 | 说明 |
|------|------|
| 是否需要回刷 | 否 |
| 回刷范围 | — |
| 风险提示 | 上线日之前的历史数据不可追溯，下游回溯窗口（bf_15_dt）内无旧数据时可能出现空白 |

## 6. 验证计划

### 验证分层

```
ODS 数据验证 → DWD 数据验证 → 下游表数据验证 → 调度配置验证
```

### 验证 SQL 清单

| 序号 | 验证目标 | 脚本路径 |
|------|----------|----------|
| 1 | ODS 层：确认 unifypush_log 有数据、product_id 分布 | `workspace/validation/ods_check.sql` |
| 2 | DWD 层：新表数据量级、is_success 分布、字段非空率 | `workspace/validation/dwd_check.sql` |
| 3 | 下游层：ADS/DWS 表新旧数据对比、量级检查 | `workspace/validation/downstream_check.sql` |
