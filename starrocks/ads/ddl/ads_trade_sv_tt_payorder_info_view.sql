create or replace view ads.ads_trade_sv_tt_payorder_info_view (
     dt                   comment "日期"
    ,product_id           comment "产品id"
    ,trade_order_id       comment "订单id"
    ,user_id              comment "用户id"
    ,core                 comment "core"
    ,mt                   comment "mt"
    ,reg_country          comment "注册国家"
    ,vip_type             comment "充值类型（0 普通充值 1 月卡 2 季卡 3 年卡 4 周卡）"
    ,shop_item_id         comment "区分不同充值类型：（0：充值，800：签到卡，810：SVIP，830:福利包，840：新福利包，860：NSVIP）"
    ,series_id            comment "剧id"
    ,recharge_amt         comment "充值金额"
    ,monthly_recharge_amt comment "充值金额-按月结算"
    ,net_amt              comment "到手金额"
    ,monthly_net_amt      comment "到手金额-按月结算"
    ,is_refund            comment "是否为退款订单 0否 1是"
    ,is_sandbox           comment "是否为沙盒订单 0否 1是"
    ,create_time          comment "创建时间"
    ,etl_time             comment "etl清洗时间"
)
comment "海剧-TT小程序充值明细最新结算视图"
as
select dt
     , product_id
     , trade_order_id
     , user_id
     , core
     , mt
     , reg_country
     , vip_type
     , shop_item_id
     , series_id
     , recharge_amt
     , monthly_recharge_amt
     , net_amt
     , monthly_net_amt
     , is_refund
     , is_sandbox
     , create_time
     , etl_time
  from dwd.dwd_sv_tt_payorder_info
qualify row_number() over(
            partition by dt, product_id, trade_order_id
            order by settle_dt desc, etl_time desc
        ) = 1
;
