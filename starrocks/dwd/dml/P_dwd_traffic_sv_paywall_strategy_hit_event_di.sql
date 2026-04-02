----------------------------------------------------------------
-- 程序功能： 流量域-短剧付费墙策略命中事件表
-- 程序名： P_dwd_traffic_sv_paywall_strategy_hit_event_di
-- 目标表： dwd.dwd_traffic_sv_paywall_strategy_hit_event_di
-- 负责人： qhr
-- 开发日期： 2026-03-30
----------------------------------------------------------------

insert into dwd.dwd_traffic_sv_paywall_strategy_hit_event_di
select a.dt                           as dt                  -- 日期分区
     , array_join(array_slice(
                       split(a.NodeId, '-')
                      ,1
                      ,array_position(split(a.NodeId, '-'), node_level)
                  )
                  ,'-'
       )                              as strategy_node_id    -- 策略节点ID
     , a.Id                           as event_id            -- 事件id
     , cast(a.AccountId as bigint)    as user_id             -- 用户id
     , a.NodeId                       as node_id             -- 策略ID
     , a.CreateTime                   as event_time          -- 事件时间
     , a.VersionId                    as version_id          -- 版本id
     , now()                          as etl_ime             -- 清洗时间
     , a.TemplateId                   as template_id         -- 模板id
  from ods.ods_tidb_short_video_log_paywall_strategy_log    as a
      , unnest(split(NodeId, '-')) as unnest(node_level)
 where dt >= '${bf_1_dt}'
   and dt <= '${dt}'
;