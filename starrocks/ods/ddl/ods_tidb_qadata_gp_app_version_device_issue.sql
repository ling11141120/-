----------------------------------------------------------------
-- 目标表： ods.ods_tidb_qadata_gp_app_version_device_issue
-- 来源表： qadata.gp_app_version_device_issue
-- 开发人： qhr
-- 开发日期： 2023-08-20
----------------------------------------------------------------

create table if not exists ods.ods_tidb_qadata_gp_app_version_device_issue (
     Id               bigint        not null                  comment 'Id'
    ,InitTime         datetime      not null                  comment '数据写入时间'
    ,DeviceGuid       varchar(150)                            comment 'Guid'
    ,IssueId          varchar(150)                            comment '问题Id'
    ,IssueInfo        string                                  comment '问题'
    ,IssueUserCount   int                                     comment '受影响用户数'
    ,IssueActiveCount int                                     comment '活动数'
    ,IssueActiveRate  decimal(15,5)                           comment '活动率'
    ,AndroidVersion   varchar(300)                            comment '安卓版本'
    ,FrontCount       int                                     comment '前台问题数量'
    ,BackCount        int                                     comment '后台问题数量'
    ,RamSize          int                                     comment '内存大小'
    ,RamTotalSize     int                                     comment '总内存大小'
    ,UpdateTime       datetime                                comment '数据更新时间'
    ,sr_createtime    datetime      default current_timestamp comment 'starrocks数据注入时间'
    ,sr_updatetime    datetime      default current_timestamp comment 'starrocks数据更新时间'
)
duplicate key (Id, InitTime)
comment '谷歌Play机型问题和机型属性'
distributed by hash (Id)
properties("replication_num" = "3",
           "in_memory" = "false",
           "storage_format" = "DEFAULT",
           "enable_persistent_index" = "true",
           "compression" = "LZ4"
)
;