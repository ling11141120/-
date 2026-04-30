# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

- 基于 StarRocks 3.2.15 的数据仓库，经典分层架构（ODS → DWD → DWS → ADS / DIM）
- 所有开发产物为 **SQL 文件**（DDL + DML），通过 DolphinScheduler 调度执行
- 业务领域：海外阅读/海外短剧/圣经业务分析、广告投放、用户行为、商业化分析

## 工作语言与风格

- 使用**简体中文**沟通
- SQL 注释使用中文，说明业务含义而非语法
- 数仓命名规范：`{层}_{业务域}_{主题}_{粒度}_{周期}`，周期后缀 `di`=日、`hi`=小时、`df`=全量快照、`ed`=增量
- 文件编码统一为 **UTF-8 无 BOM**，行尾 **CRLF**，中文字符不能乱码


## 目录结构

```
.
├── orchestrator/                       # 工作流编排（规范、技能、Program）
│   ├── SKILLS/                         # 可复用技能
│   │   └── sql-codeformat/             # SQL 格式化脚本
├── starrocks/                          # 数仓 SQL 代码
│   ├── ods/                            # 操作数据层 — 原始数据接入（DDL + DML）
│   ├── ods_log/                        # 日志数据层 — 埋点/传感器日志
│   ├── dwd/                            # 数据明细层 — 清洗、标准化（DDL + DML）
│   ├── dwm/                            # 数据中间层 — 轻度汇总（DDL + DML）
│   ├── dws/                            # 数据服务层 — 主题宽表（DDL + DML）
│   ├── dim/                            # 维度层（DDL + DML）
│   ├── ads/                            # 应用数据层
│   │   ├── ddl/                        # 表定义：{table_name}.sql
│   │   └── dml/                        # 数据加载：P_{table_name}.sql
│   ├── alg/                            # 算法层
│   └── test/                           # 测试脚本
└── Application/                        # 数据应用
    ├── FineBI/                         # FineBI 应用
    └── FineReport/                     # FineReport 应用
```