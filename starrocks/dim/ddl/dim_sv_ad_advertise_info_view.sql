create or replace view dim.dim_sv_ad_advertise_info_view (
     id                comment "自增主键"
    ,day               comment "日期，20240626"
    ,project_name      comment "项目名称，任务3_moboreader_001102"
    ,ad_request        comment "广告请求"
    ,match_request     comment "匹配请求"
    ,ad_click_count    comment "点击次数"
    ,income            comment "收益，US$"
    ,cover_rate        comment "覆盖率（值为百分比%），匹配请求/广告请求"
    ,show_rate         comment "展示率（值为百分比%），展示次数/匹配请求"
    ,ctr               comment "点击率（值为百分比%），点击次数/展示次数"
    ,cpc               comment "收益/点击"
    ,ecpm              comment "广告ECPM，US$"
    ,create_time       comment "记录生成时间"
    ,update_time       comment "记录更新时间"
    ,system_type       comment "类型,1短剧 2阅读"
    ,ad_show_count     comment "展示次数"
    ,revenue_share     comment "分成后收益，US$"
    ,sr_createtime     comment "sr入库时间"
    ,sr_updatetime     comment "sr更新时间"
)
comment "海阅,海剧广告广告收益——三方链接收益数据接入"
as
select id
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
  from ods.ods_tidb_sv_short_video_log_ad_profits_report_da
;