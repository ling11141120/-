----------------------------------------------------------------
-- 程序功能：短剧属性维表(全量)
-- 程序名： P_dim_short_video_series_attr_df
-- 目标表： dim.dim_short_video_series_attr_df
-- 负责人： roger
-- 开发日期：2026-04-08
-- 版本号： v1.0
----------------------------------------------------------------

insert into dim.dim_short_video_series_attr_df
with
series_base as (
  select
    a.seriesid as series_id
    , coalesce(a.language, 0) as language_code
    , b.seriescode as series_code
    , a.seriesname as series_name
    , a.allepis as all_epis
    , a.coverurl as cover_url
    , a.publishedat as publish_time
  from ods.ods_tidb_short_video_series as a
  left join ods.ods_tidb_short_video_admin_source_series as b
    on a.sourceseriesid = b.seriesid
  where a.seriesid is not null
    and coalesce(a.isdelete, 0) = 0
)

, language_dim as (
  select
    cd_val
    , cd_val_desc
  from dim.dim_pub_code_mapping_dict
  where app_plat = 'pub'
    and cd_col = 'lang_cd'
)

, epis_agg as (
  select
    seriesid as series_id
    , sum(duration) as series_duration
    , min(case when isfree = 0 then episnum end) as first_pay_epis_num
  from ods.ods_tidb_short_video_epis
  where coalesce(isdelete, 0) = 0
  group by seriesid
)

, series_attr as (
  select
    sv.seriesid as series_id
    , sv.serieslevel as series_level
    , case sv.serieslevel
      when 1 then 'S'
      when 2 then 'A'
      when 3 then 'B'
      when 4 then 'C'
    end as series_level_name
    , sv.worktype as work_type
    , case sv.worktype
      when 1 then '男频'
      when 2 then '女频'
      when 3 then '双番'
    end as work_type_name
    , ssv.localtype as local_type
    , case ssv.localtype
      when 1 then '本土剧'
      when 2 then '译制剧'
      when 4 then '动漫'
    end as local_type_name
    , ssv.localsubtype as local_sub_type
    , case ssv.localsubtype
      when 1 then '本土剧-AI短剧'
    end as local_sub_type_name
    , ssv.audiotype as audio_type
    , case ssv.audiotype
      when 1 then '原声剧'
      when 2 then '配音剧'
    end as audio_type_name
    , ssv.dubbedtype as dubbed_type
    , case ssv.dubbedtype
      when 1 then '人工配音'
      when 2 then 'AI配音'
    end as dubbed_type_name
  from ods.ods_tidb_series as sv
  left join ods.ods_tidb_source_series as ssv
    on sv.sourceseriesid = ssv.seriesid
)

, series_type_agg as (
  select
    ref.seriesid as series_id
    , group_concat(st.name order by st.name) as series_type_labels
  from ods.ods_tidb_short_video_series_ref_type as ref
  left join ods.ods_tidb_short_video_series_type as st
    on ref.seriestypeid = st.id
  group by ref.seriesid
)

select
  b.series_id
  , b.language_code
  , d.cd_val_desc as language_name
  , b.series_code
  , b.series_name
  , b.all_epis
  , b.cover_url
  , b.publish_time
  , e.series_duration
  , e.first_pay_epis_num
  , a.series_level
  , a.series_level_name
  , a.work_type
  , a.work_type_name
  , a.local_type
  , a.local_type_name
  , a.local_sub_type
  , a.local_sub_type_name
  , a.audio_type
  , a.audio_type_name
  , a.dubbed_type
  , a.dubbed_type_name
  , t.series_type_labels
  , now() as etl_time
from series_base as b
left join language_dim as d
  on b.language_code = cast(d.cd_val as int)
left join epis_agg as e
  on b.series_id = e.series_id
left join series_attr as a
  on b.series_id = a.series_id
left join series_type_agg as t
  on b.series_id = t.series_id
;
