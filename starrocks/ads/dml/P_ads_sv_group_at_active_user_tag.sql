----------------------------------------------------------------
-- 程序功能： 海剧人群标签表-提供给付费墙中台等使用
-- 程序名： P_ads_sv_group_at_active_user_tag
-- 目标表： ads.ads_sv_group_at_active_user_tag
-- 负责人： qhr
-- 开发日期：2026-01-26
----------------------------------------------------------------

insert into tmp.ads_sv_group_at_active_user_tag
with adinfo as (
    select corever as core
         , user_id
         , mt
         , sum(ad_position_amt) as sv_last_show_ecpm
      from dwd.dwd_advertisement_user_position_amt_p_di
     where dt = '${bf_1_dt}'
       and product_id = 6833
       and ad_show_type = 3
     group by 1, 2, 3
)
select act.dt                                                              as dt                         -- 日期
     , act.user_id                                                         as user_id                    -- 用户id
     , act.period_type                                                     as period_type                -- 统计周期类型
     , act.corever                                                         as core                       -- core
     , act.reg_time                                                        as register_time              -- 注册时间
     , act.current_language                                                as ui_lang                    -- 界面语言
     , act.current_language2                                               as ad_lang                    -- 渠道推广语言
     , uinfo.version                                                       as client_ver_num             -- 服务器版本
     , act.reg_country                                                     as nation                     -- 国家
     , act.country_level                                                   as nation_level               -- 国家等级
     , act.mt                                                              as platform                   -- 平台
     , coalesce(adinfo.sv_last_show_ecpm, stat.fst_preload_reward_ecpm)    as sv_last_show_ecpm          -- 最近展现激励视频eCPM
     , case when stat.first_recharge_tm is null then 0
            else 1
        end                                                                as is_recharged               -- 有无充值
     , stat.charge_mode                                                    as double_recharge_mode       -- 充值众数
     , case when uds.sub_type = 1 and is_valid = 1 then 1
            else 0
        end                                                                as current_sign_card_status   -- 当前签到卡状态
     , case when uds.sub_type = 2 and is_valid = 1 then 1
            else 0
        end                                                                as current_vip_status         -- 当前VIP状态
     , case when uds.sub_type = 3 and is_valid = 1 then 1
           else 0
       end                                                                 as current_svip_status        -- 当前SVIP状态
     , stat.fst_svip_price                                                 as double_first_svip_price    -- 首次SVIP金额(小数)
     , stat.fst_vip_price                                                  as double_first_vip_price     -- 首次VIP金额(小数)
  from dws.dws_user_short_video_wide_active_period_ed as act      -- 海剧活跃
  left join dws.dws_user_sv_status_idx_di             as stat     -- 海剧用户状态快照指标
    on act.user_id = stat.user_id
  left join dws.dws_subscribe_user_daily_snapshot     as uds      -- 用户订阅快照
    on act.user_id = uds.user_id
   and uds.product_id = 6833
  left join dim.dim_short_video_user_accountinfo      as uinfo    -- 海剧用户基本信息
    on act.user_id = uinfo.user_id
  left join adinfo
    on act.corever = adinfo.core
   and act.user_id = adinfo.user_id
   and act.mt = adinfo.mt
 where act.dt = '${bf_1_dt}'
   and act.product_id = 6833
;