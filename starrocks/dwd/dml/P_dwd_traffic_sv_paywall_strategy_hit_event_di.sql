----------------------------------------------------------------
-- 程序功能： 流量域-短剧付费墙策略命中事件表
-- 程序名： P_dwd_traffic_sv_paywall_strategy_hit_event_di
-- 目标表： dwd.dwd_traffic_sv_paywall_strategy_hit_event_di
-- 负责人： qhr
-- 开发日期： 2026-03-30
----------------------------------------------------------------

insert into dwd.dwd_traffic_sv_paywall_strategy_hit_event_di
select a1.dt                                        as dt                 -- 日期分区
     , md5(concat(ifnull(nullif(cast(a1.id as varchar), ''), '-99')
                 ,ifnull(nullif(a1.unnest_node_id, ''), '-99')
                 ,ifnull(nullif(cast(a1.map_node_id as varchar), ''), '-99')
                 )
          )                                         as md5_key            -- md5唯一键
     , a1.id                                        as id                 -- id
     , ifnull(nullif(a1.unnest_node_id, ''), '-99') as unnest_node_id     -- 拆解节点id
     , ifnull(nullif(a1.map_node_id, ''), '-99')    as map_node_id        -- 映射节点id
     , ifnull(nullif(a1.node_id_path, ''), '-99')   as node_id_path       -- 节点id路径
     , a1.user_id                                   as user_id            -- 用户id
     , a1.core                                      as core               -- 版本id
     , a1.strategy_type                             as strategy_type      -- 策略类型
     , a1.code                                      as code               -- 业务状态码
     , a1.version_id                                as version_id         -- 策略id即版本id
     , a1.template_id                               as template_id        -- 模板id
     , a1.node_path                                 as node_path          -- 节点名称路径
     , a1.is_default                                as is_default         -- 是否走了兜底逻辑
     , a1.message                                   as message            -- 响应消息
     , a1.create_time                               as create_time        -- 创建时间
     , a1.etl_ime                                   as etl_ime            -- 清洗时间
  from (select b1.dt                  as dt                  -- 日期分区
             , b1.Id                  as id                  -- id
             , array_join(array_slice(
                               split(b1.real_node_id_path, '-')
                              ,1
                              ,array_position(split(b1.real_node_id_path, '-'), node_level)
                                     )
                                     ,'-'
                         )            as unnest_node_id      -- 拆解节点id
             , b1.real_node_id_path   as node_id_path        -- 节点id路径
             , b1.user_id             as user_id             -- 用户id
             , b1.corever             as core                -- 版本id
             , b1.strategy_type       as strategy_type       -- 策略类型
             , b1.code                as code                -- 业务状态码
             , b1.strategy_id         as version_id          -- 策略id即版本id
             , b1.template_id         as template_id         -- 模板id
             , b1.node_path           as node_path           -- 节点名称路径
             , b1.is_default          as is_default          -- 是否走了兜底逻辑
             , b1.message             as message             -- 响应消息
             , b1.create_time         as create_time         -- 创建时间
             , b1.map_node_id         as map_node_id         -- 映射节点id
             , now()                  as etl_ime             -- 清洗时间
          from (select c1.dt
                     , c1.Id
                     , c1.user_id
                     , c1.corever
                     , c1.strategy_type
                     , c1.code
                     , c1.strategy_id
                     , c1.template_id
                     , c1.node_path
                     , c1.is_default
                     , c1.message
                     , c1.create_time
                     , ifnull(c2.node_id, split_part(c1.node_id_path, '-', 3)) as real_node_id_path      -- 3220-3223-3227/0
                     , c1.node_id_path    as map_node_id                                               -- FFQ-629-3175/FFQ-629-0
                  from ods.ods_tidb_short_video_log_paywall_strategy_log as c1
                  left join dim.dim_paywall_strategy_node_map_view as c2
                    on split_part(c1.node_id_path, '-', 3) = cast(c2.id as varchar)
                 where c1.dt >= '${bf_1_dt}'
                   and c1.dt <= '${dt}'
               ) as b1
               , unnest(split(b1.real_node_id_path, '-')) as unnest(node_level)
       ) as a1
;