create or replace view dwd.dwd_finance_sr_usermoneylog_view (
     dt             comment "createtime 分区"
    ,productid      comment "产品id"
    ,Id             comment "自增id"
    ,UserId         comment "用户ID"
    ,CreateTime     comment "记录时间"
    ,Amount         comment "消费数额"
    ,RemainAmount   comment "剩余数额"
    ,BookId         comment "书籍ID"
    ,ChapterIds     comment "章节id，存在多个ID，以【逗号】分割"
    ,ChapterName    comment "章节名称"
    ,PayType        comment "付款方式 对应dim_paytype表中类型（注意：paytype<>1103)"
    ,MT             comment "平台"
    ,Seq            comment "记录序号可与createtime一起用，提取用户首次消费时间"
    ,VipType        comment "vip类型"
    ,OriginCoin     comment "原始金额"
    ,VipDisPrice    comment "打折金额"
    ,AppId          comment "项目id，core，语言"
    ,PositionId     comment "埋点id"
    ,AppGameId      comment "游戏id"
    ,SendId         comment "发送id"
    ,ChapterNos     comment "章节序号列表"
    ,ModuleSendId   comment "模块sendid"
    ,snapshot_time  comment "快照时间"
    ,sr_createtime  comment "starrocks数据注入时间"
    ,sr_updatetime  comment "starrocks数据更新时间"
)
comment "财务阅币消耗表"
as
select a1.dt             as dt             -- createtime 分区
      ,a1.productid      as productid      -- 产品id
      ,a1.Id             as Id             -- 自增id
      ,a1.UserId         as UserId         -- 用户ID
      ,a1.CreateTime     as CreateTime     -- 记录时间
      ,a1.Amount         as Amount         -- 消费数额
      ,a1.RemainAmount   as RemainAmount   -- 剩余数额
      ,a1.BookId         as BookId         -- 书籍ID
      ,a1.ChapterIds     as ChapterIds     -- 章节id，存在多个ID，以【逗号】分割
      ,a1.ChapterName    as ChapterName    -- 章节名称
      ,a1.PayType        as PayType        -- 付款方式 对应dim_paytype表中类型（注意：paytype<>1103)
      ,a1.MT             as MT             -- 平台
      ,a1.Seq            as Seq            -- 记录序号可与createtime一起用，提取用户首次消费时间
      ,a1.VipType        as VipType        -- vip类型
      ,a1.OriginCoin     as OriginCoin     -- 原始金额
      ,a1.VipDisPrice    as VipDisPrice    -- 打折金额
      ,a1.AppId          as AppId          -- 项目id，core，语言
      ,a1.PositionId     as PositionId     -- 埋点id
      ,a1.AppGameId      as AppGameId      -- 游戏id
      ,a1.SendId         as SendId         -- 发送id
      ,a1.ChapterNos     as ChapterNos     -- 章节序号列表
      ,a1.ModuleSendId   as ModuleSendId   -- 模块sendid
      ,a1.snapshot_time  as snapshot_time  -- 快照时间
      ,a1.sr_createtime  as sr_createtime  -- starrocks数据注入时间
      ,a1.sr_updatetime  as sr_updatetime  -- starrocks数据更新时间
  from ods.ods_tidb_finance_snapshot_readerlog_xx_usermoneylog    as a1
;
