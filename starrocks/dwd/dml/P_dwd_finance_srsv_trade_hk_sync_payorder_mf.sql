----------------------------------------------------------------
-- 程序功能：财务专用-海阅海剧充值表
-- 程序名：P_dwd_finance_srsv_trade_hk_sync_payorder_mf
-- 目标表：dwd.dwd_finance_srsv_trade_hk_sync_payorder_mf
-- 负责人：xjc
-- 开发日期：2026-06-03
----------------------------------------------------------------

delete from dwd.dwd_finance_srsv_trade_hk_sync_payorder_mf
       where dt>= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01') and dt<date_format('${dt}', '%Y-%m-01');

insert into dwd.dwd_finance_srsv_trade_hk_sync_payorder_mf
select date(a1.CreateTime)                  as dt
      ,a1.Id                                as id
      ,a1.OrderSerialId                     as order_serial_id
      ,a1.OrderId                           as order_id
      ,a1.CooOrderId                        as coo_order_id
      ,a1.PayChanelId                       as pay_chanel_id
      ,a1.Account                           as account
      ,a1.UserId                            as user_id
      ,a1.ServerId                          as server_id
      ,a1.UserIPAddress                     as user_i_p_address
      ,a1.CreateTime                        as create_time
      ,a1.CooNotifyTime                     as coo_notify_time
      ,a1.FinishTime                        as finish_time
      ,a1.Amount                            as amount
      ,a1.GiveAmount                        as give_amount
      ,a1.BankAmount                        as bank_amount
      ,a1.OrderStatus                       as order_status
      ,a1.CooOrderStatus                    as coo_order_status
      ,a1.ShopItem                          as shop_item
      ,a1.ProductId                         as product_id
      ,a1.PayType                           as pay_type
      ,a1.BankId                            as bank_id
      ,a1.Ext1                              as ext1
      ,a1.Ext2                              as ext2
      ,a1.Ext3                              as ext3
      ,a1.Ext4                              as ext4
      ,a1.Ext5                              as ext5
      ,a1.OsType                            as os_type
      ,a1.ShopItemId                        as shop_item_id
      ,a1.CouponId                          as coupon_id
      ,a1.PackageId                         as package_id
      ,a1.Phone                             as phone
      ,a1.HasNotifyTimes                    as has_notify_times
      ,a1.PayConfigId                       as pay_config_id
      ,a1.Core                              as core
      ,a1.BaseAmount                        as base_amount
      ,a1.UniqueGuid                        as unique_guid
      ,a1.TestFlag                          as test_flag
      ,a1.CooExtStatus                      as coo_ext_status
      ,a1.CooExtInfo                        as coo_ext_info
      ,a1.BillInfo                          as bill_info
      ,a1.RowUpdateTimestamp                as row_update_timestamp
      ,a1.SubPayType                        as sub_pay_type
      ,a1.AutoRenewTimes                    as auto_renew_times
      ,a1.SubscribeStatus                   as subscribe_status
      ,a1.AppVer                            as app_ver
      ,dim.ip_country_udf(a1.UserIPAddress) as country
      ,dim.ip_Subdiv_udf(a1.UserIPAddress)  as province
      ,a1.CurrencyAmount                    as currency_amount
      ,a1.snapshot_time                     as snapshot_time
      ,a1.sr_createtime                     as sr_createtime
      ,a1.sr_updatetime                     as sr_updatetime
  from ods.ods_tidb_finance_snapshot_sharpengine_pay_hk_sync_payorder as a1
 where a1.createtime >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
   and a1.CreateTime < date_format('${dt}', '%Y-%m-01')
;