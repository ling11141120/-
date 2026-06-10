# OpenMetadata 域治理设计规范

**状态**：已审核采纳  
**生效来源**：P-20260529-data-warehouse-governance  
**生效日期**：2026-06-04  

## 1. 适用范围

本规范用于指导 OpenMetadata 中 Domain、Domain 自定义属性、标签、Glossary 和 Data Product 的建设，适用于当前 StarRocks 数仓主题域治理、资产挂载、核心字段口径沉淀和后续数据产品建设。

## 2. Domain 设计原则

Domain 用于表达业务治理责任边界，不用于重复表达 `ods/dwd/dws/ads/dim` 等 StarRocks 数据库物理分层。

推荐采用“业务域在上，三层语义在下”的结构：

```text
用户域
  用户分析
  用户过程
  用户实体

内容域
  内容分析
  内容过程
  内容实体
```

顶层业务域是综合治理边界，子域承载具体建模语义。

## 3. domainType 与 domainLayer

OpenMetadata 原生 `domainType` 保持不改，取值仍使用：

- `Source-aligned`
- `Consumer-aligned`
- `Aggregate`

自定义属性 `domainLayer` 用于表达当前数仓三层主题域架构，取值为：

- 分析层
- 业务过程层
- 实体层

二者分工如下：

| 字段 | 用途 | 推荐规则 |
|------|------|----------|
| `domainType` | OpenMetadata 原生领域组织方式 | 顶层综合业务域使用 `Aggregate`；过程和实体子域使用 `Source-aligned`；分析消费子域使用 `Consumer-aligned` |
| `domainLayer` | 当前数仓建模语义层级 | 顶层综合业务域允许为空；子域按分析层、业务过程层、实体层填写 |

顶层综合业务域统一使用 `Aggregate`，原因是顶层“用户域、内容域、交易域”等通常聚合实体、过程、分析、术语、数据产品和治理责任，不是单一源系统域，也不是单一消费场景域。

## 4. 用户域示例

| Domain | domainType | domainLayer | 说明 |
|--------|------------|-------------|------|
| 用户域 | `Aggregate` | 空 | 综合业务责任域 |
| 用户域 / 用户分析 | `Consumer-aligned` | 分析层 | 面向用户画像、留存、生命周期、用户价值等分析消费 |
| 用户域 / 用户过程 | `Source-aligned` | 业务过程层 | 面向注册、登录、启动、活跃、设备绑定等业务事件 |
| 用户域 / 用户实体 | `Source-aligned` | 实体层 | 面向用户账号、设备、会员状态、用户标签等稳定对象 |

当前用户域试点资产：

| 数据资产 | 推荐 Domain | domainType | domainLayer |
|----------|-------------|------------|-------------|
| `ads.ads_wide_short_video_user_info_a_view` | 用户域 / 用户分析 | `Consumer-aligned` | 分析层 |
| `dws.dws_user_sv_idx_his_15d_view` | 用户域 / 用户分析 / 用户累计指标 | `Aggregate` | 分析层 |
| `dws.dws_user_sv_accumulate_idx_his_15df` | 用户域 / 用户分析 / 用户累计指标 | `Aggregate` | 分析层 |
| `dws.dws_user_sv_status_idx_his_15df` | 用户域 / 用户分析 / 用户状态指标 | `Aggregate` | 分析层 |
| `dim.dim_short_video_user_accountinfo` | 用户域 / 用户实体 / 短剧用户账号实体 | `Source-aligned` | 实体层 |

## 5. 标签使用规范

OpenMetadata 标签用于轻量横向标记。标签可挂载到表、视图、字段等资产上。

不创建 `ods/dwd/dws/ads/dim` 数仓层级标签，因为数据库名和表名前缀已经表达物理层级。

建议使用中文标签分类和中文标签名：

```text
模型类型
  用户画像
  指标视图
  指标汇总表
  事实表
  维度表
  快照表
  桥接表

业务过程
  登录过程
  观看过程
  阅读过程
  消费过程
  支付过程
  充值过程
  订阅过程
  退款过程
  点赞过程
  曝光过程
  点击过程
  渠道归因过程

资产状态
  生产使用
  已废弃
  临时表
  备份表
  待治理

治理标记
  核心资产
  缺少负责人
  缺少口径说明
  待补充血缘
```

## 6. 业务过程标签维护原则

业务过程标签只标注在直接承载业务过程的明细表、过程事实表或明确的一跳过程视图上，不要求在 DWS/ADS 汇总表、宽表、分析视图上逐层重复维护。

| 资产类型 | 是否人工维护“业务过程”标签 | 说明 |
|----------|----------------------------|------|
| DWD 过程事实表 / 过程视图 | 是 | 本表直接表达业务过程 |
| DIM 实体表 | 通常否 | 实体表表达对象属性，不直接表达业务过程 |
| DWS 指标汇总表 | 否 | 通过血缘从上游 DWD 过程表推导 |
| DWS 历史累计快照表 | 否 | 继承直接上游汇总表的过程语义 |
| ADS 分析表 / 分析视图 | 否 | 通过血缘或 Data Product 描述表达覆盖过程 |
| 核心数据产品输出表 | 可选 | 可人工维护高层摘要，但不作为强制要求 |

示例：

```text
dwd.dwd_user_short_video_user_login_view
  标签: 业务过程.登录过程

dwd.dwd_sv_consume_user_consume_bill_pdi
  标签: 业务过程.观看过程

dws.dws_user_sv_accumulate_idx_di
  不人工维护业务过程标签，通过上游 DWD 血缘推导

dws.dws_user_sv_accumulate_idx_his_15df
  不人工重复维护业务过程标签，继承直接上游过程集合
```

核心原则：只在过程源头打业务过程标签，下游通过血缘推导。

## 7. Glossary 使用规范

Glossary 用于沉淀业务术语和指标口径，不用于替代 Domain 或标签。

建议首批围绕核心字段建设术语，例如：

```text
累计登录天数
累计登录次数
累计观看天数
累计观看次数
累计消耗金额
累计订阅金额
累计充值金额
累计点赞次数
最新激活渠道
用户过期时间
```

术语应关联到具体字段，例如：

```text
累计登录天数 -> ads.ads_wide_short_video_user_info_a_view.login_days_td
累计观看次数 -> ads.ads_wide_short_video_user_info_a_view.watch_cnt_td
累计订阅金额 -> ads.ads_wide_short_video_user_info_a_view.total_subscribe_amt
```

## 8. Data Product 使用规范

Data Product 用于表达对外可消费的数据产品和资产组合。

用户域试点建议创建：

```text
Data Product: 海剧用户累计画像
Domain: 用户域 / 用户分析
输出资产:
  - ads.ads_wide_short_video_user_info_a_view
核心输入:
  - dws.dws_user_sv_idx_his_15d_view
  - dim.dim_short_video_user_accountinfo
```

## 9. 后续执行原则

先以用户域试点，完成 Domain、标签、Glossary 和 Data Product 的闭环验证，再推广到内容域、交易域、订阅域、广告投放域、算法域、渠道域、资产域等。
