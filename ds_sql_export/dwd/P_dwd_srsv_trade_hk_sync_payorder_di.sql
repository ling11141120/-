----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : dwd_srsv_trade_hk_sync_payorder_di_1
-- workflow_version : 2
-- create_user      : chenmo
-- task_name        : dwd_srsv_trade_hk_sync_payorder_di
-- task_version     : 2
-- update_time      : 2026-01-28 10:15:29
-- sql_path         : \starrocks\dwd_srsv_trade_hk_sync_payorder_di_1\dwd_srsv_trade_hk_sync_payorder_di
----------------------------------------------------------------
-- SQL语句
insert into dwd.dwd_srsv_trade_hk_sync_payorder_di
select date(CreateTime)                    as dt
     , Id                                  as id
     , OrderSerialId                       as order_serial_id
     , OrderId                             as order_id
     , CooOrderId                          as coo_order_id
     , PayChanelId                         as pay_chanel_id
     , Account                             as account
     , UserId                              as user_id
     , ServerId                            as server_id
     , UserIPAddress                       as user_i_p_address
     , CreateTime                          as create_time
     , CooNotifyTime                       as coo_notify_time
     , FinishTime                          as finish_time
     , Amount                              as amount
     , GiveAmount                          as give_amount
     , BankAmount                          as bank_amount
     , OrderStatus                         as order_status
     , CooOrderStatus                      as coo_order_status
     , ShopItem                            as shop_item
     , ProductId                           as product_id
     , PayType                             as pay_type
     , BankId                              as bank_id
     , Ext1                                as ext1
     , Ext2                                as ext2
     , Ext3                                as ext3
     , Ext4                                as ext4
     , Ext5                                as ext5
     , OsType                              as os_type
     , ShopItemId                          as shop_item_id
     , CouponId                            as coupon_id
     , PackageId                           as package_id
     , Phone                               as phone
     , HasNotifyTimes                      as has_notify_times
     , PayConfigId                         as pay_config_id
     , Core                                as core
     , BaseAmount                          as base_amount
     , UniqueGuid                          as unique_guid
     , TestFlag                            as test_flag
     , CooExtStatus                        as coo_ext_status
     , CooExtInfo                          as coo_ext_info
     , BillInfo                            as bill_info
     , RowUpdateTimestamp                  as row_update_timestamp
     , SubPayType                          as sub_pay_type
     , AutoRenewTimes                      as auto_renew_times
     , SubscribeStatus                     as subscribe_status
     , AppVer                              as app_ver
     , dim.ip_country_udf(UserIPAddress)       as Country
     , sr_createtime                       as sr_createtime
     , sr_updatetime                       as sr_updatetime
     , dim.ip_Subdiv_udf(UserIPAddress)    as province
  from ods.ods_tidb_sr_sharpengine_pay_hk_sync_payorder_di a
  where a.CreateTime >= '${bf_1_dt}' and a.CreateTime <= '${dt}';
