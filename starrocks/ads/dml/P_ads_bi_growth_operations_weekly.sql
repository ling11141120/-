----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_growth_operations_weekly
-- workflow_version : 36
-- create_user      : linq
-- task_name        : ads_bi_growth_operations_weekly
-- task_version     : 36
-- update_time      : 2026-04-14 14:37:32
-- sql_path         : \starrocks\tbl_ads_bi_growth_operations_weekly\ads_bi_growth_operations_weekly
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_bi_growth_operations_weekly where dt = '${bf_1_dt}';

-- SQL语句
-- ----------------------------海阅的周报 20240925 新增的reg_country-----------------
-- ----------------------------海阅的周报 20241214 新增的非引流指标-----------------
 insert into ads.ads_bi_growth_operations_weekly
-- ---------充值众数的-------------------------
with recharge_mode as (
    select '${bf_1_dt}' as dt, ProductId as product_id, UserId as user_id, ItemCount as mode, num, createtime,
           case
               when itemcount>0 and itemcount<=5 then '0-5'
               when itemcount>5 and itemcount<=10 then '5-10'
               when itemcount>10 and itemcount<=20  then '10-20'
               when itemcount>20 and itemcount<=30  then '20-30'
               when itemcount>30 and itemcount<=50  then '30-50'
               when itemcount>50 then '50+'
               end as user_value
    from (
             select ProductId, UserId, ItemCount, num, createtime,
                    row_number() over (partition by ProductId,UserId order by num desc,createtime desc ) as rk
             from (
                      select ProductId, UserId, ItemCount, count(1) as num, max(CreateTime) as createtime
                      from dwd.dwd_trade_user_payorder
                      where dt <= '${bf_1_dt}' and TestFlag = 0 group by 1, 2, 3
                  ) a
         ) b
    where rk = 1
),
-- -----------------------ctt活跃用户的主表 ------------------------
     active as (
         select a.dt, a.product_id, a.user_id, mt, country_level,current_language2,
                case when a.reg_days=0 then 'D0'
                     when a.reg_days>=1 and a.reg_days<=7 then 'D1-D7'
                     when a.reg_days>=8 and a.reg_days<=30 then 'D8-D30'
                     when a.reg_days>=31 and b.user_id is not null then 'D31+_stock_user'
                     when a.reg_days>=31 and b.user_id is null then 'D31+_backflow_user'
                     else 'D31+_backflow_user' end as user_type,
                if(b.user_id is not null,1,0) as is_l7_active,
                a.corever, -- ----20240822 新增的core---
				a.reg_country  -- ----20240925 新增的reg_country---
         from (
                  select a.dt, a.product_id, a.user_id, a.mt,a.reg_country,case when b.level is null then 2 else b.level end  as country_level,a.current_language2, a.reg_days,a.corever
                  from dws.dws_user_wide_active_ed a
                           left join dim.dim_countrylevel b
                                 on a.product_id =b.product_id
                                 and a.reg_country =b.short_name
                  where dt = '${bf_1_dt}'
              )a left join (
             select product_id,user_id from dws.dws_user_wide_active_ed
             where dt>=date_sub('${bf_1_dt}',interval 7 day) and dt<'${bf_1_dt}'
             group by product_id, user_id
         )b on a.product_id=b.product_id and a.user_id=b.user_id
     ),
	 -- ------------引流书籍--------------------
	 channel_book as (
		select product_id, user_id, mt,corever,lang2,last_bookid
         from(
                 select product_id,user_id, mt,corever,lang2,last_bookid ,
                        row_number() over ( partition by product_id,user_id,mt,corever,lang2 order by install_date desc,mt,corever,lang2) rn
                 from dws.dws_user_market_channel_info_detail_td
                 where dt='${bf_1_dt}' and product_id not in(6833)
             )s1
         where rn=1
	 ),
