----------------------------------------------------------------
-- 程序功能： 用户推送行为明细表
-- 程序名： P_dws_user_push_behavior_detail_df
-- 目标表： dws.dws_user_push_behavior_detail_df
-- 负责人： xjc
-- 开发日期： 2026-03-05
----------------------------------------------------------------

insert into dws.dws_user_push_behavior_detail_df
-- 海阅推送行为明细数据
with p_info as (
    select batch_id    as push_id
          ,task_type
          ,case when task_type = '0' then '通知类'
                when task_type = '1' then '全站/指定推送'
                when task_type = '2' then '书籍流失召回'
                when task_type = '3' then '章节更新'
                when task_type = '5' then '私信推送'
                when task_type = '6' then '兜底角标推送'
                when task_type = '7' then '单个私信推送'
                when task_type = '8' then '刷新数据通知'
                when task_type = '9' then '引流书PUSH'
                else '其他'
            end        as task_type_name
          ,case when task_type = '3' then '章节更新'
                else '-'
            end        as push_name
      from dwd.dwd_market_sr_push_msg_log_di    as a1
     where a1.dt >= '${bf_9_dt}'
       and a1.dt <= '${bf_1_dt}'
       and task_type <> 4
     group by 1, 2, 3, 4
     union
    select id      as push_id
          ,4       as task_type
          ,case when action_type = 1 then 'PUSH-定向充值'
                when action_type = 2 then 'PUSH-PUSH活动'
                when action_type = 4 then 'PUSH-推书（指定书籍）'
                when action_type = 5 then 'PUSH-其他活动'
                when action_type = 6 then 'PUSH-消费活动'
                when action_type = 7 then 'PUSH-组合活动'
                when action_type = 8 then 'PUSH-推书活动（书单）'
                when action_type = 13 then 'PUSH-限免卡活动'
                when action_type = 23 then 'PUSH-章节召回'
                when action_type = '25' then 'PUSH-福利中心'
                when action_type = '27' then 'PUSH-推书活动（折扣）'
                else '其他'
            end    as task_type_name
          ,name    as push_name
      from dim.dim_tag_center_activity_push_view    as a1
     where id > 1000
     group by 1, 2, 3, 4
)
, send_view as (
    select '下发'    as event
          ,a1.dt
          ,a1.id
          ,a1.push_id
          ,a1.user_id
          ,a1.product_id
          ,a1.task_type
          ,a1.msg_on
      from (select b1.dt
                  ,b1.id
                  ,b1.batch_id             as push_id
                  ,b1.user_id              as user_id
                  ,b1.product_id
                  ,b1.task_type
                  ,2                       as msg_on
              from dwd.dwd_market_sr_push_msg_log_di    as b1
             where b1.is_success = 1
               and b1.product_id not in (6833, 6883)
               and b1.dt >= '${bf_2_dt}'
               and b1.dt <= '${bf_1_dt}'
               and user_id is not null
               and batch_id is not null
           )    as a1
)
, push_send_result as (
    select '送达'    as event
          ,a1.dt
          ,a1.id
          ,a1.push_id
          ,a1.user_id
          ,a1.product_id
          ,a1.task_type
          ,a1.msg_on
      from (select date(b1.event_time)    as dt
                  ,b1.id
                  ,b2.batch_id            as push_id
                  ,b2.user_id
                  ,b2.product_id
                  ,b2.task_type
                  ,2                      as msg_on
              from (select dt
                          ,id
                          ,instance_id
                          ,message_id
                          ,product_id
                          ,event_time
                      from dwd.dwd_market_log_bigquerylog_view
                     where message_id is not null
                       and event_type = 'MESSAGE_DELIVERED'
                       and dt = '${bf_1_dt}'
                       and date(event_time) >= '${bf_9_dt}'
                       and date(event_time) <= '${bf_1_dt}'
                   )    as b1
              left join (select err_msg_id as message_id
                               ,batch_id
                               ,user_id
                               ,product_id
                               ,task_type
                               ,split_part(token, ':', 1) as instance_id
                               ,dt
                           from dwd.dwd_market_sr_push_msg_log_di
                          where dt >= '${bf_15_dt}'
                            and dt <= '${bf_1_dt}'
                            and is_success = 1
                            and product_id not in (6833, 6883)
                          group by 1,2,3,4,5,6,7
                        )   as b2
                on b2.message_id = b1.message_id
               and b2.instance_id = b1.instance_id
               and b2.product_id = b1.product_id
               and date(b1.event_time) >= b2.dt
               and date(b1.event_time) <= date_add(b2.dt, 15)
             union all
            select b1.dt
                  ,b1.id
                  ,b1.f1    as push_id
                  ,b1.user_id
                  ,b1.product_id
                  ,4        as task_type
                  ,2        as msg_on
              from ads.ads_user_commonactionlog_view    as b1
             where b1.dt = '${bf_1_dt}'
               and action = 'ApnsReceived'
           )    as a1
     where a1.push_id is not null
       and a1.user_id is not null

)
, push_click as (
    select '点击'          as event
          ,a1.dt
          ,a1.id
          ,a1.push_id
          ,a1.uid          as user_id
          ,a1.product_id
          ,a1.push_type    as task_type
          ,a1.msg_on
          ,a1.task_type_name
          ,a1.push_name
      from (select b1.dt
                  ,b1.id
                  ,b1.push_id                                   as push_id
                  ,CASE WHEN b1.push_type = 99 THEN '本地签到'
                        WHEN b3.task_type is null THEN '其他本地推送'  
                        ELSE b3.task_type_name END AS task_type_name
                  ,b3.push_name
                  ,b1.identity_login_id                         as uid
                  ,coalesce(b1.app_product_id,b2.product_id)    as product_id
                  ,b1.push_type
                  ,2                                            as msg_on
              from ads.ads_sensors_production_pushclick_view    as b1
              left join (select dt
                               ,product_id
                               ,user_id
                               ,row_number() over (partition by dt,user_id order by product_id)    as rn
                           from dim.dim_short_read_user_accountinfo_daily
                          where dt='${bf_1_dt}'
                        )    as b2
                on b1.login_id=b2.user_id
               and b2.rn=1
               left join p_info     as b3
                on b1.push_id = b3.push_id
             where b1.dt = '${bf_1_dt}'
               and b1.project_id = 5
               and b1.push_id is not null
               and b1.identity_login_id is not null
               and b1.id is not null
           )    as a1
)
, z_result as (
    select event
          ,a1.dt
          ,a1.id
          ,if(event='点击'
             ,a1.task_type_name
             ,a5.task_type_name
             )     as push_type
          ,a1.push_id
          ,if(event='点击'
             ,a1.push_name
             ,a5.push_name
             )     as push_name
          ,if(event='送达'
             ,case when a4.corever = 2 and a4.app_ver >= '3.9.5' then a1.user_id
                   when a4.corever = 2 and a4.app_ver < '3.9.5' then -99
                   else a1.user_id
               end
             ,a1.user_id
            )      as user_id
          ,a4.corever
          ,case when a4.mt = 1 then 'iOS'
                when a4.mt = 4 then 'Android'
                else '其他'
            end    as mt
          ,a1.msg_on
          ,if(a2.user_id is not null
             , 1
             , 0
             )     as is_act
          ,case when a4.app_notify = 1 then 1
                else a1.msg_on
            end    as app_notify_msg_on
          ,a1.product_id
      from (select event
                  ,dt
                  ,id
                  ,push_id
                  ,user_id
                  ,product_id
                  ,task_type
                  ,msg_on
                  ,null    as task_type_name
                  ,null    as push_name
              from send_view
             union all
            select event
                  ,dt
                  ,id
                  ,push_id
                  ,user_id
                  ,product_id
                  ,task_type
                  ,msg_on
                  ,null
                  ,null
              from push_send_result
             union all
            select event
                  ,dt
                  ,id
                  ,push_id
                  ,user_id
                  ,product_id
                  ,task_type
                  ,msg_on
                  ,task_type_name
                  ,push_name
              from push_click
           )                                               as a1
      left join dws.dws_user_wide_active_period_ed         as a2
        on a1.user_id = a2.user_id
       and a1.dt = a2.dt
       and a1.product_id = a2.product_id
       and a2.period_type = 'ctt'
       and a2.dt >= '${bf_9_dt}'
       and a2.dt <= '${bf_1_dt}'
      left join dim.dim_short_read_user_accountinfo_zip    as a4
        on a1.user_id = a4.user_id
       and a1.product_id = a4.product_id
       and a1.dt >= a4.start_dt
       and a1.dt <= a4.end_dt
      left join p_info                                     as a5
        on a1.push_id = a5.push_id
       and a1.task_type = a5.task_type
       and a1.event in('下发','送达')
)
select dt
      ,ifnull(cast(product_id as int),-99)    as product_id            -- 产品id
      ,event                                  as event                 -- event类型
      ,id                                     as id                    -- id
      ,ifnull(cast(push_id as bigint),-99)    as push_id               -- 推送id
      ,ifnull(cast(user_id as bigint),-99)    as user_id               -- 用户id
      ,ifnull(corever,-99)                    as core                  -- 核core心版本
      ,ifnull(mt,-99)                         as mt                    -- 操作系统
      ,ifnull(push_type,-99)                  as push_type             -- 推送类型
      ,ifnull(push_name,-99)                  as push_name             -- 推送名称
      ,msg_on                                 as msg_on                -- 消息通知开关
      ,is_act                                 as is_act                -- 是否活跃
      ,app_notify_msg_on                      as app_notify_msg_on     -- APP通知消息开关
      ,now()                                  as etl_tm                -- 处理时间
  from z_result
