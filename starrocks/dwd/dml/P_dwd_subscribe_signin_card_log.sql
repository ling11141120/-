----------------------------------------------------------------
-- 程序功能： 订阅域-签到卡发放记录
-- 程序名： P_dwd_subscribe_signin_card_log
-- 目标表： dwd.dwd_subscribe_signin_card_log
-- 负责人： qhr
-- 开发日期： 2026-01-27
----------------------------------------------------------------

insert into dwd.dwd_subscribe_signin_card_log
select date(CreateTimeDt)    as dt             -- 分区日期
     , 6833                  as product_id     -- product_id
     , Id                    as log_id         -- 记录id
     , AccountId             as user_id        -- 用户id
     , ExpireTimeDt          as expire_time    -- 过期时间
     , CreateTimeDt          as create_time    -- 创建时间
     , Mt                    as mt             -- 终端系统
     , now()                 as etl_time       -- etl时间
  from ods.ods_tidb_short_video_sign_in_card
 where CreateTimeDt >= '${bf_1_dt}'
   and CreateTimeDt < '${dt}'
;