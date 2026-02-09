----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_accountinfo
-- 来源实例： old_tidb_source
-- 来源表： short_video.accountinfo
-- 来源负责： lwb
-- 采集工具： 极光-定时链路
-- 开发人： qhr
-- 开发日期：2026-01-26
----------------------------------------------------------------

drop table if exists ods.ods_tidb_short_video_accountinfo;
create table ods.ods_tidb_short_video_accountinfo (
     Id                  bigint        not null                  comment "用户Id"
    ,Account             varchar(1000)                           comment "用户账号"
    ,Nick                varchar(1000)                           comment "昵称"
    ,Sex                 int                                     comment "性别"
    ,CreateTime          datetime                                comment "创建时间"
    ,LastLoginTime       datetime                                comment "最后登录时间"
    ,Chl2                varchar(1000)                           comment "初始渠道Id"
    ,Chl                 varchar(1000)                           comment "最新渠道id"
    ,Mt                  int                                     comment "最新平台号,1为iOS 4为安卓"
    ,Mt2                 int                                     comment "初始平台号,1为iOS 4为安卓"
    ,UniqueCdReaderId    varchar(1000)                           comment "畅读唯一设备号"
    ,CurrentLanguage2    int                                     comment "包初始语言"
    ,CurrentLanguage     int                                     comment "最新用户使用语言"
    ,CoreVer             int                                     comment "Core,默认1"
    ,CoreVer2            int                                     comment "Core,默认1"
    ,AdId                varchar(1000)                           comment "广告Id"
    ,Status              int                                     comment "用户状态：0 正常，1 禁用，2 审核中，3 审核拒绝"
    ,RegCountry          varchar(1000)                           comment "注册国家"
    ,row_update_time     datetime                                comment ""
    ,Version             int                                     comment "当前版本"
    ,IsDelete            int                                     comment "是否删除"
    ,Avatar              varchar(3000)                           comment ""
    ,InstallDate         datetime                                comment ""
    ,SourceChl           varchar(200)                            comment ""
    ,IDFA                varchar(500)                            comment "IDFA"
    ,Email               varchar(1000)                           comment ""
    ,IsOfficial          int                                     comment "是否正式用户"
    ,UniqueId            varchar(500)                            comment "三方登陆id"
    ,ThirdPartyId        int                                     comment "三方登陆类型枚举"
    ,SignNotify          int                                     comment "是否开启签到提醒"
    ,LastActiveTime      bigint                                  comment "最近活跃时间"
    ,AppNotify           int                                     comment "用户app是否开启推送"
    ,Level               int                                     comment "用户等级,0 普通用户, 1 svip"
    ,ExpireTime          bigint                                  comment "过期时间"
    ,VipStatus           int                                     comment "vip状态"
    ,ChangeDl            int                                     comment "dl是否被修改过,author:201910"
    ,regionId            int                                     comment "归属区域 id，1：香港，2：北美；"
    ,BanShopping         int                                     comment "是否被禁止消费"
    ,moneyfirstdate      datetime                                comment ""
    ,giftfirstdate       datetime                                comment ""
    ,HasDelete           int                                     comment "是否删除"
    ,LatestAttributionTs bigint                                  comment "最近一次归因时间"
    ,DropAttributionTs   bigint                                  comment "归因丢弃时间"
    ,AdSeriesId          bigint                                  comment "归因短剧 id"
    ,AdQuality           int                                     comment "归因用户质量"
    ,LoginBonusGetted    int                                     comment "登录奖励是否被领取"
    ,CommentBonusGetted  int                                     comment "评论奖励是否被领取"
    ,Password            varchar(1000)                           comment "加密后的登录密码"
    ,BindEmail           varchar(1000)                           comment "登录绑定邮箱"
    ,Appver              varchar(1000)                           comment "版本号"
    ,Ip                  varchar(1000)                           comment "ip地址"
    ,BindEmailGetted     int                                     comment "绑定邮箱是否被领取"
    ,StorePraiseGetted   int                                     comment "好评任务是否被领取"
    ,Unsubscribe         int                                     comment "退订状态"
    ,EmailBoundTime      datetime                                comment "邮件绑定时间"
    ,UnsubscribeTime     datetime                                comment "邮件退订时间"
    ,Country             varchar(1000)                           comment "当前国家"
    ,FirstOpenResId      bigint                                  comment ""
    ,imsi                varchar(500)                            comment "对应clientInfo中的afuid，华总专用。IMSI 是国际移动用户识别码（International Mobile Subscriber Identity）"
    ,iaaTag              tinyint(4)                              comment "IAA广告标识，0否1是"
    ,AppSeriesDlType     int                                     comment "首次拉起DL类型：1投放剧 2DL0剧"
    ,UniqueCdReaderId2   varchar(1000)                           comment "畅读唯一设备号（首次）"
    ,MaxSubsrcibeTime    datetime                                comment "记录所有订阅类型的最大过期时间"
    ,AddIcon             int                                     comment "是否添加桌面（pwa）,0否，1是"
    ,FbAnonymousId       varchar(500)                            comment "facebook sdk中收集anon_id"
    ,AppDlType           int                                     comment "首次拉起剧，流量类型：1:投放流量 2:自然流量 3:苹果流量"
    ,FirebaseInstanceId  varchar(500)                            comment "Google Analysis SDK app_instance_id"
    ,sr_createtime       datetime      default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime       datetime      default current_timestamp comment "starrocks数据更新时间"
)
primary key(Id)
comment "短剧用户注册信息表"
distributed by hash(Id) buckets 105
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "Account, CreateTime, row_update_time, UniqueCdReaderId",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;