-- --------充值金额的---------------------------
     recharge as (
         select a.dt,a.product_id, a.user_id,sum(chargemoney) as chargemoney,sum(chargeitemcount) as recharge_item_amt,sum(if(ShopItem=810,chargemoney,0)) as vip_recharge_amt,sum(if(ShopItem=810 and d.user_id is null,chargemoney,0)) as natural_pay_vip,sum(if(ShopItem=850,chargemoney,0)) as vip_recharge_amt_850
	 from (
		  select dt,Productid as product_id,userid as user_id,mt,corever,CurrentLanguage2,
		  cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(packageid,'|',1), 'Ps_Half_', -1),'Ps_Shop_half_',-1), '_', 1), '_', -1) as int ) as book_id,
		  chargemoney,chargeitemcount,ShopItem
	      from dws.dws_trade_user_shopitem_charge_ed a
	      where dt='${bf_1_dt}'
	  ) a
	left join channel_book d on  a.product_id =d.product_id  and a.book_id =d.last_bookid  and a.user_id =d.user_id and a.mt=d.mt  and a.corever=d.corever   and a.CurrentLanguage2=d.lang2
    group by 1,2,3
     ),
	 normal_recharge as (
    select dt,Productid as product_id,userid as user_id, sum(itemcount) as recharge_normal_amt
    from dwd.dwd_trade_user_payorder  where dt ='${bf_1_dt}' and TestFlag =0   and ((get_json_string(CooOrderExtInfo,"$.SubscribeStatus")!=2 and shopitem !=0 ) or ShopItem =0 )
    group by 1,2,3
),
-- ---------用户限免卡发放日志-----------------
    limit_free as (
         select dt,product_id,user_id,sum(price) as limit_free_amt
         from dwd.dwd_read_trade_user_limit_card_view
         where dt='${bf_1_dt}' and recevie_type=2
         group by 1,2,3
     ),
	consume as (
     select a.product_id,a.user_id,a.mt,a.corever,a.CurrentLanguage2,
	 		sum(if(types=1,amount,0))/100 as consume_money ,
		   sum(if(types=2,amount,0))/100 as presented_money ,
           sum(if(types=1 and pay_type in (45, 46, 63),amount,0))/100 as consume_pay_vip,
           sum(amount)/100 as consume_all,
           sum(if(types=1 and d.user_id is null,amount,0))/100 as natural_money ,
		   sum(if(types=2 and d.user_id is null,amount,0))/100 as natural_presented
	 from (
		  select a.product_id,a.user_id,acc.mt ,acc.corever,
					(case when acc.product_id = 3311 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  6
		             when acc.product_id = 3322 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  5
		             when acc.product_id = 3333 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  2
		             when acc.product_id = 3366 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  3
		             when acc.product_id = 3371 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  7
		             when acc.product_id = 3388 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  4
		             when acc.product_id = 3501 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  11
		             when acc.product_id = 3511 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  12
		             when acc.product_id = 3399 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  9
		             else acc.Current_Language2 end ) as  CurrentLanguage2,
		             types,amount,pay_type,a.book_id
		    from dwd.dwd_consume_user_consume a
			left join dim.dim_user_account_info_view acc on a.product_id=acc.product_id and a.user_id=acc.Id
			 where a.dt = '${bf_1_dt}' and a.types in(1,2,3) and a.pay_type<>1103 and a.book_id<>0
	 ) a
	 left join channel_book d on  a.product_id =d.product_id  and a.book_id =d.last_bookid  and a.user_id =d.user_id and a.mt=d.mt  and a.corever=d.corever   and a.CurrentLanguage2=d.lang2
	 group by 1, 2 ,3,4,5
),ad_amt as (
    select product_id,user_id,sum(amt) as ad_amt
    from dws.dws_advertisement_user_position_amt_ed
    where dt='${bf_1_dt}' and product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511)
    group by 1,2
),rmt as (
    select Product_Id,User_Id,max(dt) as install_dt
    from dws.dws_srsv_wide_user_type_info_di
    where dt>=date_sub('${bf_1_dt}',interval 6 month ) and dt <='${bf_1_dt}'
      and user_period=3  and  product_id not in(6883,6833)
    group by 1,2
),
-- -----------rmt用户主表，来源于 active 子查询 -------------------------------
     rmt_user_type as(
         select active.dt, active.product_id, active.user_id,active.mt,active.country_level,active.current_language2,
                case when datediff(active.dt,rmt.install_dt)=0 then 'D0'
                     when datediff(active.dt,rmt.install_dt)>=1 and datediff(active.dt,rmt.install_dt)<=7 then 'D1-D7'
                     when datediff(active.dt,rmt.install_dt)>=8 and datediff(active.dt,rmt.install_dt)<=30 then 'D8-D30'
                     when datediff(active.dt,rmt.install_dt)>=31 and is_l7_active=1 then 'D31+_stock_user'
                     else 'D31+_backflow_user'
                    end as user_type,
                if(rmt.user_id is not null,1,0) as is_rmt,
                active.corever, -- 20240822新增的core ----------------
				active.reg_country  -- ----20240925 新增的reg_country---
         from active  left join rmt on active.product_id=rmt.Product_Id and active.user_id=rmt.User_Id
     ),
