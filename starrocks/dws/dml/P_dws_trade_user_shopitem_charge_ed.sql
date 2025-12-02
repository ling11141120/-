insert into dws.dws_trade_user_shopitem_charge_ed
select a.dt,a.productid,b.corever,b.current_language,b.current_language2,b.appver,b.mt,b.ver,b.reg_country,
       a.userid,b.create_time as regtime,a.ShopItem,a.packageid,a.SubpayType,
	   c.Firstchargeday,
	   c.Firstchargemoney,
	   datediff(a.dt,c.Firstchargeday)  as reday,
	    datediff(a.dt,date(b.create_time)) as regdays,
	     sum(CasE WHEN a.dt < '2021-02-01' AND a.systemtype IN ( 336617, 336651 ) AND a.itemcount > 0 THEN a.itemcount * 0.014
	 WHEN a.dt < '2021-02-01' THEN a.itemcount
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
dws.dws_trade_user_recharge_temp c
 on a.productid=c.product_id and a.userid=c.user_id and c.dt ='${bf_1_dt}'
 where a.dt >='${bf_1_dt}' and a.dt< date(date_add('${bf_1_dt}',interval 1 day ))
group by 1,2,3,4,5,6,7,8,9,10,11,12 ,13,14,15,16
;