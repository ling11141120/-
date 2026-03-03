----------------------------------------------------------------
-- 目标表： ods.ods_en_mysqllog_readerlog_xx_log_centercoinlotterylog
-- 来源实例：en_mysqllog-slave
-- 来源表： readerlog_fr.log_centercoinlotterylog
--        readerlog_pt.log_centercoinlotterylog
--        readerlog_ft.log_centercoinlotterylog
--        readerlog_en.log_centercoinlotterylog
--        readerlog_ru.log_centercoinlotterylog
--        readerlog_sp.log_centercoinlotterylog
--        readerlog_jp.log_centercoinlotterylog
--        readerlog_id.log_centercoinlotterylog
--        readerlog_th.log_centercoinlotterylog
--        readerlog_and2.log_centercoinlotterylog_2026xx
--        readerlog_cd2.log_centercoinlotterylog_2026xx
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人：xjc
-- 开发日期：2026-02-25
----------------------------------------------------------------

drop table if exists ods.ods_en_mysqllog_readerlog_xx_log_centercoinlotterylog;
create table ods.ods_en_mysqllog_readerlog_xx_log_centercoinlotterylog (
    dt              date        not null                     comment "日期"
   ,product_id      int         not null                     comment "产品id"
   ,id              bigint      not null                     comment "主键id"
   ,userid          bigint                                   comment "用户id"
   ,createtime      datetime                                 comment "创建时间"
   ,appid           int                                      comment "应用id"
   ,isreplacetype   int                                      comment "是否替换类型"
   ,propid          int                                      comment "奖品id"
   ,proptype        int                                      comment "奖励类型 3礼券，4限时免费卡，5实物"
   ,minutes         int                                      comment "分钟数"
   ,validity        int         not null                     comment "有效期（天）"
   ,number          int                                      comment "获得数量"
   ,actid           int                                      comment "活动id"
   ,source          varchar(300)                             comment "来源"
   ,sr_createtime   datetime    default current_timestamp    comment "starrocks入库时间"
   ,sr_updatetime   datetime    default current_timestamp    comment "starrocks数据更新时间"
)
primary key(dt,product_id,id)
comment "中心币抽奖日志"
partition by date_trunc("month", dt)
distributed by hash(product_id,id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "LZ4"
)
;