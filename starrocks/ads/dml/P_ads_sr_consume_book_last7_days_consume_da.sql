----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_consume_book_last7_days_consume_da
-- workflow_version : 3
-- create_user      : hufengju
-- task_name        : ads_sr_consume_book_last7_days_consume_da
-- task_version     : 1
-- update_time      : 2024-12-11 17:12:26
-- sql_path         : \starrocks\tbl_ads_sr_consume_book_last7_days_consume_da\ads_sr_consume_book_last7_days_consume_da
----------------------------------------------------------------
-- SQL语句
--=============海阅：书籍近7天阅币消耗累计汇总表 ====================================
insert into ads.`ads_sr_consume_book_last7_days_consume_da`
select '${dt}' as dt,book_id,ifnull(b.language,-99) as language,sum(consume_td) as consume_td,now() as etl_tm
from (
	select product_id,book_id,sum(amount) as consume_td
	from dws.dws_consume_user_consume_ed
	where dt>='${bf_6_dt}' and dt<'${dt}'
	and types=1
	group by dt,product_id,book_id

	union all

	select product_id,book_id,sum(amount) as consume_td
	from dwd.dwd_sr_user_consume_info_view
	where dt='${dt}'
	group by dt,product_id,book_id
) a
left join
(
	select Productid  as product_id,langid as language
	from dim.DIM_ProductType
	where langid >0
) b on a.product_id = b.product_id
where a.book_id>0 and b.language is not null
group by 1,2,3;
