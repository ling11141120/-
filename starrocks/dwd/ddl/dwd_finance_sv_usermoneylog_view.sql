create or replace view dwd.dwd_finance_sv_usermoneylog_view (
     Id             comment ""
    ,UserId         comment "用户id"
    ,Amount         comment "总数"
    ,RemainAmount   comment "剩余数量"
    ,BookId         comment "剧id"
    ,ChapterIds     comment "集ID"
    ,ChapterName    comment "集名称"
    ,CreateTime     comment ""
    ,PayType        comment "类型"
    ,MT             comment "机型"
    ,Seq            comment ""
    ,VipType        comment ""
    ,OriginCoin     comment ""
    ,VipDisPrice    comment ""
    ,AppId          comment "应用id"
    ,PositionId     comment ""
    ,AppGameId      comment ""
    ,SendId         comment "sendid"
    ,ChapterNos     comment "章节序号列表"
    ,snapshot_time  comment "快照时间"
    ,sr_createtime  comment "starrocks数据注入时间"
    ,sr_updatetime  comment "starrocks数据更新时间"
)
comment "财务短剧用户消费记录日志"
as
select a1.Id             as Id             -- 
      ,a1.UserId         as UserId         -- 用户id
      ,a1.Amount         as Amount         -- 总数
      ,a1.RemainAmount   as RemainAmount   -- 剩余数量
      ,a1.BookId         as BookId         -- 剧id
      ,a1.ChapterIds     as ChapterIds     -- 集ID
      ,a1.ChapterName    as ChapterName    -- 集名称
      ,a1.CreateTime     as CreateTime     -- 
      ,a1.PayType        as PayType        -- 类型
      ,a1.MT             as MT             -- 机型
      ,a1.Seq            as Seq            -- 
      ,a1.VipType        as VipType        -- 
      ,a1.OriginCoin     as OriginCoin     -- 
      ,a1.VipDisPrice    as VipDisPrice    -- 
      ,a1.AppId          as AppId          -- 应用id
      ,a1.PositionId     as PositionId     -- 
      ,a1.AppGameId      as AppGameId      -- 
      ,a1.SendId         as SendId         -- sendid
      ,a1.ChapterNos     as ChapterNos     -- 章节序号列表
      ,a1.snapshot_time  as snapshot_time  -- 快照时间
      ,a1.sr_createtime  as sr_createtime  -- starrocks数据注入时间
      ,a1.sr_updatetime  as sr_updatetime  -- starrocks数据更新时间
  from ods.ods_tidb_finance_snapshot_short_video_log_usermoneylog    as a1
;
