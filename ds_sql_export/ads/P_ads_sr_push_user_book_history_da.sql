----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_push_user_book_history_da
-- workflow_version : 4
-- create_user      : hufengju
-- task_name        : ads_sr_push_user_book_history_da
-- task_version     : 1
-- update_time      : 2025-02-08 17:49:45
-- sql_path         : \starrocks\tbl_ads_sr_push_user_book_history_da\ads_sr_push_user_book_history_da
----------------------------------------------------------------
-- SQL语句
insert into ads.`ads_sr_push_user_book_history_da`
select a.*
from (
	select product_id,user_id,max(buy_book) as buy_book,max(bookshelf_book) as bookshelf_book,now() as etl_tm
	from
	(
		select product_id,user_id,group_concat(book_id order by book_id) as buy_book,null as bookshelf_book
		from (
			select Productid as product_id,UserId as user_id,BookId as book_id
			from ods.ods_tidb_readernovel_tidb_xx_userbuybookhistory
			--where UserId =114700163
			group by 1,2,3
		) a
		group by 1,2

		union all

		select product_id,user_id,null as buy_book,group_concat(book_id order by book_id) as bookshelf_book
		from (
			select Productid as product_id,UserId as user_id,BookId as book_id
			from ods.ods_tidb_readernovel_tidb_bookshelftouser
			--where UserId =114700163
			group by 1,2,3
		) a
		group by 1,2
	) a
	group by 1,2
) a
left join ads.`ads_sr_push_user_book_history_da` b on a.product_id=b.product_id and a.user_id=b.user_id
where b.user_id is null or a.buy_book<>b.buy_book or a.bookshelf_book<>b.bookshelf_book;
