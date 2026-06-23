----------------------------------------------------------------
-- 程序功能： 海阅-过期用户日表
-- 程序名： P_ads_sr_user_subscribe_expired_di
-- 目标表： ads.ads_sr_user_subscribe_expired_di
-- 负责人： tyg
-- 开发日期：2026-06-18
----------------------------------------------------------------

delete from ads.ads_sr_user_subscribe_expired_di where dt = '${dt}';

insert into ads.ads_sr_user_subscribe_expired_di
select '${dt}'        as dt
     , user_id
     , product_id
     , subscribe_type
     , expire_time
     , VipType
     , now()          as etl_time
  from (select Id                                                                                                       as user_id
             , product_id
             , 1                                                                                                        as subscribe_type
             , date_add( greatest(LowVipExpireTime, LowVipSecondsStartTime) , interval LowVipExpireTimeSeconds second ) as expire_time
             , VipType
          from ods.ods_tidb_readernovel_tidb_userdata
         where Id is not null
           and product_id is not null
           and date(
                 date_add(
                     greatest(LowVipExpireTime, LowVipSecondsStartTime)
                     , interval LowVipExpireTimeSeconds second
                 )
               ) = '${bf_1_dt}'

union

        select Id                                                                                              as user_id
             , product_id
             , 2                                                                                               as subscribe_type
             , date_add( greatest(VipExpireTime, VipSecondsStartTime) , interval VipExpireTimeSeconds second ) as expire_time
             , VipType
          from ods.ods_tidb_readernovel_tidb_userdata
         where Id is not null
           and product_id is not null
           and date(
                 date_add(
                     greatest(VipExpireTime, VipSecondsStartTime)
                     , interval VipExpireTimeSeconds second
                 )
               ) = '${bf_1_dt}'
       ) as unioned
;
