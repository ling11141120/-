create or replace view ads.ads_feedback_view (
     Id                     comment "主键ID"
    ,UserId                 comment "用户ID"
    ,ClientId               comment "客户端ID"
    ,Message                comment "反馈内容"
    ,CreateTime             comment "创建时间"
    ,MT                     comment "平台号"
    ,Ver                    comment "版本号"
    ,ToUserId               comment "目标用户ID"
    ,IsIgnore               comment "是否忽略：0-否，1-是"
    ,appver                 comment "应用版本"
    ,chl                    comment "渠道"
    ,device                 comment "设备"
    ,sysreleasever          comment "系统版本"
    ,BookId                 comment "书籍ID"
    ,ChapterId              comment "章节ID"
    ,BookName               comment "书籍名称"
    ,ChapterName            comment "章节名称"
    ,ErrorType              comment "错误类型"
    ,BackChapterErrorId     comment "章节错误反馈ID"
    ,NetWorkType            comment "网络类型"
    ,OperatorId             comment "操作人ID"
    ,OperatorName           comment "操作人名称"
    ,IsCustomerService      comment "是否客服：0-否，1-是"
    ,IsRead                 comment "是否已读"
    ,ChatGuid               comment "会话GUID"
    ,UserGuid               comment "用户GUID"
    ,CoreVer                comment "Core版本"
    ,IsAutoRep              comment "是否自动回复：0-否，1-是"
    ,SmallPt                comment "小平台"
    ,IsAnyReply             comment "是否有回复"
    ,IsClose                comment "是否关闭"
    ,IsAppraiseUp           comment "是否好评"
    ,TypeName               comment "类型名称"
    ,ParentName             comment "父级名称"
    ,ParentTypeId           comment "父级类型ID"
    ,TypeId                 comment "类型ID"
    ,IsExpire               comment "是否过期"
    ,Language               comment "语言"
    ,IsAIReply              comment "是否AI回复"
    ,AIReplyType            comment "AI回复类型"
    ,AiToManualStatus       comment "AI转人工状态：null/0=正常，1=待处理，2=已处理"
    ,AiToManualReason       comment "AI转人工原因"
)
as
select `Id`
      ,`UserId`
      ,`ClientId`
      ,`Message`
      ,`CreateTime`
      ,`MT`
      ,`Ver`
      ,`ToUserId`
      ,`IsIgnore`
      ,`appver`
      ,`chl`
      ,`device`
      ,`sysreleasever`
      ,`BookId`
      ,`ChapterId`
      ,`BookName`
      ,`ChapterName`
      ,`ErrorType`
      ,`BackChapterErrorId`
      ,`NetWorkType`
      ,`OperatorId`
      ,`OperatorName`
      ,`IsCustomerService`
      ,`IsRead`
      ,`ChatGuid`
      ,`UserGuid`
      ,`CoreVer`
      ,`IsAutoRep`
      ,`SmallPt`
      ,`IsAnyReply`
      ,`IsClose`
      ,`IsAppraiseUp`
      ,`TypeName`
      ,`ParentName`
      ,`ParentTypeId`
      ,`TypeId`
      ,`IsExpire`
      ,`Language`
      ,`IsAIReply`
      ,`AIReplyType`
      ,`AiToManualStatus`
      ,`AiToManualReason`
  from ods_tidb_readernovel_tidb_XX_feedback
;
