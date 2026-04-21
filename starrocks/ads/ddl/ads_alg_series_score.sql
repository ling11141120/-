drop table if exists ads.ads_alg_series_score;
create table ads.ads_alg_series_score (
     dt              date         not null  comment "统计周期"
    ,series_id       bigint       not null  comment "剧id"
    ,country         varchar(50)  not null  comment "国家"
    ,core            int          not null  comment "core"
    ,publish_edat    datetime               comment "上架时间"
    ,series_level    varchar(10)            comment "等级 1.S 2.A 3.B 4.C"
    ,language_id     varchar(10)            comment "语言id"
    ,local_type      int                    comment "类型 1外文剧 2 中文剧"
    ,ctr_score       int                    comment "点击率得分"
    ,avg_play_score  int                    comment "平均播放得分"
    ,play_score      int                    comment "播放得分"
    ,final_score     int                    comment "最终得分"
    ,etl_time        datetime               comment "处理时间"
)
primary key (dt, series_id, country, core)
comment "剧集得分表"
distributed by hash(dt, series_id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
