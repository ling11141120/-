----------------------------------------------------------------
-- 目标表： ods.ods_tidb_shuangwen_xx_objectchapter
-- 来源实例： old_tidb_source
-- 来源表： 
--        shuangwen_tidb_en.objectchapter
--        fanyidb_tidb.objectchapter
--        shuangwen_tidb_sp.objectchapter
-- 来源负责： 
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 创建日期： 2025-09-23
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_tidb_shuangwen_xx_objectchapter;
CREATE TABLE IF NOT EXISTS ods.ods_tidb_shuangwen_xx_objectchapter (
     productid                    INT(11)        NOT NULL                  COMMENT "产品id"
    ,Id                           INT(11)        NOT NULL                  COMMENT "章节编号"
    ,BookId                       BIGINT(20)                               COMMENT "书籍id"
    ,ChapterId                    BIGINT(20)                               COMMENT "源书籍Id"
    ,ObjectBookId                 INT(11)                                  COMMENT "项目图书Id"
    ,InterpreterId                BIGINT(20)                               COMMENT "译员Id"
    ,ChapterName                  STRING                                   COMMENT "章节名"
    ,Cretatime                    DATETIME                                 COMMENT "创建时间"
    ,InterpreterName              STRING                                   COMMENT "译员名称"
    ,Status                       INT(11)                                  COMMENT "状态"
    ,Length                       BIGINT(20)                               COMMENT "源章节字数"
    ,ChapterContent               STRING                                   COMMENT "章节内容"
    ,ProofreadingId               BIGINT(20)                               COMMENT "校对人员id"
    ,ProofreadingName             STRING                                   COMMENT "校对人员名称"
    ,Fraction                     INT(11)        NOT NULL                  COMMENT "当前分数"
    ,Correlation                  INT(11)        NOT NULL                  COMMENT "总分"
    ,EditId                       BIGINT(20)     NOT NULL                  COMMENT "编辑id"
    ,EditName                     STRING                                   COMMENT "编辑名称"
    ,InsertStatus                 INT(11)        NOT NULL                  COMMENT "0 未发布 1 已发布"
    ,RemovalStatus                INT(11)        NOT NULL                  COMMENT "移除状态"
    ,PublishTime                  DATETIME                                 COMMENT "完成翻译时间"
    ,IsComplete                   INT(11)        NOT NULL                  COMMENT "是否完成翻译 0 未完成 1 已完成"
    ,EnLength                     INT(11)        NOT NULL                  COMMENT "英文字数"
    ,ForeignProofreadingName      STRING                                   COMMENT "外籍校对名称"
    ,ForeignProofreadingId        BIGINT(20)     NOT NULL                  COMMENT "外籍校对id"
    ,GrammarScore                 INT(11)        NOT NULL                  COMMENT "基本语法错误（拼写、单复数、时态）"
    ,SyntaxScore                  INT(11)        NOT NULL                  COMMENT "语法分"
    ,FluencyScore                 INT(11)        NOT NULL                  COMMENT "流畅分"
    ,ForeignStatus                INT(11)        NOT NULL                  COMMENT "是否开始外籍校对"
    ,IsForeign                    INT(11)        NOT NULL                  COMMENT "是否开始外籍校对 0 未完成 1 已完成"
    ,ForeignTime                  DATETIME                                 COMMENT "外籍校对时间"
    ,IsWk                         INT(11)        NOT NULL                  COMMENT "是否挖坑 0 未结束 1 结束挖坑"
    ,WkTime                       DATETIME                                 COMMENT "挖坑时间"
    ,IsSelf                       INT(11)        NOT NULL                  COMMENT "是否自校完成 0 未完成 1 已完成"
    ,SelfTime                     DATETIME                                 COMMENT "自校完成时间"
    ,NoSelfCount                  INT(11)        NOT NULL                  COMMENT "挖坑的总数"
    ,CompleteTime                 DATETIME                                 COMMENT "外校完成时间"
    ,IsNoForeign                  INT(11)        NOT NULL                  COMMENT "外籍重新校对 0 未完成 1 已完成"
    ,NoForeignCount               INT(11)        NOT NULL                  COMMENT "外籍校对章节错误数"
    ,NoForeignPassCount           INT(11)        NOT NULL                  COMMENT "一校错误数"
    ,ForeignLength                INT(11)        NOT NULL                  COMMENT "二校单词数"
    ,ModifyLength                 INT(11)        NOT NULL                  COMMENT "外校单词错误数"
    ,ForeignReceiveTime           DATETIME                                 COMMENT "外校领取时间"
    ,ScheduleStatus               INT(11)                                  COMMENT "0:译员未开始,1:译员开始,2:译员完成,3:外校开始,4:外校完成,5:自校开始,6:自校完成,7:二校开始,8:二校完成,9:外校重校开始,10:外校重校完成,11:自校重校开始,12:自校重校完成"
    ,LastScheduleStatus           INT(11)                                  COMMENT "上一次开始校对ScheduleStatus的状态"
    ,TranslateStatus              INT(11)        NOT NULL                  COMMENT "是否机器翻译 0 不翻译 1 待翻译 2 已翻译"
    ,TranslateTime                DATETIME                                 COMMENT "西语机翻时间"
    ,InterpreterPercent           DECIMAL(18, 2) NOT NULL                  COMMENT "译员最终修改比例"
    ,ForeignPercent               DECIMAL(18, 2) NOT NULL                  COMMENT "外校最终修改比例"
    ,ChapterNumber                INT(11)        NOT NULL                  COMMENT "章节序号"
    ,InterpreterDeferredTime      INT(11)        NOT NULL                  COMMENT "初译申请延时时间"
    ,SelfDeferredTime             INT(11)        NOT NULL                  COMMENT "自校申请延时时间"
    ,ForeignDeferredTime          INT(11)        NOT NULL                  COMMENT "外校申请延时时间"
    ,ForeignCompleteTime          DATETIME                                 COMMENT "外校完成时间"
    ,AuditorId                    BIGINT(20)     NOT NULL                  COMMENT "二校审核人员"
    ,IsRobot                      TINYINT(4)     NOT NULL                  COMMENT "英文是否机翻"
    ,MachinePercent               DECIMAL(18, 2) NOT NULL                  COMMENT "机翻修改比例"
    ,RollBackStatus               INT(11)        NOT NULL                  COMMENT "章节驳回状态"
    ,RobotVersion                 STRING                                   COMMENT "机翻版本"
    ,FirstTranslationGrade        STRING                                   COMMENT "初译审核评分"
    ,FirstProofreadGrade          STRING                                   COMMENT "初校审核评分"
    ,ProofreadGrade               STRING                                   COMMENT "初校审核评分"
    ,RobotLength                  INT(11)                                  COMMENT "机翻字数"
    ,Version                      INT(11)                                  COMMENT "版本号"
    ,CheckStatus                  INT(11)                                  COMMENT "抽查状态，0：关闭，1：质检抽查，2：一校抽查，3：二校抽查"
    ,DelStatus                    INT(11)                                  COMMENT "删除状态"
    ,TranslateChapterName         STRING                                   COMMENT "目标语章节名"
    ,ProofreadCompleteTime        DATETIME                                 COMMENT "二校完成时间"
    ,FirstAuditorGrade            STRING                                   COMMENT "试二校评分"
    ,IsReInterpreter              INT(11)                                  COMMENT "是否译员重校"
    ,IsReInterpreterTime          DATETIME                                 COMMENT "译员重校时间"
    ,sr_createtime                DATETIME       DEFAULT CURRENT_TIMESTAMP COMMENT "数据创建时间"
    ,sr_updatetime                DATETIME                                 COMMENT "数据更新时间"
)
PRIMARY KEY(productid, Id)
COMMENT "翻译章节表"
DISTRIBUTED BY HASH(productid, Id) BUCKETS 3
PROPERTIES (
    "replication_num" = "3",
    "bloom_filter_columns" = "BookId, Id",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;