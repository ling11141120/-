----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总
-- workflow_version : 36
-- create_user      : chenmo
-- task_name        : SDK充值明细
-- task_version     : 1
-- update_time      : 2026-02-16 11:47:07
-- sql_path         : \starrocks\审计测试-总\SDK充值明细
----------------------------------------------------------------
-- 前置SQL语句
truncate table dwd.dwd_srsv_trade_hk_sync_payorder_di_daily;

-- SQL语句
-- 1、数据重刷
insert into dwd.dwd_srsv_trade_hk_sync_payorder_di_daily
select
    ifnull(b.dt, a.dt) as dt,
    a.id,
    a.order_serial_id,
    a.order_id,
    a.coo_order_id,
    a.pay_chanel_id,
    a.account,
    a.user_id,
    a.server_id,
    a.user_i_p_address,
    a.create_time,
    ifnull(b.coo_notify_time, a.coo_notify_time) as order_time,
    a.finish_time,
    a.amount,
    a.give_amount,
    a.bank_amount,
    a.order_status,
    a.coo_order_status,
    a.shop_item,
    a.product_id,
    a.pay_type,
    a.bank_id,
    a.ext1,
    a.ext2,
    a.ext3,
    a.ext4,
    a.ext5,
    a.os_type,
    a.shop_item_id,
    a.coupon_id,
    a.package_id,
    a.phone,
    a.has_notify_times,
    a.pay_config_id,
    a.core,
    a.base_amount,
    a.unique_guid,
    a.test_flag,
    a.coo_ext_status,
    a.coo_ext_info,
    a.bill_info,
    a.row_update_timestamp,
    a.sub_pay_type,
    a.auto_renew_times,
    a.subscribe_status,
    a.app_ver,
    a.country,
    a.sr_createtime,
    a.sr_updatetime,
    a.province
from (
    select
        *
    from dwd.dwd_srsv_trade_hk_sync_payorder_di
) a
left join dwd.dwd_srsv_trade_hk_sync_payorder_di_daily b
on a.order_serial_id = b.order_serial_id
where a.product_id not in('8211', '2311');

-- SQL语句
-- 2、修正订单时间
insert into dwd.dwd_srsv_trade_hk_sync_payorder_di_daily
select
    b.dt,
    a.id,
    a.order_serial_id,
    a.order_id,
    a.coo_order_id,
    a.pay_chanel_id,
    a.account,
    a.user_id,
    a.server_id,
    a.user_i_p_address,
    a.create_time,
    b.order_time as coo_notify_time,
    a.finish_time,
    a.amount,
    a.give_amount,
    a.bank_amount,
    a.order_status,
    a.coo_order_status,
    a.shop_item,
    a.product_id,
    a.pay_type,
    a.bank_id,
    a.ext1,
    a.ext2,
    a.ext3,
    a.ext4,
    a.ext5,
    a.os_type,
    a.shop_item_id,
    a.coupon_id,
    a.package_id,
    a.phone,
    a.has_notify_times,
    a.pay_config_id,
    a.core,
    a.base_amount,
    a.unique_guid,
    a.test_flag,
    a.coo_ext_status,
    a.coo_ext_info,
    a.bill_info,
    a.row_update_timestamp,
    a.sub_pay_type,
    a.auto_renew_times,
    a.subscribe_status,
    a.app_ver,
    a.country,
    a.sr_createtime,
    a.sr_updatetime,
    a.province
from dwd.dwd_srsv_trade_hk_sync_payorder_di_daily a
left join (
    select * from ads.ads_sv_finance_series_recharge_consume_info where report_type = 1
                                                                  union all
    select * from ads.ads_sr_finance_book_recharge_consume_info where report_type = 1
) b
on a.order_serial_id = b.order_id
where order_serial_id in(
    select
        a.order_serial_id
    from (
        select
            *
        from dwd.dwd_srsv_trade_hk_sync_payorder_di_daily
    ) a
    right join (
        select * from ads.ads_sv_finance_series_recharge_consume_info where report_type = 1
                                                                      union all
        select * from ads.ads_sr_finance_book_recharge_consume_info where report_type = 1
    ) b
    on a.order_serial_id = b.order_id
    where a.coo_notify_time != b.order_time or a.dt != b.dt
);

-- SQL语句
-- 3、删除因订单时间改变导致dt改变主键失效的订单
select
    order_serial_id, count(1)
from dwd.dwd_srsv_trade_hk_sync_payorder_di_daily
group by order_serial_id
having count(1) > 1;

