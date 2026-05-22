----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_tag_user_book_csum_p_a
-- workflow_version : 6
-- create_user      : yanxh
-- task_name        : ads_tag_user_book_csum_p_a
-- task_version     : 5
-- update_time      : 2024-10-16 11:10:24
-- sql_path         : \starrocks\tbl_ads_tag_user_book_csum_p_a\ads_tag_user_book_csum_p_a
----------------------------------------------------------------
-- SQL语句
-- ----任务调度脚本-----------------------
 -- ---------昨天至今天的数据---------
 insert into  ads.`ads_tag_user_book_csum_p_a`
 with tp_amt as (
	select product_id,user_id,book_id,types,
	sum(amount)  amount
	from dws.dws_consume_user_consume_ed
	where dt>='${bf_1_dt}' and  dt<='${dt}'
	and types in (1,2)
	-- and user_id=112959831
	and product_id not in (0,7777,8888)
	and book_id >0
	and user_id >0
	group by 1,2,3 ,4
 )
 select  a.dt,a.product_id,a.user_id,a.book_id,  a.csum_tp ,a.csum_amt,a.etl_tm from
 (
	 select   '${dt}' as dt,product_id,user_id,book_id,  csum_tp ,sum(amount)  as csum_amt,now() as etl_tm
	 from (
		 -- --------昨天至今天 获取用户消耗阅币和礼券最多的书-------------------------------
		 select product_id,user_id,book_id, 1 as csum_tp , sum(amount) as amount
		 from  tp_amt
		 where types in (1,2)
		 group by  1,2,3

		  union all
		 -- ----------获取用户消耗阅币最多的书-------------------------------
		 select product_id,user_id,book_id, 2 as csum_tp , sum(amount) as amount
		 from  tp_amt
		 where types in (1)
		 group by  1,2,3

		 union all
		 select product_id,user_id,book_id,csum_tp,csum_amt from   ads.ads_tag_user_book_csum_p_a
		 where dt='${bf_1_dt}'
	 )  a
	 group by 1,2,3 ,4,5
 ) a
 left join  ads.ads_tag_user_book_csum_p_a b  on  a.dt=b.dt and a.product_id=b.product_id and  a.user_id=b.user_id  and a.book_id=b.book_id  and  a.csum_tp=b.csum_tp  and a.csum_amt =b.csum_amt  and b.dt='${dt}'
 where b.dt is  null
 ;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_tag_user_book_csum_p_a
-- workflow_version : 6
-- create_user      : yanxh
-- task_name        : ads_tag_user_book_csum_p_a_yesterday
-- task_version     : 5
-- update_time      : 2025-01-27 11:14:35
-- sql_path         : \starrocks\tbl_ads_tag_user_book_csum_p_a\ads_tag_user_book_csum_p_a_yesterday
----------------------------------------------------------------
-- SQL语句
-- ----任务调度脚本-----------------------
   -- ---------截止前天的累计数据，存放昨日区间---------
  insert into  ads.`ads_tag_user_book_csum_p_a`
with tp_amt_yesterday as (
	select product_id,user_id,book_id,types,
	sum(amount)  amount
	from dws.dws_consume_user_consume_ed
	where dt='${bf_2_dt}'
	and types in (1,2)
	-- and user_id=112959831
	and product_id not in (0,7777,8888)
	and book_id >0
	and user_id >0
	group by 1,2,3 ,4
 )
 select   '${bf_1_dt}' as dt,product_id,user_id,book_id,  csum_tp ,sum(amount)  as csum_amt,now() as etl_tm
 from (
	 -- --------昨天至今天 获取用户消耗阅币和礼券最多的书-------------------------------
	 select product_id,user_id,book_id, 1 as csum_tp , sum(amount) as amount
	 from  tp_amt_yesterday
	 where types in (1,2)
	 group by  1,2,3

	  union all
	 -- ----------获取用户消耗阅币最多的书-------------------------------
	 select product_id,user_id,book_id, 2 as csum_tp , sum(amount) as amount
	 from  tp_amt_yesterday
	 where types in (1)
	 group by  1,2,3

	 union all
	 select product_id,user_id,book_id,csum_tp,csum_amt from  ads.`ads_tag_user_book_csum_p_a`
	 where dt='${bf_2_dt}'
 )  a
 group by 1,2,3 ,4,5
 ;
