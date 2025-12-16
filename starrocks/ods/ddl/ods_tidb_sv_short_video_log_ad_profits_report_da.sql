----------------------------------------------------------------
-- 目标表： ods.ods_tidb_sv_short_video_log_ad_profits_report_da
-- 来源实例： old_tidb_source
-- 来源表： short_video_log.ad_profits_report
-- 来源负责：
-- 采集工具： 极光-定时批量
-- 开发人： qhr
-- 开发日期： 2025-12-15
----------------------------------------------------------------

drop table if exists ods.ods_tidb_sv_short_video_log_ad_profits_report_da;
create table ods.ods_tidb_sv_short_video_log_ad_profits_report_da (
     id             bigint   not null comment "自增主键"
    ,day            datetime          comment "日期，20240626"
    ,project_name   string            comment "项目名称，任务3_moboreader_001102"
    ,ad_request     bigint            comment "广告请求"
    ,match_request  bigint            comment "匹配请求"
    ,ad_click_count bigint            comment "点击次数"
    ,income         double            comment "收益，US$"
    ,cover_rate     double            comment "覆盖率（值为百分比%），匹配请求/广告请求"
    ,show_rate      double            comment "展示率（值为百分比%），展示次数/匹配请求"
    ,ctr            double            comment "点击率（值为百分比%），点击次数/展示次数"
    ,cpc            bigint            comment "收益/点击"
    ,ecpm           double            comment "广告ECPM，US$"
    ,create_time    datetime          comment "记录生成时间"
    ,update_time    datetime          comment "记录更新时间"
    ,system_type    tinyint           comment "类型,1短剧 2阅读"
    ,ad_show_count  bigint            comment "展示次数"
    ,revenueShare   double            comment "分成后收益，US$"
    ,sr_createtime  datetime          comment "sr入库时间"
    ,sr_updatetime  datetime          comment "sr更新时间"
)
primary key(id)
comment "海阅,海剧广告广告收益——三方链接收益数据接入"
distributed by hash(id) buckets 3
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "project_name, day",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;