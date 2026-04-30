insert into ads.ads_sr_push_message_log
select a.dt
     , a.product_id
     , a.id
     , a.createtime   as create_time
     , a.userid       as user_id
     , b.user_id      as active_user_id
     , a.prodid       as prod_id
     , a.mt
     , a.title
     , a.tokenid      as token_id
     , a.token
     , a.body
     , a.customers
     , a.param
     , a.batchid      as batch_id
     , a.state
     , a.updatetime   as update_time
     , a.pushresponse as push_response
     , a.pushtype     as push_type
     , a.pushtime     as push_time
     , a.messageid    as message_id
     , a.tokentype    as task_type
     , a.tasktype     as task_type
     , a.imageurl     as image_url
     , a.issilent     as is_silent
     , now()          as etl_time
  from (select *
             , date(UpdateTime) as update_date
          from ods_log.ods_tidb_readerlog_Log_PushMessageLog
         where UpdateTime >= '${bf_1_dt}'
        )      a
  left join (select dt
                  , user_id
               from dws.dws_user_wide_active_period_ed
              where dt >= '${bf_1_dt}'
              group by dt, user_id
             ) b
    on update_date = b.dt
   and a.UserId = b.user_id
;