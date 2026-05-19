# 变更日志 (Changelog)

> 本文件记录所有需求的 AI/人工开发占比。
> 每个 `## {分支名}` section 对应一个需求分支的完整开发记录。
> 格式规范详见 `orchestrator/ALWAYS/CHANGELOG-SPEC.md`。

---
## dev+qhr+RTM-20262+productid语言rule映射 | 负责人: qhr | 周期: 2026-05-13 ~ 进行中

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

