----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_alg_trade_book_pay_info
-- workflow_version : 2
-- create_user      : yanxh
-- task_name        : tbl_alg_trade_book_pay_info
-- task_version     : 2
-- update_time      : 2023-10-26 15:58:20
-- sql_path         : \starrocks\tbl_alg_trade_book_pay_info\tbl_alg_trade_book_pay_info
----------------------------------------------------------------
-- SQL语句
insert overwrite alg.alg_trade_book_pay_info partition(p'${pname}')
			with trade_book as
 (
 				select
			   a.product_id,
			   a.userid,
			  a.book_id  ,
			  a.shop_item as shopitem,
			  sum(case  when dt>=DATE_SUB('${dt}',interval 1 day) and dt<'${dt}'  then pay_num end) as con_itemcount_01,
			   sum(case  when dt>=DATE_SUB('${dt}',interval 1 day) and dt<'${dt}'  then pay_money end) as sum_itemcount_01,

             sum(case  when dt>=DATE_SUB('${dt}',interval 7 day) and dt<'${dt}'  then pay_num end) as con_itemcount_07,
			  sum(case  when dt>=DATE_SUB('${dt}',interval 7 day) and dt<'${dt}'  then pay_money end) as sum_itemcount_07,

           	   sum(case  when dt>=DATE_SUB('${dt}',interval 15 day) and dt<'${dt}'  then pay_num end) as con_itemcount_15,
			   sum(case  when dt>=DATE_SUB('${dt}',interval 15 day) and dt<'${dt}'  then pay_money end) as sum_itemcount_15,
               sum( pay_num) as con_itemcount
			  ,sum(pay_money) as sum_itemcount
		from (
	select             dt,
				       productid as product_id,
				       userid ,
				       split(packageid, '_')[3] as book_id , -- ---bookid
				       shopitem as shop_item,
				       sum(chargeitemcount) pay_money,
				       count(chargeitemcount) pay_num
				from dws.dws_trade_user_shopitem_charge_ed
				where dt>='2021-01-01' and dt<'${dt}'
				      and regtime>='2021-01-01'
				       and packageid  like  'Ps_Half%'
				       group by 1,2,3,4,5

				       ) a
				       inner join
(select book_id ,build_time	 from dim.dim_shuangwen_book_read_consume_info  where  product_id  not in (8858) ) b
	on a.book_id =b.book_id
	group by 1,2,3,4
	)

