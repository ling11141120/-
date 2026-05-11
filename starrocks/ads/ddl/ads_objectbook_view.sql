create view `ads_objectbook_view`
            (`productid` comment "产品id", `SwBookId` comment "翻译书籍Id", `ToLanguage` comment "输出语言",
             `Id` comment "自增id", `BookName` comment "书籍名称", `BookId` comment "来源书籍Id",
             `AuthorId` comment "作者Id", `CretaeTime` comment "创建时间", `GroupId`, `ChapterNum`,
             `Status` comment "状态", `AuthorName` comment "作者名称", `Coefficient` comment "稿费系数",
             `StartNum` comment "常规加更", `EndNum` comment "加更上限", `Reward`, `CeilingReward`, `LadderReward`,
             `ChapterTime` comment "章节发布时间", `ChapterTimeNum`, `ReceiveGroupId`, `RewardExplain`,
             `KindleChapterNum` comment "章节系数", `WeekWordCount` comment "周更单词",
             `AutomaticStatus` comment "是否自动发布章节 0 关闭 1 开启", `SelfDay` comment "自校完成天数",
             `ProofreadingDay` comment "校对延期时间", `ForeignProofreadDay` comment "外校延期时间",
             `BookType` comment "书籍类型 0 中文图书 1 英文图书", `LastChapter` comment "最后发布章节序号",
             `IsRobot` comment "是否机翻", `RobotChapterCount` comment "机翻章节数", `IsRollBack` comment "是否驳回",
             `RollBackNumber` comment "最后驳回序号", `CommentTime` comment "打赏评论时间",
             `MachineRatio` comment "机翻修改比例", `ModifyRatio` comment "外校修改比例",
             `UnlockFlow` comment "解锁流程", `IsAnewRobot` comment "是否重新机翻", `IsStopUpdate` comment "是否停更",
             `StopUpdateDay` comment "停更天数", `StopUpdateTime` comment "停更时间", `StopUpdatePerformedTime`,
             `FromLanguage` comment "输入语言", `IsCustom` comment "是否定制文",
             `IsSelf` comment "是否跳过自校 0不是，1是", `SignType` comment "签约类型",
             `RobotType` comment "机翻类型0：百度，1谷歌，2chatgpt", `IsParagraph` comment "是否分段",
             `BookCode` comment "书籍代号", `ObjectBookType` comment "图书书籍类型,0-网文 1-短剧",
             `IsCostRate` comment "是否计算成本率,0-否 1-是", `IsShortVideo` comment "是否来源短剧",
             `StoryType` comment "类型0长篇小说 1短篇小说")
            comment "翻译书籍表的视图"
as
select `ods`.`ods_tidb_shuangwen_en_objectbook`.`productid`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`SwBookId`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`ToLanguage`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`Id`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`BookName`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`BookId`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`AuthorId`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`CretaeTime`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`GroupId`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`ChapterNum`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`Status`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`AuthorName`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`Coefficient`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`StartNum`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`EndNum`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`Reward`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`CeilingReward`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`LadderReward`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`ChapterTime`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`ChapterTimeNum`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`ReceiveGroupId`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`RewardExplain`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`KindleChapterNum`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`WeekWordCount`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`AutomaticStatus`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`SelfDay`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`ProofreadingDay`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`ForeignProofreadDay`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`BookType`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`LastChapter`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`IsRobot`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`RobotChapterCount`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`IsRollBack`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`RollBackNumber`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`CommentTime`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`MachineRatio`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`ModifyRatio`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`UnlockFlow`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`IsAnewRobot`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`IsStopUpdate`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`StopUpdateDay`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`StopUpdateTime`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`StopUpdatePerformedTime`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`FromLanguage`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`IsCustom`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`IsSelf`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`SignType`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`RobotType`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`IsParagraph`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`BookCode`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`ObjectBookType`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`IsCostRate`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`IsShortVideo`
     , `ods`.`ods_tidb_shuangwen_en_objectbook`.`StoryType`
  from `ods`.`ods_tidb_shuangwen_en_objectbook`;