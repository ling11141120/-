----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_user_charge_1d
-- workflow_version : 6
-- create_user      : yanxh
-- task_name        : tbl_ads_user_charge_1d
-- task_version     : 6
-- update_time      : 2024-10-16 15:44:07
-- sql_path         : \starrocks\tbl_ads_user_charge_1d\tbl_ads_user_charge_1d
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_user_charge_1d where dt = '${bf_1_dt}';

-- SQL语句
insert into ads.ads_user_charge_1d
select a.dt,a.productid,a.corever,a.CurrentLanguage,a.CurrentLanguage2,a.appver,a.mt,a.ver,a.regcountry,
 count(distinct userid ) charge_num,
 sum(chargemoney) charge_money,
  sum(chargeitemcount) charge_itemcount,
 count(distinct case when dt=Firstchargeday then userid end) fisrt_charge_num,
 sum(distinct  case when dt=Firstchargeday then chargemoney end) fisrt_charge_money,
 sum(distinct  case when dt=Firstchargeday then chargeitemcount end) fisrt_charge_itemcount
  ,now() as etl_time
  from dws.dws_trade_user_shopitem_charge_ed a
 where a.dt ='${bf_1_dt}'
group by 1,2,3,4,5,6,7,8,9;
