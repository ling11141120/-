----------------------------------------------------------------
-- 程序功能： 三方支付实时监控
-- 程序名： P_ads_sv_third_payment_realtime_mon
-- 目标表： ads.ads_sv_third_payment_realtime_mon
-- 负责人： qhr
-- 开发日期：2026-05-25
-- 版本号： v0.1.1
----------------------------------------------------------------

-- dt参数：传入当前调度时间的yyyy-MM-dd HH:00:00
-- 每小时调度，统计当天0点至当前小时的累计值；0点调度统计前一天整日累计

insert into ads.ads_sv_third_payment_realtime_mon
with
-- ==================== 时间参数 ====================
z_param as (
    select date_trunc('hour', '${dt}')                                                                as stat_time
          ,case when hour('${dt}') = 0 then date(date_sub('${dt}', interval 1 day)) else date('${dt}') end as p_dt
          ,case when hour('${dt}') = 0 then date_trunc('day', date_sub('${dt}', interval 1 day)) else date_trunc('day', '${dt}') end as p_start
          ,'${dt}'                                                                                     as p_end
)

-- ==================== 海剧段 (product_id = 6833) ====================

-- 海剧活跃用户（提供 user_type, core, mt 维度）
, z_sv_user as (
    select user_id
          ,case when user_type = 'D0' then 'D0' else '非D0' end as user_type
          ,coalesce(cast(corever as int), -99)                  as core
          ,mt
      from dws.dws_user_short_video_wide_active_period_ed
     where dt = (select p_dt from z_param)
       and period_type = 'ctt'
       and product_id = 6833
       and mt in (1, 4)
     group by 1, 2, 3, 4
)

-- 海剧曝光事件（回到埋点视图做小时级过滤）
, z_sv_exp as (
    select cast(login_id as bigint) as user_id
          ,case when zffs_list is not null
                  and zffs_list != ''
                  and zffs_list not in ('GooglePlay', 'AppStore')
                 then 1 else 0 end as is_third
      from ads.ads_sensors_cd_video_rechargeexposure_view
     where dt = (select p_dt from z_param)
       and event_tm >= (select p_start from z_param)
       and event_tm < (select p_end from z_param)
       and product_id = 6833
       and regexp_replace(cast(login_id as varchar), '[0-9]', '') = ''
       and cast(login_id as varchar) != '0'
       and cast(login_id as varchar) != ''
     group by 1, 2
)

-- 海剧入包用户（人群包日志 + 三方配置，通过 group_id 关联配置表）
, z_sv_group as (
    select cast(a.account as bigint) as user_id
      from (
          select group_id
                ,account
            from ads.ads_user_short_video_group_user_log_view
           where type = 1
             and dt = (select p_dt from z_param)
             and create_time >= (select p_start from z_param)
             and create_time < (select p_end from z_param)
           group by 1, 2

           union all

          select SubCrowdId as group_id
                ,UserId     as account
            from ads.crowd_log
           where Operation = 1
             and dt = (select p_dt from z_param)
             and CreateTime >= (select p_start from z_param)
             and CreateTime < (select p_end from z_param)
           group by 1, 2
      ) a
      join ads.ads_third_payment_config_view b
        on a.group_id = b.unnest_group_ids
     where b.status = 1
       and regexp_replace(cast(a.account as varchar), '[0-9]', '') = ''
       and cast(a.account as varchar) != '0'
       and cast(a.account as varchar) != ''
     group by 1
)

-- 海剧曝光聚合
, z_sv_exp_agg as (
    select (select stat_time from z_param) as stat_time
          ,6833                            as product_id
          ,u.user_type
          ,u.core
          ,u.mt
          ,bitmap_union(to_bitmap(e.user_id))                                   as exposure_uv
          ,bitmap_union(to_bitmap(case when e.is_third = 1 then e.user_id end)) as third_exposure_uv
      from z_sv_exp e
      join z_sv_user u
        on e.user_id = u.user_id
     group by 1, 2, 3, 4, 5
)

-- 海剧入包聚合（口径为曝光用户中的入包UV）
, z_sv_group_agg as (
    select (select stat_time from z_param) as stat_time
          ,6833                            as product_id
          ,u.user_type
          ,u.core
          ,u.mt
          ,bitmap_union(to_bitmap(g.user_id)) as enter_group_uv
      from z_sv_group g
      join z_sv_exp e
        on g.user_id = e.user_id
      join z_sv_user u
        on g.user_id = u.user_id
     group by 1, 2, 3, 4, 5
)