-- -----------最的媒体值---------------------
     source as (
         select product_id, user_id, last_source as source_chl
         from(
                 select product_id,user_id,last_source,
                        row_number() over ( partition by product_id,user_id order by install_date desc,mt,corever,lang2) rn
                 from dws.dws_user_market_channel_info_detail_td
                 where dt='${bf_1_dt}' and product_id not in(6833)
             )s1
         where rn=1
     )
	 ,
	 vip_type as
	 (
		select
			dt,period_type,user_id
			,case min(vip_type) when 1 then 'VIP投流' when 2 then 'VIP投流1H'  when 3 then '普通用户' end vip_type
		from (
			SELECT  dt
				,user_id,period_type
				,CASE WHEN user_ad_set_source <> 2 AND user_ad_source = 1 THEN 1
						WHEN user_ad_set_source = 2 AND user_ad_source = 1 AND user_ad_set_time >= '2000-01-01' THEN 2
						WHEN dt < '2025-06-01'  AND user_ad_source = 1 THEN 1  -- 旧逻辑全天VIP
						ELSE 3 END  vip_type
			FROM dws.dws_user_wide_active_period_ed t1  where dt='${bf_1_dt}'
				group by 1,2,3,4
		) a
		group by 1,2 ,3
	 )

select dt,period_type,period_week,mt,country_level,reg_language,user_type,user_value,source_chl,corever,reg_country,vip_type,dau,recharge_amount,recharge_item_amt,
       recharge_normal_amt,recharge_cnt,vip_recharge_amt,limit_free_amt,consume_money,consume_pay_vip,consume_all,
       consume_money_cnt,consume_pay_vip_cnt,consume_all_cnt,consume_user_pay_cnt,consume_wide_all_cnt,ad_amt,natural_vip_recharge_amt,natural_consume_money,natural_presented_money,natural_limit_free_amt,natural_consume_money_all,natural_money_all,now() as etl_time
