# RESULT — pushmessagelog 迁移（截至 2026-05-27）

## 当前状态

代码改造已全部完成并 Review 通过，待上线验证。当前阻塞在 **ODS 层数据验证**（需用户在 StarRocks 执行验证 SQL）。

## 已完成

### 1. 代码改造 Review ✅

逐文件比对迁移方案与仓库代码，5 个文件的改造全部完成且正确：

| 文件 | 改造状态 | 关键确认 |
|------|----------|----------|
| `dwd/ddl/dwd_market_sr_push_msg_log_di.sql` | ✅ | 字段完整，删除 5 个旧字段，4 个字段重命名正确 |
| `dwd/dml/P_dwd_market_sr_push_msg_log_di.sql` | ✅ | 来源表正确，JSON 解析逻辑正确 |
| `ads/dml/P_ads_sr_push_message_log.sql` | ✅ | 底表切换，删除字段置 null，字段映射正确 |
| `ads/dml/P_ads_bi_tag_push_result_info.sql` | ✅ | tmp_a 底表/过滤条件全部适配，sd 计数简化 |
| `dws/dml/P_dws_user_push_behavior_detail_df.sql` | ✅ | send_view + push_send_result 适配完成 |

### 2. Program 文件

| 文件 | 路径 |
|------|------|
| PROGRAM.md | `orchestrator/PROGRAMS/P-20260527-pushmessagelog-migration/PROGRAM.md` |
| SCOPE.yml | `orchestrator/PROGRAMS/P-20260527-pushmessagelog-migration/SCOPE.yml` |
| STATUS.yml | `orchestrator/PROGRAMS/P-20260527-pushmessagelog-migration/STATUS.yml` |
| PLAN.md | `orchestrator/PROGRAMS/P-20260527-pushmessagelog-migration/workspace/PLAN.md` |

### 3. 验证 SQL

| 验证阶段 | 路径 |
|----------|------|
| ODS 数据验证 | `workspace/validation/ods_check.sql` |
| DWD 数据验证 | `workspace/validation/dwd_check.sql` |
| 下游表验证 | `workspace/validation/downstream_check.sql` |

### 4. View 下线 CHECKLIST

`workspace/VIEW-DECOMMISSION.md` — 下线条件和步骤

## 待完成（按顺序）

### 第一步：ODS 数据验证（当前阻塞）

由你在 StarRocks 执行 `workspace/validation/ods_check.sql`，反馈结果。核心关注：
- `ods.ods_tidb_unifypush_log_log_pushlog_sr` 是否有数据？
- product_id 分布：是否有 3371（圣经）之外的产品？

### 第二步：DolphinScheduler 配置 & DWD 上线

1. 在 DolphinScheduler 创建 `P_dwd_market_sr_push_msg_log_di` 任务
   - 调度频率：每天 00:20、17:20（与 P_ads_bi_tag_push_result_info 一致）
   - DML 中 `${bf_1_dt}` 由调度系统自动传入
2. 执行首跑，确认 DWD 表有数据
3. 执行 `workspace/validation/dwd_check.sql` 验证

### 第三步：下游表上线

1. 更新 DolphinScheduler 中以下任务的 DML 引用：
   - P_ads_sr_push_message_log（调度不变，每天 12:00）
   - P_ads_bi_tag_push_result_info（调度不变，每天 00:20、17:20）
   - P_dws_user_push_behavior_detail_df（调度不变，每天 3:00）
2. 执行首跑后，执行 `workspace/validation/downstream_check.sql` 验证

### 第四步：稳定观察 & 下线旧 view

新链路稳定运行 3-7 天后，按 `workspace/VIEW-DECOMMISSION.md` 执行 view 下线。

### 第五步：代码提交 & MR

全部验证通过后，git commit + push，创建 MR 合入 master。（注意：不涉及 git worktree，因为附件方案中说代码改造已完成，待上线。如需新建分支，从 master 拉取。）

## 关键决策记录

- 不回刷历史数据，从上线日开始跑增量
- 上线时机：等用户确认 ODS 有圣经之外的数据后上线
- 验证方式：用户手动执行 SQL，反馈结果给 AI
- dwd_market_log_pushmessagelog_view 待新链路稳定后下线
