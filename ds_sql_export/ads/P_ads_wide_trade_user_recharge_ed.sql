----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_wide_trade_user_recharge_ed
-- workflow_version : 2
-- create_user      : linq
-- task_name        : ads_wide_trade_user_recharge_ed
-- task_version     : 1
-- update_time      : 2023-12-26 16:16:58
-- sql_path         : \starrocks\tbl_ads_wide_trade_user_recharge_ed\ads_wide_trade_user_recharge_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_wide_trade_user_recharge_ed where dt='${bf_1_dt}';

-- SQL语句
insert into ads.`ads_wide_trade_user_recharge_ed`
select a.dt,
       md5(concat_ws('-',a.dt,b.user_type,a.Productid,a.userid,a.ShopItem,a.packageid,if(a.packageid like 'Ps_Half%',split(a.packageid, '_')[3],-99),a.SubpayType)) as md5_key,
       b.user_type,
       a.Productid as product_id,
       a.corever,
       a.CurrentLanguage as current_language,
       a.CurrentLanguage2 as current_language2,
       a.appver as app_ver,
       a.mt,
       a.ver,
       a.regcountry as reg_country,
       ifnull(c.level,2) as country_level,
       a.userid as user_id,
       a.regtime as reg_time,
       a.ShopItem as shop_item,
       a.packageid as package_id,
       if(a.packageid like 'Ps_Half%',split(a.packageid, '_')[3],-99) as book_id,
       a.SubpayType as sub_pay_Type,
       b.user_period,
       b.user_value,
       b.source,
       a.Firstchargeday as first_charge_day,
       a.Firstchargemoney as  first_charge_money,
       a.reday as re_day,
       a.regdays as reg_days,
       a.chargemoney as charge_money,
       a.chargecount as charge_count,
       a.chargeitemcount as  charge_itemcount,
       now() as etl_time
from dws.dws_trade_user_shopitem_charge_ed a
left join dws.dws_user_wide_tag_info_ed b
    on a.dt=b.dt and a.Productid=b.product_id and a.userid=b.user_id
left join dim.dim_countrylevel c
    on a.Productid=c.product_id and a.regcountry=c.short_name
where a.dt>='${bf_1_dt}' and a.dt<'${dt}';
