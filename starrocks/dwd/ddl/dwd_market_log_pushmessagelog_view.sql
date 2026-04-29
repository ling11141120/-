create view `dwd_market_log_pushmessagelog_view`
            (`dt` comment "createtime 分区", `product_id` comment "产品id", `id` comment "id",
             `create_time` comment "插入时间", `user_id` comment "用户id", `active_user_id` comment "活跃用户id",
             `prod_id` comment "产品id", `mt` comment "平台", `title` comment "标题", `token_id` comment "tokenid",
             `token` comment "令牌", `body` comment "内容", `customers` comment "推送下发参数",
             `param` comment "辅助参数", `batch_id` comment "批次id",
             `state` comment "状态:0未入列1已入列2已出列3已推送4推送失败5token不存在6fcm有效投递7fcm送达8已发站内信",
             `update_time` comment "更新时间", `push_response` comment "推送结果",
             `push_type` comment "推送类型 1常规 2私信", `push_time` comment "计划推送时间",
             `message_id` comment "消息 id 用于标识消息（fcm使用）", `token_type` comment "0友盟1fcm2华为",
             `task_type` comment "任务类型1tag中台推送2全站推送3召回推送任务4章节更新推送",
             `image_url` comment "信息url", `is_silent` comment "是否静默 1：是 0：否",
             `sr_createtime` comment "starrocks数据注入时间", `sr_updatetime` comment "starrocks数据更新时间")
as
select `ods_log`.`a`.`dt`
     , `ods_log`.`a`.`product_id`
     , `ods_log`.`a`.`id`
     , `ods_log`.`a`.`createtime`   as `create_time`
     , `ods_log`.`a`.`userid`       as `user_id`
     , `b`.`user_id`                as `active_user_id`
     , `ods_log`.`a`.`prodid`       as `prod_id`
     , `ods_log`.`a`.`mt`
     , `ods_log`.`a`.`title`
     , `ods_log`.`a`.`tokenid`      as `token_id`
     , `ods_log`.`a`.`token`
     , `ods_log`.`a`.`body`
     , `ods_log`.`a`.`customers`
     , `ods_log`.`a`.`param`
     , `ods_log`.`a`.`batchid`      as `batch_id`
     , `ods_log`.`a`.`state`
     , `ods_log`.`a`.`updatetime`   as `update_time`
     , `ods_log`.`a`.`pushresponse` as `push_response`
     , `ods_log`.`a`.`pushtype`     as `push_type`
     , `ods_log`.`a`.`pushtime`     as `push_time`
     , `ods_log`.`a`.`messageid`    as `message_id`
     , `ods_log`.`a`.`tokentype`    as `task_type`
     , `ods_log`.`a`.`tasktype`     as `task_type`
     , `ods_log`.`a`.`imageurl`     as `image_url`
     , `ods_log`.`a`.`issilent`     as `is_silent`
     , `ods_log`.`a`.`sr_createtime`
     , `ods_log`.`a`.`sr_updatetime`
  from `ods_log`.`ods_tidb_readerlog_Log_PushMessageLog` as `a`
  left outer join (select `dws`.`dws_user_wide_active_period_ed`.`dt`, `dws`.`dws_user_wide_active_period_ed`.`user_id`
                     from `dws`.`dws_user_wide_active_period_ed`
                    group by `dws`.`dws_user_wide_active_period_ed`.`dt`
                           , `dws`.`dws_user_wide_active_period_ed`.`user_id`
                   )                                        `b`
  on ((date(`ods_log`.`a`.`UpdateTime`)) = `b`.`dt`) and (`ods_log`.`a`.`UserId` = `b`.`user_id`);