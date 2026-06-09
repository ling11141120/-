# RoiStdConfigDaily 替 RoiStdCfgDaily 标准关联修改方案

## 背景

何妨 2026-06-08 要求：用新表 `RoiStdConfigDaily` 替换旧表 `RoiStdCfgDaily`，删除 `RoiStdCfgFlowTag` 关联。
配置还没跑完，**先准备好 SQL，不执行生产替换**。

## 核心变更

| 项目 | 删除 | 新增 |
|------|------|------|
| 海阅 (ProjectCode=1) | `RoiStdCfgFlowTag` join + 旧表 `StdCode` 条件 | `BookSeriesTypeDaily` join + `ProductId`/`BookSeriesType` 新条件 |
| 海剧/圣经 (ProjectCode=2) | `RoiStdCfgFlowTag` join + 旧表 `StdCode` 条件 | `ProductId` 新条件 |

## 影响文件清单

### 直接引用旧表 RoiStdCfgDaily 的 DML（7处，4个文件）

| 文件 | 行号 | 场景 |
|------|------|------|
| `ads/dml/P_ads_srsv_bi_ad_optimizer_template_target_data_pre.sql` | ~190, 203, 221, 231 | 海阅+海剧 |
| `ads/dml/P_ads_srsv_bi_ad_optimizer_template_target_data_pre_1.sql` | ~441, 455, 484, 496 | 海阅+海剧 |
| `ads/dml/P_ads_srsv_material_rating_probability_pre.sql` | ~51, 91 | 海阅 |
| `ads/dml/P_ads_sv_advertisement_optimize_di.sql` | ~94 | 海剧 |

### 间接引用（通过 VIEW，6个文件）

| 文件 | 场景 |
|------|------|
| `ads/dml/P_ads_srsv_bi_ad_optimizer_target_data.sql` | 海阅+海剧 |
| `ads/dml/P_ads_srsv_bi_ad_optimizer_target_data_v1.sql` | 海阅+海剧 |
| `ads/dml/P_ads_srsv_bi_ad_optimizer_priority_v1.sql` | 海阅+海剧 |
| `ads/dml/P_ads_ad_time_partitioned_data.sql` | 海阅+海剧 |
| `ads/dml/P_ads_sr_series_roi_growth_metrics.sql` | 海阅 |
| `ads/dml/P_ads_sv_series_roi_growth_metrics.sql` | 海剧 |

### VIEW DDL（4个，底层指向旧 ODS 表）

| 文件 | 场景 |
|------|------|
| `dwd/ddl/dwd_advertisement_put_product_stdcfg_daily_view.sql` | 海阅-投放语言 |
| `dwd/ddl/dwd_advertisement_book_roi_stdcfg_daily_view.sql` | 海阅-书籍 |
| `dwd/ddl/dwd_sv_ad_put_product_video_roi_stdCfg_daily_view.sql` | 海剧-投放语言 |
| `dim/ddl/dim_sv_videoroistdcfgdaily_view.sql` | 海剧-短剧 |

## 修改模板

### 海阅 (ProjectCode=1)

```sql
-- 删除
left join sharpengine_ads_global.RoiStdCfgFlowTag rscft
    on a.CreateTime = rscft.Dt
   and ae.AdSetId = rscft.AdSetId

-- 旧表关联删除 StdCode，新增 ProductId 和 BookSeriesType
-- 改前
left join sharpengine_ads_global.RoiStdCfgDaily rscd
    on ...
   and rscd.StdCode = rscft.StdCode

-- 改后
left join sharpengine_ads_global.BookSeriesTypeDaily bstd
    on bstd.DateKey = a.CreateTime
   and bstd.BookSeries = ae.BookSeries
left join sharpengine_ads_global.RoiStdConfigDaily pprsc
    on pprsc.ProjectCode = 1
   and pprsc.DateKey = a.CreateTime
   and pprsc.CurrentLanguage = ae.CurrentLanguage2
   and pprsc.Mt = ae.Mt
   and pprsc.SourceChl = a.SourceChl
   and pprsc.Core = a.Core
   and pprsc.ProductId = a.ProductId
   and IFNULL(pprsc.AdTarget, '') = IFNULL(ae.AdTarget, '')
   and pprsc.BookChannel = (case when ae.BookChannel not in (0, 1) then 1 else ae.BookChannel end)
   and pprsc.BookType = ae.StoryType
   and pprsc.BookSeriesType = IFNULL(bstd.BookSeriesType, 1)
```

### 海剧/圣经 (ProjectCode=2)

```sql
-- 删除同上：RoiStdCfgFlowTag + 旧表 StdCode 条件

-- 改后
left join sharpengine_ads_global.RoiStdConfigDaily pprsc
    on pprsc.ProjectCode = 2
   and pprsc.DateKey = a.CreateTime
   and pprsc.CurrentLanguage = ae.CurrentLanguage2
   and pprsc.Mt = ae.Mt
   and pprsc.SourceChl = a.SourceChl
   and pprsc.Core = a.Core
   and pprsc.ProductId = a.ProductId
   and IFNULL(pprsc.AdTarget, '') = IFNULL(ae.AdTarget, '')
```

## 前置检查项

- [ ] `RoiStdConfigDaily` 新表是否已在 StarRocks 建好
- [ ] `BookSeriesTypeDaily` 表是否存在（海阅需要）
- [ ] 新表数据是否覆盖到所需日期范围
- [ ] 何妨确认配置跑完后才执行生产替换

## 风险点

1. **StdCode 字段在新表中可能不存在** —— 新表直接用多维度 join 替代了 StdCode 映射
2. **VIEW 层的影响** —— 如果 VIEW 也引用了旧表字段名，需要联动修改
3. **BookSeriesType 兼容性** —— 海阅新增了 BookSeriesTypeDaily 关联，需确认该表数据完整
