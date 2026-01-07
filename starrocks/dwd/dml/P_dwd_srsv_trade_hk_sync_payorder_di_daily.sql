insert into dwd.dwd_srsv_trade_hk_sync_payorder_di_daily
select ifnull(tar.dt, ori.dt)                              as dt
     , ori.id
     , ori.order_serial_id
     , ori.order_id
     , ori.coo_order_id
     , ori.pay_chanel_id
     , ori.account
     , ori.user_id
     , ori.server_id
     , ori.user_i_p_address
     , ori.create_time
     , ifnull(tar.coo_notify_time, ori.coo_notify_time)    as order_time
     , ori.finish_time
     , ori.amount
     , ori.give_amount
     , ori.bank_amount
     , ori.order_status
     , ori.coo_order_status
     , ori.shop_item
     , ori.product_id
     , ori.pay_type
     , ori.bank_id
     , ori.ext1
     , ori.ext2
     , ori.ext3
     , ori.ext4
     , ori.ext5
     , ori.os_type
     , ori.shop_item_id
     , ori.coupon_id
     , ori.package_id
     , ori.phone
     , ori.has_notify_times
     , ori.pay_config_id
     , ori.core
     , ori.base_amount
     , ori.unique_guid
     , ori.test_flag
     , ori.coo_ext_status
     , ori.coo_ext_info
     , ori.bill_info
     , ori.row_update_timestamp
     , ori.sub_pay_type
     , ori.auto_renew_times
     , ori.subscribe_status
     , ori.app_ver
     , ori.country
     , ori.sr_createtime
     , ori.sr_updatetime
     , ori.province
  from dwd.dwd_srsv_trade_hk_sync_payorder_di               as ori
  left join dwd.dwd_srsv_trade_hk_sync_payorder_di_daily    as tar
    on ori.order_serial_id = tar.order_serial_id
 where ori.dt >= '${bf_1_dt}'
   and ori.dt <= '${dt}'
   and ori.product_id != '8211';