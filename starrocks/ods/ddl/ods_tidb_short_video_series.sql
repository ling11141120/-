----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_series
-- 来源实例： video-en-mysql-slave
-- 来源表： short_video.series
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2025-12-01
----------------------------------------------------------------

drop table if exists ods.ods_tidb_short_video_series;
create table ods.ods_tidb_short_video_series (
     SeriesId         bigint(20)    not null                  comment "id"
    ,Language         int(11)       not null                  comment "语言"
    ,SeriesName       varchar(2000)                           comment ""
    ,Description      string                                  comment "短剧简介"
    ,CoverUrl         varchar(512)                            comment "封面"
    ,CreateTime       datetime                                comment "创建时间"
    ,UpdateTime       datetime                                comment "修改时间"
    ,CreateUser       varchar(100)                            comment "上传人"
    ,PublishStatus    int(11)       not null                  comment "上架状态(1上架 2下架)"
    ,PublishedAt      datetime                                comment "上架时间"
    ,UnPublishedAt    datetime                                comment "下架时间"
    ,LastEpis         int(11)                                 comment "更新至第几集"
    ,AllEpis          int(11)                                 comment "总集数"
    ,PayEpisFrom      int(11)                                 comment "收费起始集数"
    ,IsDelete         int(11)                                 comment "是否删除"
    ,Producer         varchar(1000)                           comment ""
    ,Recommend        varchar(100)                            comment "推荐文案"
    ,SourceSeriesId   bigint(20)                              comment "源语言短剧"
    ,Price            int(11)                                 comment "单集价格（分）"
    ,Ending           int(11)                                 comment "完结状态（1连载中 2已完结）"
    ,SeriesNameKey    varchar(2000)                           comment ""
    ,DescriptionKey   string                                  comment "短剧简介转换key"
    ,RecommendKey     varchar(100)                            comment "推荐文案转换key"
    ,SeriesLevel      int(11)                                 comment "等级 1.S 2.A 3.B 4.C"
    ,OperateLevel     int(11)                                 comment "运营等级 1.S 2.A 3.B 4.C"
    ,WorkType         int(11)                                 comment "作品类型 1.男频  2.女频 3.双番"
    ,ImageKey         int(11)                                 comment "轮播榜单配图id"
    ,ListRecommendKey string                                  comment "轮播榜单推荐语key"
    ,ListRecommend    string                                  comment "轮播榜单推荐语"
    ,Core             varchar(300)                            comment "Core ，多个用逗号隔开(1core1，2core2，3core3，4core4)"
    ,sr_updatetime    datetime                                comment "ods同步时间"
    ,sr_createtime    datetime      default current_timestamp comment "starrocks数据注入时间"
)
primary key(SeriesId)
comment "短剧-短剧剧集维度表"
distributed by hash(SeriesId) buckets 5
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;