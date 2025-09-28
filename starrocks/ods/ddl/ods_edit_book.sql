----------------------------------------------------------------
-- 目标表：ods.ods_edit_book
-- 来源实例：old_starrocks_source
-- 来源表：shuangwen_tidb_en.Book
--        shuangwen_tidb_fr.Book
--        shuangwen_tidb_pt.Book
--        shuangwen_tidb_sp.Book
-- 来源负责：
-- 采集工具：极光-定时链路
-- 开发人：wx
-- 创建日期：2025-09-24
----------------------------------------------------------------
DROP TABLE IF EXISTS ods.ods_edit_book;
CREATE TABLE ods.ods_edit_book (
     productid               INT(11)        NOT NULL                  COMMENT "产品id"
    ,BookId                  BIGINT(20)     NOT NULL                  COMMENT "书籍Id"
    ,BookName                VARCHAR(255)                             COMMENT "书名"
    ,AuthorId                BIGINT(20)                               COMMENT "作者Id"
    ,CreateTime              DATETIME                                 COMMENT "创建时间"
    ,UpdateTime              DATETIME                                 COMMENT "作品信息最后更新时间"
    ,SignType                INT(11)                                  COMMENT "签约类型  -1未签约 0买断 1A签 2B签  3解约"
    ,Summary                 STRING                                   COMMENT "简介"
    ,IsAudit                 TINYINT(4)                               COMMENT "是否已审核"
    ,IsFull                  TINYINT(4)                               COMMENT "是否完本"
    ,Channel                 INT(11)                                  COMMENT "频道 1女频、2男频、9图书、0其他 "
    ,CategoryId              INT(11)                                  COMMENT "分类Id"
    ,CoverSrc                VARCHAR(255)                             COMMENT "封面图片"
    ,ChapterNum              INT(11)                                  COMMENT "总章节数"
    ,FontLength              INT(11)                                  COMMENT "字数"
    ,IsPutdown               TINYINT(4)                               COMMENT "是否下架"
    ,FontPrice               INT(11)                                  COMMENT "价格,xx分每千字"
    ,Status                  INT(11)                                  COMMENT "状态 2书籍封面异常 3书籍封面异常请重新传"
    ,PresentSignType         INT(11)                                  COMMENT "0 一级全勤 1 二级全勤 2 三级全勤 3 四级全勤"
    ,TollStatus              INT(11)                                  COMMENT "是否开通收费权限 TollStatus == 1 拥有,其他是 无"
    ,EveryCount              INT(11)                                  COMMENT "每日更新数"
    ,EditorCharge            VARCHAR(255)                             COMMENT "责任编辑"
    ,ProductionType          INT(11)                                  COMMENT "废弃"
    ,AccountName             VARCHAR(1000)                            COMMENT "账号名称"
    ,BankAccount             VARCHAR(1000)                            COMMENT "银行帐号"
    ,BankName                VARCHAR(1000)                            COMMENT "银行名称"
    ,BankUserName            VARCHAR(1000)                            COMMENT "银行用户名称"
    ,UpdateStatus            INT(11)                                  COMMENT "更新状态  0 正常 1太监"
    ,FreeChapterNum          INT(11)                                  COMMENT "免费章节数"
    ,VipStart                INT(11)                                  COMMENT "开始收费章节"
    ,VipStatus               INT(11)                                  COMMENT "Vip状态"
    ,OutputStatus            INT(11)                                  COMMENT "输出状态"
    ,VipStartTime            DATETIME                                 COMMENT "vip开始时间"
    ,VipEndTime              DATETIME                                 COMMENT "vip结束时间"
    ,ChapterUploadStatus     INT(11)        NOT NULL                  COMMENT "章节是否上传"
    ,IsUploadBook            INT(11)        NOT NULL                  COMMENT "是否上传书籍"
    ,CategoryName            VARCHAR(500)                             COMMENT "频道名称"
    ,AuthorName              VARCHAR(500)                             COMMENT "作者名称"
    ,NewUpdateStatus         INT(11)        NOT NULL                  COMMENT "更新状态 0 未更新 1 更新"
    ,PricePerThousand        INT(11)        NOT NULL                  COMMENT "千字价格"
    ,MoboreaderVip           INT(11)        NOT NULL                  COMMENT "Moboreader可查看章节数"
    ,MoboreaderEndVip        INT(11)        NOT NULL                  COMMENT "Moboreader不可查看章节数"
    ,MoboreaderTime          VARCHAR(500)                             COMMENT "Moboreader更新定时时间24小时 整点更新"
    ,QYEditor                VARCHAR(50)                              COMMENT "QY编辑"
    ,TranslatorAccounts      VARCHAR(2000)                            COMMENT "翻译者标识"
    ,SideBookName            VARCHAR(255)                             COMMENT "二套书名"
    ,SideCoverSrc            VARCHAR(500)                             COMMENT "二套封面"
    ,PresentReward           DECIMAL(18, 2)                           COMMENT "全勤奖励金额"
    ,IsBadEnd                TINYINT(4)                               COMMENT "废弃"
    ,IsChineseSequenceNum    TINYINT(4)                               COMMENT "废弃"
    ,IsNeedVolume            TINYINT(4)                               COMMENT "废弃"
    ,FullTime                DATETIME                                 COMMENT "完本时间"
    ,Translator              VARCHAR(255)                             COMMENT "翻译者"
    ,Language                INT(11)                                  COMMENT "语言"
    ,SiteId                  INT(11)                                  COMMENT "渠道语言 下拉 key:SiteIdToLang"
    ,IsCustomWriting         INT(11)                                  COMMENT "是否定制文"
    ,RowVersion              BIGINT(20)                               COMMENT "时间戳"
    ,SideAuthorName          VARCHAR(500)                             COMMENT "二套作者"
    ,NoPassReason            VARCHAR(500)                             COMMENT "不通过原因"
    ,NewBook                 STRING                                   COMMENT "书籍修改数据"
    ,EditStatus              TINYINT(4)                               COMMENT "编辑状态"
    ,RefUserId               VARCHAR(50)                              COMMENT "推荐人"
    ,BookNature              TINYINT(4)                               COMMENT "机翻1,人工2,原创3 cp4 原创拆章5 翻译拆章6 原创图书7  9cp 翻译"
    ,CheckTips               STRING                                   COMMENT "敏感词提示"
    ,Remarks                 VARCHAR(500)                             COMMENT "备注"
    ,CheckLevel              INT(11)                                  COMMENT "敏感等级"
    ,CheckTime               DATETIME                                 COMMENT "敏感词检查时间"
    ,IsStop                  TINYINT(4)                               COMMENT "是否停更"
    ,StopTime                DATETIME                                 COMMENT "停更时间"
    ,PutdownLevel            INT(11)        DEFAULT "4"               COMMENT "下架等级 DEFAULT 4"
    ,BreakTime               DATETIME                                 COMMENT "解约时间"
    ,Score                   DOUBLE         DEFAULT "0"               COMMENT "分数 DEFAULT 0"
    ,EssayActIds             VARCHAR(100)                             COMMENT "征文活动id (,号分割)"
    ,IsEssayAct              INT(11)                                  COMMENT "书籍来源 0 作者申请 1 征文活动 2原创cp 默认 作者申请"
    ,Star                    DOUBLE         DEFAULT "0"               COMMENT "星级 DEFAULT 0"
    ,ContractStartTime       DATETIME                                 COMMENT "合同开始时间"
    ,ContractEndTime         DATETIME                                 COMMENT "合同结束时间"
    ,ContractApplyTime       DATETIME                                 COMMENT "合同申请时间"
    ,ContractRewardType      INT(11)        DEFAULT "0"               COMMENT "合同奖励类型 0无,1独家奖励A 2独家奖励B 3非独家宝石奖励 4早期合同奖金 5独家福利5.31 6独家福利20220901,7独家福利20230101 DEFAULT 0"
    ,IsEighteen              INT(11)        DEFAULT "0"               COMMENT "是否十八禁 DEFAULT 0"
    ,ReviewRemark            VARCHAR(300)   DEFAULT ""                COMMENT "籍评审说明  "
    ,FirstSignTime           DATETIME                                 COMMENT "首次签到时间"
    ,IsReceiveBook           INT(11)        DEFAULT "0"               COMMENT "是否收书"
    ,CompetReadNum           INT(11)        DEFAULT "0"               COMMENT "竞品书阅读量"
    ,RealFontLength          INT(11)        DEFAULT "0"               COMMENT "实际字数"
    ,UpPenNameTime           INT(11)        DEFAULT "0"               COMMENT "更新笔名次数"
    ,BookCode                VARCHAR(50)                              COMMENT "书籍代号"
    ,CompetPlatform          INT(11)        DEFAULT "0"               COMMENT "竞品平台 0Wattpad 1Booknet"
    ,OutsideId               VARCHAR(60)                              COMMENT "外部id"
    ,OutUpdateTime           DATETIME                                 COMMENT "外部书籍更新时间"
    ,DivideType              INT(11)        NOT NULL DEFAULT "0"      COMMENT "分成类型0:超保底按流水分成,1:超保底按利润分成"
    ,IsTranslateBook         INT(11)        NOT NULL DEFAULT "0"      COMMENT "是否翻译书籍"
    ,StoryType               INT(11)        NOT NULL DEFAULT "0"      COMMENT "类型0长篇小说 1短篇小说"
    ,row_update_time         DATETIME                                 COMMENT ""
    ,BookCodeNumber          INT(11)                 DEFAULT "0"      COMMENT "书籍代号字数"
    ,IsAdsOutTest            INT(11)        NOT NULL DEFAULT "0"      COMMENT "是否ads外测"
    ,IsAdsOutTestSmall       INT(11)        NOT NULL DEFAULT "0"      COMMENT "是否小测 1是"
    ,IsWashingBook           INT(11)        NOT NULL DEFAULT "0"      COMMENT "是否洗稿短篇 0否  1是"
    ,IsWashingCoverFail      INT(11)        NOT NULL DEFAULT "0"      COMMENT "是否洗稿封面失败 0否  1是"
    ,WashingBookScore        DECIMAL(18, 2)                           COMMENT "洗稿短篇评分"
    ,sr_createtime           DATETIME       DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
    ,sr_updatetime           DATETIME       DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
)
PRIMARY KEY (productid, BookId)
COMMENT "书籍"
DISTRIBUTED BY HASH (productid, BookId) BUCKETS 5
PROPERTIES (
    "replication_num" = "3",
    "bloom_filter_columns" = "BookId, CreateTime",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;