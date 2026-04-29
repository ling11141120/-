----------------------------------------------------------------
-- 程序功能： 用户推送行为标签表
-- 程序名： P_ads_user_push_behavior_df
-- 目标表： ads.ads_user_push_behavior_df
-- 负责人： xjc
-- 开发日期： 2026-03-05
-- 版本号： v0.0.0
----------------------------------------------------------------

insert into ads.ads_user_push_behavior_df
select dt                   as dt                   -- 日期
      ,project_id           as project_id           -- 项目id
      ,md5(concat_ws('|'
          , dt
          , project_id
          , push_id
          , user_id
          , core
          , mt
          , push_type
          )
      )                     as md5_key              -- md5_key
      ,push_id              as push_id              -- 推送id
      ,user_id              as user_id              -- 用户id
      ,core                 as core                 -- 核心
      ,mt                   as mt                   -- 媒体
      ,push_type            as push_type            -- 推送类型
      ,push_name            as push_name            -- 推送名称
      ,is_act               as is_act               -- 是否激活
      ,is_send              as is_send              -- 是否送达
      ,is_received          as is_received          -- 是否收到
      ,is_click             as is_click             -- 是否点击
      ,app_notify_msg_on    as app_notify_msg_on    -- 是否开启通知
      ,etl_tm               as etl_tm               -- 处理时间
  from (select dt
              ,if(product_id=6833,8,5)    as project_id
              ,push_id
              ,user_id
              ,core
              ,mt
              ,push_type
              ,push_name
              ,max(if(event = '下发', 1, null))            as is_send
              ,max(if(event = '送达', 1, null))            as is_received
              ,max(if(event = '点击', 1, null))            as is_click
              ,max(if(app_notify_msg_on = 1, 1, null))     as app_notify_msg_on
              ,now()    as etl_tm
              ,is_act                                     as is_act
          from dws.dws_user_push_behavior_detail_df
         where dt >= '${bf_10_dt}'
           and dt<='${bf_1_dt}'
         group by 1, 2, 3, 4, 5, 6, 7, 8, 14
 )    as a1
;