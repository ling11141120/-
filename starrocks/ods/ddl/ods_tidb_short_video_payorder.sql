----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_payorder
-- 来源实例： video-en-mysql-slave
-- 来源表： short_video.payorder
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2023-06-03
----------------------------------------------------------------

drop table if exists ods.ods_tidb_short_video_payorder;
create table ods.ods_tidb_short_video_payorder(
     dt                  date            not null                                   comment "createtime分区"
    ,id                  int(11)         not null                                   comment "自增id"
    ,type                int(11)         not null default '0'                       comment "类型"
    ,userid              bigint(20)      not null                                   comment "用户id"
    ,used                int(11)         not null default ''                        comment "是否执行"
    ,orderid             varchar(128)    not null                                   comment "订单id"
    ,flag                int(11)         not null default '0'                       comment "标识"
    ,createtime          datetime        not null default '1970-01-01 00:00:00.000' comment '创建时间'
    ,gettime             datetime        not null default '1970-01-01 00:00:00.000' comment '获取时间'
    ,itemcount           int(11)         not null default '0'                       comment "金额数"
    ,systemtype          int(11)         not null default '0'                       comment "系统类型"
    ,receivedate         datetime                                                   comment "被接收时间"
    ,MT                  int(11)         not null default '0'                       comment "终端"
    ,CouponId            varchar(128)                                               comment "礼券id"
    ,PackageId           varchar(255)                                               comment "存放充值页面来源"
    ,ShopItem            varchar(128)                                               comment "充值类型"
    ,ExtInfo             varchar(128)                                               comment "信息"
    ,VipExpireTime       varchar(20)                                                comment "充值订阅卡时,过期时间"
    ,RealMoney           int(11)                                                    comment "给的阅币数"
    ,GiveMoney           int(11)                                                    comment "暂时无用"
    ,Amount              int(11)                                                    comment "暂时无用"
    ,ProdId              int(11)         not null default '0'                       comment "暂时无用"
    ,PayConfigId         int(11)                                                    comment "充值项的Id,可能不准确"
    ,CoreVer             int(11)                                                    comment "包体"
    ,UniqueGuid          varchar(255)                                               comment "用户设备id"
    ,TestFlag            int(11)         not null default '0'                       comment "是否是测试号充值(0正式,1测试)"
    ,BuyToken            varchar(255)                                               comment "购买时候的google的token"
    ,BaseAmount          int(11)         not null default ''                        comment "分成后的数量"
    ,Version             varchar(255)                                               comment "购买时,用户客户端的版本号"
    ,SubPayType          varchar(50)                                                comment "充值渠道"
    ,GiftMoney           int(11)                                                    comment "充值赠送的礼券数(可能不准确)"
    ,OrderInitTime       datetime                                                   comment "用户订单创建时间"
    ,CooOrderExtInfo     varchar(1000)                                              comment "合作方订单扩展"
    ,CustomData          string                                                     comment "自定义数据,透传,json格式"
    ,sr_createtime       datetime        not null default current_timestamp         comment "starrocks数据注入时间"
    ,sr_updatetime       datetime        not null default current_timestamp         comment "starrocks数据更新时间"
)
primary key(dt, id)
comment '海外短剧-用户充值表'
partition by range(dt)
(start ("2023-07-05") end ("2023-11-24") every (interval 1 day))
distributed by hash(dt, id) buckets 1
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "userid,orderid",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "day",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-2147483648",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "1",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "storage_format" = "DEFAULT",
    "enable_persistent_index" = "true",
    "compression" = "LZ4"
)
;