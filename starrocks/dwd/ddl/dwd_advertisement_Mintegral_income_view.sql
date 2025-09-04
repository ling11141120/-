create or replace view dwd.dwd_advertisement_Mintegral_income_view (
    ,dt             comment "日期，来自date字段"
    ,id             comment "自增id"
    ,appid          comment "appid"
    ,name           comment "广告来源名字"
    ,account        comment "广告账户"
    ,unitid         comment "单元id"
    ,plat_form      comment "系统"
    ,filled         comment "填充次数"
    ,request        comment "请求次数"
    ,impression     comment "印记次数"
    ,click          comment "点击"
    ,estrevenue     comment "estrevenue"
    ,fillrate       comment "填充率"
    ,country        comment "国家"
    ,ecpm           comment "每一千的有效成本"
    ,ctr            comment "点击通过率"
    ,app_name       comment "app名字"
    ,app_package    comment "应用包"
    ,unit_name      comment "单元名字"
    ,ad_format      comment "广告格式"
    ,create_time    comment "创建时间"
    ,update_time    comment "更新时间"
) COMMENT "广告域Mintegral广告收入事实表" AS
SELECT date(DATE)     AS dt
      ,Id
      ,AppId
      ,'Custom Event' AS name
      ,'Mintegral'    AS account
      ,UnitId
      ,Platform
      ,Filled
      ,Request
      ,Impression
      ,Click
      ,EstRevenue
      ,FillRate
      ,Country
      ,Ecpm
      ,Ctr
      ,AppName
      ,AppPackage
      ,UnitName
      ,AdFormat
      ,CreatedTime
      ,UpdatedTime
  FROM ods.ods_tidb_sharpengine_ads_global_mintegralreport
;