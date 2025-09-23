create or replace view ads.ads_objectchapter_view (
     productid               comment "产品id"
    ,Id                      comment "章节编号"
    ,BookId                  comment "书籍id"
    ,ChapterId               comment "源书籍Id"
    ,ObjectBookId            comment "项目图书Id"
    ,InterpreterId           comment "译员Id"
    ,ChapterName             comment "章节名"
    ,Cretatime               comment "创建时间"
    ,InterpreterName         comment "译员名称"
    ,Status                  comment "状态"
    ,Length                  comment "源章节字数"
    ,ChapterContent          comment "章节内容"
    ,ProofreadingId          comment "校对人员id"
    ,ProofreadingName        comment "校对人员名称"
    ,Fraction                comment "当前分数"
    ,Correlation             comment "总分"
    ,EditId                  comment "编辑id"
    ,EditName                comment "编辑名称"
    ,InsertStatus            comment "0 未发布 1 已发布"
    ,RemovalStatus           comment "移除状态"
    ,PublishTime             comment "完成翻译时间"
    ,IsComplete              comment "是否完成翻译 0 未完成 1 已完成"
    ,EnLength                comment "英文字数"
    ,ForeignProofreadingName comment "外籍校对名称"
    ,ForeignProofreadingId   comment "外籍校对id"
    ,GrammarScore            comment "基本语法错误（拼写、单复数、时态）"
    ,SyntaxScore             comment "语法分"
    ,FluencyScore            comment "流畅分"
    ,ForeignStatus           comment "是否开始外籍校对"
    ,IsForeign               comment "是否开始外籍校对 0 未完成 1 已完成"
    ,ForeignTime             comment "外籍校对时间"
    ,IsWk                    comment "是否挖坑 0 未结束 1 结束挖坑"
    ,WkTime                  comment "挖坑时间"
    ,IsSelf                  comment "是否自校完成 0 未完成 1 已完成"
    ,SelfTime                comment "自校完成时间"
    ,NoSelfCount             comment "挖坑的总数"
    ,CompleteTime            comment "外校完成时间"
    ,IsNoForeign             comment "外籍重新校对 0 未完成 1 已完成"
    ,NoForeignCount          comment "外籍校对章节错误数"
    ,NoForeignPassCount      comment "一校错误数"
    ,ForeignLength           comment "二校单词数"
    ,ModifyLength            comment "外校单词错误数"
    ,ForeignReceiveTime      comment "外校领取时间"
    ,ScheduleStatus          comment "0:译员未开始,1:译员开始,2:译员完成,3:外校开始,4:外校完成,5:自校开始,6:自校完成,7:二校开始,8:二校完成,9:外校重校开始,10:外校重校完成,11:自校重校开始,12:自校重校完成"
    ,LastScheduleStatus      comment "上一次开始校对ScheduleStatus的状态"
    ,TranslateStatus         comment "是否机器翻译 0 不翻译 1 待翻译 2 已翻译"
    ,TranslateTime           comment "西语机翻时间"
    ,InterpreterPercent      comment "译员最终修改比例"
    ,ForeignPercent          comment "外校最终修改比例"
    ,ChapterNumber           comment "章节序号"
    ,InterpreterDeferredTime comment "初译申请延时时间"
    ,SelfDeferredTime        comment "自校申请延时时间"
    ,ForeignDeferredTime     comment "外校申请延时时间"
    ,ForeignCompleteTime     comment "外校完成时间"
    ,AuditorId               comment "二校审核人员"
    ,IsRobot                 comment "英文是否机翻"
    ,MachinePercent          comment "机翻修改比例"
    ,RollBackStatus          comment "章节驳回状态"
    ,RobotVersion            comment "机翻版本"
    ,FirstTranslationGrade   comment "初译审核评分"
    ,FirstProofreadGrade     comment "初校审核评分"
    ,ProofreadGrade          comment "初校审核评分"
    ,RobotLength             comment "机翻字数"
    ,Version                 comment "版本号"
    ,CheckStatus             comment "抽查状态，0：关闭，1：质检抽查，2：一校抽查，3：二校抽查"
    ,DelStatus               comment "删除状态"
    ,TranslateChapterName    comment "目标语章节名"
    ,ProofreadCompleteTime   comment "二校完成时间"
    ,FirstAuditorGrade       comment "试二校评分"
    ,IsReInterpreter         comment "是否译员重校"
    ,IsReInterpreterTime     comment "译员重校时间"
)
as
select productid
      ,Id
      ,BookId
      ,ChapterId
      ,ObjectBookId
      ,InterpreterId
      ,ChapterName
      ,Cretatime
      ,InterpreterName
      ,Status
      ,Length
      ,ChapterContent
      ,ProofreadingId
      ,ProofreadingName
      ,Fraction
      ,Correlation
      ,EditId
      ,EditName
      ,InsertStatus
      ,RemovalStatus
      ,PublishTime
      ,IsComplete
      ,EnLength
      ,ForeignProofreadingName
      ,ForeignProofreadingId
      ,GrammarScore
      ,SyntaxScore
      ,FluencyScore
      ,ForeignStatus
      ,IsForeign
      ,ForeignTime
      ,IsWk
      ,WkTime
      ,IsSelf
      ,SelfTime
      ,NoSelfCount
      ,CompleteTime
      ,IsNoForeign
      ,NoForeignCount
      ,NoForeignPassCount
      ,ForeignLength
      ,ModifyLength
      ,ForeignReceiveTime
      ,ScheduleStatus
      ,LastScheduleStatus
      ,TranslateStatus
      ,TranslateTime
      ,InterpreterPercent
      ,ForeignPercent
      ,ChapterNumber
      ,InterpreterDeferredTime
      ,SelfDeferredTime
      ,ForeignDeferredTime
      ,ForeignCompleteTime
      ,AuditorId
      ,IsRobot
      ,MachinePercent
      ,RollBackStatus
      ,RobotVersion
      ,FirstTranslationGrade
      ,FirstProofreadGrade
      ,ProofreadGrade
      ,RobotLength
      ,Version
      ,CheckStatus
      ,DelStatus
      ,TranslateChapterName
      ,ProofreadCompleteTime
      ,FirstAuditorGrade
      ,IsReInterpreter
      ,IsReInterpreterTime
  from ods.ods_tidb_shuangwen_xx_objectchapter
;