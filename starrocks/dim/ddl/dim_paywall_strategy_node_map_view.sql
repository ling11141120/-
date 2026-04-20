create or replace view dim.dim_paywall_strategy_node_map_view (
     id                comment "主键"
    ,strategy_id       comment "所属策略Id"
    ,node_id           comment "节点Id"
    ,template_id       comment "模板Id"
    ,create_time       comment "创建时间"
    ,sr_createtime     comment "starrocks入库时间"
    ,sr_updatetime     comment "starrocks数据更新时间"
)
comment "付费墙策略id映射"
as
select id
      ,strategyid
      ,nodeid
      ,templateid
      ,createtime
      ,sr_createtime
      ,sr_updatetime
  from ods.ods_tidb_ads_center_ads_paywall_strategy_production_template
;
