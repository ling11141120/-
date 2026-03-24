----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_comment
-- 来源实例： old_tidb_source
-- 来源表： short_video.comment
-- 来源负责： 施鼎锋(250610)
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2026-03-23
----------------------------------------------------------------

drop table if exists ods.ods_tidb_short_video_comment;
create table ods.ods_tidb_short_video_comment(
     dt              date      not null                           comment "分区日期"
    ,Id              bigint    not null                           comment "评论id"
    ,AccountId       bigint                                       comment "评论用户Id"
    ,CreateTime      datetime  not null                           comment "创建时间"
    ,UpdateTime      datetime                                     comment "更新时间"
    ,CreateTimestamp bigint                                       comment "创建时间戳"
    ,Content         string                                       comment "评论内容"
    ,WordCount       int                                          comment "字数统计"
    ,SeriesId        bigint                                       comment "剧集id"
    ,EpisId          bigint                                       comment "分集id"
    ,LikeCount       bigint                                       comment "点赞数量"
    ,ReplyCount      bigint                                       comment "回复数量"
    ,FirstReplyId    bigint                                       comment "第一个回复id"
    ,IsDelete        tinyint                                      comment "是否删除"
    ,RegionId        tinyint                                      comment "归属区域 id，1：香港，2：北美；"
    ,CommentType     int                                          comment "评论类型"
    ,EncodeLength    int                                          comment "字符编码长度统计"
    ,LangId          int                                          comment "语言id"
    ,SpamSource      int                                          comment "限制来源： 1人工 10模型 11模型正常后GPT复审 100 命中敏感词 101命中数字数量大于N 102包含网址103重复字符 104字符串相似度/刷评 0命中旧规则屏蔽"
    ,Status          int                                          comment "评论状态：1正常 2垃圾 5待审核"
    ,PlayProgress    int                                          comment "播放时长，对应当前剧集的播放进度"
    ,IsDanmaku       int                                          comment "是否用作弹幕，1-是，0-否"
    ,AiDeal          int                                          comment "是否ai处理过，1-是，0-否"
    ,sr_createtime   datetime  not null default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime   datetime  not null default current_timestamp comment "starrocks数据更新时间"
)
primary key (dt, Id)
COMMENT "短剧评论表"
partition by date_trunc("month", dt)
distributed by hash(dt, Id)
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "AccountId, SeriesId, EpisId",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "compression" = "LZ4"
    "partition_live_number" = "733"
)
;