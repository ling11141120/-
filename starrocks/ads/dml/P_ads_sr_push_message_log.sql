----------------------------------------------------------------
-- 程序功能： push推送日志，从DWD层取清洗后数据写入ADS
-- 程序名： P_ads_sr_push_message_log
-- 目标表： ads.ads_sr_push_message_log
-- 负责人： qhr
-- 开发日期：2026-05-11
----------------------------------------------------------------

insert into ads.ads_sr_push_message_log
select a.dt
     , a.product_id
     , a.id
     , a.create_time
     , a.user_id
     , b.user_id          as active_user_id
     , a.app_id           as prod_id
     , a.mt
     , a.title
     , a.token_id
     , a.token
     , a.body
     , a.customers
     , null               as param
     , a.batch_id
     , null               as state
     , null               as update_time
     , a.is_success       as push_response
     , a.push_type
     , a.schedule_time    as push_time
     , a.err_msg_id       as message_id
     , null               as token_type
     , a.task_type
     , a.image_url
     , null               as is_silent
     , now()              as etl_time
     , a.push_title_id
     , a.push_content_id
  from dwd.dwd_market_sr_push_msg_log_di as a
  left join (select dt
                  , user_id
               from dws.dws_user_wide_active_period_ed
              where dt >= '${bf_1_dt}'
              group by dt, user_id
             )                           as b
    on a.dt = b.dt
   and a.user_id = b.user_id
 where a.dt >= '${bf_1_dt}'
;
