-- =====================================================
-- 问题2修复：周报充值逻辑（修正沙箱关联+新增退款过滤）
-- 修改人：陈末
-- 修改日期：2026-01-06
-- =====================================================

-- ----------------------------海阅的周报 20240925 新增的reg_country-----------------
-- ----------------------------海阅的周报 20241214 新增的非引流指标-----------------
insert into ads.ads_bi_video_growth_operations_weekly
with recharge_mode as (
    select '${bf_1_dt}' as dt, product_id,user_id, item_count as mode, num, create_time,
           case
               when item_count>0 and item_count<=5 then '0-5'
               when item_count>5 and item_count<=10 then '5-10'
               when item_count>10 and item_count<=20  then '10-20'
               when item_count>20 and item_count<=30  then '20-30'
               when item_count>30 and item_count<=50  then '30-50'
               when item_count>50 then '50+'
               end as user_value
    from (
             select Product_Id, User_Id, item_count, num, create_time,
                    row_number() over (partition by Product_Id, User_Id order by num desc,create_time desc ) as rk
             from (
                      select Product_Id, User_Id, item_count, count(1) as num, max(create_time) as create_time
                      from dwd.dwd_trade_short_video_payorder
                      where dt <= '${bf_1_dt}' and Test_Flag = 0 and product_id in(6833) and status=0
                      group by 1, 2, 3
                      union all
                      select Product_Id, video_user_id as User_Id, round(amount/100,2) as itemcount, count(1) as num, max(create_time) as create_time
                      from dwd.dwd_trade_video_cn_payorder_view
                      where dt <= '${bf_1_dt}' and Test_Flag = 0 and coo_order_status=1
                      group by 1, 2, 3

                      union all
                     -- TT换币充值订单（tt_payorder）
                     select product_id, user_id, monthly_recharge_amt, count(1) as num, max(create_time) as create_time
                     from dwd.dwd_sv_tt_payorder_info
                     where is_refund = 0 and is_sandbox = 0 and settle_dt <= '${dt}' and user_id >= 0
                     group by 1, 2, 3
                  ) a
         ) b
    where rk = 1
),

active as (
select a.dt, a.product_id, a.user_id, mt, country_level,current_language2,a.corever,
       case when a.reg_days=0 then 'D0'
            when a.reg_days>=1 and a.reg_days<=7 then 'D1-D7'
            when a.reg_days>=8 and a.reg_days<=30 then 'D8-D30'
            when a.reg_days>=31 and b.user_id is not null then 'D31+_stock_user'
            when a.reg_days>=31 and b.user_id is null then 'D31+_backflow_user'
            else 'D31+_backflow_user' end as user_type,
       if(b.user_id is not null,1,0) as is_l7_active,
       c.chl2,
       c.chl,
	   a.reg_country     -- ----20240925 新增的reg_country---
from (
         select a.dt, a.product_id, a.user_id, max(a.mt) as mt,max(a.reg_country) as reg_country,MAX(case when b.level is null then 2 else b.level end) as country_level,
                max(a.current_language2) as current_language2, max(a.reg_days) as reg_days,max(a.corever) as corever -- 新增的core字段
         from dws.dws_user_short_video_wide_active_ed a
                  left join dim.dim_countrylevel b
                        on a.product_id =b.product_id
                        and a.reg_country =b.short_name
         where a.dt = '${bf_1_dt}'
         group by 1,2,3
     )a
left join (
            select product_id, user_id
            from dws.dws_user_short_video_wide_active_ed
            where dt>=date_sub('${bf_1_dt}',interval 7 day) and dt<'${bf_1_dt}'
            group by 1,2
         )b
  on a.product_id=b.product_id
  and a.user_id=b.user_id
left join ( -- ---初始渠道值---
            select product_id,user_id,chl2,chl from dim.dim_short_video_user_accountinfo
            )c
  on a.product_id=c.product_id
  and a.user_id=c.user_id
),
 -- ------------引流剧--------------------
 channel_book as (
	select product_id, user_id, mt,corever,lang2,last_bookid
	 from(
			 select product_id,user_id, mt,corever,lang2,last_bookid ,
					row_number() over ( partition by product_id,user_id,mt,corever,lang2 order by install_date desc,mt,corever,lang2) rn
			 from dws.dws_user_market_channel_info_detail_td
			 where dt='${bf_1_dt}' and product_id  in(6833)
		 )s1
	 where rn=1
 ),
