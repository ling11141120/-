----------------------------------------------------------------
-- 程序功能：海剧-用户订阅状态日表
-- 程序名： P_ads_sv_user_subscribe_status_di
-- 目标表： ads.ads_sv_user_subscribe_status_di
-- 负责人： tyg
-- 开发日期：2026-06-03
----------------------------------------------------------------

delete from ads.ads_sv_user_subscribe_status_di where dt = '${dt}';

insert into ads.ads_sv_user_subscribe_status_di
with account_base as (
    select id                                                  as user_id
         , vipstatus                                           as vip_status
         , from_unixtime(expiretime / 1000)                    as expire_time
         , datediff(from_unixtime(expiretime / 1000), '${dt}') as expire_days_diff
         , corever                                             as core
         , mt
         , currentlanguage                                     as lang_id
         , regcountry                                          as reg_country
      from ods.ods_tidb_short_video_accountinfo
     where hasdelete = 0
       and expiretime > 0
       and id is not null
)
-- 基础VIP信息+过期天数计算
, vip_info as (
    select user_id
         , vip_status
         , expire_time
         , case when expire_days_diff between 0 and 3 and vip_status = 1 then 1 else 0 end as is_expiring_soon
         , case when expire_days_diff = -1 and vip_status in (0, 2) then 1 else 0 end as is_expired
         , 0           as renewal_failed
         , cast(null   as datetime) as renewal_failed_time
         , core
         , mt
         , lang_id
         , reg_country
      from account_base
     where (expire_days_diff between 0 and 3 and vip_status = 1)
       or (expire_days_diff = -1 and vip_status in (0, 2))
)
-- 即将到期 + 已过期
, renewal_info as (
    select cast(get_json_string(c.args, '$.UserId') as bigint) as user_id
         , cast(null                                as int) as vip_status
         , cast(null                                as datetime) as expire_time
         , 0                                        as is_expiring_soon
         , 0                                        as is_expired
         , 1                                        as renewal_failed
         , max(c.scheduletime)                      as renewal_failed_time
         , max(a.corever)                           as core
         , max(a.mt)                                as mt
         , max(a.currentlanguage)                   as lang_id
         , max(a.regcountry)                        as reg_country
      from ods.ods_short_video_commandtask as c
      left join ods.ods_tidb_short_video_accountinfo as a
        on cast(get_json_string(c.args, '$.UserId') as bigint) = a.id
    where c.classtype = 'UserGracePeriodSetCmd'
       and date(c.scheduletime) = '${bf_1_dt}'
       and get_json_string(c.args, '$.UserId') is not null
     group by cast(get_json_string(c.args, '$.UserId') as bigint)
)
select '${dt}'                  as dt
     , user_id
     , max(vip_status)          as vip_status
     , max(expire_time)         as expire_time
     , max(is_expiring_soon)    as is_expiring_soon
     , max(is_expired)          as is_expired
     , max(renewal_failed)      as renewal_failed
     , max(renewal_failed_time) as renewal_failed_time
     , max(core)                as core
     , max(mt)                  as mt
     , max(lang_id)             as lang_id
     , max(reg_country)         as reg_country
     , now()                    as etl_time
  from (select user_id
             , vip_status
             , expire_time
             , is_expiring_soon
             , is_expired
             , renewal_failed
             , renewal_failed_time
             , core
             , mt
             , lang_id
             , reg_country
          from vip_info

union all

        select user_id
             , vip_status
             , expire_time
             , is_expiring_soon
             , is_expired
             , renewal_failed
             , renewal_failed_time
             , core
             , mt
             , lang_id
             , reg_country
          from renewal_info
       ) as unioned_tmp
 group by user_id
;
