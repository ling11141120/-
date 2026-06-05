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
with youtubechannel_detail as (
    select a1.id
          ,a1.info_id
          ,a1.channel_id
          ,coalesce(a2.channel_name,a1.channel_name)    as channel_name
          ,a1.channel_name_api
          ,a1.subscriber_count
          ,a1.view_count
          ,a1.updatetime
          ,a1.sr_createtime
          ,a1.sr_updatetime
      from dwd.dwd_content_youtubechannel_detail_view    as a1
      left join dwd.dwd_content_youtube_info_view        as a2
        on a1.id=a2.id
       and a2.status=1
)
select a1.dt                          as dt                   -- 日期
      ,a1.channel_id                  as chl_id               -- 渠道id
      ,a2.channel_name                as chl_name             -- 渠道名称 展示用的
      ,a2.channel_name_api            as chl_name_api         -- 渠道名称 api上取的
      ,a2.subscriber_count            as ttl_sub_num          -- 总订阅人数
      ,a2.view_count                  as ttl_view_num         -- 总观看次数
      ,a1.estimated_revenue           as d_ttl_rev            -- 当日总收入
      ,a1.estimated_ad_revenue        as d_ad_rev             -- 当日广告收入
      ,a1.estimated_vip_revenue       as d_mbr_apx_rev        -- 当日会员收入（近似值）
      ,a1.estimated_minuteswatched    as d_view_time          -- 当日观看时长 （分钟）
      ,a1.updatetime                  as d_rev_etl_time       -- 当日收入etl时间
      ,a2.updatetime                  as chl_info_etl_time    -- 渠道信息etl时间
  from dwd.dwd_content_youtubechannel_report_view    as a1
  left join youtubechannel_detail     as a2
    on a1.channel_id = a2.channel_id
 where a1.dt between '${bf_37_dt}' and '${dt}'
;