recharge as (
select dt,product_id,user_id,round(sum(charge_money),2) as chargemoney, round(sum(recharge_item_amt),2) as recharge_item_amt
from (
         select dt, product_id, user_id, base_amount/100 as charge_money,item_count as recharge_item_amt
			 from dwd.dwd_trade_short_video_payorder
			 where dt = '${bf_1_dt}' and Test_Flag = 0 and product_id in(6833) and status=0
         union all
         select dt, product_id, user_id, charge_money_rmb as charge_money,charge_itemcount*7 as recharge_item_amt  -- 上游表落表时除了7的
			 from dws.dws_trade_viedo_cn_payorder_ed
			 where dt = '${bf_1_dt}' and self_type in(1)

		 union all
		 select settle_dt, product_id, user_id, monthly_net_amt, monthly_recharge_amt
         from dwd.dwd_sv_tt_payorder_info
         where is_refund = 0 and is_sandbox = 0 and settle_dt = '${bf_1_dt}'
     )t1
group by 1,2,3
),

limit_free as (
select dt,6833 as product_id,user_id,
       sum(if(shop_item=810,base_amount/100,0)) as vip_recharge_amt,
       sum(if(get_json_string(custom_data,'$.goodsType')=3,item_count,0)) as limit_free_amt
from dwd.dwd_trade_short_video_payorder
where dt='${bf_1_dt}' and Test_Flag = 0 and product_id in(6833) and status=0
group by 1,2,3
union all
select a.dt,6883 as product_id,a.user_id,
       round(sum(b.base_amount_rmb),2) as vip_recharge_amt,
       null as limit_free_amt
from dwd.dwd_trade_cn_a_recharge_view a
         left join dwd.dwd_trade_video_cn_payorder_view b on a.dt=b.dt and a.out_trade_no=b.coo_order_id
where a.dt='${bf_1_dt}' and test_flag=0 and a.subject rlike '会员' and a.pay_status=1
group by 1,2,3
),
consume as (
	select
		a.product_id,a.user_id ,b.corever ,b.mt ,b.current_language2 ,
		sum(if(types=0,consume_amt,0))/100 as consume_money,sum(if(types=1,consume_amt,0))/100 as presented_money,sum(consume_amt)/100 as consume_all,
		sum(if(types=0 and d.user_id is null,consume_amt,0))/100 as natural_money,sum(if(types=1 and d.user_id is null,consume_amt,0))/100 as natural_presented
	from (
		select a.product_id,a.user_id,a.epis_id,a.types,a.consume_amt,b.series_id as book_id
		from dws.dws_consume_short_video_consume_ed a
		left join dim.dim_short_video_epis_view b on a.epis_id = b.epis_id
		where dt = '${bf_1_dt}'

	union all
	-- TT消耗订单（tt_consume）
    select 6833 as product_id, a.account_id as user_id,null as epis_id,0 as types,
           cast(a.coin as decimal(10, 2))*(1-0.00966958) as consume_amt,  -- 扣除手续费后的消耗金额
           a.series_id as book_id
    from ods.ods_tidb_short_video_tt_consume a
    left join (
       select
           get_json_string(content, '$.trade_order_id') as trade_order_id,
           max(if(get_json_string(content, '$.is_sandbox'), 1, 0)) as is_sandbox
       from ods.ods_tidb_short_video_tt_vip_subscribe_event_log
       where date(create_time) >= '${bf_3_dt}' and date(create_time) <= '${dt}'
           and get_json_string(content, '$.trade_order_id') is not null
       group by 1
    ) b on a.trade_order_id = b.trade_order_id
    where date(a.create_time)='${bf_1_dt}'
      and ifnull(b.is_sandbox, 0) = 0  -- 剔除沙盒数据
	) a
	left join  dim.dim_short_video_user_accountinfo  b on a.product_id = b.product_id and a.user_id=b.user_id
	left join channel_book d on a.product_id =d.product_id  and a.book_id =d.last_bookid  and a.user_id =d.user_id and b.mt=d.mt  and b.corever=d.corever   and b.current_language2=d.lang2
	group by 1,2,3,4,5
union all
	select
			product_id,user_id,corever2 as corever,mt2 as mt,current_language2,sum(consume_amt)/100 as consume_money ,0 as presented_money,sum(consume_amt)/100 as consume_all,0 as natural_money,0 as natural_presented
	from dws.dws_consume_short_video_cn_consume_ed
	where dt = '${bf_1_dt}'
	group by 1,2,3,4,5

),
over_consume as (
-- 海外短剧超前点播
select 6833 as product_id, account_id as user_id, sum(consume_value)/100 as over_consume_value
from dwd.dwd_sv_consume_user_consume_bill_pdi
where dt = '${bf_1_dt}'
  and  consume_type2 in (2,3)
group by product_id, user_id
    -- 国内短剧暂时没有超前点播

),

