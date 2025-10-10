----------------------------------------------------------------
-- 目标表：ods.ods_mysql_zhangzhong_xzz_Book
-- 来源实例：old_starrocks_source
-- 来源表：zhangzhong_xzz.BookEditorRight
--        zhangzhong_xzz.Book
-- 来源负责：
-- 采集工具：极光-定时链路
-- 开发人：wx
-- 创建日期：2025-09-24
----------------------------------------------------------------
DROP TABLE IF EXISTS ods.ods_mysql_zhangzhong_xzz_Book;
CREATE TABLE ods.ods_mysql_zhangzhong_xzz_Book (
     BookId                    int(11)          NOT null                  COMMENT "书籍Id"
    ,BookName                  varchar(900)                               COMMENT "书名",
    ,AuthorId                  bigint(20)                                 COMMENT "作者Id"
    ,CreateTime                datetime                                   COMMENT "",
    ,UpdateTime                date                                       COMMENT "作品信息最后更新时间"
    ,SignType                  bigint(20)                                 COMMENT "签约类型： 0买断 1A签 2B签"
    ,Summary                   varchar(65535)                             COMMENT "简介",
    ,IsAudit                   smallint(6)                                COMMENT "是否已审核"
    ,IsFull                    smallint(6)                                COMMENT "是否完本 0 是连载 1是完本"
    ,Channel                   int(11)                                    COMMENT "频道 0:男频 1:女频"
    ,CategoryId                int(11)                                    COMMENT "分类Id"
    ,CoverSrc                  varchar(65535)                             COMMENT "封面图片"
    ,ChapterNum                int(11)                                    COMMENT "章节数量"
    ,FontLength                int(11)                                    COMMENT "字数",
    ,IsPutdown                 tinyint(4)                                 COMMENT "是否下架"
    ,FontPrice                 int(11)                                    COMMENT "价格，xx分每千字"
    ,Status                    int(11)          DEFAULT "0"               COMMENT ""
    ,PresentSignType           int(11)                                    COMMENT "0 一级全勤 1 二级全勤 2 三级全勤 3 四级全勤"
    ,TollStatus                int(11)          DEFAULT "0"               COMMENT ""
    ,StartVip                  int(11)          DEFAULT "0"               COMMENT ""
    ,EveryCount                int(11)          DEFAULT "0"               COMMENT ""
    ,EditorCharge              varchar(900)                               COMMENT ""
    ,ProductionType            int(11)          DEFAULT "0"               COMMENT ""
    ,AccountName               varchar(3000)                              COMMENT ""
    ,BankAccount               varchar(3000)                              COMMENT ""
    ,BankName                  varchar(3000)                              COMMENT ""
    ,BankUserName              varchar(3000)                              COMMENT ""
    ,UpdateStatus              int(11)          DEFAULT "0"               COMMENT ""
    ,VipStart                  int(11)          DEFAULT "0"               COMMENT ""
    ,VipStatus                 int(11)          DEFAULT "0"               COMMENT ""
    ,OutputStatus              int(11)          DEFAULT "0"               COMMENT ""
    ,VipStartTime              date                                       COMMENT ""
    ,VipEndTime                date                                       COMMENT ""
    ,UpdateStatusTime          date                                       COMMENT ""
    ,PlagiarismType            int(11)          NOT null DEFAULT "0"      COMMENT ""
    ,ChapterUploadStatus       int(11)          NOT null DEFAULT "0"      COMMENT ""
    ,AuthorName                varchar(1500)                              COMMENT ""
    ,QYEditor                  varchar(150)                               COMMENT ""
    ,FullTime                  date                                       COMMENT ""
    ,FS                        varchar(150)                               COMMENT ""
    ,SH                        varchar(150)                               COMMENT ""
    ,FullPrice                 int(11)                                    COMMENT ""
    ,LockStatus                int(11)          NOT null DEFAULT "0"      COMMENT ""
    ,RowVersion                bigint(20)                                 COMMENT ""
    ,StartNum                  int(11)          NOT null DEFAULT "0"      COMMENT ""
    ,EndNum                    int(11)          NOT null DEFAULT "0"      COMMENT ""
    ,CeilingReward             int(11)          NOT null DEFAULT "0"      COMMENT ""
    ,ChapterTime               varchar(150)                               COMMENT ""
    ,ChapterTimeNum            int(11)          NOT null DEFAULT "0"      COMMENT ""
    ,LadderReward              varchar(600)                               COMMENT ""
    ,ContractImgUrl            varchar(1500)                              COMMENT ""
    ,SARFT_Audit               int(11)          NOT null DEFAULT "0"      COMMENT ""
    ,IsPoint                   int(11)          NOT null DEFAULT "0"      COMMENT ""
    ,IsPkBook                  int(11)          NOT null DEFAULT "0"      COMMENT ""
    ,ContractID                varchar(900)                               COMMENT ""
    ,SideBookName              varchar(900)                               COMMENT ""
    ,SideCoverSrc              varchar(1500)                              COMMENT ""
    ,PresentReward             decimal(18, 2)                             COMMENT ""
    ,IsBadEnd                  boolean          DEFAULT "false"           COMMENT ""
    ,IsChineseSequenceNum      boolean          DEFAULT "false"           COMMENT ""
    ,IsNeedVolume              boolean          DEFAULT "false"           COMMENT ""
    ,DelStatus                 int(11)          NOT null                  COMMENT ""
    ,IsSigned                  boolean          DEFAULT "false"           COMMENT ""
    ,CharacterNames            varchar(65535)                             COMMENT ""
    ,IsCanAutoWriting          boolean          DEFAULT "false"           COMMENT ""
    ,Recommendation            varchar(3000)                              COMMENT ""
    ,IsCustomWriting           int(11)          DEFAULT "0"               COMMENT ""
    ,PutDownTime               datetime                                   COMMENT ""
    ,PutDownRemark             varchar(1500)                              COMMENT ""
    ,Remark                    varchar(1500)                              COMMENT ""
    ,VipBecomeTime             datetime                                   COMMENT ""
    ,LastUpdateTime            datetime                                   COMMENT ""
    ,EditStatus                int(11)          DEFAULT "1"               COMMENT "编辑状态 0不可编辑 1可编辑 2编辑拒绝"
    ,Outline                   varchar(65535)                             COMMENT "大纲"
    ,SignTime                  datetime                                   COMMENT "签约时间"
    ,BookCode                  varchar(50)                                COMMENT "书籍代号"
    ,CpMode                    int(11)                                    COMMENT " 合作模式 0保底 1分成"
    ,ScoreType                 int(11)                                    COMMENT "未评级 = 0, S = 1, A = 2, B = 3, C = 4"
    ,ClockTime                 datetime                                   COMMENT "打卡日时间"
    ,SpeculationTime           datetime                                   COMMENT "测推开始时间"
    ,MonthScoreStartTime       datetime                                   COMMENT "开始月度评级时间"
    ,TransferStatus            int(11)          NOT null DEFAULT "0"      COMMENT "转分成状态 0未达成 1预达 2达成"
    ,BindFullBookId            int(11)          NOT null DEFAULT "0"      COMMENT "绑定完本书籍id"
    ,BindNewBookId             int(11)          NOT null DEFAULT "0"      COMMENT "绑定新书书籍id"
    ,SignFontRewardTime        datetime                                   COMMENT "签约字数奖励时间"
    ,IsSyncSexy                int(11)                                    COMMENT "上下架状态是否同步繁体 0 否 1 是"
    ,ImageFtSrc                varchar(500)                               COMMENT "繁体封面"
    ,DepartmentType            int(11)          NOT null DEFAULT "0"      COMMENT "部门类型 0内容编辑部 1凤鸣轩"
    ,SiteId                    int(11)          NOT null DEFAULT "449"    COMMENT "SiteId"
    ,MainBookid                int(11)          NOT null DEFAULT "0"      COMMENT "主书书籍id"
    ,StoryType                 int(11)          NOT null DEFAULT "0"      COMMENT "类型0长篇小说 1短篇小说"
) 
PRIMARY KEY(BookId)
COMMENT "新掌中--书籍信息表"
DISTRIBUTED BY HASH(`BookId`) BUCKETS 1
PROPERTIES (
    "replication_num" = "3",
    "bloom_filter_columns" = "BookId",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;