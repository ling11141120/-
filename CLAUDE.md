# CLAUDE.md

此文件为 AI Coding Agent 在本数仓项目中工作时提供指导。

# 项目概述

- 基于 StarRocks 3.2.15 的数据仓库，经典分层架构（ODS → DWD → DWS → ADS / DIM）  
- 所有开发产物为 **SQL 文件**（DDL + DML），通过 DolphinScheduler 调度执行  
- 业务领域：海外阅读/海外短剧/圣经业务分析、广告投放、用户行为、商业化分析

# 工作语言与风格

- 使用**简体中文**沟通
- SQL 注释使用中文，说明业务含义而非语法
- 代码简洁直接
- 数仓命名规范：`{层}_{业务域}_{主题}_{粒度}_{周期}`，周期后缀 `di`=日、`hi`=小时、`df`=全量快照、`ed`=增量
- 生成文件的编码使用 UTF-8 无 BOM，行尾使用 CRLF，中文字符不能乱码

# Boot Sequence

Agent 启动后：

1. **用户指定 Program**（如"继续 P-2026-001"或"新 Program: xxx"）
2. **读取** `orchestrator/ALWAYS/BOOT.md`
3. **按指示加载**相关文件
4. **输出**当前状态和下一步

如果用户未指定 Program，扫描 `orchestrator/PROGRAMS/` 展示任务列表，询问要做什么。

## 目录结构

```
kunlun-dolphinscheduler/
├── orchestrator/
│   ├── ALWAYS/                        # 核心配置（每次必读）
│   │   ├── BOOT.md                    # 启动加载顺序
│   │   ├── CORE.md                    # 工作协议（含 Plan 确认流程）
│   │   ├── DEV-FLOW.md                # 数仓开发流程
│   │   ├── RESOURCE-MAP.yml            # 资源索引（仓库级只读）
│   │   ├── SUB-AGENT.md               # Sub-Agent 规范（按需使用，不作为默认流程）
│   │   └── PLAN-TEMPLATE.md           # Plan 方案模板
│   │
│   ├── PROGRAMS/                      # 开发任务
│   │   └── P-YYYY-NNN-name/           # 每个 Program 一个目录
│   │       ├── PROGRAM.md             # 任务定义
│   │       ├── STATUS.yml              # 状态跟踪
│   │       ├── SCOPE.yml               # 写入范围
│   │       └── workspace/             # 工作文档（PLAN.md / CHECKPOINT / HANDOFF）
│   │
│   └── SKILLS/                        # 可复用技能
│
└── starrocks/                         # 数仓 SQL 代码
    ├── ods/                           # 操作数据层
    ├── ods_log/                       # 日志数据层
    ├── dwd/                           # 数据明细层（DDL + DML）
    ├── dwm/                           # 数据中间层（DDL + DML）
    ├── dws/                           # 数据服务层（DDL + DML）
    ├── dim/                           # 维度层（DDL + DML）
    ├── ads/                           # 应用数据层
    │   ├── ddl/                       # 表定义：{table_name}.sql
    │   └── dml/                       # 数据加载：P_{table_name}.sql
    ├── alg/                           # 算法层
    └── test/                          # 测试脚本
```

# 快速命令

- "继续 P-YYYY-NNN" — 加载并继续该 Program
- "新 Program: xxx" — 创建新的开发任务，进入 Plan 确认流程
- "保存进度" — 写入 HANDOFF.md 保存当前状态

# Plan 模式对话示例

用户说"新 Program"后，Agent 进入 Plan 确认流程（详见 CORE.md）：

```
用户: 新 Program: ads 层新增一个用户活跃趋势表

Agent:
  需求理解: 在 ads 层新建日粒度表，统计用户活跃趋势
  目标层级: ads
  业务域: 从您的描述推断可能是"用户行为"，确认吗？
  候选表名: ads.ads_user_active_trend_di，确认吗？
  
  接下来需要确认：
  1. 上游数据来源是哪张表？
  2. 需要哪些统计指标？
  3. 是否需要回刷历史？

用户确认后 →
  Agent 生成 PLAN.md，写入 PROGRAM.md / SCOPE.yml / STATUS.yml
  用户确认文件内容后开始编码
```

# 状态来源

- **Programs 列表**: 扫描 `orchestrator/PROGRAMS/` 目录
- **Program 状态**: 读取各 Program 下的 `STATUS.yml`
- **仓库信息**: 读取 `orchestrator/ALWAYS/RESOURCE-MAP.yml`
- **业务域和关键表**: Agent 运行时动态扫描 `starrocks/` 目录发现

不要在此文件维护状态副本，直接从源文件读取。