# 变更日志 (Changelog)

> 本文件记录所有需求的 AI/人工开发占比。
> 每个 `## {分支名}` section 对应一个需求分支的完整开发记录。
> 格式规范详见 `orchestrator/ALWAYS/CHANGELOG-SPEC.md`。

---
## dev+qhr+RTM-20262+productid语言rule映射 | 负责人: qhr | 周期: 2026-05-13 ~ 2026-05-13

### 2026-05-13
- [人工] 向服务端确认productid与language等信息的映射关系，编辑Excel文件
- [AI] 扫描 Excel 配置表结构，生成 dim_rule_productid_lang_mapping 建表 DDL
- [人工] 确认字段命名、排序键设计、rule 域归属及 Plan 方案
- [AI] 编写 DML INSERT INTO ... VALUES 脚本，转换 30 行 Excel 数据
- [AI] 更新 RESOURCE-MAP.yml 新增 rule 域定义
- [人工] 确认编码格式和行尾规范

---
## dev+qhr+RTM-20262+sql-codeformat优化 | 负责人: qhr | 周期: 2026-05-18 ~ 2026-05-19

### 2026-05-18
- [AI] 扫描 correct_format.sql 提取 13 项格式规则，写入 workspace/format-rules.md
- [人工] 确认格式规则设计决策：select 首表达式同行、前置逗号缩进规则、as 垂直对齐策略、反引号智能处理策略、文件头自动生成策略、case when 格式规则
- [AI] 重写 format_starrocks_insert_select.py（970 行），实现 tokenizer → normalizer → parser → formatter 完整流水线，覆盖 CTE/子查询/join 链/条件/select 列表 as 对齐/case-when 多行格式化/运算符空格标准化/反引号智能处理/文件头检测与生成
- [AI] 重写 dml-format-rules.md 参考文档，13 个章节覆盖文件头、整体结构、select 列表、case when、from/join/子查询、where/group/order、union all、反引号、关键字函数、运算符空格、多段 insert、行结束、保守策略，所有示例与脚本输出一致

### 2026-05-19
- [AI] 执行单文件验证（P_ads_qa_srsv_recharge_monitoring_info_hi.sql），输出 112 行与 correct_format.sql 一致，标注 3 处 correct_format 自身不一致项（now() as etl_time 不参与 as 对齐、单行 case when 不拆分、括号列不对齐）
- [AI] 执行批量验证，3 个不同复杂度 DML 文件（simple: P_dim_sv_series_hi.sql 61 行 / medium: P_dwd_advertisement_admob_income.sql 99 行 / complex: P_dws_user_wide_active_period_ed.sql 218 行）均通过，验证项含文件头不重复、select 缩进、as 对齐、子查询 alias、union all 格式
- [人工] 审核验证结果，确认 3 处差异为 correct_format 自身不一致，脚本行为符合统一规则
- [AI] 更新项目级 sql-codeformat SKILL.md，含 --function/--owner 参数说明和完整格式化规则列表
- [AI] 同步更新系统级 sql-codeformat skill（Cowork save_skill）
- [AI] 新增 format_finebi.py 格式化脚本（554 行），复用 DML 格式化器核心模块（tokenizer/normalizer/parser/formatter），新增 FineBIBodyParser 修复 parse_ctes 逗号检测和 parse_conditions where 关键字终止，实现 CTE 注释提取与标准化（---xxx → -- xxx）、隐式别名 as 自动补全、between...and 条件合并、FineBI 文件头生成
- [AI] 执行单文件验证（raw/original.sql 对比 raw/correct-format.sql），核心格式一致（文件头、6 个 CTE 全部识别、注释标准化、缩进、别名 as、between 合并）
- [AI] 执行批量验证，Application/FineBI/海剧/ 下 4 个不同复杂度文件（广告基建策略、海剧用户留存、模板&剧维度基建上限、收入）均通过
- [AI] 更新 SKILL.md 添加 FineBI 格式化器章节（触发条件、命令行参数、格式化规则）


