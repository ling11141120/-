create or replace view dim.dim_short_video_ads_unit_adid_view (
     unit_adid      comment "广告单元id",
    ,status         comment "广告开启状态 1：开启,0:关闭,2:关闭",
    ,ads_type       comment "广告类型 1激励视频 2原生视频",
    ,position_id    comment "广告位置id"
)
as
select c.unnest         as unit_adid
      ,a.status
      ,a.ads_type
      ,min(b.unnest)    as position_id
  from (select ads_type
              ,status
              ,split(ads_id,',')          as unit_adid
              ,split(position_ids,',')    as position_id
          from ods.ods_tidb_short_video_ads_settings
       ) a
  ,lateral unnest (a.position_id) b (unnest)
  ,lateral unnest (a.unit_adid)   c (unnest)
 group by 1, 2, 3
;