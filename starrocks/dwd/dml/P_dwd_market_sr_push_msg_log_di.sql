----------------------------------------------------------------
-- 程序功能：营销域-海阅push资源位消息推送日志
-- 程序名：P_dwd_market_sr_push_msg_log_di
-- 目标表：dwd.dwd_market_sr_push_msg_log_di
-- 负责人：qhr
-- 开发日期：2026-05-09
----------------------------------------------------------------

insert into dwd.dwd_market_sr_push_msg_log_di
-- 新推送表数据
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
     , coalesce(
         get_json_string(a.Body, '$.aps.attributes.pushId'),
         get_json_string(a.CustomData, '$.push_id')
       )                                                               as push_id       -- push_id，Body/CustomData互补
     , a.ScheduleTime                                               as schedule_time -- 计划推送时间
     , a.ErrorMessage                                               as err_msg_id    -- 消息ID
     , cast(get_json_string(a.CustomData, '$.task_type') as int)    as task_type     -- 任务类型
     , case when b.MT = 1 then get_json_string(a.Body, '$.aps.image')
            when b.MT = 4 then get_json_string(a.Body, '$.Notification.ImageUrl')
            else null
        end                                                         as image_url     -- 图片地址
     , get_json_string(get_json_string(a.Body, '$.aps.attributes.extData'), '$.push_title_id')    as push_title_id     -- push标题ID
     , get_json_string(get_json_string(a.Body, '$.aps.attributes.extData'), '$.push_content_id')  as push_content_id   -- push内容ID
     , now()                                                        as etl_time      -- etl写入时间
  from ods.ods_tidb_unifypush_log_log_pushlog_sr as a
  left join ods.ods_tidb_unifypush_log_apps      as b
    on a.AppId = b.Id
 where a.dt = '${bf_1_dt}'

 union all
-- 旧readerlog数据
select dt                                                        as dt
     , product_id                                                as product_id
     , id                                                        as id
     , create_time                                               as create_time
     , user_id                                                   as user_id
     , app_id                                                    as app_id
     , mt                                                        as mt
     , title                                                     as title
     , token_id                                                  as token_id
     , token                                                     as token
     , body                                                      as body
     , customers                                                 as customers
     , batch_id                                                  as batch_id
     , is_success                                                as is_success
     , push_type                                                 as push_type
     , push_id                                                   as push_id
     , schedule_time                                             as schedule_time
     , err_msg_id                                                as err_msg_id
     , task_type                                                 as task_type
     , image_url                                                 as image_url
     , push_title_id                                             as push_title_id
     , push_content_id                                           as push_content_id
     , etl_time                                                  as etl_time
  from (select r.dt
             , r.product_id
             , r.Id                                               as id
             , r.CreateTime                                       as create_time
             , r.UserId                                           as user_id
             , r.ProdId                                           as app_id
             , r.MT                                               as mt
             , r.Title                                            as title
             , r.TokenId                                          as token_id
             , r.Token                                            as token
             , r.Body                                             as body
             , r.Customers                                        as customers
             , r.BatchId                                          as batch_id
             , case when r.State = 3 then 1 else 0 end            as is_success
             , r.PushType                                         as push_type
             , r.BatchId                                          as push_id
             , r.PushTime                                         as schedule_time
             , r.MessageId                                        as err_msg_id
             , r.TaskType                                         as task_type
             , r.ImageUrl                                         as image_url
             , get_json_string(get_json_string(r.Customers, '$.sensorsdata'), '$.push_title_id')    as push_title_id
             , get_json_string(get_json_string(r.Customers, '$.sensorsdata'), '$.push_content_id')  as push_content_id
             , now()                                              as etl_time
             , row_number() over (partition by r.dt, r.product_id, r.Id order by r.CreateTime desc) as rn
          from ods_log.ods_tidb_readerlog_Log_PushMessageLog as r
         where r.dt = '${bf_1_dt}'
       ) t
 where t.rn = 1
;
