create or replace view ads.ads_bi_ad_3p_af_noti_log_view (
     id                    comment 'id'
    ,crt_time              comment '创建时间'
    ,noti_type             comment '通知类型'
    ,noti_num              comment '通知数据'
    ,statu                 comment '状态'
    ,evt_type              comment '事件类型'
    ,attr_proc_statu       comment '充值归因处理状态'
    ,is_noti_ad_plat       comment '是否已通知到广告平台'
    ,med_src_type          comment '媒体来源类型'
    ,appsflyer_plat_id     comment 'AppsFlyer平台id'
    ,evt_time              comment '事件时间'
    ,core                  comment 'core'
    ,af_attr_proc_statu    comment 'af归因处理状态'
    ,bdl_id                comment '包Id'
    ,plat                  comment '平台'
)
comment '广告第三方af通知日志视图'
as
select Id                         as id
      ,CreateTime                 as crt_time
      ,NotifyType                 as noti_type
      ,NotifyData                 as noti_num
      ,Status                     as statu
      ,EventType                  as evt_type
      ,PurchaseAttributeStatus    as attr_proc_statu
      ,SendToAdPlatformStatus     as is_noti_ad_plat
      ,MediaSource                as med_src_type
      ,AppsflyerId                as appsflyer_plat_id
      ,EventTime                  as evt_time
      ,Core                       as core
      ,AfAttributeStatus          as af_attr_proc_statu
      ,BundleId                   as bdl_id
      ,Platform                   as plat
  from ods.ods_tidb_sharpengine_analysis_tidb_ads_third_notify
;