;




insert into dws.dws_user_push_behavior_detail_df
with send_view as (
    select '下发'    as event
          ,a1.dt
          ,a1.id
          ,a1.push_type
          ,a1.push_id
          ,a1.user_id
          ,a1.msg_on
      from (select date(need_to_send_time)    as dt
                  ,id
                  ,case when push_position_id = 1 then '签到push'
                        when push_position_id = 2 then '小安私信'
                        else b1.push_type
                    end                       as push_type
                  ,push_position_id           as push_id
                  ,account_id                 as user_id
                  ,2                          as msg_on
              from ads.ads_center_push_position_message_di_analysis_json                        as b1
             where 1 = 1
               and (send_status = 1 or (push_position_id in (1, 2)))
               and b1.dt = '${bf_1_dt}'
               and date(b1.need_to_send_time) = '${bf_1_dt}'
               and date(b1.update_time) = '${bf_1_dt}'
           )    as a1
)
, push_send_result as (
    select '送达'    as event
          ,a1.dt
          ,a1.id
          ,a1.push_type
          ,a1.push_id
          ,a1.user_id
          ,a1.msg_on
      from (select date(b1.eventtime)     as dt
                  ,b1.id
                  ,b2.push_type
                  ,b2.push_position_id    as push_id
                  ,b2.account_id          as user_id
                  ,2                      as msg_on
              from (select c1.eventtime
                          ,c1.id
                          ,c1.instanceid
                          ,c1.messageid
                          ,c1.eventtype
                      from ods.ods_tidb_unifypush_log_log_bigquerylog_sv    as c1
                     where eventtype = 'MESSAGE_DELIVERED'
                       and c1.messageid is not null
                       and date(c1.eventtime) >= '${bf_9_dt}'
                       and date(c1.eventtime) <= '${bf_1_dt}'
                       and dt='${bf_1_dt}'
                   )    as b1
              left join (select error_message
                               ,split_part(token, ':', 1)    as instanceid
                               ,dt
                               ,push_position_id
                               ,account_id
                               ,send_status
                               ,push_type
                           from ads.ads_center_push_position_message_di_analysis_json
                          where dt >= '${bf_15_dt}'
                            and dt <= '${bf_1_dt}'
                        )    as b2
                on b1.messageid = b2.error_message
               and b1.instanceid = b2.instanceid
               and date(b1.eventtime) >= b2.dt
               and date(b1.eventtime) <= date_add(b2.dt, 15)
             where b2.send_status = 1
             union all
            select b1.dt
                  ,b1.id
                  ,b1.push_type
                  ,b1.push_id
                  ,login_id    as user_id
                  ,2           as msg_on
              from ods_log.ods_sensors_cd_video_pushdelivery    as b1
             where b1.dt = '${bf_1_dt}'
           )    as a1
)
, push_click as (
    select '点击'    as event
          ,a1.dt
          ,a1.id
          ,a1.push_type
          ,a1.push_id
          ,a1.user_id
          ,a1.corever
          ,a1.mt
          ,a1.msg_on
      from (select b1.dt
                  ,b1.id
                  ,case when push_id = 1 then '签到push'
                        when push_id = 2 then '小安私信'
                        when b1.push_type is null then '签到push'
                        when b1.push_type = '' then '签到push'
                        else b1.push_type
                    end                        as push_type
                  ,push_id
                  ,login_id                    as user_id
                  ,substr(b1.app_id, -4, 1)    as corever
                  ,b1.os                       as mt
                  ,2                           as msg_on
              from ads.ads_sensors_video_pushclick_view    as b1
             where b1.dt between '${bf_10_dt}' and '${bf_1_dt}'
               and project_id = 8
           )    as a1
     where 1 = 1
)
, z_result as (
    select a1.event
          ,a1.dt
          ,a1.id
          ,a1.push_type
          ,a1.push_id
          ,if(a1.event='点击'
             ,case when a1.push_id='101' and a1.push_type='1' then '本地PUSH-定时签到'
		   		         when a1.push_id='101' and a1.push_type='2' then '本地PUSH-沉默召回'
				           when a1.push_id='101' and a1.push_type='3' then '本地PUSH-解锁屏幕'
                   else a4.push_position_name 
               end
             ,a4.push_position_name
             )                                 as push_name
          ,a1.user_id
          ,a5.corever
          ,case when a5.mt = 1 then 'iOS'
                when a5.mt = 4 then 'Android'
                else '其他'
            end                                as mt
          ,a1.msg_on
          ,if(a2.user_id is not null, 1, 0)    as is_act
          ,case when a5.app_notify = 1 then 1
                else a1.msg_on
            end                                as app_notify_msg_on
      from (select event
                  ,dt
                  ,id
                  ,push_type
                  ,push_id
                  ,user_id
                  ,msg_on
              from send_view
             union all
            select event
                  ,dt
                  ,id
                  ,push_type
                  ,push_id
                  ,user_id
                  ,msg_on
              from push_send_result
             union all
            select event
                  ,dt
                  ,id
                  ,push_type
                  ,push_id
                  ,user_id
                  ,msg_on
              from push_click
           )                                                          as a1
      left join dws.dws_user_short_video_wide_active_period_ed        as a2
        on a1.user_id = a2.user_id
       and a1.dt = a2.dt
       and a2.period_type = 'ctt'
      left join ads.ads_tidb_short_video_center_push_position_view    as a4
        on a1.push_id = a4.id
      left join dim.dim_short_video_user_accountinfo_zip              as a5
        on a1.user_id = a5.user_id
       and a1.dt >= a5.start_dt
       and a1.dt <= a5.end_dt
)
select dt                                     as dt                   -- 日期
      ,6833                                   as product_id           -- 产品id
      ,event                                  as event                -- event类型
      ,id                                     as id                   -- id
      ,ifnull(cast(push_id as bigint),-99)    as push_id              -- 推送id
      ,ifnull(cast(user_id as bigint),-99)    as user_id              -- 用户id
      ,ifnull(corever,-99)                    as core                 -- 核core心版本
      ,ifnull(mt,-99)                         as mt                   -- 操作系统
      ,ifnull(push_type,-99)                  as push_type            -- 推送类型
      ,ifnull(push_name,-99)                  as push_name            -- 推送名称
      ,msg_on                                 as msg_on               -- 消息通知开关
      ,is_act                                 as is_act               -- 是否活跃
      ,app_notify_msg_on                      as app_notify_msg_on    -- APP通知消息开关
      ,now()                                  as etl_tm               -- 处理时间
  from z_result
;
