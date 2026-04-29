----------------------------------------------------------------
-- 程序功能： push资源位需要推送的消息表
-- 程序名： P_dwd_center_push_position_message_di
-- 目标表： dwd.dwd_center_push_position_message_di
-- 负责人： qhr
-- 开发日期： 2025-10-15
-- 版本号： v0.0.0
----------------------------------------------------------------

insert into dwd.dwd_center_push_position_message_di
-- IOS
select dt                                                               as dt
      ,Id                                                               as id
      ,get_json_string(Body, '$.custom.pushId')                         as push_position_id
      ,date_format(date_sub(CreateTime, interval 13 hour), '%Y%m%d')    as generate_day
      ,get_json_string(Body, '$.custom.accountId')                      as account_id
      ,AppId                                                            as app_id
      ,Body                                                             as msg_body
      ,-28800                                                           as utc_offset
      ,ScheduleTime                                                     as need_to_send_time
      ,IsSuccess                                                        as send_status
      ,SendTime                                                         as send_success_time
      ,Token                                                            as token
      ,ErrorMessage                                                     as error_message
      ,get_json_string(Body, '$.custom.titleId')                        as title_id
      ,get_json_string(Body, '$.custom.contentId')                      as content_id
      ,CreateTime                                                       as create_time
      ,CreateTime                                                       as update_time
      ,now()                                                            as etl_time
  from ods.ods_tidb_unifypush_log_log_pushlog_sv
 where CreateTime>='${bf_1_dt}'
   and AppId % 2 = 1
   and IsSuccess = 1
   and get_json_string(Body, '$.custom.accountId') is not null
union all
-- 安卓
select dt
      ,Id                                                               as id
      ,get_json_string(get_json_string(Body, '$.Data.custom'), '$.pushId') as push_position_id
      ,date_format(date_sub(CreateTime, interval 13 hour), '%Y%m%d')    as generate_day
      ,get_json_string(get_json_string(Body, '$.Data.custom'), '$.accountId') as account_id
      ,AppId                                                            as app_id
      ,Body                                                             as msg_body
      ,-28800                                                           as utc_offset
      ,ScheduleTime                                                     as need_to_send_time
      ,IsSuccess                                                        as send_status
      ,SendTime                                                         as send_success_time
      ,Token                                                            as token
      ,ErrorMessage                                                     as error_message
      ,get_json_string(get_json_string(Body, '$.Data.custom'), '$.titleId') as title_id
      ,get_json_string(get_json_string(Body, '$.Data.custom'), '$.contentId') as content_id
      ,CreateTime                                                       as create_time
      ,CreateTime                                                       as update_time
      ,now()                                                            as etl_time
  from ods.ods_tidb_unifypush_log_log_pushlog_sv
 where CreateTime>='${bf_1_dt}' 
   and AppId % 2 = 0 
   and IsSuccess = 1 
   and get_json_string(get_json_string(Body, '$.Data.custom'), '$.accountId') is not null
;