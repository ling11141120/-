----------------------------------------------------------------
-- 程序功能： 海剧人群标签表-提供给付费墙中台等使用
-- 程序名： P_ads_sv_group_at_active_user_tag
-- 目标表： ads.ads_sv_group_at_active_user_tag
-- 负责人： qhr
-- 开发日期：2026-01-26
----------------------------------------------------------------

insert into ads.ads_sv_group_at_active_user_tag
with base_user as (
    select rcgex.user_id
         , uinfo.corever              as core
         , uinfo.create_time          as register_time
         , uinfo.current_language     as ui_lang
         , uinfo.current_language2    as ad_lang
         , uinfo.version              as client_ver_num
         , uinfo.reg_country          as nation
         , ifnull(ctlv.level, 2)      as nation_level
         , uinfo.mt2                  as platform
      from (select login_id           as user_id
              from ads.ads_sensors_cd_video_rechargeexposure_view    -- 充值曝光事件埋点表
             where dt = '${bf_1_dt}'
               and login_id is not null
             group by 1
           )                                            as rcgex
      left join dim.dim_short_video_user_accountinfo    as uinfo
        on rcgex.user_id = uinfo.user_id
      left join dim.dim_countrylevel                    as ctlv
        on uinfo.reg_country = ctlv.short_name
       and ctlv.product_id = 6833
)
, t1_data as (
    select '${bf_1_dt}'                                                              as dt                       -- 日期
         , bu.user_id                                                                as user_id                  -- 用户id
         , 'T1'                                                                      as stat_period_type         -- 统计周期类型
         , bu.core                                                                   as core                     -- core
         , bu.register_time                                                          as register_time            -- 注册时间
         , bu.ui_lang                                                                as ui_lang                  -- 界面语言
         , bu.ad_lang                                                                as ad_lang                  -- 渠道推广语言
         , bu.client_ver_num                                                         as client_ver_num           -- 服务器版本
         , bu.nation                                                                 as nation                   -- 国家
         , bu.nation_level                                                           as nation_level             -- 国家等级
         , bu.platform                                                               as platform                 -- 平台
         , coalesce(stat.lst_position_reward_ecpm,stat.fst_preload_reward_ecpm,0)    as sv_last_show_ecpm        -- 最近展现激励视频eCPM
         , case when stat.first_recharge_tm is null then 0
                else 1
           end                                                                       as is_recharged             -- 有无充值
         , coalesce(stat.charge_mode,0)                                              as double_recharge_mode     -- 充值众数
         , case when uds.sub_type = 1 and is_valid = 1 then 1
                else 0
           end                                                                       as current_sign_card_status -- 当前签到卡状态
         , case when uds.sub_type = 2 and is_valid = 1 then 1
                else 0
           end                                                                       as current_vip_status       -- 当前VIP状态
         , case when uds.sub_type = 3 and is_valid = 1 then 1
                else 0
           end                                                                       as current_svip_status      -- 当前SVIP状态
         , coalesce(stat.fst_svip_price,0)                                           as double_first_svip_price  -- 首次SVIP金额(小数)
         , coalesce(stat.fst_vip_price,0)                                            as double_first_vip_price   -- 首次VIP金额(小数)
         , now()                                                                     as etl_time                 -- etl时间
      from base_user                                  as bu
      left join dws.dws_user_sv_status_idx_his_15df   as stat -- 海剧用户状态快照指标
        on bu.user_id = stat.user_id
       and stat.dt = '${bf_1_dt}'
      left join dws.dws_subscribe_user_daily_snapshot as uds -- 用户订阅快照
        on bu.user_id = uds.user_id
       and uds.dt = '${bf_1_dt}'
)
, t2_data as (
    select '${bf_1_dt}'                                                              as dt                       -- 日期
         , bu.user_id                                                                as user_id                  -- 用户id
         , 'T2'                                                                      as stat_period_type         -- 统计周期类型
         , bu.core                                                                   as core                     -- core
         , bu.register_time                                                          as register_time            -- 注册时间
         , bu.ui_lang                                                                as ui_lang                  -- 界面语言
         , bu.ad_lang                                                                as ad_lang                  -- 渠道推广语言
         , bu.client_ver_num                                                         as client_ver_num           -- 服务器版本
         , bu.nation                                                                 as nation                   -- 国家
         , bu.nation_level                                                           as nation_level             -- 国家等级
         , bu.platform                                                               as platform                 -- 平台
         , coalesce(stat.lst_position_reward_ecpm,stat.fst_preload_reward_ecpm,0)    as sv_last_show_ecpm        -- 最近展现激励视频eCPM
         , case when stat.first_recharge_tm is null then 0
                else 1
           end                                                                       as is_recharged             -- 有无充值
         , coalesce(stat.charge_mode,0)                                              as double_recharge_mode     -- 充值众数
         , case when uds.sub_type = 1 and is_valid = 1 then 1
                else 0
           end                                                                       as current_sign_card_status -- 当前签到卡状态
         , case when uds.sub_type = 2 and is_valid = 1 then 1
                else 0
           end                                                                       as current_vip_status       -- 当前VIP状态
         , case when uds.sub_type = 3 and is_valid = 1 then 1
                else 0
           end                                                                       as current_svip_status      -- 当前SVIP状态
         , coalesce(stat.fst_svip_price,0)                                           as double_first_svip_price  -- 首次SVIP金额(小数)
         , coalesce(stat.fst_vip_price,0)                                            as double_first_vip_price   -- 首次VIP金额(小数)
         , now()                                                                     as etl_time                 -- etl时间
      from base_user                                  as bu
      left join dws.dws_user_sv_status_idx_his_15df   as stat -- 海剧用户状态快照指标
        on bu.user_id = stat.user_id
       and stat.dt = '${bf_2_dt}'
      left join dws.dws_subscribe_user_daily_snapshot as uds -- 用户订阅快照
        on bu.user_id = uds.user_id
       and uds.dt = '${bf_2_dt}'
)
, d0_data as (
    select '${bf_1_dt}'      as dt                       -- 日期
         , user_id           as user_id                  -- 用户id
         , 'D0'              as stat_period_type         -- 统计周期类型
         , core              as core                     -- core
         , register_time     as register_time            -- 注册时间
         , ui_lang           as ui_lang                  -- 界面语言
         , ad_lang           as ad_lang                  -- 渠道推广语言
         , client_ver_num    as client_ver_num           -- 服务器版本
         , nation            as nation                   -- 国家
         , nation_level      as nation_level             -- 国家等级
         , platform          as platform                 -- 平台
         , 0                 as sv_last_show_ecpm        -- 最近展现激励视频eCPM
         , 0                 as is_recharged             -- 有无充值
         , 0                 as double_recharge_mode     -- 充值众数
         , 0                 as current_sign_card_status -- 当前签到卡状态
         , 0                 as current_vip_status       -- 当前VIP状态
         , 0                 as current_svip_status      -- 当前SVIP状态
         , 0                 as double_first_svip_price  -- 首次SVIP金额(小数)
         , 0                 as double_first_vip_price   -- 首次VIP金额(小数)
         , now()             as etl_time                 -- etl时间
      from base_user
     where date(register_time) = '${bf_1_dt}'
)
select * from t1_data
 union all
select * from t2_data
 union all
select * from d0_data