create or replace view dwd.dwd_trade_sharpenginepaycenter_payorder_view (
     dt                     comment "createtime 分区"
    ,product_id             comment "充值产品编号"
    ,id
    ,order_serial_id        comment "订单流水号全局唯一,写入到业务库使用"
    ,order_id               comment "订单号,透传给支付合作方"
    ,coo_order_id           comment "支付订单号,合作方回传的"
    ,pay_chanel_id          comment "渠道号"
    ,account                comment "账号"
    ,user_id                comment "用户Id"
    ,server_id              comment "服务器id,已废弃"
    ,user_ip_address        comment "客户端ip"
    ,create_time            comment "创建时间"
    ,coo_notify_time        comment "收到的付款时间"
    ,finish_time            comment "订单处理完成时间,表示已经发送给业务服务器的时间"
    ,amount                 comment "金额,元为单位"
    ,give_amount            comment "赠送金额,一般无用了"
    ,bank_amount            comment "银行金额,一般等同于Amount"
    ,order_status           comment "订单状态1为成功"
    ,coo_order_status       comment "合作方扣款状态1为成功"
    ,shop_item              comment "支付的商品id"
    ,pay_type
    ,bank_id
    ,Ext1
    ,Ext2
    ,Ext3
    ,Ext4
    ,Ext5
    ,os_type                comment "相当于Mt"
    ,shop_item_id           comment "商品Id,配置在后台"
    ,coupon_id              comment "优惠券Id"
    ,package_id             comment "客户端透传参数,不同场景用途不一样"
    ,phone
    ,has_notify_times
    ,pay_config_id
    ,core
    ,base_amount            comment "统计收入金额字段"
    ,unique_guid
    ,test_flag              comment "测试标记1为测试"
    ,coo_ext_status
    ,coo_ext_info
    ,bill_info
    ,row_update_timestamp
    ,sub_pay_type           comment "子渠道类型"
    ,AutoRenewTimes         comment "续订次数"
    ,uuid                   comment "支付链路串联唯一标识 类似tradeid"
    ,etl_time               comment "数据etl时间"
    ,sr_createtime          comment "starrocks数据注入时间"
    ,sr_updatetime          comment "starrocks数据更新时间"
)
as
select dt
     , ProductId                                  as product_id
     , Id                                         as ud
     , OrderSerialId                              as order_serial_id
     , OrderId                                    as order_id
     , CooOrderId                                 as coo_order_id
     , PayChanelId                                as pay_chanel_id
     , Account                                    as account
     , UserId                                     as user_id
     , ServerId                                   as server_id
     , UserIPAddress                              as user_ip_address
     , CreateTime                                 as create_time
     , CooNotifyTime                              as coo_notify_time
     , FinishTime                                 as finish_time
     , cast((Amount / 100) as decimal(10, 2))     as amount
     , cast((GiveAmount / 100) as decimal(10, 2)) as give_amount
     , cast((BankAmount / 100) as decimal(10, 2)) as bank_amount
     , OrderStatus                                as order_status
     , CooOrderStatus                             as coo_order_status
     , ShopItem                                   as shop_item
     , PayType                                    as pay_type
     , BankId                                     as bank_id
     , Ext1
     , Ext2
     , Ext3
     , Ext4
     , Ext5
     , OsType                                     as os_type
     , ShopItemId                                 as shop_item_id
     , CouponId                                   as coupon_id
     , PackageId                                  as package_id
     , Phone
     , HasNotifyTimes                             as has_notify_times
     , PayConfigId                                as pay_config_id
     , Core                                       as core
     , cast((BaseAmount / 100) as decimal(10, 2)) as base_amount
     , UniqueGuid                                 as unique_guid
     , TestFlag                                   as test_flag
     , CooExtStatus                               as coo_ext_status
     , CooExtInfo                                 as coo_ext_info
     , BillInfo                                   as bill_info
     , RowUpdateTimestamp                         as row_update_timestamp
     , SubPayType                                 as sub_pay_type
     , AutoRenewTimes                             as auto_renew_times
     , null                                       as uuid
     , current_timestamp()                        as etl_time
     , sr_createtime
     , sr_updatetime
  from ods.ods_tidb_sharpenginepaycenter_hk_payorder
 where TestFlag != 1
;