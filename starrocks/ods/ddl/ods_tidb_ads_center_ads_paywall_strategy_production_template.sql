----------------------------------------------------------------
-- 目标表：ods.ods_tidb_ads_center_ads_paywall_strategy_production_template
-- 来源实例： old_tidb_source
-- 来源表： ads_center.ads_paywall_strategy_production_template
-- 来源负责：
-- 采集工具：SeaTunnel
-- 开发人：xjc
-- 创建日期：2026-04-17
----------------------------------------------------------------

drop table if exists ods.ods_tidb_ads_center_ads_paywall_strategy_production_template;
create table ods.ods_tidb_ads_center_ads_paywall_strategy_production_template (
    id               int               not null                    comment "主键"
   ,strategyid       int               not null                    comment "所属策略Id"
   ,nodeid           varchar(65533)    not null                    comment "节点Id"
   ,templateid       bigint            not null                    comment "模板Id"
   ,createtime       datetime          not null                    comment "创建时间"
   ,sr_createtime    datetime          default current_timestamp   comment "starrocks入库时间"
   ,sr_updatetime    datetime          default current_timestamp   comment "starrocks数据更新时间"
)
primary key (id)
comment "付费墙策略正式模板表"
distributed by hash(id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "lz4"
)
;