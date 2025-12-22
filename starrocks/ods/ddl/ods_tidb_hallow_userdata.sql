----------------------------------------------------------------
-- 目标表： ods.ods_tidb_hallow_userdata
-- 来源实例： old_tidb_source
-- 来源表： hallow.userdata
-- 来源负责： chh
-- 采集工具： SeaTunnel
-- 开发人：qhr
-- 开发日期： 2025-12-02
----------------------------------------------------------------

drop table if exists ods.ods_tidb_hallow_userdata;
create table ods.ods_tidb_hallow_userdata (
     Id                       bigint          not null comment '用户id'
    ,ConversationId           varchar(765)             comment '会话id'
    ,UpdateTime               datetime        not null comment '更新时间'
    ,RemarketingTime          datetime                 comment '再召回时间'
    ,AttributionDropTime      datetime                 comment '归因丢弃时间'
    ,AdSetName                varchar(765)             comment '归因成功的广告组名'
    ,AdSetId                  varchar(765)             comment '归因成功的广告组Id'
    ,AdCampId                 varchar(765)             comment '归因成功的广告系列Id'
    ,AdCampName               varchar(765)             comment '归因成功的广告系列名'
    ,SourceChl                varchar(765)             comment '归因成功的来源渠道'
    ,IsRemarketing            int                      comment '归因成功的是否再营销标记'
    ,DynamicIslandSwitch      int                      comment '灵动岛开关，1：开，0关'
    ,LastCourseId             bigint                   comment '上次学习的课程Id'
    ,WeekChargePlanPrice      decimal(18, 2)           comment '周充值方案金额'
    ,HasCharge                int                      comment '有无充值， 0：无 1：有'
    ,FirstChargeAmount        decimal(18, 2)           comment '首次充值金额'
    ,TotalChargeAmount        decimal(18, 2)           comment '累计充值金额'
    ,LastChargeAmount         decimal(18, 2)           comment '最近一次充值金额'
    ,AdverUnlockCount         int                      comment '看广告解锁权益次数'
    ,FirstECPMReportValue     decimal(30, 20)          comment '第一次eCPM的值'
    ,LastECPMReportValue      decimal(30, 20)          comment '最后一次eCPM的值'
    ,AdPreloadReportNum       int                      comment '广告预加载上报次数'
    ,AdPreloadResetTime       datetime                 comment '广告预加载上次重置时间'
    ,AskTheBibleUnreadMessage int             not null comment 'AskTheBible聊天未读消息数 为0则无未读消息'
    ,BibleJoyUnreadMessage    int             not null comment 'BibleJoy聊天未读消息数 为0则无未读消息'
    ,sr_createtime            datetime                 comment 'starrocks入库时间'
    ,sr_updatetime            datetime                 comment 'starrocks数据更新时间'
)
primary key (Id)
comment "圣经用户信息扩展表"
distributed by hash(Id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "false",
    "replicated_storage" = "true",
    "compression" = "lz4"
)
;