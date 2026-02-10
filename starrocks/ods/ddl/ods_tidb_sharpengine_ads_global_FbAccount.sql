----------------------------------------------------------------
-- 目标表：  ods_tidb_sharpengine_ads_global_FbAccount
-- 来源实例：new_tidb_source
-- 来源表：  sharpengine_ads_global.FbAccount
-- 采集工具： SeaTunnel
-- 开发人： wx
-- 开发日期： 2025-10-17
----------------------------------------------------------------

drop table if exists ods.ods_tidb_sharpengine_ads_global_FbAccount;
create table ods.ods_tidb_sharpengine_ads_global_FbAccount (
     id                                int(11)    not null                               comment ""
    ,account                           varchar(128)                                      comment ""
    ,secret                            varchar(128)                                      comment ""
    ,pageid                            varchar(128)                                      comment ""
    ,appid                             varchar(128)                                      comment ""
    ,appurl                            varchar(500)                                      comment ""
    ,creattime                         datetime                                          comment ""
    ,productid                         int(11)                                           comment ""
    ,productname                       varchar(128)                                      comment ""
    ,mt                                int(11)                                           comment ""
    ,token                             varchar(500)                                      comment ""
    ,insid                             varchar(500)                                      comment ""
    ,status                            int(11)                                           comment ""
    ,autofillad                        int(11)                                           comment ""
    ,updatestatus                      int(11)                                           comment ""
    ,chl                               varchar(128)                                      comment ""
    ,core                              int(11)                                           comment ""
    ,fbadruleid                        int(11)                                           comment ""
    ,adautoactive                      int(11)                                           comment ""
    ,statuschangetime                  datetime                                          comment ""
    ,fbaccounttype                     int(11)                                           comment ""
    ,rowversion                        bigint(20)                                        comment ""
    ,spendcap                          bigint(20)       default "0"                      comment ""
    ,amountspent                       bigint(20)       default "0"                      comment ""
    ,putproductid                      int(11)          default "0"                      comment ""
    ,currentlanguage2                  int(11)                                           comment ""
    ,accountadtype                     int(11)          default "0"                      comment ""
    ,exchangerate                      double           default "1"                      comment ""
    ,isproductputaccount               int(11)          default "0"                      comment "是否书籍目录投放账号"
    ,lastputtime                       datetime                                          comment "最新的投放数据的时间"
    ,fbadnetworktype                   int(11)          default "0"                      comment "fb投放类型,1app 2web"
    ,accountchangetoremarketingtime    datetime         default "2020-01-01 00:00:00"    comment "何时设置为再营销类型"
    ,thirdpaydatasetid                 varchar(255)                                      comment "第三方充值上传的fb中的datasetid"
    ,lastinsightinfo                   varchar(2000)                                     comment "最后一次抓取dailyinsight的信息"
    ,timezoneoffset                    int(11)                                           comment "相对utc的小时差"
    ,accounttz                         int(11)                                           comment "账号时区 -13=GMT-5默认时区|-20=GMT-12英西时区|-18=GMT-10葡语时区|-7=GMT+1亚洲时区"
    ,sr_createtime                     datetime         default current_timestamp        comment "starrocks数据注入时间"
    ,sr_updatetime                     datetime         default current_timestamp        comment "starrocks数据更新时间"
    ,InstId                            bigint           default '0'                      comment '机构ID'
)
primary key(id)
comment "olap"
distributed by hash(id) buckets 20
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "lz4"
)
;