-- SQL语句
delete from dwd.dwd_srsv_trade_hk_sync_payorder_di_daily where (dt, order_serial_id) in(
    select
        min(dt) as dt,
        order_serial_id
    from dwd.dwd_srsv_trade_hk_sync_payorder_di_daily
    group by order_serial_id
    having count(1) > 1
);

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总_改
-- workflow_version : 11
-- create_user      : xiejc
-- task_name        : SDK充值明细
-- task_version     : 1
-- update_time      : 2026-03-31 14:40:14
-- sql_path         : \starrocks\审计测试-总_改\SDK充值明细
----------------------------------------------------------------
-- 前置SQL语句
truncate table dwd.dwd_srsv_trade_hk_sync_payorder_di_daily;

-- SQL语句
-- 1、数据重刷
insert into dwd.dwd_srsv_trade_hk_sync_payorder_di_daily
select
    ifnull(b.dt, a.dt) as dt,
    a.id,
    a.order_serial_id,
    a.order_id,
    a.coo_order_id,
    a.pay_chanel_id,
    a.account,
    a.user_id,
    a.server_id,
    a.user_i_p_address,
    a.create_time,
    ifnull(b.coo_notify_time, a.coo_notify_time) as order_time,
    a.finish_time,
    a.amount,
    a.give_amount,
    a.bank_amount,
    a.order_status,
    a.coo_order_status,
    a.shop_item,
    a.product_id,
    a.pay_type,
    a.bank_id,
    a.ext1,
    a.ext2,
    a.ext3,
    a.ext4,
    a.ext5,
    a.os_type,
    a.shop_item_id,
    a.coupon_id,
    a.package_id,
    a.phone,
    a.has_notify_times,
    a.pay_config_id,
    a.core,
    a.base_amount,
    a.unique_guid,
    a.test_flag,
    a.coo_ext_status,
    a.coo_ext_info,
    a.bill_info,
    a.row_update_timestamp,
    a.sub_pay_type,
    a.auto_renew_times,
    a.subscribe_status,
    a.app_ver,
    a.country,
    a.sr_createtime,
    a.sr_updatetime,
    a.province
from (
    select
        *
    from dwd.dwd_srsv_trade_hk_sync_payorder_di
) a
left join dwd.dwd_srsv_trade_hk_sync_payorder_di_daily b
on a.order_serial_id = b.order_serial_id
where a.product_id not in('8211', '2311');

-- SQL语句
-- 2、修正订单时间
insert into dwd.dwd_srsv_trade_hk_sync_payorder_di_daily
select
    b.dt,
    a.id,
    a.order_serial_id,
    a.order_id,
    a.coo_order_id,
    a.pay_chanel_id,
    a.account,
    a.user_id,
    a.server_id,
    a.user_i_p_address,
    a.create_time,
    b.order_time as coo_notify_time,
    a.finish_time,
    a.amount,
    a.give_amount,
    a.bank_amount,
    a.order_status,
    a.coo_order_status,
    a.shop_item,
    a.product_id,
    a.pay_type,
    a.bank_id,
    a.ext1,
    a.ext2,
    a.ext3,
    a.ext4,
    a.ext5,
    a.os_type,
    a.shop_item_id,
    a.coupon_id,
    a.package_id,
    a.phone,
    a.has_notify_times,
    a.pay_config_id,
    a.core,
    a.base_amount,
    a.unique_guid,
    a.test_flag,
    a.coo_ext_status,
    a.coo_ext_info,
    a.bill_info,
    a.row_update_timestamp,
    a.sub_pay_type,
    a.auto_renew_times,
    a.subscribe_status,
    a.app_ver,
    a.country,
    a.sr_createtime,
    a.sr_updatetime,
    a.province
from dwd.dwd_srsv_trade_hk_sync_payorder_di_daily a
left join (
    select * from ads.ads_sv_finance_series_recharge_consume_info where report_type = 1
                                                                  union all
    select * from ads.ads_sr_finance_book_recharge_consume_info where report_type = 1
) b
on a.order_serial_id = b.order_id
where order_serial_id in(
    select
        a.order_serial_id
    from (
        select
            *
        from dwd.dwd_srsv_trade_hk_sync_payorder_di_daily
    ) a
    right join (
        select * from ads.ads_sv_finance_series_recharge_consume_info where report_type = 1
                                                                      union all
        select * from ads.ads_sr_finance_book_recharge_consume_info where report_type = 1
    ) b
    on a.order_serial_id = b.order_id
    where a.coo_notify_time != b.order_time or a.dt != b.dt
);

-- SQL语句
-- 3、删除因订单时间改变导致dt改变主键失效的订单
select
    order_serial_id, count(1)
from dwd.dwd_srsv_trade_hk_sync_payorder_di_daily
group by order_serial_id
having count(1) > 1;

-- SQL语句
delete from dwd.dwd_srsv_trade_hk_sync_payorder_di_daily where (dt, order_serial_id) in(
    select
        min(dt) as dt,
        order_serial_id
    from dwd.dwd_srsv_trade_hk_sync_payorder_di_daily
    group by order_serial_id
    having count(1) > 1
);

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总_改_补数
-- workflow_version : 20
-- create_user      : xiejc
-- task_name        : SDK充值明细
-- task_version     : 5
-- update_time      : 2026-05-07 18:01:08
-- sql_path         : \starrocks\审计测试-总_改_补数\SDK充值明细
----------------------------------------------------------------
-- 前置SQL语句
truncate table dwd.dwd_srsv_trade_hk_sync_payorder_di_daily;

