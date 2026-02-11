----------------------------------------------------------------
-- 目标表： ods.ods_tidb_readernovel_tidb_xx_bookcommentitem
-- 来源实例： old_tidb_source
-- 来源表：
--        readernovel_tidb_fr.bookcommentitem
--        readernovel_tidb_pt.bookcommentitem
--        readernovel_tidb_ft.bookcommentitem
--        readernovel_tidb_en.bookcommentitem
--        readernovel_tidb_ru.bookcommentitem
--        readernovel_tidb_sp.bookcommentitem
--        readernovel_tidb_jp.bookcommentitem
--        readernovel_tidb_id.bookcommentitem
--        readernovel_tidb_th.bookcommentitem
--        readernovel_tidb_and2.bookcommentitem
--        readernovel_tidb_cd2.bookcommentitem
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人：xjc
-- 开发日期： 2026-02-04
----------------------------------------------------------------

drop table if exists ods.ods_tidb_readernovel_tidb_xx_bookcommentitem;
create table ods.ods_tidb_readernovel_tidb_xx_bookcommentitem (
     dt                   date              not null                     comment "分区日期"
    ,productid            int               not null                     comment "产品id"
    ,Id                   bigint            not null                     comment "id"
    ,SenderId             bigint            not null                     comment "发送者id"
    ,SenderName           varchar(655)                                   comment "发送者昵称"
    ,HeadId               int               not null                     comment "发送者头像id"
    ,Title                varchar(655)                                   comment "评论标题"
    ,Content              varchar(65533)    not null                     comment "评论内容"
    ,Score                int               not null                     comment "打分"
    ,SendTime             datetime          not null                     comment "评论发送时间"
    ,Pid                  bigint            not null                     comment "父id(书籍id)"
    ,ExCommentId          bigint            not null                     comment "外部评论id"
    ,CommentStatus        int               not null                     comment "评论状态"
    ,UserSource           int                                            comment "用户来源 0:畅读,1:一起读书"
    ,SenderLv             int                                            comment "发送者level"
    ,SenderExp            int                                            comment "发送者exp"
    ,TopTime              datetime          not null                     comment "置顶时间"
    ,IsTop                tinyint           not null                     comment "是否置顶"
    ,ChapterId            bigint                                         comment "评论对应的章节id"
    ,IsChoice             tinyint           not null                     comment "是否精选"
    ,IsAuthor             tinyint           not null                     comment "是否是作者发的"
    ,SupportCount         int               not null                     comment "点赞数"
    ,ReplyCount           int               not null                     comment "回复数"
    ,Classify             int               not null                     comment "评论鉴别 0,1:正常评论 2:垃圾评论"
    ,Classification       varchar(655)                                   comment "分类名称"
    ,CommentSource        int                                            comment "评论来源 0:小说 1:有声 2:漫画"
    ,IsConvertFormRedis   tinyint                                        comment "是否从redis转换"
    ,MyClassify           double                                         comment "评论鉴别分数"
    ,HotNum               int                                            comment "热门数量"
    ,UpdateTime           datetime                                       comment "评论或点赞时的更新时间"
    ,IsCheck              tinyint                                        comment "是否审核"
    ,sr_createtime        datetime          default current_timestamp    comment "starrocks数据注入时间"
    ,sr_updatetime        datetime          default current_timestamp    comment "starrocks数据更新时间"
    ,spamsource           int                                            comment "被标记的垃圾源"
    ,bookcommenttype      bigint                                         comment "书籍评论类型: 0 用户评论, 1 ai评论"
)
primary key(dt, product_id, id)
comment "书籍评论表"
partition by date_trunc("month", dt)
distributed by hash(dt, product_id, id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;