----------------------------------------------------------------
-- 程序功能：SDK充值明细
-- 程序名：P_dwd_srsv_trade_hk_sync_payorder_di_daily.sql
-- 目标表：dwd.dwd_srsv_trade_hk_sync_payorder_di_daily
-- 负责人：xjc
-- 开发日期：2026-06-08
----------------------------------------------------------------

truncate table dwd.dwd_srsv_trade_hk_sync_payorder_di_daily;

insert into dwd.dwd_srsv_trade_hk_sync_payorder_di_daily
select ifnull(a2.dt, a1.dt)                              as dt
     , a1.id
     , a1.order_serial_id
     , a1.order_id
     , a1.coo_order_id
     , a1.pay_chanel_id
     , a1.account
     , a1.user_id
     , a1.server_id
     , a1.user_i_p_address
     , a1.create_time
     , ifnull(a2.coo_notify_time, a1.coo_notify_time)    as order_time
     , a1.finish_time
     , a1.amount
     , a1.give_amount
     , a1.bank_amount
     , a1.order_status
     , a1.coo_order_status
     , a1.shop_item
     , a1.product_id
     , a1.pay_type
     , a1.bank_id
     , a1.ext1
     , a1.ext2
     , a1.ext3
     , a1.ext4
     , a1.ext5
     , a1.os_type
     , a1.shop_item_id
     , a1.coupon_id
     , a1.package_id
     , a1.phone
     , a1.has_notify_times
     , a1.pay_config_id
     , a1.core
     , a1.base_amount
     , a1.unique_guid
     , a1.test_flag
     , a1.coo_ext_status
     , a1.coo_ext_info
     , a1.bill_info
     , a1.row_update_timestamp
     , a1.sub_pay_type
     , a1.auto_renew_times
     , a1.subscribe_status
     , a1.app_ver
     , a1.country
     , a1.sr_createtime
     , a1.sr_updatetime
     , a1.province
  from dwd.dwd_finance_srsv_trade_hk_sync_payorder_mf       as a1
  left join dwd.dwd_srsv_trade_hk_sync_payorder_di_daily    as a2
    on a1.order_serial_id = a2.order_serial_id
 where a1.product_id not in ('8211', '2311');

-- 2、修正订单时间
insert into dwd.dwd_srsv_trade_hk_sync_payorder_di_daily
select a2.dt
     , a1.id
     , a1.order_serial_id
     , a1.order_id
     , a1.coo_order_id
     , a1.pay_chanel_id
     , a1.account
     , a1.user_id
     , a1.server_id
     , a1.user_i_p_address
     , a1.create_time
     , a2.order_time                                      as coo_notify_time
     , a1.finish_time
     , a1.amount
     , a1.give_amount
     , a1.bank_amount
     , a1.order_status
     , a1.coo_order_status
     , a1.shop_item
     , a1.product_id
     , a1.pay_type
     , a1.bank_id
     , a1.ext1
     , a1.ext2
     , a1.ext3
     , a1.ext4
     , a1.ext5
     , a1.os_type
     , a1.shop_item_id
     , a1.coupon_id
     , a1.package_id
     , a1.phone
     , a1.has_notify_times
     , a1.pay_config_id
     , a1.core
     , a1.base_amount
     , a1.unique_guid
     , a1.test_flag
     , a1.coo_ext_status
     , a1.coo_ext_info
     , a1.bill_info
     , a1.row_update_timestamp
     , a1.sub_pay_type
     , a1.auto_renew_times
     , a1.subscribe_status
     , a1.app_ver
     , a1.country
     , a1.sr_createtime
     , a1.sr_updatetime
     , a1.province
  from dwd.dwd_finance_srsv_trade_hk_sync_payorder_mf       as a1
  left join (
            select *
              from ads.ads_sv_finance_series_recharge_consume_info    as b1
             where b1.report_type = 1
            union all
            select *
              from ads.ads_sr_finance_book_recharge_consume_info      as b2
             where b2.report_type = 1
       )                                                    as a2
    on a1.order_serial_id = a2.order_id
 where a1.order_serial_id in (
            select b3.order_serial_id
              from dwd.dwd_srsv_trade_hk_sync_payorder_di_daily    as b3
             right join (
                        select *
                          from ads.ads_sv_finance_series_recharge_consume_info    as c1
                         where c1.report_type = 1
                        union all
                        select *
                          from ads.ads_sr_finance_book_recharge_consume_info      as c2
                         where c2.report_type = 1
                   )                                             as b4
                on b3.order_serial_id = b4.order_id
             where b3.coo_notify_time != b4.order_time
                or b3.dt != b4.dt
       );

-- 3、删除因订单时间改变导致dt改变主键失效的订单
select a1.order_serial_id
     , count(1)
  from dwd.dwd_srsv_trade_hk_sync_payorder_di_daily    as a1
 group by a1.order_serial_id
having count(1) > 1;

delete from dwd.dwd_srsv_trade_hk_sync_payorder_di_daily
 where (dt, order_serial_id) in (
            select min(b1.dt)                                  as dt
                 , b1.order_serial_id
              from dwd.dwd_srsv_trade_hk_sync_payorder_di_daily    as b1
             group by b1.order_serial_id
            having count(1) > 1
       );
