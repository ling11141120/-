create or replace view dwd.dwd_content_youtubechannel_report_view (
     id                          comment "id"
    ,info_id                     comment "infoid"
    ,channel_id                  comment "渠道id"
    ,dt                          comment "时间"
    ,dt_str                      comment "时间"
    ,estimated_revenue           comment "总收入"
    ,estimated_ad_revenue        comment "广告收入"
    ,estimated_vip_revenue       comment "会员收入（近似值）"
    ,estimated_minuteswatched    comment "观看时长 （分钟）"
    ,updatetime                  comment "更新时间"
    ,sr_createtime               comment "starrocks入库时间"
    ,sr_updatetime               comment "starrocks数据更新时间"
)
comment "YouTubeChannel收入报表"
as
select a1.id                            as id                         -- id
      ,a1.infoid                        as info_id                    -- infoid
      ,a1.channel_id                    as channel_id                 -- 渠道id
      ,a1.dt                            as dt                         -- 时间
      ,a1.dtstr                         as dt_str                     -- 时间
      ,a1.estimated_revenue             as estimated_revenue          -- 总收入
      ,a1.estimated_ad_revenue          as estimated_ad_revenue       -- 广告收入
      ,a1.estimated_vip_revenue         as estimated_vip_revenue      -- 会员收入（近似值）
      ,a1.estimated_minuteswatched      as estimated_minuteswatched   -- 观看时长 （分钟）
      ,a1.updatetime                    as updatetime                 -- 更新时间
      ,a1.sr_createtime                 as sr_createtime              -- starrocks入库时间
      ,a1.sr_updatetime                 as sr_updatetime              -- starrocks数据更新时间
  from ods.ods_tidb_cdmoney_report_tidb_cn_youtubechannel_report    as a1
;