### 2026-05-20
- [AI] 重构 format_finebi.py 架??新增预提取-占位-格式化-回填流水线（extract_finebi_vars / extract_cast_exprs / restore_finebi_vars / restore_cast_exprs）??决 ${...} 模板表达式和 cast(... as ...) 破坏 SQL 解析的核心问题
- [AI] 实现单引号别名 -> 反引号转换（s ''别名'' -> s `别名`，支持显式 s 写法和隐式别名写法）
- [AI] 实现 ${...} 内部换行展平（restore 阶段将 \n 替换为空格）
- [AI] 修复 _insert_implicit_as_in_expr 中 has_as 检测的 off-by-one 错误


---
## dev+xjc+P-2026-001-push-program-optimization+push程序优化 | 负责人: xjc | 周期: 2026-05-20 ~ 2026-06-09

### 2026-05-20
- [AI] 创建 Program 编排文档，补充 PROGRAM.md / SCOPE.yml / STATUS.yml / PLAN.md。
- [AI] 优化 `P_dws_user_push_behavior_detail_df.sql`，将短剧资源位来源从 ADS 视图切换为 DWD 清洗视图。
- [AI] 补充 live 通知场景下 `push_type` 为空时的业务兜底口径，输出 `live通知`。
- [AI] 完成静态检查，确认旧 ADS 资源位视图引用已清理，目标 DWS 程序格式检查通过。

---
## dev+xjc+P-2026-001-subscribe-mode-recharge-gear+充值档位表新增订阅方式维度 | 负责人: xjc | 周期: 2026-05-25 ~ 2026-06-09

### 2026-05-25
- [人工] 确认海阅、海剧充值档位表新增 `subscribe_mode` 维度，用于区分订阅方式和分期支付口径。
- [AI] 修改海阅 DWD 订单链路，从 `SensorsData` 解析 `subscribe_mode` 并透传到 ADS 充值档位表。
- [AI] 修改海剧 ADS 充值档位表，基于 `mt` 与 `cooorder_extinfo` 判断分期支付，新增 `subscribe_mode` 聚合维度。
- [AI] 同步调整相关 DDL/DML 字段位置和输出列，完成静态字段数核对、`git diff --check` 和海剧 ADS DDL formatter 校验。
- [人工] StarRocks 实库单日任务或样例 SQL 验证待补充。

---
## dev+xjc+P-2026-001-tt-payorder-reconcile+海剧TT支付订单口径修复与对账排查 | 负责人: xjc | 周期: 2026-06-12 ~ 2026-06-12

### 2026-06-12
- [人工] 确认财务关注 BI 与 TT 账单差异，需要拆分收入、退款、沙盒订单和订阅分摊口径。
- [AI] 将 `dwd.dwd_sv_tt_payorder_info` 订单和退款事件扫描窗口统一调整为基于 `${dt}` 的近 6 个自然月。
- [AI] 验证订阅订单商品匹配完整性，确认支付成功订阅订单与商品匹配订单数量一致，无商品未匹配导致的订单丢失。
- [AI] 解释交易月口径与结算分摊月口径差异，验证本月创建本月确认金额加历史订单本月确认金额可闭合到本月结算分摊金额。
- [AI] 新增 TT 支付相关 DWD/DIM 清洗视图，替换 `P_dwd_sv_tt_payorder_info.sql` 中对 ODS 源表的直接引用。
- [AI] 排查 Spark 推送任务失败原因，确认过滤参数应传不带 `where` 的表达式，并沉淀 DolphinScheduler 月份参数使用注意事项。
- [AI] 调整 `P_dwd_sv_tt_payorder_info.sql` 表别名规则与代码格式，保留 `generate_series` 语义并完成静态检查。

---
## dev+xjc+P-2026-002-finance-snapshot-ddl+财务快照DDL优化 | 负责人: xjc | 周期: 2026-05-22 ~ 进行中

