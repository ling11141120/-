----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_book_url_cost_total_history_da
-- workflow_version : 5
-- create_user      : hufengju
-- task_name        : ads_sr_book_url_cost_total_history_da
-- task_version     : 3
-- update_time      : 2025-02-17 11:24:25
-- sql_path         : \starrocks\tbl_ads_sr_book_url_cost_total_history_da\ads_sr_book_url_cost_total_history_da
----------------------------------------------------------------
-- SQL语句
insert into ads.`ads_sr_book_url_cost_total_history_da`
select date(date_sub(now(),interval 13 hour)) as dt,product_id,source,book_id,page_id,url,cost_amount,now() as etl_tm
from (
	select
		product_id,source,book_id,page_id,url,cost_amount,
		row_number() over(partition by product_id,source,book_id order by cost_amount desc ) rn
	from (
		select product_id,source,book_id,pageid as page_id,url,sum(cost_amount) as cost_amount
		from ads.`ads_sr_book_url_cost_info_di`
		group by 1,2,3,4,5
	) a
) a where rn=1
;
