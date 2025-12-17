create view `dwd_trade_sharpenginepaycenter_payorder_view`
            (`dt` comment "createtime 分区", `product_id` comment "充值产品编号", `id`,
             `order_serial_id` comment "订单流水号全局唯一,写入到业务库使用",
             `order_id` comment "订单号,透传给支付合作方", `coo_order_id` comment "支付订单号,合作方回传的",
             `pay_chanel_id` comment "渠道号", `account` comment "账号", `user_id` comment "用户Id",
             `server_id` comment "服务器id,已废弃", `user_ip_address` comment "客户端ip",
             `create_time` comment "创建时间", `coo_notify_time` comment "收到的付款时间",
             `finish_time` comment "订单处理完成时间,表示已经发送给业务服务器的时间", `amount` comment "金额,元为单位",
             `give_amount` comment "赠送金额,一般无用了", `bank_amount` comment "银行金额,一般等同于Amount",
             `order_status` comment "订单状态1为成功", `coo_order_status` comment "合作方扣款状态1为成功",
             `shop_item` comment "支付的商品id", `pay_type`, `bank_id`, `Ext1`, `Ext2`, `Ext3`, `Ext4`, `Ext5`,
             `os_type` comment "相当于Mt", `shop_item_id` comment "商品Id,配置在后台", `coupon_id` comment "优惠券Id",
             `package_id` comment "客户端透传参数,不同场景用途不一样", `phone`, `has_notify_times`, `pay_config_id`,
             `core`, `base_amount` comment "统计收入金额字段", `unique_guid`, `test_flag` comment "测试标记1为测试",
             `coo_ext_status`, `coo_ext_info`, `bill_info`, `row_update_timestamp`, `sub_pay_type` comment "子渠道类型",
             `AutoRenewTimes` comment "续订次数", `uuid` comment "支付链路串联唯一标识 类似tradeid",
             `etl_time` comment "数据etl时间", `sr_createtime` comment "starrocks数据注入时间",
             `sr_updatetime` comment "starrocks数据更新时间")
as
select `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`dt`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`ProductId`                                    as `product_id`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`Id`                                           as `ud`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`OrderSerialId`                                as `order_serial_id`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`OrderId`                                      as `order_id`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`CooOrderId`                                   as `coo_order_id`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`PayChanelId`                                  as `pay_chanel_id`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`Account`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`UserId`                                       as `user_id`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`ServerId`                                     as `server_id`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`UserIPAddress`                                as `user_ip_address`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`CreateTime`                                   as `create_time`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`CooNotifyTime`                                as `coo_notify_time`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`FinishTime`                                   as `finish_time`
     , cast((`ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`Amount` / 100) as DECIMAL64(10, 2))     as `amount`
     , cast((`ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`GiveAmount` / 100) as DECIMAL64(10, 2)) as `give_amount`
     , cast((`ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`BankAmount` / 100) as DECIMAL64(10, 2)) as `bank_amount`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`OrderStatus`                                  as `order_status`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`CooOrderStatus`                               as `coo_order_status`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`ShopItem`                                     as `shop_item`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`PayType`                                      as `pay_type`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`BankId`                                       as `bank_id`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`Ext1`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`Ext2`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`Ext3`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`Ext4`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`Ext5`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`OsType`                                       as `os_type`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`ShopItemId`                                   as `shop_item_id`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`CouponId`                                     as `coupon_id`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`PackageId`                                    as `package_id`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`Phone`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`HasNotifyTimes`                               as `has_notify_times`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`PayConfigId`                                  as `pay_config_id`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`Core`
     , cast((`ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`BaseAmount` / 100) as DECIMAL64(10, 2)) as `base_amount`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`UniqueGuid`                                   as `unique_guid`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`TestFlag`                                     as `test_flag`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`CooExtStatus`                                 as `coo_ext_status`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`CooExtInfo`                                   as `coo_ext_info`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`BillInfo`                                     as `bill_info`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`RowUpdateTimestamp`                           as `row_update_timestamp`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`SubPayType`                                   as `sub_pay_type`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`AutoRenewTimes`                               as `auto_renew_times`
     , null                                                                                             as `uuid`
     , current_timestamp()                                                                              as `etl_time`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`sr_createtime`
     , `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`sr_updatetime`
  from `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`
 where `ods`.`ods_tidb_sharpenginepaycenter_hk_payorder`.`TestFlag` != 1;