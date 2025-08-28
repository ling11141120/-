drop table if exists dwd.dwd_user_appstartlog;
create table if not exists dwd.dwd_user_appstartlog (
     dt              DATE         not null    comment 'createtime 分区'
    ,Productid       INT          not null    comment '产品id'
    ,AutoId          BIGINT       not null    comment '自增id'
    ,UserId          BIGINT                   comment '用户id'
    ,CreateTime      DATETIME                 comment '用户登录时间'
    ,IP              VARCHAR(512)             comment '用户ip地址'
    ,MT              INT                      comment '终端'
    ,IMEI            VARCHAR(512)             comment '用户手机设备识别码'
    ,IMSI            VARCHAR(512)             comment '国际移动用户识别码'
    ,MAC             VARCHAR(512)             comment '硬件地址'
    ,Ver             INT                      comment '版本号'
    ,Chl             VARCHAR(512)             comment '投放渠道值'
    ,Device          VARCHAR(512)             comment '设备号'
    ,SW              INT                      comment '客户端分辨率'
    ,SH              INT                      comment '客户端分辨率'
    ,DeviceGUID      VARCHAR(512)             comment '设备guid'
    ,AppId           INT                      comment '产品appid'
    ,etl_time        DATETIME                 comment '处理时间'
)
primary key (dt, Productid, AutoId)
comment '用户域用户登录事实表'
distributed by hash (Productid, AutoId)
partition by date_trunc('day', dt)
properties ("replication_num" = "3",
            "bloom_filter_columns" = "UserId, CreateTime",
            "in_memory" = "false",
            "enable_persistent_index" = "true",
            "replicated_storage" = "true",
            "compression" = "LZ4"
)
;