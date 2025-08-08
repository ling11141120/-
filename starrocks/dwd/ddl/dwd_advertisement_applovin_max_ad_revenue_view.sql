CREATE VIEW dwd_advertisement_applovin_max_ad_revenue_view (
     dt                    COMMENT "date_time 北京时间用来统计收入的日期"
    ,id                    COMMENT "主键ID"
    ,uuid                  COMMENT "day+hour+country+ad_format+max_ad_unit_id+network+device_type+has_idfa组合的md5"
    ,day                   COMMENT "原始值-UTC日期：yyyy-MM-dd"
    ,hour                  COMMENT "原始值-UTC时间：HH:mm"
    ,application           COMMENT "原始值-应用程序名称"
    ,country               COMMENT "原始值-国家"
    ,ad_format             COMMENT "原始值-广告类型"
    ,max_ad_unit_id        COMMENT "原始值-最大广告单元ID"
    ,max_ad_unit           COMMENT "原始值-最大广告单元名称"
    ,net_work              COMMENT "原始值-广告网络名称(广告来源)"
    ,device_type           COMMENT "原始值-设备类型"
    ,has_idfa              COMMENT "原始值-用户是否有可用的广告ID。0如果用户启用了LAT（限制广告流量）或选择不使用GDPR地理信息系统中的数据，则为1"
    ,ecpm_str              COMMENT "原始值-以美元计算的预计eCPM。"
    ,ecpm                  COMMENT "转换值-以美元计算的预计eCPM保留5位小数。"
    ,estimated_revenue_str COMMENT "原始值-估计产生的收入（美元）。"
    ,estimated_revenue     COMMENT "转换值-估计产生的收入（美元）保留5位小数。"
    ,impressions           COMMENT "原始值-显示的印象数"
    ,network_placement     COMMENT "原始值-外部广告网络的布局"
    ,package_name          COMMENT "原始值-包名"
    ,plat_form             COMMENT "原始值-平台"
    ,store_id              COMMENT "原始值-ios商店id"
    ,data_time             COMMENT "原始值-数据时间-北京时间"
    ,create_time           COMMENT "添加时间"
    ,sync_update_time      COMMENT "数据更新时间戳"
    ,sr_createtime         COMMENT "starrocks数据注入时间"
    ,sr_updatetime         COMMENT "starrocks数据更新时间"
) COMMENT "阅读-max广告收入数据" AS
SELECT date(data_time) AS dt
      ,id
      ,uuid
      ,day
      ,hour
      ,application
      ,country
      ,ad_format
      ,max_ad_unit_id
      ,max_ad_unit
      ,network AS net_work
      ,device_type
      ,has_idfa
      ,ecpm_str
      ,ecpm
      ,estimated_revenue_str
      ,estimated_revenue
      ,impressions
      ,network_placement
      ,package_name
      ,platform AS plat_form
      ,store_id
      ,data_time
      ,create_time
      ,sync_update_time
      ,sr_createtime
      ,sr_updatetime
  FROM ods.ods_tidb_sharpengine_ads_global_sync_applovin_max_ad_revenue
;