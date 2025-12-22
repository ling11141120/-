drop table if exists dwd.dwd_user_appstartlog;
create table dwd.dwd_user_appstartlog (
     dt              date         not null    comment 'createtime 分区'
    ,Productid       int          not null    comment '产品id'
    ,AutoId          bigint       not null    comment '自增id'
    ,UserId          bigint                   comment '用户id'
    ,CreateTime      datetime                 comment '用户登录时间'
    ,IP              varchar(512)             comment '用户ip地址'
    ,MT              int                      comment '终端'
    ,IMEI            varchar(512)             comment '用户手机设备识别码'
    ,IMSI            varchar(512)             comment '国际移动用户识别码'
    ,MAC             varchar(512)             comment '硬件地址'
    ,Ver             int                      comment '版本号'
    ,Chl             varchar(512)             comment '投放渠道值'
    ,Device          varchar(512)             comment '设备号'
    ,SW              int                      comment '客户端分辨率'
    ,SH              int                      comment '客户端分辨率'
    ,DeviceGUID      varchar(512)             comment '设备guid'
    ,AppId           int                      comment '产品appid'
    ,etl_time        datetime                 comment '处理时间'
)
primary key (dt, Productid, AutoId)
comment '用户域用户登录事实表'
distributed by hash (Productid, AutoId)
partition by date_trunc('day', dt)
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "UserId, CreateTime",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;