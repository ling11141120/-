drop table if exists ads.ads_video_user_watch_lte5s_di;
create table ads.ads_video_user_watch_lte5s_di (
     dt             date          not null                     comment "日期"
    ,user_id        bigint(20)    not null                     comment "用户id"
    ,series_id      int(11)       not null                     comment "剧集id"
    ,watch_stamp    int(11)                                    comment "观看时间戳"
    ,etl_tm         datetime      default current_timestamp    comment "etl清洗时间"
)
primary key (dt, user_id, series_id)
comment "短剧观看时长小于等于5秒明细"
partition by date_trunc("month", dt)
distributed by hash(dt, user_id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "lz4"
)
;