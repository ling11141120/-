----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_book_consume_di
-- workflow_version : 5
-- create_user      : hufengju
-- task_name        : ads_sr_book_consume_di
-- task_version     : 2
-- update_time      : 2025-05-20 14:25:09
-- sql_path         : \starrocks\tbl_ads_sr_book_consume_di\ads_sr_book_consume_di
----------------------------------------------------------------
-- SQL语句
insert into ads.`ads_sr_book_consume_di`
select
	a.dt,a.product_id,b.LangId as language_id,a.book_id,a.amount as consume_amount,now() as etl_tm
from (
	select dt,product_id,book_id,sum(amount) as amount
	from dws.dws_consume_user_consume_ed
	where types in (1,2)
	and dt>='${bf_1_dt}'
	group by 1,2,3
) a
left join ods.ods_tidb_readernovel_tidb_tag_center_book  b on a.book_id=b.BookId
where b.BookId is not null;
