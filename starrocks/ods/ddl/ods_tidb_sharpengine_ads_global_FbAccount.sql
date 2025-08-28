CREATE TABLE ods.ods_tidb_sharpengine_ads_global_FbAccount (
     Id                             int(11)       NOT NULL                               COMMENT ""
    ,Account                        varchar(128)                                         COMMENT ""
    ,Secret                         varchar(128)                                         COMMENT ""
    ,PageId                         varchar(128)                                         COMMENT ""
    ,AppId                          varchar(128)                                         COMMENT ""
    ,AppUrl                         varchar(500)                                         COMMENT ""
    ,CreatTime                      datetime                                             COMMENT ""
    ,ProductId                      int(11)                                              COMMENT ""
    ,ProductName                    varchar(128)                                         COMMENT ""
    ,Mt                             int(11)                                              COMMENT ""
    ,Token                          varchar(500)                                         COMMENT ""
    ,InsId                          varchar(500)                                         COMMENT ""
    ,Status                         int(11)                                              COMMENT ""
    ,AutoFillAd                     int(11)                                              COMMENT ""
    ,UpdateStatus                   int(11)                                              COMMENT ""
    ,Chl                            varchar(128)                                         COMMENT ""
    ,Core                           int(11)                                              COMMENT ""
    ,FbAdRuleId                     int(11)                                              COMMENT ""
    ,AdAutoActive                   int(11)                                              COMMENT ""
    ,StatusChangeTime               datetime                                             COMMENT ""
    ,FbAccountType                  int(11)                                              COMMENT ""
    ,RowVersion                     bigint(20)                                           COMMENT ""
    ,SpendCap                       bigint(20)             DEFAULT "0"                   COMMENT ""
    ,AmountSpent                    bigint(20)             DEFAULT "0"                   COMMENT ""
    ,PutProductId                   int(11)                DEFAULT "0"                   COMMENT ""
    ,CurrentLanguage2               int(11)                                              COMMENT ""
    ,AccountAdType                  int(11)                DEFAULT "0"                   COMMENT ""
    ,ExchangeRate                   double                 DEFAULT "1"                   COMMENT ""
    ,IsProductPutAccount            int(11)                DEFAULT "0"                   COMMENT "是否书籍目录投放账号"
    ,LastPutTime                    datetime                                             COMMENT "最新的投放数据的时间"
    ,FbAdNetworkType                int(11)                DEFAULT "0"                   COMMENT "fb投放类型，1app 2web"
    ,AccountChangeToRemarketingTime datetime               DEFAULT "2020-01-01 00:00:00" COMMENT "何时设置为再营销类型"
    ,ThirdPayDatasetId              varchar(255)                                         COMMENT "第三方充值上传的fb中的datasetid"
    ,LastInsightInfo                varchar(2000)                                        COMMENT "最后一次抓取dailyinsight的信息"
    ,TimeZoneOffset                 int(11)                                              COMMENT "相对utc的小时差"
    ,AccountTz                      int(11)                                              COMMENT "账号时区 -13=GMT-5默认时区|-20=GMT-12英西时区|-18=GMT-10葡语时区|-7=GMT+1亚洲时区"
    ,sr_createtime                  datetime               DEFAULT CURRENT_TIMESTAMP     COMMENT "starrocks数据注入时间"
    ,sr_updatetime                  datetime               DEFAULT CURRENT_TIMESTAMP     COMMENT "starrocks数据更新时间"
)
PRIMARY KEY(Id)
COMMENT "OLAP"
DISTRIBUTED BY HASH(Id) BUCKETS 20
PROPERTIES ("replication_num" = "3",
            "in_memory" = "false",
            "enable_persistent_index" = "true",
            "replicated_storage" = "true",
            "compression" = "LZ4"
)
;