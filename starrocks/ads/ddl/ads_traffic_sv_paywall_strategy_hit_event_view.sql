create or replace view ads.ads_traffic_sv_paywall_strategy_hit_event_view (
     dt                  comment "日期"
    ,md5_key             comment "md5唯一键"
    ,event_id            comment "事件id"
    ,strategy_node_id    comment "策略裂变节点ID"
    ,map_strategy_id     comment "映射节点ID"
    ,strategy_id         comment "完整节点id路径"
    ,user_id             comment "用户id"
    ,core                comment "应用版本号"
    ,strategy_type       comment "策略类型"
    ,code                comment "业务状态码"
    ,version_id          comment "版本id"
    ,template_id         comment "模板id"
    ,node_path           comment "节点名称路径"
    ,is_default          comment "是否走了兜底逻辑"
    ,message             comment "响应消息"
    ,create_time         comment "创建时间"
    ,etl_ime             comment "清洗时间"
)
comment "流量域-海剧付费墙策略命中事件视图"
as
select dt
      ,md5_key
      ,id
      ,unnest_node_id    as strategy_node_id
      ,map_node_id       as map_strategy_id
      ,node_id_path      as strategy_id
      ,user_id
      ,core
      ,strategy_type
      ,code
      ,version_id
      ,template_id
      ,node_path
      ,is_default
      ,message
      ,create_time
      ,etl_ime
  from dwd.dwd_traffic_sv_paywall_strategy_hit_event_di
;