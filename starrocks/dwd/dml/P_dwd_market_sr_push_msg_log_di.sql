----------------------------------------------------------------
-- 程序功能：营销域-海阅push资源位消息推送日志
-- 程序名：P_dwd_market_sr_push_msg_log_di
-- 目标表：dwd.dwd_market_sr_push_msg_log_di
-- 负责人：qhr
-- 开发日期：2026-05-09
----------------------------------------------------------------

insert into dwd.dwd_market_sr_push_msg_log_di
select a.dt                                                         as dt            -- 分区日期
     , b.ProductId                                                  as product_id    -- 产品ID
     , a.Id                                                         as id            -- Id
     , a.CreateTime                                                 as create_time   -- 插入时间
     , a.AccountId                                                  as user_id       -- 用户Id
     , a.AppId                                                      as app_id        -- 产品ID
     , b.MT                                                         as mt            -- 平台
     , case when b.MT = 1 then get_json_string(get_json_string(a.Body, '$.aps.alert'), '$.title')
            when b.MT = 4 then get_json_string(a.Body, '$.Notification.Title')
            else null
        end                                                         as title         -- 标题
     , a.DeviceId                                                   as token_id      -- TokenId
     , a.Token                                                      as token         -- 令牌
     , a.Body                                                       as body          -- Push内容
     , a.CustomData                                                 as customers     -- 自定义参数
     , a.BatchId                                                    as batch_id      -- 批次Id
     , a.IsSuccess                                                  as is_success    -- 是否推送成功
     , cast(get_json_string(a.CustomData, '$.push_type') as int)    as push_type     -- 推送类型
     , cast(get_json_string(a.CustomData, '$.push_id') as bigint)   as push_id       -- push_id
     , a.ScheduleTime                                               as schedule_time -- 计划推送时间
     , a.ErrorMessage                                               as err_msg_id    -- 消息ID
     , cast(get_json_string(a.CustomData, '$.task_type') as int)    as task_type     -- 任务类型
     , case when b.MT = 1 then get_json_string(a.Body, '$.aps.image')
            when b.MT = 4 then get_json_string(a.Body, '$.Notification.ImageUrl')
            else null
        end                                                         as image_url     -- 图片地址
     , cast(get_json_string(get_json_string(a.Body, '$.aps.attributes.extData'), '$.push_title_id') as bigint)    as push_title_id     -- push标题ID
     , cast(get_json_string(get_json_string(a.Body, '$.aps.attributes.extData'), '$.push_content_id') as bigint)  as push_content_id  -- push内容ID
     , now()                                                        as etl_time      -- etl写入时间
  from ods.ods_tidb_unifypush_log_log_pushlog_sr as a
  left join ods.ods_tidb_unifypush_log_apps      as b
    on a.AppId = b.Id
 where a.dt = '${bf_1_dt}'
;
