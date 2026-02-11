----------------------------------------------------------------
-- 目标表： ods.ods_tidb_readernovel_tidb_xx_paragraphcommentitem
-- 来源实例： old_tidb_source
-- 来源表：
--        readernovel_tidb_fr.paragraphcommentitem
--        readernovel_tidb_pt.paragraphcommentitem
--        readernovel_tidb_ft.paragraphcommentitem
--        readernovel_tidb_en.paragraphcommentitem
--        readernovel_tidb_ru.paragraphcommentitem
--        readernovel_tidb_sp.paragraphcommentitem
--        readernovel_tidb_jp.paragraphcommentitem
--        readernovel_tidb_id.paragraphcommentitem
--        readernovel_tidb_th.paragraphcommentitem
--        readernovel_tidb_and2.paragraphcommentitem
--        readernovel_tidb_cd2.paragraphcommentitem
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人：xjc
-- 开发日期： 2026-02-04
----------------------------------------------------------------

drop table if exists ods.ods_tidb_readernovel_tidb_xx_paragraphcommentitem;
create table ods.ods_tidb_readernovel_tidb_xx_paragraphcommentitem (
     dt                    date        not null                     comment "分区日期"
    ,productid             int         not null                     comment "产品id"
    ,Id                    bigint      not null                     comment "评论id"
    ,SenderId              bigint                                   comment "发送者id"
    ,UserSource            int                                      comment "用户来源 0:畅读,1:一起读书"
    ,SenderName            varchar(65533)                           comment "发送者昵称"
    ,HeadId                int                                      comment "发送者头像id"
    ,Content               varchar(65533)                           comment "评论内容"
    ,SendTime              datetime                                 comment "评论发送时间"
    ,ChapterId             bigint                                   comment "评论对应的章节id"
    ,ParaIndex             int                                      comment "段落索引"
    ,IsSecret              tinyint                                  comment "是否保密"
    ,Pid                   bigint      not null                     comment "父id(书籍id)"
    ,Classify              int                                      comment "评论鉴别 0,1:正常评论 2:垃圾评论"
    ,SupportCount          int         not null                     comment "点赞数"
    ,IsConvertFormRedis    tinyint                                  comment "是否从redis转换"
    ,ReplyCount            int                                      comment "回复数"
    ,MyClassify            double                                   comment "评论鉴别分数"
    ,UpdateTime            datetime                                 comment "评论或点赞时的更新时间"
    ,IsCheck               tinyint                                  comment "是否审核"
    ,sr_createtime         datetime    default current_timestamp    comment "starrocks数据注入时间"
    ,sr_updatetime         datetime    default current_timestamp    comment "starrocks数据更新时间"
    ,spamsource            int                                      comment "被标记的垃圾源"
)
primary key(dt, product_id, id)
comment "段落评论表"
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