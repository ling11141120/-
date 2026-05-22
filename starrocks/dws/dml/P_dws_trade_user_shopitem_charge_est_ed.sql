----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_trade_user_shopitem_charge_est_ed
-- workflow_version : 2
-- create_user      : hufengju
-- task_name        : dws_trade_user_shopitem_charge_est_ed
-- task_version     : 2
-- update_time      : 2024-11-21 21:19:14
-- sql_path         : \starrocks\tbl_dws_trade_user_shopitem_charge_est_ed\dws_trade_user_shopitem_charge_est_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_trade_user_shopitem_charge_est_ed where dt ='${bf_1_dt}';

-- SQL语句
insert into dws.dws_trade_user_shopitem_charge_est_ed
select date(date_add(a.createtime,interval -13 hour)) as dt,a.productid,b.corever,b.current_language,b.current_language2,b.appver,b.mt,b.ver,b.reg_country,
       a.userid,b.create_time as regtime,a.ShopItem,a.packageid,a.SubpayType,
	   c.Firstchargeday,
	   c.Firstchargemoney,
	   datediff(date(date_add(a.createtime,interval -13 hour)),c.Firstchargeday)  as reday,
	    datediff(date(date_add(a.createtime,interval -13 hour)),date(b.create_time)) as regdays,
	     sum(CasE WHEN date(date_add(a.createtime,interval -13 hour)) < '2021-02-01' AND a.systemtype IN ( 336617, 336651 ) AND a.itemcount > 0 THEN a.itemcount * 0.014
	 WHEN date(date_add(a.createtime,interval -13 hour)) < '2021-02-01' THEN a.itemcount
	 ELSE a.baseamount/100 END ) as chargemoney,
	  count(a.userid) as chargecount   ,
	 sum(a.itemcount) chargeitemcount,
     now() as etl_time
from
dwd.dwd_trade_user_payorder a
left join
dim.dim_user_account_info_view b
 on a.productid=b.product_id and a.userid=b.id
 left join
dws.dws_trade_user_recharge_est_temp c
 on a.productid=c.product_id and a.userid=c.user_id and c.dt ='${bf_1_dt}'
 where date(date_add(a.createtime,interval -13 hour)) >='${bf_1_dt}' and date(date_add(a.createtime,interval -13 hour))< date(date_add('${bf_1_dt}',interval 1 day ))
group by 1,2,3,4,5,6,7,8,9,10,11,12 ,13,14,15,16
;
