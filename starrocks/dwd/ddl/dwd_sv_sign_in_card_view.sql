create or replace view dwd.dwd_sv_sign_in_card_view (
     id                 comment "主键"
    ,account_id         comment "用户id"
    ,expire_time        comment "过期时间"
    ,bonus              comment "奖励券"
    ,create_time        comment "创建时间"
    ,product_id         comment "支付配置表Id"
    ,region_id          comment "归属区域 id，1：香港，2：北美；"
    ,type               comment "1 月卡  4 周卡"
    ,price              comment "价格"
    ,goods_option_id    comment "商品价值方案ID"
    ,item_id            comment "申请ID"
    ,mt                 comment "支付渠道，区分ios 1，android 4"
    ,order_mark         comment "订单标识1正常2取消续订"
    ,pay_order_id       comment "订单号"
    ,pay_info           comment "自定义数据，PayInfo快照，json格式"
    ,gain_coin          comment "获得的币"
    ,gain_bonus         comment "获得的券"
    ,sr_createtime      comment "starrocks数据注入时间"
    ,sr_updatetime      comment "starrocks数据更新时间"
    ,expire_time_dt     comment "过期时间datetime格式"
    ,create_time_dt     comment "创建时间datetime格式"
)
comment "签到卡记录查询"
as
select a1.Id               as id                 -- 主键
      ,a1.AccountId        as account_id         -- 用户id
      ,a1.ExpireTime       as expire_time        -- 过期时间
      ,a1.Bonus            as bonus              -- 奖励券
      ,a1.CreateTime       as create_time        -- 创建时间
      ,a1.ProductId        as product_id         -- 支付配置表Id
      ,a1.regionId         as region_id          -- 归属区域 id，1：香港，2：北美；
      ,a1.Type             as type               -- 1 月卡  4 周卡
      ,a1.Price            as price              -- 价格
      ,a1.GoodsOptionId    as goods_option_id    -- 商品价值方案ID
      ,a1.ItemId           as item_id            -- 申请ID
      ,a1.Mt               as mt                 -- 支付渠道，区分ios 1，android 4
      ,a1.OrderMark        as order_mark         -- 订单标识1正常2取消续订
      ,a1.PayOrderId       as pay_order_id       -- 订单号
      ,a1.PayInfo          as pay_info           -- 自定义数据，PayInfo快照，json格式
      ,a1.GainCoin         as gain_coin          -- 获得的币
      ,a1.GainBonus        as gain_bonus         -- 获得的券
      ,a1.sr_createtime    as sr_createtime      -- starrocks数据注入时间
      ,a1.sr_updatetime    as sr_updatetime      -- starrocks数据更新时间
      ,a1.ExpireTimeDt     as expire_time_dt     -- 过期时间datetime格式
      ,a1.CreateTimeDt     as create_time_dt     -- 创建时间datetime格式
  from ods.ods_tidb_short_video_sign_in_card    as a1
;
