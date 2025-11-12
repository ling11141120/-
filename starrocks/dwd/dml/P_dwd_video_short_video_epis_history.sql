insert into dwd.dwd_video_short_video_epis_history
select dt, Id, AccountId, SeriesId, EpisId, if(a.WatchOver = 1, ifnull(b.duration, a.WatchStamp), a.WatchStamp) as WatchStamp, CreateTime, EpisNum, regionId, WatchOver,now() as etl_time
from ods.ods_tidb_short_video_log_ext_epis_history_part2 a
left join dim.dim_short_video_epis_view b on a.EpisId = b.epis_id
where dt >= '${bf_4_dt}' and dt <= '${dt}';