from (
         select t1.dt,
                'ctt' as period_type,
                weekofyear(date_sub(t1.dt,interval 1 day )) as period_week,
                ifnull(mt,-99) as mt,
                country_level,
                ifnull(current_language2,-99) as reg_language,
                user_type,
                ifnull(user_value,'worthless_user') as user_value,
                ifnull(source_chl,-99) as source_chl,
                ifnull(corever,1) as corever,
				ifnull(substr(reg_country,1,6),'OTHER') as reg_country,
				ifnull(b.vip_type ,'-99') as vip_type,
                count(1) as dau,
                round(sum(chargemoney),2) as recharge_amount,
                round(sum(recharge_item_amt),2) as recharge_item_amt,
                round(sum(recharge_normal_amt),2) as recharge_normal_amt,
                count(if(chargemoney >=0,1,null)) as recharge_cnt,
                round(sum(vip_recharge_amt),2) as vip_recharge_amt,
                round(sum(limit_free_amt),2) as limit_free_amt,
                round(sum(consume_money),2) as consume_money,
                round(sum(consume_pay_vip),2) as consume_pay_vip,
                round(sum(consume_all),2) as consume_all,
                count(if(consume_money >0,1,null)) as consume_money_cnt,
                count(if(consume_pay_vip >0,1,null)) as consume_pay_vip_cnt,
                count(if(consume_all >0,1,null)) as consume_all_cnt,
                count(if(consume_money >0 or vip_recharge_amt>0 or limit_free_amt>0 or vip_recharge_amt_850>0,1,null)) as consume_user_pay_cnt,
                count(if(consume_all >0 or vip_recharge_amt>0 or limit_free_amt>0 or vip_recharge_amt_850>0,1,null)) as consume_wide_all_cnt,
                round(sum(ad_amt),2) as ad_amt,
				null	as  natural_vip_recharge_amt,
				round(sum(natural_money),2)	as  natural_consume_money,
				round(sum(natural_presented),2)	as  natural_presented_money,
				null	as  natural_limit_free_amt,
				round(sum(ifnull(natural_money,0)+ifnull(natural_presented,0)),2)	as  natural_consume_money_all,
				round(sum(ifnull(natural_money,0)),2)	as  natural_money_all
         from (
                  select active.dt,active.product_id,active.user_id,active.mt,active.country_level,active.current_language2,
                         active.user_type,recharge_mode.user_value,source.source_chl,recharge.chargemoney,consume.consume_money,consume.presented_money,
                         consume.consume_pay_vip,consume.consume_all,natural_money,natural_presented,natural_pay_vip,ad_amt.ad_amt,recharge.recharge_item_amt,normal_recharge.recharge_normal_amt,
                         recharge.vip_recharge_amt,recharge.vip_recharge_amt_850,limit_free.limit_free_amt,
                         active.corever, -- 新增的core字段
						 active.reg_country   -- 新增的reg_country字段
                  from active
                           left join recharge on active.product_id = recharge.Product_id and active.user_id = recharge.user_id
                           left join normal_recharge on active.product_id = normal_recharge.Product_id and active.user_id = normal_recharge.user_id
                           left join limit_free on active.product_id = limit_free.product_id and active.user_id = limit_free.user_id
                           left join recharge_mode  on active.product_id = recharge_mode.Product_id and active.user_id = recharge_mode.user_id
                           left join consume on active.product_id = consume.Product_id and active.user_id = consume.user_id
                           left join ad_amt on active.product_id = ad_amt.Product_id and active.user_id = ad_amt.user_id
                           left join source on active.product_id = source.Product_id and active.user_id = source.user_id
              )t1
			  left join vip_type b on t1.dt=b.dt and t1.user_id=b.user_id and b.period_type='ctt'
         group by 1,2,3,4,5,6,7,8,9,10,11,12
         union all
         select a.dt,
                'rmt' as period_type,
                weekofyear(date_sub(a.dt,interval 1 day )) as period_week,
                ifnull(mt,-99) as mt,
                country_level,
                ifnull(current_language2,-99) as reg_language,
                user_type,
                ifnull(user_value,'worthless_user') as user_value,
                ifnull(source_chl,-99) as source_chl,
                ifnull(corever,1) as corever,
				ifnull(substr(reg_country,1,6),'OTHER') as reg_country,
				ifnull(b.vip_type ,'-99') as vip_type,
                count(1) as dau,
                round(sum(chargemoney),2) as recharge_amount,
                round(sum(recharge_item_amt),2) as recharge_item_amt,
                round(sum(recharge_normal_amt),2) as recharge_normal_amt,
                count(if(chargemoney >=0,1,null)) as recharge_cnt,
                round(sum(vip_recharge_amt),2) as vip_recharge_amt,
                round(sum(limit_free_amt),2) as limit_free_amt,
                round(sum(consume_money),2) as consume_money,
                round(sum(consume_pay_vip),2) as consume_pay_vip,
                round(sum(consume_all),2) as consume_all,
                count(if(consume_money >0,1,null)) as consume_money_cnt,
                count(if(consume_pay_vip >0,1,null)) as consume_pay_vip_cnt,
                count(if(consume_all >0,1,null)) as consume_all_cnt,
                count(if(consume_money >0 or vip_recharge_amt>0 or limit_free_amt>0 or vip_recharge_amt_850>0,1,null)) as consume_user_pay_cnt,
                count(if(consume_all >0 or vip_recharge_amt>0 or limit_free_amt>0 or vip_recharge_amt_850>0,1,null)) as consume_wide_all_cnt,
                round(sum(ad_amt),2) as ad_amt,
				null	as  natural_vip_recharge_amt,
				round(sum(natural_money),2)	as  natural_consume_money,
				round(sum(natural_presented),2)	as  natural_presented_money,
				null	as  natural_limit_free_amt,
				round(sum(ifnull(natural_money,0)+ifnull(natural_presented,0)),2)	as  natural_consume_money_all,
				round(sum(ifnull(natural_money,0)),2)	as  natural_money_all
         from (
                  select rmt_user_type.dt,rmt_user_type.product_id,rmt_user_type.user_id,rmt_user_type.mt,rmt_user_type.country_level,
                         rmt_user_type.current_language2,rmt_user_type.user_type,recharge_mode.user_value,source.source_chl,
                         recharge.chargemoney,recharge.recharge_item_amt,normal_recharge.recharge_normal_amt,consume.consume_money,consume.presented_money,
                         consume.consume_pay_vip,consume.consume_all,natural_money,natural_presented,natural_pay_vip,ad_amt.ad_amt,recharge.vip_recharge_amt,recharge.vip_recharge_amt_850,limit_free.limit_free_amt,
                         rmt_user_type.corever, -- 新增的core字段
						 rmt_user_type.reg_country   -- 新增的reg_country字段
                  from rmt_user_type
                           left join recharge on rmt_user_type.product_id = recharge.Product_id and rmt_user_type.user_id = recharge.user_id
                           left join normal_recharge on rmt_user_type.product_id = normal_recharge.Product_id and rmt_user_type.user_id = normal_recharge.user_id
                           left join limit_free on rmt_user_type.product_id = limit_free.product_id and rmt_user_type.user_id = limit_free.user_id
                           left join recharge_mode  on rmt_user_type.product_id = recharge_mode.Product_id and rmt_user_type.user_id = recharge_mode.user_id
                           left join consume on rmt_user_type.product_id = consume.Product_id and rmt_user_type.user_id = consume.user_id
                           left join ad_amt on rmt_user_type.product_id = ad_amt.Product_id and rmt_user_type.user_id = ad_amt.user_id
                           left join source on rmt_user_type.product_id = source.Product_id and rmt_user_type.user_id = source.user_id
                  -- where rmt_user_type.is_rmt=1
              ) a
			  left join vip_type b on a.dt=b.dt and a.user_id=b.user_id and b.period_type='rmt'
         group by 1,2,3,4,5,6,7,8,9,10,11,12
     )a

;
