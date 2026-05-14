CREATE TABLE `ods_tidb_shuangwen_xx_authorchapter` (
  `ProductId` smallint(6) NOT NULL COMMENT "产品id",
  `ChapterId` bigint(20) NOT NULL COMMENT "章节id",
  `BookId` bigint(20) NOT NULL COMMENT "书籍id",
  `ChapterName` varchar(65533) NULL COMMENT "章节名字",
  `ChapterContent` varchar(65533) NULL COMMENT "章节内容",
  `PublishTime` datetime NULL COMMENT "发布时间",
  `Status` int(11) NULL COMMENT "状态",
  `IsReject` tinyint(4) NULL COMMENT "是否拒绝",
  `RejectReason` varchar(65533) NULL COMMENT "拒绝理由",
  `IsVip` tinyint(4) NULL COMMENT "是否vip",
  `FontLength` int(11) NULL COMMENT "字数",
  `SequenceNum` int(11) NULL COMMENT "序列号",
  `AuthorComment` varchar(65533) NULL COMMENT "作者意见",
  `DelStatus` int(11) NULL COMMENT "删除状态",
  `IsSuccess` int(11) NULL COMMENT "是否保存成功",
  `ModifyType` int(11) NULL COMMENT "是否删除 0 可修改 1 不可以修改",
  `AudityType` int(11) NULL COMMENT "审查类型",
  `LockType` int(11) NULL COMMENT "锁章类型 0 正常 1 格式 2 敏感 3 立刻锁章",
  `LockTime` datetime NULL COMMENT "锁章时间",
  `Translator` varchar(65533) NULL COMMENT "翻译者",
  `Editor` varchar(65533) NULL COMMENT "编辑者",
  `IsTiming` int(11) NULL COMMENT "是否发布",
  `RecommendBookName` varchar(65533) NULL COMMENT "推荐书名",
  `RecommendAuthorName` varchar(65533) NULL COMMENT "推荐作者名",
  `ObjChapterId` bigint(20) NULL COMMENT "对应翻译章节",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `CheckTips` varchar(65533) NULL COMMENT "敏感词提示",
  `CheckLevel` int(11) NULL COMMENT "敏感等级",
  `CheckTime` datetime NULL COMMENT "敏感词检查时间",
  `row_create_time` datetime NULL COMMENT "数据创建时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "sr数据创建时间",
  `sr_updatetime` datetime NULL COMMENT "sr数据更新时间",
  INDEX index_ProductId (`ProductId`) USING BITMAP COMMENT '产品id索引'
) ENGINE=OLAP 
PRIMARY KEY(`ProductId`, `ChapterId`, `BookId`)
COMMENT "编辑网编信息表"
DISTRIBUTED BY HASH(`ProductId`, `ChapterId`, `BookId`) BUCKETS 8 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "BookId, ChapterId",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
