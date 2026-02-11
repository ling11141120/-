----------------------------------------------------------------
-- 程序功能： 订阅域-vip信息
-- 程序名： P_dwd_subscribe_vip_info
-- 目标表： dwd.dwd_subscribe_vip_info
-- 负责人： qhr
-- 开发日期： 2026-01-27
----------------------------------------------------------------

insert into dwd.dwd_subscribe_vip_info
select 6833           as product_id     -- product_id
     , account_id     as user_id        -- 用户id
     , vip_type       as vip_type       -- vip类型
     , is_vip         as is_vip         -- 是否vip
     , vip_level      as vip_level      -- vip等级
     , case when expire_time = 0 then null
            else str_to_jodatime(from_unixtime(expire_time/1000), 'yyyy-MM-dd HH:mm:ss')
        end           as expire_time    -- 过期时间
     , create_time    as create_time    -- 创建时间
     , update_time    as update_time    -- 更新时间
     , now()          as etl_time       -- etl时间
  from ods.ods_tidb_short_video_account_vip
;