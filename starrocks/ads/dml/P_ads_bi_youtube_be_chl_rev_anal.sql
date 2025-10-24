----------------------------------------------------------------
-- 程序功能：YouTube后台频道数据展示
-- 程序名： P_ads_bi_youtube_be_chl_rev_anal
-- 目标表： ads.ads_bi_youtube_be_chl_rev_anal
-- 负责人： xjc
-- 开发日期：2025-10-22
-- 版本号：v0.0.0
----------------------------------------------------------------

insert into ads.ads_bi_youtube_be_chl_rev_anal
-- youtube频道收入信息日更新表数据
with youtubechannel_report as (
    select id                           -- id
          ,infoid                       -- infoid
          ,channel_id                   -- 渠道id
          ,dt                           -- 日期
          ,estimated_revenue            -- 每日总收入
          ,estimated_ad_revenue         -- 每日广告收入
          ,estimated_vip_revenue        -- 每日会员收入（近似值）
          ,estimated_minuteswatched     -- 每日观看时长 （分钟）
          ,updatetime                   -- 更新时间
          ,sr_createtime                -- starrocks数据更新时间入库时间
          ,sr_updatetime                -- starrocks数据更新时间
      from ods.ods_tidb_cdmoney_report_tidb_cn_youtubechannel_report
     where dt between '${bf_5_dt}' and '${dt}'
),
-- youtube渠道详情表
youtubechannel_detail as (
    select Id                           -- id
          ,infoid                       -- infoid
          ,channel_id                   -- 渠道id
          ,channename                   -- 渠道名称 展示用的
          ,channename_api               -- 渠道名称 api上取的
          ,subscriber_count             -- 总订阅人数
          ,view_count                   -- 总观看次数
          ,updatetime                   -- 更新时间
          ,sr_createtime                -- starrocks数据更新时间入库时间
          ,sr_updatetime                -- starrocks数据更新时间
      from ods.ods_tidb_cdmoney_report_tidb_cn_youtubechannel_detail
)
select a1.dt                                as dt                                  -- 日期
      ,a1.channel_id                        as chl_id                              -- 渠道id
      ,a2.channename                        as chl_name                            -- 渠道名称 展示用的
      ,a2.channename_api                    as chl_name_api                        -- 渠道名称 api上取的
      ,a2.subscriber_count                  as ttl_sub_num                         -- 总订阅人数
      ,a2.view_count                        as ttl_view_num                        -- 总观看次数
      ,a1.estimated_revenue                 as d_ttl_rev                           -- 当日总收入
      ,a1.estimated_ad_revenue              as d_ad_rev                            -- 当日广告收入
      ,a1.estimated_vip_revenue             as d_mbr_rev                           -- 当日会员收入（近似值）
      ,a1.estimated_minuteswatched          as d_view_time                         -- 当日观看时长 （分钟）
      ,a1.updatetime                        as d_rev_etl_time                      -- 当日收入etl时间
      ,a2.updatetime                        as chl_info_etl_time                   -- 渠道信息etl时间
  from youtubechannel_report                as a1
  left join youtubechannel_detail           as a2
    on a1.channel_id = a2.channel_id
;