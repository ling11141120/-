----------------------------------------------------------------
-- 目标表： ods.ods_tidb_shuangwen_en_objectbook
-- 来源实例： hk-cm-mysql-slave
-- 来源表： 
--        shuangwen_tidb_en.objectbook
--        fanyidb_tidb.objectbook
--        shuangwen_tidb_sp.objectbook
-- 来源负责： 
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 创建日期： 2025-09-23
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_tidb_shuangwen_en_objectbook;
CREATE TABLE IF NOT EXISTS ods.ods_tidb_shuangwen_en_objectbook (
     productid                     INT(11)        NOT NULL                  COMMENT "产品id"
    ,Id                            INT(11)        NOT NULL                  COMMENT "自增id"
    ,BookName                      VARCHAR(2000)                            COMMENT "书籍名称"
    ,BookId                        BIGINT(20)                               COMMENT "来源书籍Id"
    ,SwBookId                      BIGINT(20)                               COMMENT "翻译书籍Id"
    ,AuthorId                      BIGINT(20)                               COMMENT "作者Id"
    ,CretaeTime                    DATETIME                                 COMMENT "创建时间"
    ,GroupId                       INT(11)                                  COMMENT ""
    ,ChapterNum                    INT(11)                                  COMMENT ""
    ,Status                        INT(11)                                  COMMENT "状态"
    ,AuthorName                    VARCHAR(2000)                            COMMENT "作者名称"
    ,Coefficient                   DECIMAL(18, 2)                           COMMENT "稿费系数"
    ,StartNum                      INT(11)                                  COMMENT "常规加更"
    ,EndNum                        INT(11)                                  COMMENT "加更上限"
    ,Reward                        INT(11)                                  COMMENT ""
    ,CeilingReward                 INT(11)                                  COMMENT ""
    ,ChapterTime                   VARCHAR(600)                             COMMENT "章节发布时间"
    ,ChapterTimeNum                INT(11)                                  COMMENT ""
    ,LadderReward                  VARCHAR(2000)                            COMMENT ""
    ,ReceiveGroupId                INT(11)                                  COMMENT ""
    ,RewardExplain                 VARCHAR(2000)                            COMMENT ""
    ,KindleChapterNum              INT(11)                                  COMMENT "章节系数"
    ,WeekWordCount                 INT(11)                                  COMMENT "周更单词"
    ,BookType                      INT(11)                                  COMMENT "书籍类型 0 中文图书 1 英文图书"
    ,AutomaticStatus               INT(11)                                  COMMENT "是否自动发布章节 0 关闭 1 开启"
    ,SelfDay                       INT(11)                                  COMMENT "自校完成天数"
    ,ProofreadingDay               INT(11)                                  COMMENT "校对延期时间"
    ,ForeignProofreadDay           INT(11)                                  COMMENT "外校延期时间"
    ,LastChapter                   INT(11)                                  COMMENT "最后发布章节序号"
    ,IsRobot                       INT(11)                                  COMMENT "是否机翻"
    ,RobotChapterCount             INT(11)                                  COMMENT "机翻章节数"
    ,IsRollBack                    INT(11)                                  COMMENT "是否驳回"
    ,RollBackNumber                INT(11)                                  COMMENT "最后驳回序号"
    ,CommentTime                   DATETIME                                 COMMENT "打赏评论时间"
    ,ToLanguage                    INT(11)                                  COMMENT "输出语言"
    ,MachineRatio                  DECIMAL(5, 2)                            COMMENT "机翻修改比例"
    ,ModifyRatio                   DECIMAL(5, 2)                            COMMENT "外校修改比例"
    ,UnlockFlow                    INT(11)                                  COMMENT "解锁流程"
    ,IsAnewRobot                   INT(11)                                  COMMENT "是否重新机翻"
    ,IsStopUpdate                  INT(11)                                  COMMENT "是否停更"
    ,StopUpdateDay                 INT(11)                                  COMMENT "停更天数"
    ,StopUpdateTime                DATETIME                                 COMMENT "停更时间"
    ,StopUpdatePerformedTime       DATETIME                                 COMMENT ""
    ,FromLanguage                  INT(11)                                  COMMENT "输入语言"
    ,IsCustom                      INT(11)                                  COMMENT "是否定制文"
    ,IsSelf                        INT(11)                                  COMMENT "是否跳过自校 0不是，1是"
    ,SignType                      INT(11)                                  COMMENT "签约类型"
    ,RobotType                     INT(11)                                  COMMENT "机翻类型0：百度，1谷歌，2chatgpt"
    ,IsParagraph                   INT(11)                                  COMMENT "是否分段"
    ,BookCode                      VARCHAR(1000)                            COMMENT "书籍代号"
    ,ObjectBookType                INT(11)                                  COMMENT "图书书籍类型,0-网文 1-短剧"
    ,IsCostRate                    INT(11)                                  COMMENT "是否计算成本率,0-否 1-是"
    ,IsShortVideo                  INT(11)                                  COMMENT "是否来源短剧"
    ,ChapterTotalLength            INT(11)                                  COMMENT "是否来源短剧"
    ,HasChangeChapter              INT(11)                                  COMMENT "章节总数"
    ,HasChangeDictionary           INT(11)                                  COMMENT "源章节是否变更"
    ,FromObjectBookId              INT(11)                                  COMMENT "源字典是否变更"
    ,Level                         INT(11)                                  COMMENT "中文剧壳翻译Id"
    ,Score                         DECIMAL(18, 2)                           COMMENT "翻译优先级"
    ,ModelIds                      VARCHAR(1000)                            COMMENT "机翻评分"
    ,HasRefinement                 INT(11)                                  COMMENT "机翻流程模型"
    ,IsRefinement                  INT(11)                                  COMMENT "是否精修"
    ,StoryType                     INT(11)                                  COMMENT "类型0长篇小说 1短篇小说"
    ,IsDictionaryFinish            INT(11)                                  COMMENT "是否词典完成"
    ,row_update_time               DATETIME                                 COMMENT ""
    ,AiTaskId                      BIGINT(20)                               COMMENT "词典提取任务Id"
    ,IsExtractFinish               INT(11)                                  COMMENT "是否提取完成，默认为完成 0未完成，1完成"
    ,IsMaterial                    INT(11)                                  COMMENT "是否素材"
    ,IsFinishNotice                INT(11)                                  COMMENT "是否完成翻译文案素材通知标识 0否 1是"
    ,IsFinishOutTest               INT(11)                                  COMMENT "是否完成外测标识 0否 1是"
    ,IsIntroduceBook               INT(11)                                  COMMENT "是否书名简介翻译书籍 0否  1是"
    ,IsIntroduceTask               INT(11)                                  COMMENT "是否下单书名简介翻译任务 0否  1是"
    ,AutoCollectionStatus          INT(11)                                  COMMENT "自动化领稿生效 0生效  1不生效"
    ,AiTagStatus                   INT(11)                                  COMMENT "大模型tag判断状态  0无，1无需处理 2已处理"
    ,AiTagTaskId                   INT(11)                                  COMMENT "大模型tag任务id"
    ,ShortVideoCheckStatus         INT(11)                                  COMMENT "短剧抽查状态 null无需抽查 0待抽查 1抽查中 2抽查完成"
    ,IsWashingTranslate            INT(11)                                  COMMENT "是否孵化洗稿翻译 0否  1是"
    ,sr_createtime                 DATETIME       DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
    ,sr_updatetime                 DATETIME       DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(productid, Id)
COMMENT "翻译书籍表"
DISTRIBUTED BY HASH(productid, Id) BUCKETS 3 
PROPERTIES (
    "replication_num" = "3",
    "bloom_filter_columns" = "SwBookId",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;