-- 海剧充值聚合（从漏斗充值表取，create_time 过滤）
, z_sv_pay_agg as (
    select (select stat_time from z_param) as stat_time
          ,6833                            as product_id
          ,u.user_type
          ,u.core
          ,u.mt
          ,bitmap_union(to_bitmap(case when p.if_third = 1 then p.user_id end)) as third_recharge_uv
          ,sum(case when p.if_third = 1 then p.base_amount else 0 end)          as third_recharge_amount
          ,sum(case when p.if_third = 0 then p.base_amount else 0 end)          as native_recharge_amount
      from (
          select user_id
                ,if_third
                ,base_amount
            from ads.ads_sv_third_party_payment_funnel_recharge
           where dt = (select p_dt from z_param)
             and create_time >= (select p_start from z_param)
             and create_time < (select p_end from z_param)
             and period_type = 'ctt'
      ) p
      join z_sv_user u
        on p.user_id = u.user_id
     group by 1, 2, 3, 4, 5
)

-- 海剧最终结果（曝光 + 充值 + 入包，FULL JOIN 防止只充值不曝光的用户丢失）
, z_sv_res as (
    select coalesce(a.stat_time, b.stat_time)              as stat_time
          ,coalesce(a.product_id, b.product_id)            as product_id
          ,coalesce(a.user_type, b.user_type)              as user_type
          ,coalesce(a.core, b.core)                        as core
          ,coalesce(a.mt, b.mt)                            as mt
          ,a.exposure_uv
          ,a.third_exposure_uv
          ,c.enter_group_uv
          ,b.third_recharge_uv
          ,coalesce(b.third_recharge_amount, 0)  as third_recharge_amount
          ,coalesce(b.native_recharge_amount, 0) as native_recharge_amount
      from z_sv_exp_agg a
      full join z_sv_pay_agg b
        on a.stat_time = b.stat_time
       and a.product_id = b.product_id
       and a.user_type = b.user_type
       and a.core = b.core
       and a.mt = b.mt
      left join z_sv_group_agg c
        on coalesce(a.stat_time, b.stat_time) = c.stat_time
       and coalesce(a.product_id, b.product_id) = c.product_id
       and coalesce(a.user_type, b.user_type) = c.user_type
       and coalesce(a.core, b.core) = c.core
       and coalesce(a.mt, b.mt) = c.mt
)

-- ==================== 海阅段 (product_id = 阅读各语言 product_id) ====================

-- 海阅活跃用户（提供 product_id, user_type, core, mt 维度）
, z_sr_user as (
    select cast(product_id as int)                                as product_id
          ,user_id
          ,case when user_type = 'D0' then 'D0' else '非D0' end as user_type
          ,coalesce(cast(corever as int), -99)                  as core
          ,cast(mt as int)                                      as mt
      from dws.dws_user_wide_active_period_ed
     where dt = (select p_dt from z_param)
       and period_type = 'ctt'
       and product_id <> 6833
       and mt in (1, 4)
     group by 1, 2, 3, 4, 5
)

-- 海阅曝光事件原始数据（回到埋点视图做小时级过滤）
, z_sr_exp_raw as (
    select cast(if(coalesce(app_product_id, 0) = 0, product_id, app_product_id) as int) as product_id
          ,cast(coalesce(identity_user_id, login_id) as bigint)           as user_id
          ,cast(concat('[', zffs_id_list, ']') as array<int>)             as zffs_id_array
      from ads.ads_sensors_production_rechargeexposure_view
     where dt = (select p_dt from z_param)
       and event_tm >= (select p_start from z_param)
       and event_tm < (select p_end from z_param)
       and project_id = 5
       and element_id not in ('100647', '100651', '100107')
       and if(coalesce(app_product_id, 0) = 0, product_id, app_product_id) is not null
       and regexp_replace(cast(coalesce(identity_user_id, login_id) as varchar), '[0-9]', '') = ''
       and cast(coalesce(identity_user_id, login_id) as varchar) != '0'
       and cast(coalesce(identity_user_id, login_id) as varchar) != ''
       and zffs_id_list is not null
       and zffs_id_list != ''
)

-- 海阅曝光事件（解析支付方式ID，沿用海阅三方曝光日表的三方判断口径）
, z_sr_exp as (
    select a.product_id
          ,a.user_id
          ,max(case when unnest = 0 then 0
                    when b.payment is null then 0
                    when b.payment in ('GooglePlay', 'AppStore') then 0
                    else 1
                end) as is_third
      from z_sr_exp_raw a
      join z_sr_user u
        on a.product_id = u.product_id
       and a.user_id = u.user_id
      left join unnest (zffs_id_array) as unnest
        on true
      left join ads.ads_tag_center_third_payment_rate_view b
        on unnest = b.id
     group by 1, 2
)

