drop table if exists tmp.ads_ab_exp_detail;
create table tmp.ads_ab_exp_detail (
     dt                         date           not null comment "日期分区"
    ,experimentId               bigint         not null comment "实验id"
    ,experimentGroupId          bigint         not null comment "实验组id"
    ,projectId                  int            not null comment "项目id"
    ,experimentType             int            not null comment "实验类型(1对照组、2实验组)"
    ,trackficVersion            varchar(50)    not null comment "流量版本"
    ,windowNum                  int            not null comment "窗口大小(过去n天)"
    ,totalNumberGroup           bigint                  comment "实验组的总的样本量(用策略命中人数)"
    ,arpuMean                   varchar(50)             comment "ARPU均值"
    ,arpuVar                    varchar(50)             comment "ARPU方差"
    ,adverArpuMean              varchar(50)             comment "广告ARPU均值"
    ,adverArpuVar               varchar(50)             comment "广告ARPU方差"
    ,totalAdverArpuMean         varchar(50)             comment "总广告ARPU均值"
    ,totalAdverArpuVar          varchar(50)             comment "总广告ARPU方差"
    ,adverUnlockEpisodeNumMean  varchar(50)             comment "人均广告解锁剧集均值"
    ,adverUnlockEpisodeNumVar   varchar(50)             comment "人均广告解锁剧集方差"
    ,oneExposureArpuMean        decimal(20, 6)          comment "单人曝光ARPU均值"
    ,oneExposureArpuVar         decimal(20, 6)          comment "单人曝光ARPU方差"
    ,oneExposureAllArpuMean     decimal(20, 6)          comment "单人ARPU均值"
    ,oneExposureAllArpuVar      decimal(20, 6)          comment "单人ARPU方差"
    ,oneExposureArpuDingYueMean decimal(20, 6)          comment "单人曝光ARPU(订阅)均值"
    ,oneExposureArpuDingYueVar  decimal(20, 6)          comment "单人曝光ARPU(订阅)方差"
    ,predictARPUMean            decimal(20, 6)          comment "预估ARPU均值"
    ,predictARPUVar             decimal(20, 6)          comment "预估ARPU方差"
    ,buyersNum                  int                     comment "购买总人数"
    ,buyAmount                  decimal(12, 2)          comment "购买总金额"
    ,unlockArppuMean            decimal(20, 6)          comment "人均解锁ARPPU均值"
    ,unlockArppuVar             decimal(20, 6)          comment "人均解锁ARPPU方差"
    ,unlockArpuMean             decimal(20, 6)          comment "人均解锁ARPU均值"
    ,unlockArpuVar              decimal(20, 6)          comment "人均解锁ARPU方差"
    ,saveTime                   datetime                comment "入库时间"
    ,updateTime                 datetime                comment "更新时间"
    ,watchEpisodeNumAvgMean     decimal(20, 6)          comment "人均观看剧集均值"
    ,watchEpisodeNumAvgVar      decimal(20, 6)          comment "人均观看剧集方差"
)
primary key(dt, experimentId, experimentGroupId, projectId, experimentType, trackficVersion, windowNum)
comment "AB实验明细表"
distributed by hash(experimentId) buckets 6
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "fast_schema_evolution" = "true",
    "compression" = "LZ4"
)
;

alter table tmp.ads_ab_exp_detail add columns (
     watchEpisodeNumAvgMean decimal(20, 6) comment "人均观看剧集均值"
    ,watchEpisodeNumAvgVar  decimal(20, 6) comment "人均观看剧集方差"
)