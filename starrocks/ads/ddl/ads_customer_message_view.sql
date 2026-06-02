create or replace view ads.ads_customer_message_view (
     Id               comment "主键ID"
    ,Project          comment "项目 短剧：sv"
    ,LangId           comment "语言"
    ,Account          comment "账号"
    ,NickName         comment "昵称"
    ,Mt               comment "最新平台号,1为iOS 4为安卓"
    ,AppVer           comment "版本号"
    ,core             comment "core"
    ,MsgType          comment "message/reply/ignore/autoReply"
    ,ContentType      comment "内容类型 1文本 2字段"
    ,Content          comment "内容"
    ,CreateTime       comment "创建时间"
    ,UpdateTime       comment "更新时间"
    ,Staff            comment "客服人员"
    ,StaffType        comment "客服类型：0-客服；1-ChatGpt(AI客服)"
    ,HasReply         comment "是否已回复"
    ,AccountId        comment "账号id"
    ,Picture          comment "图片"
    ,BigPicture       comment "大图"
    ,DeviceInfo       comment "设备信息"
    ,regionId         comment "归属区域 id，1：香港，2：北美"
    ,Country          comment "国家"
    ,IsRecharge       comment "是否充值：0-否，1-是"
    ,StaffName        comment "客服人员名称"
    ,IsTransfer       comment "是否转人工：0-否，1-是"
    ,TransferReason   comment "转人工原因"
)
as
select `Id`
      ,`Project`
      ,`LangId`
      ,`Account`
      ,`NickName`
      ,`Mt`
      ,`AppVer`
      ,`core`
      ,`MsgType`
      ,`ContentType`
      ,`Content`
      ,`CreateTime`
      ,`UpdateTime`
      ,`Staff`
      ,`StaffType`
      ,`HasReply`
      ,`AccountId`
      ,`Picture`
      ,`BigPicture`
      ,`DeviceInfo`
      ,`regionId`
      ,`Country`
      ,`IsRecharge`
      ,`StaffName`
      ,`IsTransfer`
      ,`TransferReason`
  from ods_tidb_short_video_customer_message
;