select
      date_sub('${dt}',INTERVAL 1 day) as dt,
	   book_id
	,count(DISTINCT  userid ) as con_user_charege
	,count(DISTINCT case when shopitem='0' then userid end) as con_user_charege_a
	,count(DISTINCT case when shopitem in ('800','810','830','840') then userid end) as con_user_charege_b
	,0 as con_aduser_charege
	,0 as con_notaduser_charege

	,0 as con_aduser_charege_a
	,0 as con_aduser_charege_b
	,0 as con_notaduser_charege_a
	,0 as con_notaduser_charege_b

	,count(DISTINCT case when shopitem='0' and con_itemcount_01>0 then userid end) as con_user_charege_a_01
	,count(DISTINCT case when shopitem in ('800','810','830','840')  and con_itemcount_01>0 then userid end) as con_user_charege_b_01
	,0 as con_aduser_charege_01
	,0 as con_notaduser_charege_01

	,0 as con_aduser_charege_a_01
	,0 as con_aduser_charege_b_01
	,0 as con_notaduser_charege_a_01
	,0 as con_notaduser_charege_b_01

	,count(DISTINCT case when shopitem='0' and con_itemcount_07>0 then userid end) as con_user_charege_a_07
	,count(DISTINCT case when shopitem in ('800','810','830','840')  and con_itemcount_07>0 then userid end) as con_user_charege_b_07
	,0 as con_aduser_charege_07
	,0 as con_notaduser_charege_07

	,0 as con_aduser_charege_a_07
	,0 as con_aduser_charege_b_07
	,0 as con_notaduser_charege_a_07
	,0 as con_notaduser_charege_b_07

	,count(DISTINCT case when shopitem='0' and con_itemcount_15>0 then userid end) as con_user_charege_a_15
	,count(DISTINCT case when shopitem in ('800','810','830','840')  and con_itemcount_15>0 then userid end) as con_user_charege_b_15
	,0 as con_aduser_charege_15
	,0 as con_notaduser_charege_15

	,0 as con_aduser_charege_a_15
	,0 as con_aduser_charege_b_15
	,0 as con_notaduser_charege_a_15
	,0 as con_notaduser_charege_b_15

	,sum(con_itemcount) as con_itemcount
	,sum(case when shopitem='0' then con_itemcount end) as con_itemcount_a
	,sum(case when shopitem in ('800','810','830','840') then con_itemcount end) as con_itemcount_b
	,0 as con_itemcount_ad
	,0 as con_itemcount_notad

	,0 as con_itemcount_ad_a
	,0 as con_itemcount_ad_b
	,0 as con_itemcount_notad_a
	,0 as con_itemcount_notad_b

	,sum(case when shopitem='0' and con_itemcount_01>0 then con_itemcount end) as con_itemcount_a_01
	,sum(case when shopitem in ('800','810','830','840') and con_itemcount_01>0 then con_itemcount end) as con_itemcount_b_01
	,0 as con_itemcount_ad_01
	,0 as con_itemcount_notad_01

	,0 as con_itemcount_ad_a_01
	,0 as con_itemcount_ad_b_01
	,0 as con_itemcount_notad_a_01
	,0 as con_itemcount_notad_b_01

	,sum(case when shopitem='0' and con_itemcount_07>0 then con_itemcount end) as con_itemcount_a_07
	,sum(case when shopitem in ('800','810','830','840') and con_itemcount_07>0 then con_itemcount end) as con_itemcount_b_07
	,0 as con_itemcount_ad_07
	,0 as con_itemcount_notad_07

	,0 as con_itemcount_ad_a_07
	,0 as con_itemcount_ad_b_07
	,0 as con_itemcount_notad_a_07
	,0 as con_itemcount_notad_b_07

	,sum(case when shopitem='0' and con_itemcount_15>0 then con_itemcount end) as con_itemcount_a_15
	,sum(case when shopitem in ('800','810','830','840') and con_itemcount_15>0 then con_itemcount end) as con_itemcount_b_15
	,0 as con_itemcount_ad_15
	,0 as con_itemcount_notad_15

	,0 as con_itemcount_ad_a_15
	,0 as con_itemcount_ad_b_15
	,0 as con_itemcount_notad_a_15
	,0 as con_itemcount_notad_b_15

	,sum(sum_itemcount) as sum_itemcount
	,sum(case when shopitem='0' then sum_itemcount end) as sum_itemcount_a
	,sum(case when shopitem in ('800','810','830','840') then sum_itemcount end) as sum_itemcount_b
	,0 as sum_itemcount_ad
	,0 as sum_itemcount_notad

	,0 as sum_itemcount_ad_a
	,0 as sum_itemcount_ad_b
	,0 as sum_itemcount_notad_a
	,0 as sum_itemcount_notad_b

	,sum(case when shopitem='0' and sum_itemcount_01>0 then sum_itemcount end) as sum_itemcount_a_01
	,sum(case when shopitem in ('800','810','830','840') and sum_itemcount_01>0 then sum_itemcount end) as sum_itemcount_b_01
	,0 as sum_itemcount_ad_01
	,0 as sum_itemcount_notad_01

	,0 as sum_itemcount_ad_a_01
	,0 as sum_itemcount_ad_b_01
	,0 as sum_itemcount_notad_a_01
	,0 as sum_itemcount_notad_b_01

	,sum(case when shopitem='0' and sum_itemcount_07>0 then sum_itemcount end) as sum_itemcount_a_07
	,sum(case when shopitem in ('800','810','830','840') and sum_itemcount_07>0 then sum_itemcount end) as sum_itemcount_b_07
	,0 as sum_itemcount_ad_07
	,0 as sum_itemcount_notad_07

	,0 as sum_itemcount_ad_a_07
	,0 as sum_itemcount_ad_b_07
	,0 as sum_itemcount_notad_a_07
	,0 as sum_itemcount_notad_b_07

	,sum(case when shopitem='0' and sum_itemcount_15>0 then sum_itemcount end) as sum_itemcount_a_15
	,sum(case when shopitem in ('800','810','830','840') and sum_itemcount_15>0 then sum_itemcount end) as sum_itemcount_b_15
	,0 as sum_itemcount_ad_15
	,0 as sum_itemcount_notad_15

	,0 as sum_itemcount_ad_a_15
	,0 as sum_itemcount_ad_b_15
	,0 as sum_itemcount_notad_a_15
	,0 as sum_itemcount_notad_b_15
     ,now() as etl_time

	from trade_book
 group by 1,2;