rmt as (
select
        Product_Id,User_Id,max(dt) as install_dt
from dws.dws_srsv_wide_user_type_info_di
where dt>=date_sub('${bf_1_dt}',interval 6 month ) and dt <='${bf_1_dt}' and  user_period=3   and product_id in(6833)
group by 1,2
union all

select
        Product_Id,User_Id,max(stat_period) as install_dt
from dws.dws_wide_video_cn_user_type_info_ed
where user_period=3 and period_types=1 and stat_period>=date_sub('${bf_1_dt}',interval 6 month ) and stat_period <='${bf_1_dt}' and product_id in(6883)
group by 1,2
),
rmt_user_type as(
select active.dt, active.product_id, active.user_id,active.mt,active.country_level,active.current_language2,active.chl2,active.chl,active.corever, -- --新增的core字段
    case when datediff(active.dt,rmt.install_dt)=0 then 'D0'
    when datediff(active.dt,rmt.install_dt)>=1 and datediff(active.dt,rmt.install_dt)<=7 then 'D1-D7'
    when datediff(active.dt,rmt.install_dt)>=8 and datediff(active.dt,rmt.install_dt)<=30 then 'D8-D30'
    when datediff(active.dt,rmt.install_dt)>=31 and is_l7_active=1 then 'D31+_stock_user'
    else 'D31+_backflow_user' end as user_type,
    if(rmt.user_id is not null,1,0) as is_rmt,
	active.reg_country     -- ----20240925 新增的reg_country---
from active
left join rmt
on active.product_id=rmt.Product_Id
and active.user_id=rmt.User_Id
),
ad_amt as (
select product_id,user_id,sum(amt) as ad_amt
from dws.dws_advertisement_user_position_amt_ed
where dt='${bf_1_dt}' and product_id in(6833)
group by 1,2
),
source as (
select product_id, user_id, last_source as source_chl,is_source
from(
    select product_id,user_id,last_source,
	case when  last_bookid>0 then 1
		when  last_bookid<=0 or last_bookid is null then 0
		end as is_source ,
    row_number() over ( partition by product_id,user_id order by install_date desc,mt,corever,lang2) rn
    from dws.dws_user_market_channel_info_detail_td
    where dt='${bf_1_dt}' and product_id in(6833)
    )s1
where rn=1
    )


