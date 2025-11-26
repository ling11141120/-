drop table if exists ads.ads_sv_hot_list_hi;
create table ads.ads_sv_hot_list_hi (
     dt               date          not null                     comment "日期"
    ,stat_dt_h        int(11)       not null                     comment "统计日期yyyyMMddHH-小时"
    ,series_id        bigint(20)    not null                     comment "剧集id"
    ,language_id      int(11)       not null                     comment "语言id"
    ,core             int(11)       not null                     comment "core"
    ,amt_weight       int(11)                                    comment "观看付费集权重值"
    ,consume_coin     int(11)                                    comment "消费观看币数"
    ,consume_bonus    int(11)                                    comment "消费观看券数"
    ,watch_cnt        int(11)                                    comment "播放次数"
    ,like_cnt         int(11)                                    comment "点赞次数"
    ,follow_cnt       int(11)                                    comment "添加追剧"
    ,etl_time         datetime      default current_timestamp    comment "清洗时间"
)
primary key(dt, stat_dt_h, series_id, language_id, core)
comment "海剧排行榜热度指标计算口径"
partition by date_trunc('day', dt)
distributed by hash(dt, stat_dt_h)
properties (
     "replication_num" = "3"
    ,"partition_live_number" = "30"
    ,"in_memory" = "false"
    ,"enable_persistent_index" = "true"
    ,"replicated_storage" = "true"
    ,"compression" = "LZ4"
)
;