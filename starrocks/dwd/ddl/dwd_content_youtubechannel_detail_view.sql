create or replace view dwd.dwd_content_youtubechannel_detail_view (
     id                  comment "id"
    ,info_id             comment "infoid"
    ,channel_id          comment "渠道id"
    ,channel_name        comment "渠道名称 展示用的"
    ,channel_name_api    comment "渠道名称 api上取的"
    ,subscriber_count    comment "订阅人数"
    ,view_count          comment "观看次数"
    ,updatetime          comment "更新时间"
    ,sr_createtime       comment "starrocks入库时间"
    ,sr_updatetime       comment "starrocks数据更新时间"
)
comment "youtube渠道详情表"
as
select a1.Id                  as id                 -- id
      ,a1.infoid              as info_id            -- infoid
      ,a1.channel_id          as channel_id         -- 渠道id
      ,a1.channename          as channel_name       -- 渠道名称 展示用的
      ,a1.channename_api      as channel_name_api   -- 渠道名称 api上取的
      ,a1.subscriber_count    as subscriber_count   -- 订阅人数
      ,a1.view_count          as view_count         -- 观看次数
      ,a1.updatetime          as updatetime         -- 更新时间
      ,a1.sr_createtime       as sr_createtime      -- starrocks入库时间
      ,a1.sr_updatetime       as sr_updatetime      -- starrocks数据更新时间
  from ods.ods_tidb_cdmoney_report_tidb_cn_youtubechannel_detail    as a1
;
