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
## dev+qhr+三方曝光及充值监控分析 | 负责人: qhr | 周期: 2026-05-20 ~ 2026-05-20

### 2026-05-20
- [AI] 扫描海剧三方支付漏斗链路报表 V4，创建 Program P-20260520，提取曝光+充值核心 CTE，精简为 T+1 分析 SQL（维度：用户类型 D0/非D0、core、mt；指标：三方曝光UV、曝光UV、三方充值UV、三方充值金额、原生充值金额）
- [AI] 按反馈切换维度方案：策略体系（recharge_source/strategy_id/策略代号&名称） → 用户体系（user_type/core/mt），同步更新 PLAN.md
- [AI] 基于海阅三方支付漏斗链路报表 V3 脚本内部三表（dws_user_wide_active_period_ed / ads_bi_sr_third_payment_exposure_pv_di / ads_trade_user_payorder_view）重构海阅 T+1 分析 SQL，独立 CTE 防 fan-out，新增 period_type=''ctt'' 过滤
- [人工] 在 StarRocks 执行两条 SQL 验证，确认字段口径和输出结果满足要求
- [AI] 更新 PROGRAM.md / SCOPE.yml / STATUS.yml / PLAN.md 配套文档