-- 海阅入包用户（北斗人群包 + 三方配置，通过 group_id 关联配置表）
, z_sr_group as (
    select cast(a.product_id as int) as product_id
          ,cast(a.account as bigint) as user_id
      from (
          select ProductId  as product_id
                ,SubCrowdId as group_id
                ,UserId     as account
            from ads.ads_sr_beidou_group_crowd_log
           where Operation = 1
             and ProjectId = 1
             and dt = (select p_dt from z_param)
             and CreateTime >= (select p_start from z_param)
             and CreateTime < (select p_end from z_param)
           group by 1, 2, 3
      ) a
      join ads.ads_center_third_payment_global_view b
        on a.group_id = b.unnest_jgroupid
     where b.status = 1
       and cast(a.product_id as int) <> 6833
       and regexp_replace(cast(a.account as varchar), '[0-9]', '') = ''
       and cast(a.account as varchar) != '0'
       and cast(a.account as varchar) != ''
     group by 1, 2
)

-- 海阅曝光聚合
, z_sr_exp_agg as (
    select (select stat_time from z_param) as stat_time
          ,u.product_id
          ,u.user_type
          ,u.core
          ,u.mt
          ,bitmap_union(to_bitmap(e.user_id))                                   as exposure_uv
          ,bitmap_union(to_bitmap(case when e.is_third = 1 then e.user_id end)) as third_exposure_uv
      from z_sr_exp e
      join z_sr_user u
        on e.product_id = u.product_id
       and e.user_id = u.user_id
     group by 1, 2, 3, 4, 5
)

-- 海阅入包聚合（口径为曝光用户中的入包UV）
, z_sr_group_agg as (
    select (select stat_time from z_param) as stat_time
          ,u.product_id
          ,u.user_type
          ,u.core
          ,u.mt
          ,bitmap_union(to_bitmap(g.user_id)) as enter_group_uv
      from z_sr_group g
      join z_sr_exp e
        on g.product_id = e.product_id
       and g.user_id = e.user_id
      join z_sr_user u
        on g.product_id = u.product_id
       and g.user_id = u.user_id
     group by 1, 2, 3, 4, 5
)

-- 海阅充值聚合（从支付订单取，create_time 过滤）
, z_sr_pay_agg as (
    select (select stat_time from z_param) as stat_time
          ,u.product_id
          ,u.user_type
          ,u.core
          ,u.mt
          ,bitmap_union(to_bitmap(case when p.if_third = 1 then p.user_id end)) as third_recharge_uv
          ,sum(case when p.if_third = 1 then p.base_amount / 100 else 0 end)    as third_recharge_amount
          ,sum(case when p.if_third = 0 then p.base_amount / 100 else 0 end)    as native_recharge_amount
      from (
          select cast(product_id as int) as product_id
                ,user_id
                ,case when subpay_type in ('AppStore', 'GooglePlay', 'AppGallery', 'MiGlobal', 'Miglobal') then 0 else 1 end as if_third
                ,base_amount
            from ads.ads_trade_user_payorder_view
           where dt = (select p_dt from z_param)
             and create_time >= (select p_start from z_param)
             and create_time < (select p_end from z_param)
             and product_id <> 6833
      ) p
      join z_sr_user u
        on p.product_id = u.product_id
       and p.user_id = u.user_id
     group by 1, 2, 3, 4, 5
)

-- 海阅最终结果（曝光 + 充值 + 入包，FULL JOIN 防止只充值不曝光的用户丢失）
, z_sr_res as (
    select coalesce(a.stat_time, b.stat_time)              as stat_time
          ,coalesce(a.product_id, b.product_id)            as product_id
          ,coalesce(a.user_type, b.user_type)              as user_type
          ,coalesce(a.core, b.core)                        as core
          ,coalesce(a.mt, b.mt)                            as mt
          ,a.exposure_uv
          ,a.third_exposure_uv
          ,c.enter_group_uv
          ,b.third_recharge_uv
          ,coalesce(b.third_recharge_amount, 0)  as third_recharge_amount
          ,coalesce(b.native_recharge_amount, 0) as native_recharge_amount
      from z_sr_exp_agg a
      full join z_sr_pay_agg b
        on a.stat_time = b.stat_time
       and a.product_id = b.product_id
       and a.user_type = b.user_type
       and a.core = b.core
       and a.mt = b.mt
      left join z_sr_group_agg c
        on coalesce(a.stat_time, b.stat_time) = c.stat_time
       and coalesce(a.product_id, b.product_id) = c.product_id
       and coalesce(a.user_type, b.user_type) = c.user_type
       and coalesce(a.core, b.core) = c.core
       and coalesce(a.mt, b.mt) = c.mt
)

-- ==================== 最终合并 ====================
select stat_time, product_id, user_type, core, mt
      ,exposure_uv, third_exposure_uv, enter_group_uv
      ,third_recharge_uv, third_recharge_amount, native_recharge_amount
  from z_sv_res

union all

select stat_time, product_id, user_type, core, mt
      ,exposure_uv, third_exposure_uv, enter_group_uv
      ,third_recharge_uv, third_recharge_amount, native_recharge_amount
  from z_sr_res
;