### 2026-05-22
- [人工] 明确财务快照总体口径：每个账期只保留一个版本，使用 `account_month`，不使用 `snapshot_batch` 和 `source_table`。
- [AI] 设计财务来源明细快照/拉链表 DDL，新增 SDK 订单月度拉链表，调整 getmoneylog、usermoneylog、支付渠道和 SDK 排除规则快照表。
- [AI] 清理废弃的 SDK 订单普通快照 DDL 与 view snapshot DDL，避免重复存储。
- [AI] 编写 6 张 DWD 财务快照/拉链表和 2 张 DIM 财务维表快照的 DML。
- [AI] 补充业务库到财务 MySQL 的近 3 个月滚动删除插入脚本，直接使用 DolphinScheduler `${dt}` 计算窗口边界。
- [人工] 财务后续方案调整为近 3 个月滚动更新与历史封存，原完整快照/拉链方向部分任务进入阻塞。

---
## dev+xjc+P-2026-002-paywall-metrics-init+付费墙指标初始化 | 负责人: xjc | 周期: 2026-05-27 ~ 2026-05-27

### 2026-05-27
- [人工] 确认付费墙初始化表目标粒度、VIP 商品范围和充值类型字段存储格式
- [AI] 扫描现有付费墙指标表、短剧充值订单表和订阅累计表，形成初始化表开发方案
- [AI] 创建 Program P-2026-002，补充 PROGRAM.md / SCOPE.yml / STATUS.yml / PLAN.md
- [AI] 新建 ADS 层付费墙用户指标初始化表 DDL 和一次性全量初始化 DML
- [AI] 编写验证 SQL，覆盖唯一性、空值、首充/末充/VIP 充值口径核对和 DWS 参考对比
- [AI] 按 v0.2 调研文档切换上游为支付成功充值订单表，调整充值类型字段为 int 枚举并同步验证 SQL
- [AI] 修正充值类型枚举映射，区分 VIP 与 SVIP：810 映射 1，860 映射 8
- [AI] 按服务端反馈将首充和首次 VIP 充值字段统一为时间戳口径，DML 保留完整 create_time
- [AI] 修正 StarRocks 不支持 timestamp 类型的问题，最终按 bigint 输出毫秒级时间戳
- [AI] 按服务端要求将首充和首次 VIP 充值字段改为 bigint，输出 13 位毫秒级时间戳
- [AI] 付费墙实时指标改用充值曝光事件视图，新增 max_exp_strategy_id 统计前 3d 半屏充值曝光次数最多的 event_strategy_id
- [AI] 将 max_exp_strategy_id 类型调整为 varchar(128)，保留 event_strategy_id 原始字符串以兼容后续策略编码变化

---
## dev+xjc+P-2026-003-book-cost-reach+书籍孵化新增花费与达标率 | 负责人: xjc | 周期: 2026-05-29 ~ 2026-06-03

### 2026-05-29
- [人工] 确认书籍孵化分析需求，按 `dt + book_id + site_id` 输出每日快照，指标统一来自 ROI 明细源表。
- [AI] 创建 Program 控制文档，补充 PROGRAM.md / SCOPE.yml / STATUS.yml。
- [AI] 新建 ADS 表 `ads.ads_content_book_cost_reach_df`，沉淀累计花费、近三日均花费、当日 D0 收入、标准花费和 D0 达标率。
- [AI] 编写 `P_ads_content_book_cost_reach_df.sql`，切换 ROI 来源到 `dwd_ad_fb_ad_roi_install_referrer_timezone_di_view`，并修正字段映射。
- [AI] 更新 `workspace/validation.sql` 和 RESULT 文档，覆盖粒度唯一、指标口径和异常值验证。

---
## dev+qhr+三方曝光及充值监控分析 | 负责人: qhr | 周期: 2026-05-20 ~ 2026-05-20

