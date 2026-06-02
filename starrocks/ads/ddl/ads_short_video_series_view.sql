create or replace view ads.ads_short_video_series_view (
     series_code      comment "短剧编号"
    ,series_id        comment "id"
    ,language         comment "语言"
    ,series_name      comment "名称"
    ,description      comment "短剧简介"
    ,coverurl         comment "封面"
    ,create_time      comment "创建时间"
    ,update_time      comment "修改时间"
    ,create_user      comment "上传人"
    ,publish_status   comment "上架状态(1上架 2下架)"
    ,publishe_dat     comment "上架时间"
    ,unpublishe_dat   comment "下架时间"
    ,last_epis        comment "更新至第几集"
    ,all_epis         comment "总集数"
    ,pay_epis_from    comment "收费起始集数"
    ,is_delete        comment "是否删除"
    ,producer         comment "制片人"
    ,recommend        comment "推荐文案"
    ,source_series_id comment "源语言短剧"
    ,price            comment "单集价格（分）"
    ,ending           comment "完结状态（1连载中 2已完结）"
    ,series_name_key  comment "剧集名称key"
    ,description_key  comment "短剧简介转换key"
    ,recommend_key    comment "推荐文案转换key"
    ,series_level     comment "等级 1.s 2.a 3.b 4.c"
    ,sr_updatetime    comment "ods同步时间"
    ,sr_createtime    comment "starrocks数据注入时间"
)
as
select b.seriescode      as series_code
     , a.seriesid        as series_id
     , a.language
     , a.seriesname      as series_name
     , a.description
     , a.coverurl
     , a.createtime      as create_time
     , a.updatetime      as update_time
     , a.createuser      as create_user
     , a.publishstatus   as publish_status
     , a.publishedat     as publishe_dat
     , a.unpublishedat   as unpublishe_dat
     , a.lastepis        as last_epis
     , a.allepis         as all_epis
     , a.payepisfrom     as pay_epis_from
     , a.isdelete        as is_delete
     , a.producer
     , a.recommend
     , a.sourceseriesid  as source_series_id
     , a.price
     , a.ending
     , a.seriesnamekey   as series_name_key
     , a.descriptionkey  as description_key
     , a.recommendkey    as recommend_key
     , a.SeriesLevel     as series_level
     , a.sr_updatetime
     , a.sr_createtime
  from ods.ods_tidb_short_video_series                   as a
  left join ods.ods_tidb_short_video_admin_source_series as b
    on a.sourceseriesid = b.seriesid
 where a.AppType = 1
;