select dt,md5(concat_ws('_',dt,product_id,period_type,period_week,mt,country_level,reg_language,user_type,user_value,chl2,chl,source_chl,corever,reg_country)) as md5_key,
       product_id,period_type,period_week,mt,country_level,reg_language,user_type,user_value,chl2,chl,source_chl,corever,reg_country,dau,recharge_amount,recharge_cnt,
       vip_recharge_amt,limit_free_amt,consume_money,consume_all,consume_money_cnt,consume_all_cnt,consume_user_pay_cnt,
       consume_wide_all_cnt,recharge_item_amt,consume_pay_vip,consume_pay_vip_cnt,ad_amt,natural_vip_recharge_amt,natural_consume_money,natural_presented_money,natural_limit_free_amt,natural_consume_money_all,natural_money_all,
	   now() as etl_time
from (
         select dt,
                product_id,
                'ctt'                                    as period_type,
                weekofyear(date_sub(dt, interval 1 day)) as period_week,
                ifnull(mt, -99)                          as mt,
                country_level,
                ifnull(current_language2, -99)           as reg_language,
                user_type,
                ifnull(user_value, 'worthless_user')     as user_value,
                ifnull(chl2,-99) as chl2,
                ifnull(chl,-99) as chl,
                ifnull(source_chl,-99) as source_chl,
                ifnull(corever, 1)                       as corever,
				ifnull(reg_country,'OTHER') as reg_country,
                count(1)                                 as dau,
                round(sum(chargemoney), 2)               as recharge_amount,
                count(if(chargemoney >= 0, 1, null))     as recharge_cnt,
                round(sum(vip_recharge_amt), 2)          as vip_recharge_amt,
                round(sum(limit_free_amt), 2)            as limit_free_amt,
                round(sum(consume_money), 2)             as consume_money,
                round(sum(consume_all), 2)               as consume_all,
                count(if(consume_money > 0, 1, null))    as consume_money_cnt,
                count(if(consume_all > 0, 1, null))      as consume_all_cnt,
                count(if(consume_money > 0 or vip_recharge_amt>0 or limit_free_amt>0, 1, null))  as consume_user_pay_cnt,
                count(if(consume_all > 0 or vip_recharge_amt>0 or limit_free_amt>0, 1, null))    as consume_wide_all_cnt,
                round(sum(recharge_item_amt), 2)                                                 as recharge_item_amt,
                round(sum(over_consume_value), 2)                                                as consume_pay_vip,
                sum(case when over_user_id is null then 0 else 1 end )                           as consume_pay_vip_cnt,
                round(sum(ad_amt), 2)                                                            as ad_amt,
				null	as  natural_vip_recharge_amt,
				round(sum(natural_money),2)	as  natural_consume_money,
				round(sum(natural_presented),2)	as  natural_presented_money,
				null	as  natural_limit_free_amt,
				round(sum(ifnull(natural_money,0)+ifnull(natural_presented,0)),2)	as  natural_consume_money_all,
				round(sum(ifnull(natural_money,0)),2)	as  natural_money_all
         from (
                  select active.dt,active.product_id,active.user_id,active.mt,active.country_level,active.current_language2,active.corever,active.reg_country, -- 新增的core字段,20240925 新增的reg_country
                         active.user_type,active.chl2,active.chl,recharge_mode.user_value,recharge.chargemoney,limit_free.vip_recharge_amt,limit_free.limit_free_amt,
                         consume.consume_money,consume.presented_money,consume.consume_all,consume.natural_money,consume.natural_presented,recharge.recharge_item_amt,over_consume.over_consume_value,over_consume.user_id as over_user_id,
                         ad_amt.ad_amt,source.source_chl
                  from active
                           left join recharge on active.product_id = recharge.product_id and active.user_id = recharge.user_id
                           left join limit_free on active.product_id = limit_free.product_id and active.user_id = limit_free.user_id
                           left join recharge_mode on active.product_id = recharge_mode.product_id and active.user_id = recharge_mode.user_id
                           left join consume on active.product_id = consume.product_id and active.user_id = consume.user_id
                           left join over_consume on active.product_id = over_consume.product_id and active.user_id = over_consume.user_id
                           left join ad_amt on active.product_id = ad_amt.product_id and active.user_id = ad_amt.user_id
                           left join source on active.product_id = source.product_id and active.user_id = source.user_id
              ) t1
         group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14
         union all
         select dt,
                product_id,
                'rmt'                                    as period_type,
                weekofyear(date_sub(dt, interval 1 day)) as period_week,
                ifnull(mt, -99)                          as mt,
                country_level,
                ifnull(current_language2, -99)           as reg_language,
                user_type,
                ifnull(user_value, 'worthless_user')     as user_value,
                ifnull(chl2,-99) as chl2,
                ifnull(chl,-99) as chl,
                ifnull(source_chl,-99) as source_chl,
                ifnull(corever, 1)                       as corever,
				ifnull(reg_country,'OTHER') as reg_country,
                count(1)                                 as dau,
                round(sum(chargemoney), 2)               as recharge_amount,
                count(if(chargemoney >= 0, 1, null))     as recharge_cnt,
                round(sum(vip_recharge_amt), 2)          as vip_recharge_amt,
                round(sum(limit_free_amt), 2)            as limit_free_amt,
                round(sum(consume_money), 2)             as consume_money,
                round(sum(consume_all), 2)               as consume_all,
                count(if(consume_money > 0, 1, null))    as consume_money_cnt,
                count(if(consume_all > 0, 1, null))      as consume_all_cnt,
                count(if(consume_money > 0 or vip_recharge_amt>0 or limit_free_amt>0, 1, null))  as consume_user_pay_cnt,
                count(if(consume_all > 0 or vip_recharge_amt>0 or limit_free_amt>0, 1, null))    as consume_wide_all_cnt,
                round(sum(recharge_item_amt), 2)                                                 as recharge_item_amt,
                round(sum(over_consume_value), 2)                                                as consume_pay_vip,
                sum(case when over_user_id is null then 0 else 1 end )                           as consume_pay_vip_cnt,
                round(sum(ad_amt), 2)                                                            as ad_amt,
				null	as  natural_vip_recharge_amt,
				round(sum(natural_money),2)	as  natural_consume_money,
				round(sum(natural_presented),2)	as  natural_presented_money,
				null	as  natural_limit_free_amt,
				round(sum(ifnull(natural_money,0)+ifnull(natural_presented,0)),2)	as  natural_consume_money_all,
				round(sum(ifnull(natural_money,0)),2)	as  natural_money_all
         from (
                  select rmt_user_type.dt,rmt_user_type.product_id,rmt_user_type.user_id,rmt_user_type.mt,rmt_user_type.country_level,rmt_user_type.corever,rmt_user_type.reg_country, -- 新增的core字段,20240925 新增的reg_country
                         rmt_user_type.current_language2,rmt_user_type.user_type,rmt_user_type.chl2,rmt_user_type.chl,recharge_mode.user_value,recharge.chargemoney,
                         limit_free.vip_recharge_amt,limit_free.limit_free_amt,consume.consume_money,consume.presented_money,consume.consume_all,consume.natural_money,consume.natural_presented,
                         recharge.recharge_item_amt,over_consume.over_consume_value,over_consume.user_id as over_user_id,
                         ad_amt.ad_amt,source.source_chl
                  from rmt_user_type
                           left join recharge on rmt_user_type.product_id = recharge.product_id and rmt_user_type.user_id = recharge.user_id
                           left join limit_free on rmt_user_type.product_id = limit_free.product_id and rmt_user_type.user_id = limit_free.user_id
                           left join recharge_mode on rmt_user_type.product_id = recharge_mode.product_id and rmt_user_type.user_id = recharge_mode.user_id
                           left join consume on rmt_user_type.product_id = consume.product_id and rmt_user_type.user_id = consume.user_id
                           left join over_consume on rmt_user_type.product_id = over_consume.product_id and rmt_user_type.user_id = over_consume.user_id
                           left join ad_amt on rmt_user_type.product_id = ad_amt.product_id and rmt_user_type.user_id = ad_amt.user_id
                           left join source on rmt_user_type.product_id = source.product_id and rmt_user_type.user_id = source.user_id
                  -- where rmt_user_type.is_rmt=1
              ) a
         group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14
     )a
;