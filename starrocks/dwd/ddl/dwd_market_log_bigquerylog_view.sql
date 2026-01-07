create or replace view dwd.dwd_market_log_bigquerylog_view(
     dt               comment "日期分区"
    ,product_id       comment "product_id"
    ,id               comment "自增id"
    ,prod_id          comment "产品id"
    ,event_time       comment "事件时间"
    ,message_id       comment "消息id"
    ,instance_id      comment "实例id"
    ,message_type     comment "消息类型"
    ,event_type       comment "事件类型"
    ,create_time      comment "创建时间"
    ,sr_createtime    comment "starrocks数据注入时间"
    ,sr_updatetime    comment "starrocks数据更新时间"
)
comment "push推送 送达相关日志表"
as
select dt               as dt
     , Id               as product_id
     , product_id       as id
     , ProdId           as prod_id
     , EventTime        as event_time
     , MessageId        as message_id
     , InstanceId       as instance_id
     , MessageType      as message_type
     , EventType        as event_type
     , CreateTime       as create_time
     , sr_createtime    as sr_createtime
     , sr_updatetime    as sr_updatetime
  from ods.ods_tidb_unifypush_log_log_bigquerylog_sr
;