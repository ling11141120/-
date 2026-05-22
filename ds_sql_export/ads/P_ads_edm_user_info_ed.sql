----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_edm_userbook_info
-- workflow_version : 33
-- create_user      : linq
-- task_name        : ads_edm_user_info_ed
-- task_version     : 8
-- update_time      : 2025-03-18 14:28:18
-- sql_path         : \starrocks\tbl_ads_edm_userbook_info\ads_edm_user_info_ed
----------------------------------------------------------------
-- SQL语句
insert overwrite ads.ads_edm_user_info_ed
select '${dt}' as dt,
       acc.id as user_id,
       acc.CurrentLanguage,
       acc.productid,
       acc.Country,
       acc.CoreVer,
       acc.MT,
       acc.UtcOffset,
       bookshelf.book_id,
       last_login_time,
       last_charge_time,
       svip_expire_time,
       acc.emailboundstatus as is_boud_email,
       current_timestamp() as etl_time
from(
    select
        id, productid, CurrentLanguage, Country, CoreVer, MT, UtcOffset, emailboundstatus
    from ods.ods_book_user_accountinfo
    where CreateTime < '${dt}'
) acc
left join (
    -- ---30---
    select
        product_id, user_id, book_id
    from ads.ads_user_read_bookshelftouser_last
    where dt = date_sub('${dt}',interval 1 day)
) bookshelf on acc.productid = bookshelf.product_id and acc.id = bookshelf.user_id
left join (
-- ---svip-810-30-
    select
        ProductId, UserId, max(CreateTime) as last_charge_time
--         ,date_add(max(if(ShopItem = 810, CreateTime, null)), interval 30 day) as svip_expire_time
    from dwd.dwd_trade_user_payorder
    where dt < '${dt}' and Flag = 0
    group by 1, 2
) pay on acc.productid = pay.ProductId and acc.Id = pay.UserId
left join (
    select
        product_id, user_id, last_login_time
    from ads.ads_user_login_roll_mid
) login on acc.productid = login.product_id and acc.Id = login.user_id
left join (
    select
       product_id, Id,
       date_add(if(VipExpireTime >= VipSecondsStartTime, VipExpireTime, VipSecondsStartTime), interval VipExpireTimeSeconds second) as svip_expire_time
    from(
        select
            product_id, Id,
            ifnull(VipExpireTime, '1970-01-01 00:00:00') as VipExpireTime,
            ifnull(VipSecondsStartTime, '1970-01-01 00:00:00') as VipSecondsStartTime,
            ifnull(VipExpireTimeSeconds, 0) as VipExpireTimeSeconds
        from ods.ods_tidb_readernovel_tidb_userdata
    )t1
) userdata on acc.productid = userdata.product_id and acc.Id = userdata.Id;
