----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_consume_top6_book_mi
-- workflow_version : 3
-- create_user      : hufengju
-- task_name        : ads_sr_consume_top6_book_mi
-- task_version     : 1
-- update_time      : 2025-05-09 17:42:41
-- sql_path         : \starrocks\tbl_ads_sr_consume_top6_book_mi\ads_sr_consume_top6_book_mi
----------------------------------------------------------------
-- SQL语句
insert into ads.`ads_sr_consume_top6_book_mi`
with tag as (
	select * from(
		select a.* ,b.BookName,b.LangId,b.ImgSrc,b.Introduce,b.IsPutaway,
			row_number() over(partition by dt order by coin_amount desc) as rn
		from (
			select
				date_format('${dt}','%Y-%m-01') as dt,book_code,book_id,sum(coin_amount) as coin_amount,
				row_number() over(partition by book_code order by sum(coin_amount) desc) as rn1
			from ads.ads_bi_book_coin_consume_stat
			where date_format(dt,'%Y%m')=date_format(date_sub('${dt}',interval 1 month),'%Y%m')
			group by 1,2,3
		) a
		left join (
			select BookId,LangId,BookName,ImgSrc,Introduce,IsPutaway
			from ods.ods_tidb_readernovel_tidb_tag_center_book
			qualify row_number() over(partition by BookId order by LangId) =1
		) b on a.book_id = b.BookId
		where b.IsPutaway=1 and rn1=1
	) a
	where rn<=20
)
,
book as (
  select  (b.book_id*1000+b.site_id) as book_id,book_name,b.create_time as sign_time,book_code,cover_src,summary
                 from
                      (   select book_id,book_name,site_id,create_time,book_code,cover_src,summary
                          from dim.dim_edit_book_view
                          where product_id = 3311 and  `language`=1
                      ) b
                 union all
                 select  b.book_id,book_name,b.signtime as sign_time,book_code,cover_src,summary
                 from  dim.dim_zhangzhong_xzz_book_view b
                 where  b.book_id is not null
) ,
read_num as (
	select book_id,count(distinct user_id) as view_count
	from dws.dws_read_user_book_readtime_ed
	where date_format(dt,'%Y%m')=date_format(date_sub('${dt}',interval 1 month),'%Y%m')
	group by 1
)
select
	tag.dt,
	tag.rn as sort_num,
	tag.book_id,
	book.book_id as book_id_cn,
	coalesce(book.book_name,tag.BookName) as book_name,
	coalesce(book.cover_src,tag.ImgSrc) as cover_src,
	coalesce(book.summary,tag.Introduce) as summary,
	tag.book_code,
	tag.coin_amount,
	view_count as view_count,
	now() as etl_tm
from tag
left join book on tag.book_code=book.book_code
left join read_num on tag.book_id = read_num.book_id
where tag.rn<=6;
