create or replace view ads.ads_flow_app_client_biz_admobaderror_view (
     dt              comment "日期"
    ,app_id          comment "app_id"
    ,corever         comment "core"
    ,mt              comment "设备"
    ,product_id      comment "产品id"
    ,app_ver         comment "应用版本"
    ,biz_type        comment "报错类型"
    ,biz_ads_type    comment "报错类型"
    ,biz_msg         comment "报错内容"
    ,cnt             comment "数量"
    ,etl_tm          comment "清洗时间"
)
comment "客户端上报错误 admobaderror"
as
select dt
     , app_id
     , corever
     , mt
     , product_id
     , app_ver
     , biz_type
     , biz_ads_type
     , biz_msg
     , cnt
     , etl_tm
  from dws.dws_flow_app_client_biz_admobaderror_ed
;