### 2026-05-20
- [AI] 扫描海剧三方支付漏斗链路报表 V4，创建 Program P-20260520，提取曝光+充值核心 CTE，精简为 T+1 分析 SQL（维度：用户类型 D0/非D0、core、mt；指标：三方曝光UV、曝光UV、三方充值UV、三方充值金额、原生充值金额）
- [AI] 按反馈切换维度方案：策略体系（recharge_source/strategy_id/策略代号&名称） → 用户体系（user_type/core/mt），同步更新 PLAN.md
- [AI] 基于海阅三方支付漏斗链路报表 V3 脚本内部三表（dws_user_wide_active_period_ed / ads_bi_sr_third_payment_exposure_pv_di / ads_trade_user_payorder_view）重构海阅 T+1 分析 SQL，独立 CTE 防 fan-out，新增 period_type=''ctt'' 过滤
- [人工] 在 StarRocks 执行两条 SQL 验证，确认字段口径和输出结果满足要求
- [AI] 更新 PROGRAM.md / SCOPE.yml / STATUS.yml / PLAN.md 配套文档

---
## dev+qhr+P-20260526-dml-format-optimization | 负责人: qhr | 周期: 2026-05-26 ~ 2026-05-27

### 2026-05-26
- [AI] 分析 ori.sql vs ai-old.sql vs correct.sql，识别 24 个差异点，分为 6 组（A-F），制定改造方案写入 PLAN.md
- [AI] 改造 A 组（文件头重新生成、分号保留、函数参数逗号加空格）
- [AI] 改造 B/C 组（函数名全小写、逗号/运算符/over/partition by/cast 空格规范化）
- [AI] 改造 D 组（CTE 列0、CTE 逗号列0、子查询缩进、left/right 函数识别、注释保留、parse_conditions 右括号修复）
- [AI] 改造 E/F 组（as 显式添加、表别名 as、单行 case-when、clean_expr 剥离注释、as 前空格保证）
- [AI] 修复 13 项 bug（CTE 逗号检测 kw_val→peek().kind、select 缩进前缀空格、CTE 内部缩进 +5→+4、split_as_expr 双空格移除回溯、insert_line 规范化用 re.sub、单行 case-when 检测与渲染、left/right 函数后跟 ( 时不作为子句边界、parse_conditions 右括号 paren_depth<0 正确 return、注释保留 StreamParser._captured、文件头从 P_ads_... 推断 layer、clean_expr 剥离 comment token、as 前始终保证空格、_contains_case 排除 case 表达式避免极端 as 填充）
- [人工] 修复 correct.sql 第 112 行 ON 条件合行错误
- [人工] 审核 diff 结果（632→321 行，-49%），确认剩余差异为 as 对齐列宽/注释策略/子查询闭括号对齐等规则偏好非 bug，决定就此收尾

### 2026-05-27
- [AI] 诊断 as_col 公式差异，逐层对比 37 个 select block 的 max_before_as 值，确认 34 个完全一致，排除此前怀疑的"224 vs 72"为 case 表达式宽度已被正确排除
- [AI] 修复一元负号/正号空格（normalize_spacing 检测 unary +/-，-365 不再被格式化为 - 365）
- [AI] 修复 union 解析，支持 bare union（不含 all），解决 regression 测试中文件解析失败
- [AI] 更新 dml-format-rules.md 至 v2（新增一元负号、union、显式 as、注释保留、隐式别名、函数调用无空格等规则，末尾增加变更记录表）
- [AI] 执行回归测试，24 个 DML 文件随机抽样全部格式化解析通过（含之前 bare union 失败文件）
- [AI] 更新 PROGRAM.md / STATUS.yml / memory
- [人工] 确认 left(a.code_value, 2) 无空格为正确格式
- [人工] 确认 diff 318 行状态可接受，审批收尾
---
## dev+qhr+RTM-20262+productid语言rule映射 | 负责人: qhr | 周期: 2026-05-13 ~ 2026-05-13

### 2026-05-13
- [人工] 向服务端确认productid与language等信息的映射关系，编辑Excel文件
- [AI] 扫描 Excel 配置表结构，生成 dim_rule_productid_lang_mapping 建表 DDL
- [人工] 确认字段命名、排序键设计、rule 域归属及 Plan 方案
- [AI] 编写 DML INSERT INTO ... VALUES 脚本，转换 30 行 Excel 数据
- [AI] 更新 RESOURCE-MAP.yml 新增 rule 域定义
- [人工] 确认编码格式和行尾规范

---
## dev+qhr+RTM-20262+sql-codeformat优化 | 负责人: qhr | 周期: 2026-05-18 ~ 2026-05-19

### 2026-05-18
- [AI] 扫描 correct_format.sql 提取 13 项格式规则，写入 workspace/format-rules.md
- [人工] 确认格式规则设计决策：select 首表达式同行、前置逗号缩进规则、as 垂直对齐策略、反引号智能处理策略、文件头自动生成策略、case when 格式规则
- [AI] 重写 format_starrocks_insert_select.py（970 行），实现 tokenizer → normalizer → parser → formatter 完整流水线，覆盖 CTE/子查询/join 链/条件/select 列表 as 对齐/case-when 多行格式化/运算符空格标准化/反引号智能处理/文件头检测与生成
- [AI] 重写 dml-format-rules.md 参考文档，13 个章节覆盖文件头、整体结构、select 列表、case when、from/join/子查询、where/group/order、union all、反引号、关键字函数、运算符空格、多段 insert、行结束、保守策略，所有示例与脚本输出一致

### 2026-05-19
- [AI] 执行单文件验证（P_ads_qa_srsv_recharge_monitoring_info_hi.sql），输出 112 行与 correct_format.sql 一致，标注 3 处 correct_format 自身不一致项（now() as etl_time 不参与 as 对齐、单行 case when 不拆分、括号列不对齐）
- [AI] 执行批量验证，3 个不同复杂度 DML 文件（simple: P_dim_sv_series_hi.sql 61 行 / medium: P_dwd_advertisement_admob_income.sql 99 行 / complex: P_dws_user_wide_active_period_ed.sql 218 行）均通过，验证项含文件头不重复、select 缩进、as 对齐、子查询 alias、union all 格式
- [人工] 审核验证结果，确认 3 处差异为 correct_format 自身不一致，脚本行为符合统一规则
- [AI] 更新项目级 sql-codeformat SKILL.md，含 --function/--owner 参数说明和完整格式化规则列表
- [AI] 同步更新系统级 sql-codeformat skill（Cowork save_skill）
- [AI] 新增 format_finebi.py 格式化脚本（554 行），复用 DML 格式化器核心模块（tokenizer/normalizer/parser/formatter），新增 FineBIBodyParser 修复 parse_ctes 逗号检测和 parse_conditions where 关键字终止，实现 CTE 注释提取与标准化（---xxx → -- xxx）、隐式别名 as 自动补全、between...and 条件合并、FineBI 文件头生成
- [AI] 执行单文件验证（raw/original.sql 对比 raw/correct-format.sql），核心格式一致（文件头、6 个 CTE 全部识别、注释标准化、缩进、别名 as、between 合并）
- [AI] 执行批量验证，Application/FineBI/海剧/ 下 4 个不同复杂度文件（广告基建策略、海剧用户留存、模板&剧维度基建上限、收入）均通过
- [AI] 更新 SKILL.md 添加 FineBI 格式化器章节（触发条件、命令行参数、格式化规则）


### 2026-05-20
- [AI] 重构 format_finebi.py 架??新增预提取-占位-格式化-回填流水线（extract_finebi_vars / extract_cast_exprs / restore_finebi_vars / restore_cast_exprs）??决 ${...} 模板表达式和 cast(... as ...) 破坏 SQL 解析的核心问题
- [AI] 实现单引号别名 -> 反引号转换（s ''别名'' -> s `别名`，支持显式 s 写法和隐式别名写法）
- [AI] 实现 ${...} 内部换行展平（restore 阶段将 \n 替换为空格）
- [AI] 修复 _insert_implicit_as_in_expr 中 has_as 检测的 off-by-one 错误


---
## dev+qhr+三方曝光及充值监控分析 | 负责人: qhr | 周期: 2026-05-20 ~ 2026-05-20

### 2026-05-20
- [AI] 扫描海剧三方支付漏斗链路报表 V4，创建 Program P-20260520，提取曝光+充值核心 CTE，精简为 T+1 分析 SQL（维度：用户类型 D0/非D0、core、mt；指标：三方曝光UV、曝光UV、三方充值UV、三方充值金额、原生充值金额）
- [AI] 按反馈切换维度方案：策略体系（recharge_source/strategy_id/策略代号&名称） → 用户体系（user_type/core/mt），同步更新 PLAN.md
- [AI] 基于海阅三方支付漏斗链路报表 V3 脚本内部三表（dws_user_wide_active_period_ed / ads_bi_sr_third_payment_exposure_pv_di / ads_trade_user_payorder_view）重构海阅 T+1 分析 SQL，独立 CTE 防 fan-out，新增 period_type=''ctt'' 过滤
- [人工] 在 StarRocks 执行两条 SQL 验证，确认字段口径和输出结果满足要求
- [AI] 更新 PROGRAM.md / SCOPE.yml / STATUS.yml / PLAN.md 配套文档

---
## dev+qhr+P-20260526-dml-format-optimization | 负责人: qhr | 周期: 2026-05-26 ~ 2026-05-27

### 2026-05-26
- [AI] 分析 ori.sql vs ai-old.sql vs correct.sql，识别 24 个差异点，分为 6 组（A-F），制定改造方案写入 PLAN.md
- [AI] 改造 A 组（文件头重新生成、分号保留、函数参数逗号加空格）
- [AI] 改造 B/C 组（函数名全小写、逗号/运算符/over/partition by/cast 空格规范化）
- [AI] 改造 D 组（CTE 列0、CTE 逗号列0、子查询缩进、left/right 函数识别、注释保留、parse_conditions 右括号修复）
- [AI] 改造 E/F 组（as 显式添加、表别名 as、单行 case-when、clean_expr 剥离注释、as 前空格保证）
- [AI] 修复 13 项 bug（CTE 逗号检测 kw_val→peek().kind、select 缩进前缀空格、CTE 内部缩进 +5→+4、split_as_expr 双空格移除回溯、insert_line 规范化用 re.sub、单行 case-when 检测与渲染、left/right 函数后跟 ( 时不作为子句边界、parse_conditions 右括号 paren_depth<0 正确 return、注释保留 StreamParser._captured、文件头从 P_ads_... 推断 layer、clean_expr 剥离 comment token、as 前始终保证空格、_contains_case 排除 case 表达式避免极端 as 填充）
- [人工] 修复 correct.sql 第 112 行 ON 条件合行错误
- [人工] 审核 diff 结果（632→321 行，-49%），确认剩余差异为 as 对齐列宽/注释策略/子查询闭括号对齐等规则偏好非 bug，决定就此收尾

### 2026-05-27
- [AI] 诊断 as_col 公式差异，逐层对比 37 个 select block 的 max_before_as 值，确认 34 个完全一致，排除此前怀疑的"224 vs 72"为 case 表达式宽度已被正确排除
- [AI] 修复一元负号/正号空格（normalize_spacing 检测 unary +/-，-365 不再被格式化为 - 365）
- [AI] 修复 union 解析，支持 bare union（不含 all），解决 regression 测试中文件解析失败
- [AI] 更新 dml-format-rules.md 至 v2（新增一元负号、union、显式 as、注释保留、隐式别名、函数调用无空格等规则，末尾增加变更记录表）
- [AI] 执行回归测试，24 个 DML 文件随机抽样全部格式化解析通过（含之前 bare union 失败文件）
- [AI] 更新 PROGRAM.md / STATUS.yml / memory
- [人工] 确认 left(a.code_value, 2) 无空格为正确格式
- [人工] 确认 diff 318 行状态可接受，审批收尾

---
## dev+tyg+RTM-41982+push推送用户订阅状态功能-短剧系统 | 负责人: tyg | 周期: 2026-05-29 ~ 2026-06-03

### 2026-05-29
- [人工] 与业务方沟通海剧push推送用户订阅状态功能需求，确认拆两张表方案（频控表+订阅状态表）
- [人工] 确认频控查询模式（accountId+pushId点查）和订阅状态查询模式（只查最近几天）

### 2026-06-01
- [AI] 扫描数仓现有 ads_sv_ 表结构，确定高频通用维度字段（core/mt/lang_id/reg_country）
- [AI] 编写 ads_sv_user_push_click_di 和 ads_sv_user_subscribe_status_di DDL 建表语句
- [AI] 编写 accountinfo / commandtask 数据源测试探查SQL
- [人工] 确认 isdelete/hasdelete 过滤口径
- [人工] 数据量探查验证

### 2026-06-02
- [AI] 编写 P_ads_sv_user_push_click_di DML（max聚合取最新点击初版）
- [AI] 编写 P_ads_sv_user_subscribe_status_di DML（三部分union：即将到期+已过期+续费失败）
- [AI] 输出测试验证SQL文件（频控/订阅状态各2份）
- [人工] 与业务方确认 is_expiring_soon（3日内到期）和 is_expired（昨日过期）口径
- [人工] 确认续费失败 Args.UserId 关联 accountinfo 补全维度逻辑

### 2026-06-03
- [人工] 排查 is_expired 数据量差距根因（isdelete过滤导致，仅hasdelete=0）
- [AI] 修正 DML 过滤条件，治理 select * 写法，规范化子查询别名和表别名
- [AI] 补充主键非空过滤（id is not null、identity_user_id/push_id is not null）
- [AI] 生成 MySQL 版本 DDL，补充普通索引（index_user_id、index_expire_time等）
- [AI] 使用项目 sql-codeformat 脚本格式化四个 SQL 文件
- [人工] 测试环境建表验证，DML 单天数据验证通过

---
## dev+roger+RTM-43047+短剧内容完播中台迭代 | 负责人: roger | 周期: 2026-06-09 ~ 2026-06-12

### 2026-06-09
- [人工] 确认短剧完播中台新增字段范围、播放量口径不改原始 PV、不新增 ROI 字段
- [AI] 分析两张北斗 ADS 表 DDL/DML 与营销计划视图口径，生成测试 DDL 和字段缺口清单
- [AI] 改造 ads_sv_beidou_series_epis_stat_di DDL/DML，新增每集播放量、有效观看用户、流失观看用户
- [AI] 改造 ads_sv_beidou_series_daily_stat_di DDL/DML，新增投放字段和免费/付费有效观看、流失观看指标
- [人工] 确认 placement_time 需从西五区 begin_date 转换为东八区，调整和修正口径

### 2026-06-10
- [人工] 确认最后一集不计入流失观看用户，播放量保持去重观看记录计数口径
- [AI] 调整每集和每日 DML，排除最后一集流失观看用户
- [人工] 对比 tmp 与 ads 在 2026-06-08 同批次数据，验证主键覆盖、旧字段一致性、新增字段覆盖和最后一集流失规则
- [AI] 生成生产 ALTER TABLE ADD COLUMN 工单 SQL，并校验字段顺序
- [人工] 重跑测试表与生产 ADS 数据，确认验证结论

### 2026-06-11
- [人工] 业务需求变更，确认 dim_sv_beidou_serices_detail_df 需补充 placement_time，用 MarketingPlan BeginDate 加 13 小时转换为东八区
- [人工] 改造 dim_sv_beidou_serices_detail_df DDL/DML，新增 placement_time 并关联营销计划来源
- [AI] 补充 dim.dim_sv_beidou_serices_detail_df 的生产 ALTER TABLE ADD COLUMN 工单 SQL

### 2026-06-12
- [人工] 确认 ads_sv_beidou_series_epis_stat_di、ads_sv_beidou_series_source_stat_di、ads_sv_beidou_series_user_type_di 需补充 publish_time 和 placement_time
- [AI] 按计划改造 3 张 ADS 表 DDL/DML，统一从 dim_sv_beidou_serices_detail_df 聚合取发布时间和投放时间，避免维表多行放大
- [AI] 补充 3 张 ADS 表生产 ALTER TABLE ADD COLUMNS 工单 SQL，字段统一放在 series_name 后
- [人工] 重新刷 tmp 表 2026-06-10 ~ 2026-06-11 数据，用于和生产 ADS 同名表对比
