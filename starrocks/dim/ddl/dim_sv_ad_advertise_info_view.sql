CREATE VIEW dim_sv_ad_advertise_info_view (
    ,id             COMMENT "自增主键"
    ,day            COMMENT "日期，20240626"
    ,project_name   COMMENT "项目名称，任务3_moboreader_001102"
    ,ad_request     COMMENT "广告请求"
    ,match_request  COMMENT "匹配请求"
    ,ad_click_count COMMENT "点击次数"
    ,income         COMMENT "收益，US$"
    ,cover_rate     COMMENT "覆盖率（值为百分比%），匹配请求/广告请求"
    ,show_rate      COMMENT "展示率（值为百分比%），展示次数/匹配请求"
    ,ctr            COMMENT "点击率（值为百分比%），点击次数/展示次数"
    ,cpc            COMMENT "收益/点击"
    ,ecpm           COMMENT "广告ECPM，US$"
    ,create_time    COMMENT "记录生成时间"
    ,update_time    COMMENT "记录更新时间"
    ,system_type    COMMENT "类型,1短剧 2阅读"
    ,ad_show_count  COMMENT "展示次数"
    ,revenue_share  COMMENT "分成后收益，US$"
    ,sr_createtime  COMMENT "sr入库时间"
    ,sr_updatetime  COMMENT "sr更新时间"
) COMMENT "海阅,海剧广告广告收益——三方链接收益数据接入" AS
SELECT id
      ,day
      ,project_name
      ,ad_request
      ,match_request
      ,ad_click_count
      ,income
      ,cover_rate
      ,show_rate
      ,ctr
      ,cpc
      ,ecpm
      ,create_time
      ,update_time
      ,system_type
      ,ad_show_count
      ,revenueShare
      ,sr_createtime
      ,sr_updatetime
  FROM ods.ods_tidb_sv_short_video_log_ad_profits_report_da
;