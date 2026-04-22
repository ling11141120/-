# AGENTS.md

此文件为 AI Coding Agent 在本数仓项目中工作时提供指导。

---

## 项目概述

本项目是基于 **StarRocks** 的数据仓库，采用经典分层架构（ODS → DWD → DWS → ADS / DIM），所有开发产物为 **SQL 文件**（DDL + DML）。代码通过 DolphinScheduler 调度执行。

---

## 工作语言与风格

- 使用**简体中文**沟通
- SQL 注释使用中文
- 代码简洁直接，注释说明业务含义而非语法
- 数仓命名规范：`{层}_{业务域}_{主题}_{粒度}_{周期}`
- 生成文件的编码使用UTF-8无BOM，行尾使用 CRLF， 且中文字符不能乱码

---

## Boot Sequence

Agent 启动后：

1. **用户指定 Program**（如 "继续 P-2026-001" 或 "新 Program: xxx"）
2. **读取** `orchestrator/ALWAYS/BOOT.md`
3. **按指示加载**相关文件
4. **输出**当前状态和下一步

如果用户未指定 Program，扫描 `orchestrator/PROGRAMS/` 展示任务列表，询问要做什么。

---

## 目录结构

```
dolphinscheduler/
├── AGENTS.md                          # 本文件
├── orchestrator/
│   ├── ALWAYS/                        # 核心配置（每次必读）
│   │   ├── BOOT.md                    # 启动加载顺序
│   │   ├── CORE.md                    # 工作协议
│   │   ├── DEV-FLOW.md                # 数仓开发流程
│   │   ├── SUB-AGENT.md               # Sub-Agent 规范（按需使用）
│   │   └── RESOURCE-MAP.yml           # 资源索引
│   │
│   └── PROGRAMS/                      # 开发任务
│       └── P-YYYY-NNN-name/           # 每个 Program 一个目录
│           ├── PROGRAM.md             # 任务定义
│           ├── STATUS.yml             # 状态跟踪
│           ├── SCOPE.yml              # 写入范围
│           └── workspace/             # 工作文档
│
└── starrocks/                         # 数仓 SQL 代码
    ├── ods/                           # 操作数据层
    ├── ods_log/                       # 日志数据层
    ├── dwd/                           # 数据明细层（DDL + DML）
    ├── dwm/                           # 数据中间层（DDL + DML）
    ├── dws/                           # 数据服务层（DDL + DML）
    ├── dim/                           # 维度层（DDL + DML）
    ├── ads/                           # 应用数据层（DDL + DML）
    │   ├── ddl/                       # 表定义
    │   └── dml/                       # 数据加载（DolphinScheduler 调度）
    ├── alg/                           # 算法层
    └── test/                          # 测试脚本
```

---

## 快速命令

- "继续 P-2026-001" — 加载并继续该 Program
- "新 Program: xxx" — 创建新的开发任务
- "委托: xxx" — 使用 Sub-Agent 执行任务
- "保存进度" — 写入 HANDOFF.md 保存当前状态

---

## 状态来源

- **Programs 列表**: 扫描 `orchestrator/PROGRAMS/` 目录
- **Program 状态**: 读取各 Program 下的 `STATUS.yml`
- **仓库信息**: 读取 `orchestrator/ALWAYS/RESOURCE-MAP.yml`

不要在此文件维护状态副本，直接从源文件读取。
