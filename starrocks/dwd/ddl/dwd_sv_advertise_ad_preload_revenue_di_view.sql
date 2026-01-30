create or replace view dwd.dwd_sv_advertise_ad_preload_revenue_di_view(
     id                              comment "唯一ID"
    ,create_time                     comment "创建时间"
    ,account_id                      comment "账户id"
    ,precision_type                  comment "精准投放类型"
    ,value_micros                    comment "值"
    ,currency_code                   comment "货币代码"
    ,ad_unit_id                      comment "广告id"
    ,mediation_adapter_class_name    comment "媒体适配器类名"
    ,update_time                     comment "更新时间"
    ,userid                          comment "用户ID"
    ,mt                              comment "类型"
    ,appver                          comment "版本号"
    ,appid                           comment "应用ID"
    ,chl                             comment "渠道"
    ,langid                          comment "语言ID"
    ,position                        comment "广告位置"
    ,ads_platform                    comment "广告商，218 max广告版本开始上报，旧版本为空"
    ,core                            comment "core"
    ,revenue_precision               comment "精准投放类型(String)"
    ,ad_type                         comment "广告类型：3激励 5插屏"
    ,sr_createtime                   comment "sr入库时间"
    ,sr_updatetime                   comment "sr更新时间"
)
as
select Id                           as id
     , CreateTime                   as create_time
     , AccountId                    as account_id
     , PrecisionType                as precision_type
     , ValueMicros                  as value_micros
     , CurrencyCode                 as currency_code
     , AdUnitId                     as ad_unit_id
     , MediationAdapterClassName    as mediation_adapter_class_name
     , UpdateTime                   as update_time
     , Userid                       as userid
     , Mt                           as mt
     , Appver                       as appver
     , Appid                        as appid
     , Chl                          as chl
     , Langid                       as langid
     , position                     as position
     , adsPlatform                  as ads_platform
     , core                         as core
     , RevenuePrecision             as revenue_precision
     , ifnull(adType, 3)            as ad_type
     , sr_createtime                as sr_createtime
     , sr_updatetime                as sr_updatetime
  from ods.ods_tidb_sv_short_video_log_ad_preload_revenue_di
;