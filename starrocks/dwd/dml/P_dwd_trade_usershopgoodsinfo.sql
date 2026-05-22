----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_trade_usershopgoodsinfo
-- workflow_version : 2
-- create_user      : zhugl
-- task_name        : tbl_dwd_trade_usershopgoodsinfo
-- task_version     : 2
-- update_time      : 2025-03-29 01:22:45
-- sql_path         : \starrocks\tbl_dwd_trade_usershopgoodsinfo\tbl_dwd_trade_usershopgoodsinfo
----------------------------------------------------------------
-- SQL语句
insert into dwd.dwd_trade_usershopgoodsinfo
select
dt,productid,Id,Pid,ShopGoodsId,ShopGoodsType,BuyType,Source,Amount,ExpiredTime,CreateTime,Core,Mt,Status,Email,FaceBook,SuperExchangeType,SuperExchangeNum,Days,GameCode,GameAccount,GameUserName,GameArea,ShopGoodsPriceInfo,ReadBgId,OrderStatus,ExchangeNum,
b.app_id_account,
b.mt_account,
b.is_has_charge,
b.corever,
b.current_language,
b.current_language2,
b.reg_country,
b.regdate,
b.prod_id,
b.device_guid,
b.app_ver,
b.ver,
b.ads_type,
b.ads_quality,
b.is_negative_user,
NOW()
from (select *  from  ods.ods_tidb_readernovel_tidb_xx_usershopgoodsinfo where dt = '${bf_1_dt}' ) a
left join
(
select
b.app_id app_id_account,
b.mt mt_account,
b.is_has_charge,
b.corever,
b.current_language,
b.current_language2,
b.reg_country,
b.create_tm_account as regdate,
b.prod_id,
b.device_guid,
b.app_ver,
b.ver,
b.ads_type,
b.ads_quality,
b.is_negative_user,
b.product_id,
b.user_id
from dim.dim_user_all_info b
)b on a.productid = b.product_id and a.pid = b.user_id;
