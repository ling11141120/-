
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
CREATE TABLE IF NOT EXISTS ods.ods_edit_book (
     productid                int(11)          NOT NULL              COMMENT "产品id"
    ,BookId                  bigint(20)        NOT NULL              COMMENT "书籍Id"
    ,BookName                varchar(255)                            COMMENT "书名"
    ,AuthorId                bigint(20)                              COMMENT "作者Id"
    ,CreateTime              datetime                                COMMENT "创建时间"
    ,UpdateTime              datetime                                COMMENT "作品信息最后更新时间"
    ,SignType                int(11)                                 COMMENT "签约类型  -1未签约 0买断 1A签 2B签  3解约"
    ,Summary                 varchar(65533)                          COMMENT "简介"
    ,IsAudit                 tinyint(4)                              COMMENT "是否已审核"
    ,IsFull                  tinyint(4)                              COMMENT "是否完本"
    ,Channel                 int(11)                                 COMMENT "频道 1女频、2男频、9图书、0其他 "
    ,CategoryId              int(11)                                 COMMENT "分类Id"
    ,CoverSrc                varchar(255)                            COMMENT "封面图片"
    ,ChapterNum              int(11)                                 COMMENT "总章节数"
    ,FontLength              int(11)                                 COMMENT "字数"
    ,IsPutdown               tinyint(4)                              COMMENT "是否下架"
    ,FontPrice               int(11)                                 COMMENT "价格,xx分每千字"
    ,Status                  int(11)                                 COMMENT "状态 2书籍封面异常 3书籍封面异常请重新传"
    ,PresentSignType         int(11)                                 COMMENT "0 一级全勤 1 二级全勤 2 三级全勤 3 四级全勤"
    ,TollStatus              int(11)                                 COMMENT "是否开通收费权限 TollStatus == 1 拥有,其他是 无"
    ,EveryCount              int(11)                                 COMMENT "每日更新数"
    ,EditorCharge            varchar(255)                            COMMENT "责任编辑"
    ,ProductionType          int(11)                                 COMMENT "废弃"
    ,AccountName             varchar(1000)                           COMMENT "账号名称"
    ,BankAccount             varchar(1000)                           COMMENT "银行帐号"
    ,BankName                varchar(1000)                           COMMENT "银行名称"
    ,BankUserName            varchar(1000)                           COMMENT "银行用户名称"
    ,UpdateStatus            int(11)                                 COMMENT "更新状态  0 正常 1太监"
    ,FreeChapterNum          int(11)                                 COMMENT "免费章节数"
    ,VipStart                int(11)                                 COMMENT "开始收费章节"
    ,VipStatus               int(11)                                 COMMENT "Vip状态"
    ,OutputStatus            int(11)                                 COMMENT "输出状态"
    ,VipStartTime            datetime                                COMMENT "vip开始时间"
    ,VipEndTime              datetime                                COMMENT "vip结束时间"
    ,ChapterUploadStatus     int(11)             NOT NULL            COMMENT "章节是否上传"
    ,IsUploadBook            int(11)             NOT NULL            COMMENT "是否上传书籍"
    ,CategoryName            varchar(500)                            COMMENT "频道名称"
    ,AuthorName              varchar(500)                            COMMENT "作者名称"
    ,NewUpdateStatus         int(11)             NOT NULL            COMMENT "更新状态 0 未更新 1 更新"
    ,PricePerThousand        int(11)             NOT NULL            COMMENT "千字价格"
    ,MoboreaderVip           int(11)             NOT NULL            COMMENT "Moboreader可查看章节数"
    ,MoboreaderEndVip        int(11)             NOT NULL            COMMENT "Moboreader不可查看章节数"
    ,MoboreaderTime          varchar(500)                            COMMENT "Moboreader更新定时时间24小时 整点更新"
    ,QYEditor                varchar(50)                             COMMENT "QY编辑"
    ,TranslatorAccounts      varchar(2000)                           COMMENT "翻译者标识"
    ,SideBookName            varchar(255)                            COMMENT "二套书名"
    ,SideCoverSrc            varchar(500)                            COMMENT "二套封面"
    ,PresentReward           decimal(18, 2)                          COMMENT "全勤奖励金额"
    ,IsBadEnd                tinyint(4)                              COMMENT "废弃"
    ,IsChineseSequenceNum    tinyint(4)                              COMMENT "废弃"
    ,IsNeedVolume            tinyint(4)                              COMMENT "废弃"
    ,FullTime                datetime                                COMMENT "完本时间"
    ,Translator              varchar(255)                            COMMENT "翻译者"
    ,Language                int(11)                                 COMMENT "语言"
    ,SiteId                  int(11)                                 COMMENT "渠道语言 下拉 key:SiteIdToLang"
    ,IsCustomWriting         int(11)                                 COMMENT "是否定制文"
    ,RowVersion              bigint(20)                              COMMENT "时间戳"
    ,SideAuthorName          varchar(500)                            COMMENT "二套作者"
    ,NoPassReason            varchar(500)                            COMMENT "不通过原因"
    ,NewBook                 varchar(65533)                          COMMENT "书籍修改数据"
    ,EditStatus              tinyint(4)                              COMMENT "编辑状态"
    ,RefUserId               varchar(50)                             COMMENT "推荐人"
    ,BookNature              tinyint(4)                              COMMENT "机翻1,人工2,原创3 cp4 原创拆章5 翻译拆章6 原创图书7  9cp 翻译"
    ,CheckTips               varchar(65533)                          COMMENT "敏感词提示"
    ,Remarks                 varchar(500)                            COMMENT "备注"
    ,CheckLevel              int(11)                                 COMMENT "敏感等级"
    ,CheckTime               datetime                                COMMENT "敏感词检查时间"
    ,IsStop                  tinyint(4)                              COMMENT "是否停更"
    ,StopTime                datetime                                COMMENT "停更时间"
    ,PutdownLevel            int(11)             DEFAULT "4"         COMMENT "下架等级 DEFAULT 4"
    ,BreakTime               datetime                                COMMENT "解约时间"
    ,Score                   double              DEFAULT "0"         COMMENT "分数 DEFAULT 0"
    ,EssayActIds             varchar(100)                            COMMENT "征文活动id (,号分割)"
    ,IsEssayAct              int(11)                                 COMMENT "书籍来源 0 作者申请 1 征文活动 2原创cp 默认 作者申请"
    ,Star                    double              DEFAULT "0"         COMMENT "星级 DEFAULT 0"
    ,ContractStartTime       datetime                                COMMENT "合同开始时间"
    ,ContractEndTime         datetime                                COMMENT "合同结束时间"
    ,ContractApplyTime       datetime                                COMMENT "合同申请时间"
    ,ContractRewardType      int(11)             DEFAULT "0"         COMMENT "合同奖励类型 0无,1独家奖励A 2独家奖励B 3非独家宝石奖励 4早期合同奖金 5独家福利5.31 6独家福利20220901,7独家福利20230101 DEFAULT 0"
    ,IsEighteen              int(11)             DEFAULT "0"         COMMENT "是否十八禁 DEFAULT 0"
    ,ReviewRemark            varchar(300)        DEFAULT ""          COMMENT "籍评审说明  "
    ,FirstSignTime           datetime                                COMMENT "首次签到时间"
    ,IsReceiveBook           int(11)             DEFAULT "0"         COMMENT "是否收书"
    ,CompetReadNum           int(11)             DEFAULT "0"         COMMENT "竞品书阅读量"
    ,RealFontLength          int(11)             DEFAULT "0"         COMMENT "实际字数"
    ,UpPenNameTime           int(11)             DEFAULT "0"         COMMENT "更新笔名次数"
    ,BookCode                varchar(50)                             COMMENT "书籍代号"
    ,CompetPlatform          int(11)             DEFAULT "0"         COMMENT "竞品平台 0Wattpad 1Booknet"
    ,OutsideId               varchar(60)                             COMMENT "外部id"
    ,OutUpdateTime           datetime                                COMMENT "外部书籍更新时间"
    ,DivideType              int(11)    NOT NULL DEFAULT "0"         COMMENT "分成类型0:超保底按流水分成,1:超保底按利润分成"
    ,IsTranslateBook         int(11)    NOT NULL DEFAULT "0"         COMMENT "是否翻译书籍"
    ,StoryType               int(11)    NOT NULL DEFAULT "0"         COMMENT "类型0长篇小说 1短篇小说"
    ,row_update_time         datetime                                COMMENT ""
    ,BookCodeNumber          int(11)             DEFAULT "0"         COMMENT "书籍代号字数"
    ,IsAdsOutTest            int(11)    NOT NULL DEFAULT "0"         COMMENT "是否ads外测"
    ,IsAdsOutTestSmall       int(11)    NOT NULL DEFAULT "0"         COMMENT "是否小测 1是"
    ,IsWashingBook           int(11)    NOT NULL DEFAULT "0"         COMMENT "是否洗稿短篇 0否  1是"
    ,IsWashingCoverFail      int(11)    NOT NULL DEFAULT "0"         COMMENT "是否洗稿封面失败 0否  1是"
    ,WashingBookScore        decimal(18, 2)                          COMMENT "洗稿短篇评分"
    ,sr_createtime           datetime   DEFAULT CURRENT_TIMESTAMP    COMMENT "starrocks数据注入时间"
    ,sr_updatetime           datetime   DEFAULT CURRENT_TIMESTAMP    COMMENT "starrocks数据更新时间"
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