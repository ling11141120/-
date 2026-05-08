----------------------------------------------------------------
-- 目标表：ods_tidb_unifypush_log_apps
-- 来源实例：old_tidb_source
-- 来源表：unifypush_log.apps
-- 来源负责人：串总
-- 开发人：qhr
-- 开发日期：2026-05-08
----------------------------------------------------------------

create table if not exists ods.ods_tidb_unifypush_log_apps (
     Id               int          not null                  comment "Id"
    ,AppName          varchar(765)                           comment "应用名称"
    ,AppRemark        varchar(765)                           comment "说明"
    ,MT               int                                    comment "平台"
    ,PackageName      varchar(765)                           comment "包名"
    ,CreateTime       datetime(3)                            comment "创建时间"
    ,IsInvalid        tinyint                                comment "是否有效"
    ,AppKey           varchar(765)                           comment "请求签名Key"
    ,AppSecret        varchar(765)                           comment "请求签名密钥"
    ,ChannelType      int                                    comment "1:苹果APN 2:谷歌FCM"
    ,ApnsJwtType      int                                    comment "Apns Jwt类型"
    ,Config           string                                 comment "推送配置"
    ,DisableSign      tinyint                                comment "是否开启签名验证"
    ,AppGroup         varchar(20)                            comment "应用组"
    ,ProductId        varchar(20)                            comment "ProductId"
    ,OrginalAppId     varchar(20)                            comment "AppId（原始AppId，非push规定的appid）"
    ,Core             int                                    comment "Core"
    ,Lang             varchar(12)                            comment "语言"
    ,KeepaliveEnabled tinyint                                comment "是否启用发送保活消息"
    ,KeepaliveMinVer  int                                    comment "发送保活消息要求的最低设备版本号"
    ,sr_createtime    datetime     default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime    datetime     default current_timestamp comment "starrocks数据更新时间"
)
primary key(id)
comment "海阅-push资源位需要推送的消息表"
distributed by hash(id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "false",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
