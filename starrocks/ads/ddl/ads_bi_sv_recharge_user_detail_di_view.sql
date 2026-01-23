create or replace view ads.ads_bi_sv_recharge_user_detail_di_view (
     dt                          comment "日期分区"
    ,period_type                 comment "周期类型"
    ,strategy_id                 comment "策略ID"
    ,recharge_source             comment "充值来源"
    ,user_id                     comment "用户id"
    ,row_1                       comment "排序"
    ,product_id                  comment "产品id"
    ,user_type                   comment "用户类型"
    ,put_language                comment "投放语言"
    ,country_level               comment "国家等级"
    ,mt                          comment "终端"
    ,corever                     comment "core"
    ,strategy_name               comment "策略名称"
    ,strategy_weight             comment "策略权重"
    ,strategy_code               comment "策略代号"
    ,sv_last_preload_ecpm        comment "最近一次激励视频预加载eCPM拆包维度"
    ,recharge_mode               comment "充值众数"
    ,exposure_uv                 comment "曝光UV"
    ,exposure_pv                 comment "曝光PV"
    ,ad_exposure_uv              comment "广告曝光UV"
    ,ad_exposure_pv              comment "广告曝光PV"
    ,ad_amt                      comment "广告收益"
    ,shop_item_type              comment "档位类型"
    ,vip_type                    comment "1、月卡，2、季卡，3、年卡，4、周卡"
    ,item_count                  comment "充值档位"
    ,recharge_un                 comment "充值人数"
    ,recharge_times              comment "充值次数"
    ,recharge_amount             comment "充值金额"
    ,recharge_amount_arpu        comment "充值金额_ARPU"
    ,normal_recharge_amount      comment "充值金额-普通充值"
    ,signin_recharge_amount      comment "充值金额-签到卡"
    ,svip_recharge_amount        comment "充值金额-SVIP"
    ,nsvip_recharge_amount       comment "充值金额-NSVIP"
    ,normal_recharge_times       comment "充值次数-普通充值"
    ,signin_recharge_times       comment "充值次数-签到卡"
    ,svip_recharge_times         comment "充值次数-SVIP"
    ,nsvip_recharge_times        comment "充值次数-NSVIP"
    ,normal_recharge_un          comment "充值人数-普通充值"
    ,signin_recharge_un          comment "充值人数-签到卡"
    ,svip_recharge_un            comment "充值人数-SVIP"
    ,nsvip_recharge_un           comment "充值人数-NSVIP"
    ,recharge_un_subscription    comment "充值人数-订阅"
    ,is_recharge                 comment "是否充值"
    ,finish_time                 comment "订单完成用时(秒)"
    ,create_order_num            comment "创建订单数"
    ,etl_ime                     comment "清洗时间"
    ,third_recharge_amount       comment "充值金额-三方支付"
)
as
select a.dt
     , a.period_type
     , a.strategy_id
     , a.recharge_source
     , a.user_id
     , a.row_1
     , a.product_id
     , a.user_type
     , a.put_language
     , a.country_level
     , a.mt
     , a.corever
     , a.strategy_name
     , a.strategy_weight
     , a.strategy_code
     , a.sv_last_preload_ecpm
     , a.recharge_mode
     , a.exposure_uv
     , a.exposure_pv
     , a.ad_exposure_uv
     , a.ad_exposure_pv
     , a.ad_amt
     , a.shop_item_type
     , a.vip_type
     , a.item_count
     , a.recharge_un
     , a.recharge_times
     , a.recharge_amount
     , (((a.normal_recharge_amount_arpu + a.signin_recharge_amount_arpu) + a.svip_recharge_amount_arpu) + a.nsvip_recharge_amount_arpu)
       + (((((a.recharge_amount - a.normal_recharge_amount) - a.signin_recharge_amount) - a.svip_recharge_amount) - a.nsvip_recharge_amount) * 1) as recharge_amount_arpu
     , a.normal_recharge_amount
     , a.signin_recharge_amount
     , a.svip_recharge_amount
     , a.nsvip_recharge_amount
     , a.normal_recharge_times
     , a.signin_recharge_times
     , a.svip_recharge_times
     , a.nsvip_recharge_times
     , a.normal_recharge_un
     , a.signin_recharge_un
     , a.svip_recharge_un
     , a.nsvip_recharge_un
     , a.recharge_un_subscription
     , a.is_recharge
     , a.finish_time
     , a.create_order_num
     , a.etl_ime
     , a.third_recharge_amount
  from (select dt
             , period_type
             , strategy_id
             , recharge_source
             , user_id
             , row_1
             , product_id
             , user_type
             , put_language
             , country_level
             , mt
             , corever
             , strategy_name
             , strategy_weight
             , strategy_code
             , sv_last_preload_ecpm
             , recharge_mode
             , exposure_uv
             , exposure_pv
             , ad_exposure_uv
             , ad_exposure_pv
             , ad_amt
             , shop_item_type
             , vip_type
             , item_count
             , recharge_un
             , recharge_times
             , recharge_amount
             , normal_recharge_amount
             , case when (vip_type = 1) then (normal_recharge_amount * 1)
                    when (vip_type = 4) then (normal_recharge_amount * 1)
                    else (normal_recharge_amount * 1)
                end     as normal_recharge_amount_arpu
             , signin_recharge_amount
             , case when (vip_type = 1) then (signin_recharge_amount * 1.15)
                    when (vip_type = 4) then (signin_recharge_amount * 1.31)
                    else (signin_recharge_amount * 1)
                end     as signin_recharge_amount_arpu
             , svip_recharge_amount
             , case when (vip_type = 1) then (svip_recharge_amount * 1.1)
                    when (vip_type = 4) then (svip_recharge_amount * 1.37)
                    else (svip_recharge_amount * 1)
                end as svip_recharge_amount_arpu
             , case when (vip_type = 1) then (nsvip_recharge_amount * 1.1)
                    when (vip_type = 4) then (nsvip_recharge_amount * 1.37)
                    else (nsvip_recharge_amount * 1)
                end     as nsvip_recharge_amount_arpu
             , nsvip_recharge_amount
             , normal_recharge_times
             , signin_recharge_times
             , svip_recharge_times
             , nsvip_recharge_times
             , normal_recharge_un
             , signin_recharge_un
             , svip_recharge_un
             , nsvip_recharge_un
             , recharge_un_subscription
             , is_recharge
             , finish_time
             , create_order_num
             , etl_ime
             , third_recharge_amount
          from tmp.ads_bi_sv_recharge_user_detail_di
       ) a
;