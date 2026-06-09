----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_ai_progect
-- 来源实例：
-- 来源表：  short_video_ai.progect
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人：
-- 开发日期： 2026-06-08
----------------------------------------------------------------

drop table if exists ods.ods_tidb_short_video_ai_progect;
create table ods.ods_tidb_short_video_ai_progect (
     `Id`                    bigint       NOT NULL COMMENT "项目ID"
    ,`ProjectName`           varchar(200) NOT NULL COMMENT "项目名称"
    ,`PaintingType`          int                   COMMENT "画风类型"
    ,`Types`                 string                COMMENT "风格类型"
    ,`AspectRatio`           int                   COMMENT "视频比例"
    ,`BriefBiographyUrl`     string                COMMENT "简介URL"
    ,`BriefBiographyId`      bigint                COMMENT "简介ID"
    ,`OutLineUrl`            string                COMMENT "大纲URL"
    ,`OutLineId`             bigint                COMMENT "大纲ID"
    ,`CreateTime`            datetime              COMMENT "创建时间"
    ,`UpdateTime`            datetime              COMMENT "更新时间"
    ,`CreateUserId`          varchar(510)          COMMENT "创建人ID"
    ,`UpdateUserId`          varchar(510)          COMMENT "更新人ID"
    ,`IsDeleted`             int                   COMMENT "删除状态 0正常 1删除"
    ,`JobData`               string                COMMENT "请求"
    ,`Status`                int          NOT NULL DEFAULT "0" COMMENT "状态"
    ,`JobResp`               string                COMMENT "返回"
    ,`Error`                 string                COMMENT "错误详情"
    ,`Creator`               varchar(510)          COMMENT "创建人"
    ,`Updater`               varchar(510)          COMMENT "更新人"
    ,`ScriptType`            int                   COMMENT "剧本类型"
    ,`ProductionStatus`      int          DEFAULT "0" COMMENT "制作状态"
    ,`DefaultImgModel`       int                   COMMENT "默认选择模型"
    ,`DefaultVideoModel`     int                   COMMENT "默认视频模型"
    ,`CompletedTime`         datetime              COMMENT "完成时间"
    ,`IsTest`                int          NOT NULL DEFAULT "0" COMMENT "是否是测试 0不是，1是"
    ,`StartProductionTime`   datetime              COMMENT "开始制作时间"
    ,`PlannedCompletionTime` datetime              COMMENT "计划成片时间"
    ,`PlannedReleaseTime`    datetime              COMMENT "计划上架时间"
    ,`Summarize100`          string                COMMENT "简介100字"
    ,`Summarize200`          string                COMMENT "简介200字"
    ,`Summarize500`          string                COMMENT "简介500字"
    ,`TgtCode`               varchar(510)          COMMENT "目标代号"
    ,`TgtId`                 varchar(510)          COMMENT "目标ID"
    ,`TgtName`               varchar(510)          COMMENT "目标名称"
    ,`Language`              int          NOT NULL DEFAULT "1" COMMENT "语言"
    ,`SourceTgtCode`         varchar(510)          COMMENT "源目标代号"
    ,`IsEmptyShell`          tinyint      DEFAULT "0" COMMENT "是否是空壳项目"
    ,`DefaultLanguage`       int          NOT NULL DEFAULT "3" COMMENT "默认语言，解说漫使用"
    ,`PoBookId`              int          NOT NULL DEFAULT "0" COMMENT "推荐榜单ID"
    ,`NarrationRatio`        int          NOT NULL DEFAULT "0" COMMENT "旁白比例 0-100"
    ,`Audience`              int          DEFAULT "1" COMMENT "受众 1国内 2海外"
    ,`Theme`                 varchar(200)          COMMENT "题材"
    ,`EpisodesPerCard`       int          DEFAULT "0" COMMENT "一卡集数"
    ,`ShortVideoType`        int          DEFAULT "3" COMMENT "短剧类型"
    ,`CorrelationCode`       varchar(200)          COMMENT "关联书籍/剧本代号"
    ,`HitProductId`          int          DEFAULT "0" COMMENT "爆款ID"
    ,`ActualReleaseTime`     datetime              COMMENT "实际上架时间"
    ,`TotalEpisodes`         int                   COMMENT "上架总集数"
    ,`Level`                 int          DEFAULT "1" COMMENT "优先级别"
    ,`Duration`              int                   COMMENT "时长-秒"
    ,`TeamAiModel`           int          DEFAULT "0" COMMENT "0 SD2.0模型 3 超分模型"
    ,`NovelIpCode`           varchar(510)          COMMENT "网文IP代号"
    ,`PlannedDeliveryTime`   datetime              COMMENT "计划交付时间"
    ,`CharacterProfile`      string                COMMENT "人物简介"
    ,`ParsingFormat`         int          NOT NULL DEFAULT "0" COMMENT "0默认格式 1新格式"
    ,`HistoryBookId`         bigint       NOT NULL DEFAULT "0" COMMENT "历史排行榜ID"
    ,`PublishStatus`         int          NOT NULL DEFAULT "0" COMMENT "发布状态"
    ,`HotWord`               varchar(510)          COMMENT "热搜词"
) ENGINE = OLAP
PRIMARY KEY (`Id`)
COMMENT "项目表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
