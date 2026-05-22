----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_sign_in_card_info
-- workflow_version : 2
-- create_user      : chenmo
-- task_name        : ads_sv_sign_in_card_info
-- task_version     : 1
-- update_time      : 2025-07-30 19:03:27
-- sql_path         : \starrocks\tbl_ads_sv_sign_in_card_info\ads_sv_sign_in_card_info
----------------------------------------------------------------
-- SQL语句
insert overwrite ads.ads_sv_sign_in_card_info
select
    a.PayOrderId,
    a.AccountId,
    a.ExpireTime,
    a.Bonus,
    a.ProductId,
    a.GoodsOptionId,
    a.ItemId,
    a.OrderMark,
    b.PayType,
    b.GainBonus,
    b.GainCoin,
    now() as etl_time
from (
    select
        *
    from ods.ods_tidb_short_video_sign_in_card
    where from_unixtime(ExpireTime/1000) >= now()
) a
left join ods.ods_tidb_short_video_bill b
on a.PayOrderId = b.PayOrderId and BillType = 4;
