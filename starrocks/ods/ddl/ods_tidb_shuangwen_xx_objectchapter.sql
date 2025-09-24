----------------------------------------------------------------
-- 目标表： ods.ods_tidb_shuangwen_xx_objectchapter
-- 来源实例：hk-cm-mysql-slave
-- 来源表：
--        fanyidb_tidb.object chapter
--        shuangwen_tidb_en.objectchapter
--        shuangwen_tidb_sp.objectchapter
-- 来源负责：
-- 采集工具：SeaTunnel
-- 开发人：xjc
-- 开发日期：2023-07-25
----------------------------------------------------------------



DROP TABLE IF EXISTS ods_tidb_shuangwen_xx_objectchapter;
CREATE TABLE IF NOT EXISTS ods_tidb_shuangwen_xx_objectchapter (
     productid                      int(11)             not null                                    comment "产品id"
    ,Id                             int(11)             not null                                    comment "章节编号"
    ,BookId                         bigint(20)          null                                        comment "书籍id"
    ,ChapterId                      bigint(20)          null                                        comment "源书籍Id"
    ,ObjectBookId                   int(11)             null                                        comment "项目图书Id"
    ,InterpreterId                  bigint(20)          null                                        comment "译员Id"
    ,ChapterName                    varchar(65533)      null                                        comment "章节名"
    ,Cretatime                      datetime            null                                        comment "创建时间"
    ,InterpreterName                varchar(65533)      null                                        comment "译员名称"
    ,Status                         int(11)             null                                        comment "状态"
    ,Length                         bigint(20)          null                                        comment "源章节字数"
    ,ChapterContent                 varchar(65533)      null                                        comment "章节内容"
    ,ProofreadingId                 bigint(20)          null                                        comment "校对人员id"
    ,ProofreadingName               varchar(65533)      null                                        comment "校对人员名称"
    ,Fraction                       int(11)             not null                                    comment "当前分数"
    ,Correlation                    int(11)             not null                                    comment "总分"
    ,EditId                         bigint(20)          not null                                    comment "编辑id"
    ,EditName                       varchar(65533)      null                                        comment "编辑名称"
    ,InsertStatus                   int(11)             not null                                    comment "0 未发布 1 已发布"
    ,RemovalStatus                  int(11)             not null                                    comment "移除状态"
    ,PublishTime                    datetime            null                                        comment "完成翻译时间"
    ,IsComplete                     int(11)             not null                                    comment "是否完成翻译 0 未完成 1 已完成"
    ,EnLength                       int(11)             not null                                    comment "英文字数"
    ,ForeignProofreadingName        varchar(65533)      null                                        comment "外籍校对名称"
    ,ForeignProofreadingId          bigint(20)          not null                                    comment "外籍校对id"
    ,GrammarScore                   int(11)             not null                                    comment "基本语法错误（拼写、单复数、时态）"
    ,SyntaxScore                    int(11)             not null                                    comment "语法分"
    ,FluencyScore                   int(11)             not null                                    comment "流畅分"
    ,ForeignStatus                  int(11)             not null                                    comment "是否开始外籍校对"
    ,IsForeign                      int(11)             not null                                    comment "是否开始外籍校对 0 未完成 1 已完成"
    ,ForeignTime                    datetime            null                                        comment "外籍校对时间"
    ,IsWk                           int(11)             not null                                    comment "是否挖坑 0 未结束 1 结束挖坑"
    ,WkTime                         datetime            null                                        comment "挖坑时间"
    ,IsSelf                         int(11)             not null                                    comment "是否自校完成 0 未完成 1 已完成"
    ,SelfTime                       datetime            null                                        comment "自校完成时间"
    ,NoSelfCount                    int(11)             not null                                    comment "挖坑的总数"
    ,CompleteTime                   datetime            null                                        comment "外校完成时间"
    ,IsNoForeign                    int(11)             not null                                    comment "外籍重新校对 0 未完成 1 已完成"
    ,NoForeignCount                 int(11)             not null                                    comment "外籍校对章节错误数"
    ,NoForeignPassCount             int(11)             not null                                    comment "一校错误数"
    ,ForeignLength                  int(11)             not null                                    comment "二校单词数"
    ,ModifyLength                   int(11)             not null                                    comment "外校单词错误数"
    ,ForeignReceiveTime             datetime            null                                        comment "外校领取时间"
    ,ScheduleStatus                 int(11)             null                                        comment "0:译员未开始,1:译员开始,2:译员完成,3:外校开始,4:外校完成,5:自校开始,6:自校完成,7:二校开始,8:二校完成,9:外校重校开始,10:外校重校完成,11:自校重校开始,12:自校重校完成"
    ,LastScheduleStatus             int(11)             null                                        comment "上一次开始校对ScheduleStatus的状态"
    ,TranslateStatus                int(11)             not null                                    comment "是否机器翻译 0 不翻译 1 待翻译 2 已翻译"
    ,TranslateTime                  datetime            null                                        comment "西语机翻时间"
    ,InterpreterPercent             decimal(18, 2)      not null                                    comment "译员最终修改比例"
    ,ForeignPercent                 decimal(18, 2)      not null                                    comment "外校最终修改比例"
    ,ChapterNumber                  int(11)             not null                                    comment "章节序号"
    ,InterpreterDeferredTime        int(11)             not null                                    comment "初译申请延时时间"
    ,SelfDeferredTime               int(11)             not null                                    comment "自校申请延时时间"
    ,ForeignDeferredTime            int(11)             not null                                    comment "外校申请延时时间"
    ,ForeignCompleteTime            datetime            null                                        comment "外校完成时间"
    ,AuditorId                      bigint(20)          not null                                    comment "二校审核人员"
    ,IsRobot                        tinyint(4)          not null                                    comment "英文是否机翻"
    ,MachinePercent                 decimal(18, 2)      not null                                    comment "机翻修改比例"
    ,RollBackStatus                 int(11)             not null                                    comment "章节驳回状态"
    ,RobotVersion                   varchar(65533)      null                                        comment "机翻版本"
    ,FirstTranslationGrade          varchar(65533)      null                                        comment "初译审核评分"
    ,FirstProofreadGrade            varchar(65533)      null                                        comment "初校审核评分"
    ,ProofreadGrade                 varchar(65533)      null                                        comment "初校审核评分"
    ,RobotLength                    int(11)             null                                        comment "机翻字数"
    ,Version                        int(11)             null                                        comment "版本号"
    ,CheckStatus                    int(11)             null                                        comment "抽查状态，0：关闭，1：质检抽查，2：一校抽查，3：二校抽查"
    ,DelStatus                      int(11)             null                                        comment "删除状态"
    ,TranslateChapterName           varchar(65533)      null                                        comment "目标语章节名"
    ,ProofreadCompleteTime          datetime            null                                        comment "二校完成时间"
    ,FirstAuditorGrade              varchar(65533)      null                                        comment "试二校评分"
    ,IsReInterpreter                int(11)             null                                        comment "是否译员重校"
    ,IsReInterpreterTime            datetime            null                                        comment "译员重校时间"
    ,sr_createtime                  datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP          comment "数据创建时间"
    ,sr_updatetime                  datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP          comment "数据更新时间"
)
primary key(productid, Id)
comment "翻译章节表"
distributed by hash(productid, Id) buckets 3
properties ("replication_num" = "3",
            "bloom_filter_columns" = "BookId, Id",
            "in_memory" = "false",
            "enable_persistent_index" = "true",
            "replicated_storage" = "true",
            "compression" = "LZ4"
)
;