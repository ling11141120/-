----------------------------------------------------------------
-- 程序功能： 订阅域-用户快照表
-- 程序名： P_dws_subscribe_user_daily_snapshot
-- 目标表： dws.dws_subscribe_user_daily_snapshot
-- 负责人： qhr
-- 开发日期： 2026-01-27
----------------------------------------------------------------

-- 签到卡
insert into dws.dws_subscribe_user_daily_snapshot
select coalesce(susc.product_id, uds.product_id)      as product_id
     , coalesce(susc.user_id, uds.user_id)            as user_id
     , 1                                              as sub_type
     , coalesce(susc.expire_time, uds.expire_time)    as expire_time
     , case when coalesce(susc.expire_time, uds.expire_time) > now() then 1
            else 0
       end                                            as is_valid
     , now()                                          as etl_time
  from dwd.dwd_subscribe_signin_card_log              as susc
  left join dws.dws_subscribe_user_daily_snapshot     as uds
    on uds.product_id = susc.product_id
   and uds.user_id = susc.user_id
   and uds.sub_type = 1
 where susc.dt >= '${bf_1_dt}'
   and susc.dt < '${dt}'
;

-- vip
insert into dws.dws_subscribe_user_daily_snapshot
select product_id
     , user_id
     , 2                                                                          as sub_type
     , str_to_jodatime(from_unixtime(expire_time/1000), 'yyyy-MM-dd HH:mm:ss')    as expire_time
     , case when level = 1 and vip_status = 1 and str_to_jodatime(from_unixtime(expire_time/1000), 'yyyy-MM-dd HH:mm:ss') > now() then 1
            else 0
       end                                                                        as is_valid
     , now()                                                                      as etl_time
  from dim.dim_short_video_user_accountinfo -- 海剧用户信息
;

-- svip
insert into dws.dws_subscribe_user_daily_snapshot
select product_id
     , user_id
     , 3        as sub_type
     , expire_time
     , case when is_vip = 1 and expire_time > now() then 1
            else 0
       end      as is_valid
     , now()    as etl_time
  from dwd.dwd_subscribe_vip_info
 where vip_type = 1
;