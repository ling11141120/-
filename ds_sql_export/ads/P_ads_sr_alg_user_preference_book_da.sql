----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_alg_user_preference_book_da
-- workflow_version : 2
-- create_user      : hufengju
-- task_name        : ads_sr_alg_user_preference_book_da
-- task_version     : 2
-- update_time      : 2025-02-12 15:19:46
-- sql_path         : \starrocks\tbl_ads_sr_alg_user_preference_book_da\ads_sr_alg_user_preference_book_da
----------------------------------------------------------------
-- SQL语句
insert into ads.`ads_sr_alg_user_preference_book_da`
select  product_id,user_id,max(most_read_book) as most_read_book,max(most_consume_book) as most_consume_book,now() as etl_tm
from (
	select product_id ,user_id , most_read_book,null as most_consume_book
	from (
		select product_id ,user_id ,book_id as most_read_book
		from (
			select product_id ,user_id ,book_id ,sum(read_chapter_num) as read_chapter_nums
			from dws.dws_read_user_readbook_ed
			-- where user_id =1936
			group by 1,2,3
		) a QUALIFY ROW_NUMBER() OVER (PARTITION BY product_id,user_id ORDER BY read_chapter_nums desc,book_id desc) =1
	) a
union all
select product_id ,user_id ,null as most_read_book, most_consume_book
	from (
		select product_id ,user_id ,book_id as most_consume_book
		from (
			select product_id ,user_id ,book_id ,sum(amount) as consume_chapter_nums
			from dws.dws_consume_user_consume_ed
			-- where user_id =1936
			group by 1,2,3
		) a QUALIFY ROW_NUMBER() OVER (PARTITION BY product_id,user_id ORDER BY consume_chapter_nums desc,book_id desc) =1
	) b
) a
group by 1,2;
