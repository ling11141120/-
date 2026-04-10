create or replace view ads.ads_traffic_sv_paywall_strategy_hit_event_view (
     dt                  comment "日期"
    ,strategy_node_id    comment "策略节点ID"
    ,event_id            comment "事件id"
    ,user_id             comment "用户id"
    ,strategy_id         comment "策略id"
    ,event_time          comment "事件时间"
    ,version_id          comment "版本id"
    ,template_id         comment "模板id"
    ,etl_ime             comment "清洗时间"
)
comment "流量域-海剧付费墙策略命中事件视图"
as
select dt
     , strategy_node_id
     , event_id
     , user_id
     , if(strategy_node_id = node_id, node_id, null) as strategy_id
     , event_time
     , version_id
     , template_id
     , etl_ime
  from dwd.dwd_traffic_sv_paywall_strategy_hit_event_di
;