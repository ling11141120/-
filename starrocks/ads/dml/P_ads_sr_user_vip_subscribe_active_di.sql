----------------------------------------------------------------
-- 程序功能： 海阅-VIP未过期用户日表
-- 程序名： P_ads_sr_user_vip_subscribe_active_di
-- 目标表： ads.ads_sr_user_vip_subscribe_active_di
-- 负责人： tyg
-- 开发日期：2026-06-18
----------------------------------------------------------------

delete from ads.ads_sr_user_vip_subscribe_active_di where dt = '${dt}';

insert into ads.ads_sr_user_vip_subscribe_active_di
select '${dt}'                                                                                                  as dt
     , Id                                                                                                       as user_id
     , product_id
     , 1                                                                                                        as subscribe_type
     , date_add( greatest(LowVipExpireTime, LowVipSecondsStartTime) , interval LowVipExpireTimeSeconds second ) as expire_time
     , VipType
     , now()                                                                                                    as etl_time
  from ods.ods_tidb_readernovel_tidb_userdata
 where Id is not null
   and product_id is not null
   and date_add(
         greatest(LowVipExpireTime, LowVipSecondsStartTime)
         , interval LowVipExpireTimeSeconds second
       ) > now()
;
