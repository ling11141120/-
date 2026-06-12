create or replace view dwd.dwd_sv_tt_vip_subscribe_event_log_view (
     id             comment "主键ID"
    ,tt_open_id     comment "TT用户openid"
    ,event_type     comment "事件类型"
    ,content        comment "事件内容"
    ,trade_order_id comment "TikTok生成的订单号"
    ,is_sandbox     comment "是否沙盒订单"
    ,pay_type       comment "支付类型"
    ,create_time    comment "创建时间"
    ,update_time    comment "更新时间"
    ,sr_createtime  comment "StarRocks数据注入时间"
    ,sr_updatetime  comment "StarRocks数据更新时间"
)
comment "海剧-TikTok订阅回调事件清洗视图"
as
select
     a1.id                                                      as id             -- 主键ID
    ,a1.tt_open_id                                              as tt_open_id     -- TT用户openid
    ,a1.event_type                                              as event_type     -- 事件类型
    ,a1.content                                                 as content        -- 事件内容
    ,get_json_string(a1.content, '$.trade_order_id')            as trade_order_id -- TikTok生成的订单号
    ,if(get_json_string(a1.content, '$.is_sandbox'), 1, 0)      as is_sandbox -- 是否沙盒订单
    ,get_json_string(a1.content, '$.pay_type')                  as pay_type       -- 支付类型
    ,a1.create_time                                             as create_time    -- 创建时间
    ,a1.update_time                                             as update_time    -- 更新时间
    ,a1.sr_createtime                                           as sr_createtime  -- StarRocks数据注入时间
    ,a1.sr_updatetime                                           as sr_updatetime  -- StarRocks数据更新时间
  from ods.ods_tidb_short_video_tt_vip_subscribe_event_log    as a1
;
