----------------------------------------------------------------
-- 目标表： ods.ods_tidb_readernovel_tidb_xx_paragraphcommentreplyitem
-- 来源实例： old_tidb_source
-- 来源表：
--        readernovel_tidb_fr.paragraphcommentreplyitem
--        readernovel_tidb_pt.paragraphcommentreplyitem
--        readernovel_tidb_ft.paragraphcommentreplyitem
--        readernovel_tidb_en.paragraphcommentreplyitem
--        readernovel_tidb_ru.paragraphcommentreplyitem
--        readernovel_tidb_sp.paragraphcommentreplyitem
--        readernovel_tidb_jp.paragraphcommentreplyitem
--        readernovel_tidb_id.paragraphcommentreplyitem
--        readernovel_tidb_th.paragraphcommentreplyitem
--        readernovel_tidb_and2.paragraphcommentreplyitem
--        readernovel_tidb_cd2.paragraphcommentreplyitem
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人：xjc
-- 开发日期： 2026-02-04
----------------------------------------------------------------

drop table if exists ods.ods_tidb_readernovel_tidb_xx_paragraphcommentreplyitem;
create table ods.ods_tidb_readernovel_tidb_xx_paragraphcommentreplyitem (
     dt                    date        not null                     comment "分区日期"
    ,product_id            int         not null                     comment "产品id"
    ,id                    bigint      not null                     comment "段落评论回复id"
    ,senderid              bigint                                   comment "发送者id"
    ,sendername            string                                   comment "发送者昵称"
    ,usersource            int                                      comment "用户来源 0:畅读,1:一起读书"
    ,headid                int                                      comment "发送者头像id"
    ,content               string                                   comment "回复内容"
    ,replytime             datetime                                 comment "评论发送时间"
    ,classify              int                                      comment "评论鉴别 0,1:正常评论 2:垃圾评论"
    ,pid                   bigint      not null                     comment "回复对应的评论id"
    ,isconvertformredis    tinyint                                  comment "是否从redis转换"
    ,supportcount          int                                      comment "点赞数"
    ,myclassify            double                                   comment "评论鉴别分数"
    ,toname                varchar(765)                             comment "被回复人"
    ,newcontent            string                                   comment "内容"
    ,hashandle             tinyint     not null                     comment "是否已处理"
    ,ischeck               tinyint                                  comment "是否审核"
    ,spamsource            int                                      comment "被标记的垃圾源"
    ,sr_createtime         datetime    default current_timestamp    comment "starrocks数据注入时间"
    ,sr_updatetime         datetime    default current_timestamp    comment "starrocks数据更新时间"
)
primary key(dt, product_id, id)
comment "段落评论回复表"
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