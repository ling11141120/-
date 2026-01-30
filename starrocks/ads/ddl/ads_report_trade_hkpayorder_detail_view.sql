create or replace view ads.ads_report_trade_hkpayorder_detail_view (
     product_id           comment "产品id"
    ,user_id              comment "用户id"
    ,order_serial_id      comment "订单流水号全局唯一,写入到业务库使用"
    ,order_id             comment "订单号,透传给支付合作方"
    ,coo_order_id         comment "支付订单号,合作方回传的"
    ,pay_chanel_id        comment "渠道id,用来关联获取支付方式"
    ,dt                   comment "创建时间"
    ,create_time          comment "创建时间"
    ,core                 comment "包体"
    ,mt                   comment "平台"
    ,app_ver              comment "客户端版本号"
    ,account              comment "账号"
    ,amount               comment "金额,美分为单位"
    ,pay_name             comment "支付方式"
    ,merchant_name        comment "支付方式（详细版区分app）"
    ,sub_pay_type         comment "渠道id"
    ,pay_ment_way         comment "渠道名称"
    ,package_id           comment "客户端透传参数,不同场景用途不一样"
    ,coo_notify_time      comment "收到的付款时间"
    ,finish_time          comment "订单处理完成时间,表示已经发送给业务服务器的时间"
    ,order_status         comment "订单状态 1：为成功 "
    ,coo_order_status     comment "合作方扣款状态1为成功"
    ,shop_item            comment "支付的商品id"
    ,shop_item_id         comment "商品Id,配置在后台"
    ,base_amount          comment "统计分成后收入金额字段"
    ,bank_amount          comment "银行金额,一般等同于Amount"
    ,pay_type             comment "支付类型"
    ,pay_config_id        comment "未知"
    ,bank_id              comment "未知"
    ,test_flag            comment "是否测试，1：测试，0：非测试"
    ,auto_renew_times     comment "表示续订次数"
    ,sub_scribe_status    comment "表示是否续订  -1：试用  0：默认值 1：首次购买 2 ：续订  "
    ,Ext1
    ,Ext5                 comment "区分充值sdk"
    ,coo_ext_status       comment " -1 表示是退款"
    ,ip_to_country        comment "由ip转换为国家"
    ,source_chl           comment "最新渠道"
)
as
select x.product_id
     , x.user_id
     , x.order_serial_id
     , x.order_id
     , x.coo_order_id
     , x.pay_chanel_id
     , x.dt
     , x.create_time
     , x.core
     , x.mt
     , x.app_ver
     , x.account
     , x.amount
     , x.pay_name
     , x.merchant_name
     , x.sub_pay_type
     , case when (x.sub_pay_type = 'GooglePlay') then 'GooglePlay'
            when (x.sub_pay_type = 'AppStore') then 'AppStore'
            when (x.product_id != 6833) then y.PaymentWay
            else z.PaymentWay
       end                                    as pay_ment_way
     , x.package_id
     , x.coo_notify_time
     , x.finish_time
     , x.order_status
     , x.coo_order_status
     , x.shop_item
     , x.shop_item_id
     , x.base_amount
     , x.bank_amount
     , x.pay_type
     , x.pay_config_id
     , x.bank_id
     , x.test_flag
     , x.auto_renew_times
     , x.sub_scribe_status
     , x.Ext1
     , x.Ext5
     , x.CooExtStatus                         as coo_ext_status
     , x.ip_to_country
     , ifnull(e.source_chl, dim.f.source_chl) as late_chl
  from (select a.productid                                                               as product_id
             , a.userid                                                                  as user_id
             , a.OrderSerialId                                                           as order_serial_id
             , a.orderid                                                                 as order_id
             , a.cooorderid                                                              as coo_order_id
             , a.paychanelid                                                             as pay_chanel_id
             , a.dt
             , a.createtime                                                              as create_time
             , a.core
             , a.ostype                                                                  as mt
             , a.appver                                                                  as app_ver
             , a.account
             , a.amount
             , b.payname                                                                 as pay_name
             , b.merchantname                                                            as merchant_name
             , case when a.SubPayType = 'PayPalV2' and a.amount / 100 < 10 then 'PayPalV2-HK'
                    when a.SubPayType = 'PayPalV2' and a.amount / 100 >= 10 then 'PayPalV2-HK-2'
                    else ods.a.SubPayType
                end                                                                      as sub_pay_type
             , if(a.packageid = '' or a.packageid is null, 'null_other',a.packageid)     as package_id
             , a.coonotifytime                                                           as coo_notify_time
             , a.finishtime                                                              as finish_time
             , a.orderstatus                                                             as order_status
             , a.cooorderstatus                                                          as coo_order_status
             , a.ShopItem                                                                as shop_item
             , a.shopitemid                                                              as shop_item_id
             , a.baseamount                                                              as base_amount
             , a.bankamount                                                              as bank_amount
             , a.paytype                                                                 as pay_type
             , a.payconfigid                                                             as pay_config_id
             , a.bankid                                                                  as bank_id
             , a.testflag                                                                as test_flag
             , a.AutoRenewTimes                                                          as auto_renew_times
             , a.SubscribeStatus                                                         as sub_scribe_status
             , a.Ext1
             , a.Ext5
             , a.CooExtStatus
             , udf.ip2country(a.UserIPAddress)                                           as ip_to_country
          from ods.ods_tidb_sharpenginepaycenter_hk_payorder                             as a
          left join ods.ods_tidb_sharpenginepaycenter_hk_paychanel                       as b
            on a.productid = b.productid
           and a.paychanelid = b.id
       )                                                                                 as x
  left join (select upper(c.PaymentId)    as PaymentId
                  , max(c.PaymentWay)     as PaymentWay
                   from ods.ods_tidb_readernovel_tidb_tag_center_third_payment_map_da    as c
                  group by 1
            )                                                                            as y
    on upper(x.sub_pay_type) = upper(y.PaymentId)
  left join (select upper(ods.d.pay_id)       as PaymentId
                  , max(ods.d.pay_channel)    as PaymentWay
               from ods.ods_tidb_short_video_third_payment_rate                          as d
              group by 1
            )                                                                            as z
    on upper(x.sub_pay_type) = upper(z.PaymentId)
   and x.product_id = 6833
  left join (select s1.product_id
                  , s1.user_id
                  , s1.last_source as source_chl
               from (select product_id
                          , user_id
                          , last_source
                          , row_number() over (partition by product_id, user_id
                                                   order by install_date desc, mt asc, corever asc, lang2 asc
                                              ) as rn
                       from dws.dws_user_market_channel_info_detail_td
                      where dt = date_sub(current_date(), interval 1 day)
                        and product_id not in (6833)
                     ) s1
              where s1.rn = 1
            )                                                                            as e
    on x.product_id = e.product_id
   and x.user_id = e.user_id
  left join dim.dim_short_video_user_accountinfo                                         as f
    on x.product_id = f.product_id
   and x.user_id = f.user_id
;