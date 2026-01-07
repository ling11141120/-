create or replace view dwd.dwd_video_short_video_account_like_view (
     dt               comment "日期，根据create_time转换而来"
    ,user_id          comment "用户id"
    ,epis_id          comment "集数id"
    ,create_time      comment "创建时间"
    ,is_delete        comment "逻辑删除字段"
    ,region_id        comment "归属区域 id，1：香港，2：北美；"
    ,series_id        comment "短剧id"
    ,sr_createtime    comment "starrocks数据注入时间"
    ,sr_updatetime    comment "starrocks数据更新时间"
)
comment "海外短剧-用户点赞表"
as
select date(CreateTime)    as dt
     , AccountId           as user_id
     , EpisId              as epis_id
     , CreateTime          as create_time
     , IsDelete            as is_delete
     , regionId            as region_id
     , SeriesId            as series_id
     , sr_createtime
     , sr_updatetime
  from ods.ods_tidb_short_video_account_like
;