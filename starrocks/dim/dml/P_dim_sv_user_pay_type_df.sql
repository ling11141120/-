----------------------------------------------------------------
-- 程序功能： 短剧用户充值类型维表(每日全量快照)
-- 程序名： P_dim_sv_user_pay_type_df
-- 目标表： dim.dim_sv_user_pay_type_df
-- 负责人： roger
-- 开发日期：2026-01-28
-- 版本号： v1.0
----------------------------------------------------------------

-- 说明： 记录用户充值/订阅关键时间点，每日分区方便历史回溯
-- 增量逻辑： 昨日分区数据 + 今日ODS新增分区数据，写入今日分区
-- 用户类型判断逻辑：
--   1. 订阅用户：历史有订阅记录(shop_item<>0)
--   2. IAP用户：有充值但从未订阅(所有记录shop_item=0)
--   3. 免费用户：关联不上本表的用户

-- DML (每日全量快照：昨日分区 + 今日ODS新增 -> 今日分区)
insert into dim.dim_sv_user_pay_type_df
with 
-- 昨日分区数据
yesterday_dim as (
    select user_id
         , first_pay_time
         , first_subscribe_time
         , last_subscribe_expire_time
         , total_pay_count
         , total_subscribe_count
         , etl_time
    from dim.dim_sv_user_pay_type_df
    where dt = '${bf_2_dt}'
),

-- 今日ODS新增分区数据
today_ods as (
    select userid        as user_id
         , createtime    as create_time
         , shopitem      as shop_item
         , vipexpiretime as vip_expire_time
    from ods.ods_tidb_short_video_payorder
    where dt = '${bf_1_dt}'
      and testflag = 0
),

-- 今日新增数据按用户聚合
today_agg as (
    select user_id
         , min(create_time)                                       as first_pay_time
         , min(case when shop_item <> 0 then create_time end)     as first_subscribe_time
         , max(case when shop_item <> 0 then vip_expire_time end) as last_subscribe_expire_time
         , count(1)                                               as total_pay_count
         , sum(case when shop_item <> 0 then 1 else 0 end)        as total_subscribe_count
    from today_ods
    group by user_id
),

-- 合并昨日数据和今日新增数据(全量)
merged_data as (
    select coalesce(y.user_id, t.user_id)                                                 as user_id
         , least(coalesce(y.first_pay_time, t.first_pay_time),
                 coalesce(t.first_pay_time, y.first_pay_time))                            as first_pay_time
         , least(coalesce(y.first_subscribe_time, t.first_subscribe_time),
                 coalesce(t.first_subscribe_time, y.first_subscribe_time))                as first_subscribe_time
         , greatest(coalesce(y.last_subscribe_expire_time, t.last_subscribe_expire_time),
                    coalesce(t.last_subscribe_expire_time, y.last_subscribe_expire_time)) as last_subscribe_expire_time
         , coalesce(y.total_pay_count, 0) + coalesce(t.total_pay_count, 0)                as total_pay_count
         , coalesce(y.total_subscribe_count, 0) + coalesce(t.total_subscribe_count, 0)    as total_subscribe_count
    from yesterday_dim y
    full outer join today_agg t on y.user_id = t.user_id
)

select '${bf_1_dt}' as dt
     , user_id
     , first_pay_time
     , first_subscribe_time
     , last_subscribe_expire_time
     , total_pay_count
     , total_subscribe_count
     , case when total_subscribe_count > 0 then '订阅用户' else 'IAP用户' end as user_type
     , now() as etl_time
from merged_data
;

--
-- ====================================================================
-- 首次全量初始化DML (仅首次运行时使用，之后使用上面的增量DML)
-- ====================================================================
-- insert into dim.dim_sv_user_pay_type_df
-- select '${bf_1_dt}' as dt
--      , userid as user_id
--      , min(createtime) as first_pay_time
--      , min(case when shopitem <> 0 then createtime end) as first_subscribe_time
--      , max(case when shopitem <> 0 then vipexpiretime end) as last_subscribe_expire_time
--      , count(1) as total_pay_count
--      , sum(case when shopitem <> 0 then 1 else 0 end) as total_subscribe_count
--      , case when sum(case when shopitem <> 0 then 1 else 0 end) > 0 then '订阅用户'
--             else 'IAP用户' end as user_type
--      , now() as etl_time
-- from ods.ods_tidb_short_video_payorder
-- where testflag = 0
-- group by userid
-- ;