-- SQL语句
-- 1、数据重刷
insert into dwd.dwd_srsv_trade_hk_sync_payorder_di_daily
select
    ifnull(b.dt, a.dt) as dt,
    a.id,
    a.order_serial_id,
    a.order_id,
    a.coo_order_id,
    a.pay_chanel_id,
    a.account,
    a.user_id,
    a.server_id,
    a.user_i_p_address,
    a.create_time,
    ifnull(b.coo_notify_time, a.coo_notify_time) as order_time,
    a.finish_time,
    a.amount,
    a.give_amount,
    a.bank_amount,
    a.order_status,
    a.coo_order_status,
    a.shop_item,
    a.product_id,
    a.pay_type,
    a.bank_id,
    a.ext1,
    a.ext2,
    a.ext3,
    a.ext4,
    a.ext5,
    a.os_type,
    a.shop_item_id,
    a.coupon_id,
    a.package_id,
    a.phone,
    a.has_notify_times,
    a.pay_config_id,
    a.core,
    a.base_amount,
    a.unique_guid,
    a.test_flag,
    a.coo_ext_status,
    a.coo_ext_info,
    a.bill_info,
    a.row_update_timestamp,
    a.sub_pay_type,
    a.auto_renew_times,
    a.subscribe_status,
    a.app_ver,
    a.country,
    a.sr_createtime,
    a.sr_updatetime,
    a.province
from (
    select
        *
    from dwd.dwd_srsv_trade_hk_sync_payorder_di
) a
left join dwd.dwd_srsv_trade_hk_sync_payorder_di_daily b
on a.order_serial_id = b.order_serial_id
where a.product_id not in('8211', '2311');

-- SQL语句
-- 2、修正订单时间
insert into dwd.dwd_srsv_trade_hk_sync_payorder_di_daily
select
    b.dt,
    a.id,
    a.order_serial_id,
    a.order_id,
    a.coo_order_id,
    a.pay_chanel_id,
    a.account,
    a.user_id,
    a.server_id,
    a.user_i_p_address,
    a.create_time,
    b.order_time as coo_notify_time,
    a.finish_time,
    a.amount,
    a.give_amount,
    a.bank_amount,
    a.order_status,
    a.coo_order_status,
    a.shop_item,
    a.product_id,
    a.pay_type,
    a.bank_id,
    a.ext1,
    a.ext2,
    a.ext3,
    a.ext4,
    a.ext5,
    a.os_type,
    a.shop_item_id,
    a.coupon_id,
    a.package_id,
    a.phone,
    a.has_notify_times,
    a.pay_config_id,
    a.core,
    a.base_amount,
    a.unique_guid,
    a.test_flag,
    a.coo_ext_status,
    a.coo_ext_info,
    a.bill_info,
    a.row_update_timestamp,
    a.sub_pay_type,
    a.auto_renew_times,
    a.subscribe_status,
    a.app_ver,
    a.country,
    a.sr_createtime,
    a.sr_updatetime,
    a.province
from dwd.dwd_srsv_trade_hk_sync_payorder_di_daily a
left join (
    select * from tmp.tmp_xjc_ads_sv_finance_series_recharge_consume_info where report_type = 1
                                                                  union all
    select * from tmp.tmp_xjc_ads_sr_finance_book_recharge_consume_info where report_type = 1
) b
on a.order_serial_id = b.order_id
where order_serial_id in(
    select
        a.order_serial_id
    from (
        select
            *
        from dwd.dwd_srsv_trade_hk_sync_payorder_di_daily
    ) a
    right join (
        select * from tmp.tmp_xjc_ads_sv_finance_series_recharge_consume_info where report_type = 1
                                                                      union all
        select * from tmp.tmp_xjc_ads_sr_finance_book_recharge_consume_info where report_type = 1
    ) b
    on a.order_serial_id = b.order_id
    where a.coo_notify_time != b.order_time or a.dt != b.dt
);

-- SQL语句
-- 3、删除因订单时间改变导致dt改变主键失效的订单
select
    order_serial_id, count(1)
from dwd.dwd_srsv_trade_hk_sync_payorder_di_daily
group by order_serial_id
having count(1) > 1;

-- SQL语句
delete from dwd.dwd_srsv_trade_hk_sync_payorder_di_daily where (dt, order_serial_id) in(
    select
        min(dt) as dt,
        order_serial_id
    from dwd.dwd_srsv_trade_hk_sync_payorder_di_daily
    group by order_serial_id
    having count(1) > 1
);
