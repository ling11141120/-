----------------------------------------------------------------
-- 目标表： ods.ods_tidb_readernovel_tidb_xx_bookcommentreplyitem
-- 来源实例： old_tidb_source
-- 来源表：
--        readernovel_tidb_fr.bookcommentreplyitem
--        readernovel_tidb_pt.bookcommentreplyitem
--        readernovel_tidb_ft.bookcommentreplyitem
--        readernovel_tidb_en.bookcommentreplyitem
--        readernovel_tidb_ru.bookcommentreplyitem
--        readernovel_tidb_sp.bookcommentreplyitem
--        readernovel_tidb_jp.bookcommentreplyitem
--        readernovel_tidb_id.bookcommentreplyitem
--        readernovel_tidb_th.bookcommentreplyitem
--        readernovel_tidb_and2.bookcommentreplyitem
--        readernovel_tidb_cd2.bookcommentreplyitem
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人：xjc
-- 开发日期： 2026-02-04
----------------------------------------------------------------

drop table if exists ods.ods_tidb_readernovel_tidb_xx_bookcommentreplyitem;
create table ods.ods_tidb_readernovel_tidb_xx_bookcommentreplyitem (
     dt                    date            not null                     comment "分区日期"
    ,product_id            int             not null                     comment "产品id"
    ,id                    bigint          not null                     comment "回复id"
    ,senderid              bigint          not null                     comment "发送者id"
    ,sendername            varchar(765)    not null                     comment "发送者昵称"
    ,content               string                                       comment "回复内容"
    ,replytime             datetime        not null                     comment "回复时间"
    ,pid                   bigint          not null                     comment "该回复对应的评论id"
    ,headid                int             not null                     comment "发送者头像id"
    ,usersource            int                                          comment "用户来源 0:畅读,1:一起读书"
    ,senderlv              int                                          comment "发送者level"
    ,commentstatus         int             not null                     comment "评论状态"
    ,senderexp             int                                          comment "发送者exp"
    ,storage               string                                       comment "存储内容"
    ,classify              int             not null                     comment "评论鉴别 0,1:正常评论 2:垃圾评论"
    ,classification        varchar(765)                                 comment "分类名称"
    ,commentsource         int                                          comment "评论来源 0:小说 1:有声"
    ,isconvertformredis    tinyint                                      comment "是否从redis转换"
    ,supportcount          int                                          comment "点赞数"
    ,myclassify            double                                       comment "评论鉴别分数"
    ,source                int                                          comment "来源"
    ,toname                varchar(765)                                 comment "被回复人"
    ,newcontent            string                                       comment "内容"
    ,hashandle             tinyint         not null                     comment "是否已处理"
    ,ischeck               tinyint                                      comment "是否审核"
    ,spamsource            int                                          comment "被标记的垃圾源"
    ,sr_createtime         datetime        default current_timestamp    comment "starrocks数据注入时间"
    ,sr_updatetime         datetime        default current_timestamp    comment "starrocks数据更新时间"
)
primary key(dt, product_id, id)
comment "书籍评论回复表"
partition by date_trunc("year", dt)
distributed by hash(dt, product_id, id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "LZ4"
)
;