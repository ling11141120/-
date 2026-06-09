create or replace view dwd.dwd_finance_sv_getmoneylog_view (
     Id             comment "id"
    ,UserId         comment "用户id"
    ,VipLv          comment "vip等级"
    ,PayChl         comment "payorder.type"
    ,Charge         comment "充值金额"
    ,RealGet        comment "实际获取到的阅币数量"
    ,Give           comment "实际获取到的赠送币数量"
    ,CurMoney       comment "用户当前阅币数量"
    ,GetTime        comment "获得时间"
    ,reforderid     comment "payorder.orderid"
    ,Seq            comment "自增的序号"
    ,cps
    ,chl2
    ,ChargeType     comment "充值类型："
    ,DeviceGUID     comment "当前用户的设备id"
    ,GiftMoney      comment "获得的礼券数量"
    ,snapshot_time  comment "快照时间"
    ,sr_createtime  comment "starrocks数据注入时间"
    ,sr_updatetime  comment "starrocks数据更新时间"
)
comment "财务短剧领卡获取到的阅币，礼券记录日志"
as
select a1.Id             as Id             -- id
      ,a1.UserId         as UserId         -- 用户id
      ,a1.VipLv          as VipLv          -- vip等级
      ,a1.PayChl         as PayChl         -- payorder.type
      ,a1.Charge         as Charge         -- 充值金额
      ,a1.RealGet        as RealGet        -- 实际获取到的阅币数量
      ,a1.Give           as Give           -- 实际获取到的赠送币数量
      ,a1.CurMoney       as CurMoney       -- 用户当前阅币数量
      ,a1.GetTime        as GetTime        -- 获得时间
      ,a1.reforderid     as reforderid     -- payorder.orderid
      ,a1.Seq            as Seq            -- 自增的序号
      ,a1.cps            as cps
      ,a1.chl2           as chl2
      ,a1.ChargeType     as ChargeType     -- 充值类型：
      ,a1.DeviceGUID     as DeviceGUID     -- 当前用户的设备id
      ,a1.GiftMoney      as GiftMoney      -- 获得的礼券数量
      ,a1.snapshot_time  as snapshot_time  -- 快照时间
      ,a1.sr_createtime  as sr_createtime  -- starrocks数据注入时间
      ,a1.sr_updatetime  as sr_updatetime  -- starrocks数据更新时间
  from ods.ods_tidb_finance_snapshot_short_video_log_getmoneylog    as a1
;
