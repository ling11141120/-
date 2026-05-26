----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_ad_read_toufang_tag_da
-- workflow_version : 11
-- create_user      : hufengju
-- task_name        : ads_sr_ad_read_toufang_tag_da
-- task_version     : 10
-- update_time      : 2025-01-03 15:12:31
-- sql_path         : \starrocks\tbl_ads_sr_ad_read_toufang_tag_da\ads_sr_ad_read_toufang_tag_da
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_sr_ad_read_toufang_tag_da where book_id>0;

-- SQL语句
--===============调度：海阅tag人群包标签【最新引流书籍】======================
insert into `ads`.`ads_sr_ad_read_toufang_tag_da`
with t1 as (
	select a.date_start as dt,a.ProductId as product_id,a.adid as ad_id,b.book_id
	from (
		select adid,date_start,ProductId
		from (
				select adid,date_start,ProductId
				from dim.dim_FbAdDailyInsight_view
				where date_start >='${bf_7_dt}'
				and ProductId <> 6833
			union all
				select adid,date_start,ProductId
				from dim.dim_LtvDailyInsight_view
				where date_start >='${bf_7_dt}'
				and ProductId <> 6833
			) t
			group by 1,2,3
	) a
	left join  ads.ads_advertisement_adext_view  b on a.adid=b.ad_id  and b.product_id  not in (6833,6883)
	where b.book_id  is  not  null
	group by 1,2,3,4
)
select
	product_id,
	book_id,
	Day0Amount  as day0_amount,
    now() as etl_tm
from (
	select dt,product_id,book_id,Day0Amount ,
	row_number() over(partition by product_id,book_id order by dt  ) as rn
	from (
		select t1.dt,t1.product_id,t1.book_id ,sum(t2.Day0Amount) as Day0Amount
		from t1
		left join
		(
			select  CreateTime,substr(AdId,1,18)   as ad_id,Day0Amount
			from ods.ods_tidb_sharpengine_ads_global_FbAdRoiInstallReferrerTimeZone_di
			where ProductId <> 6833
			and CreateTime >='${bf_7_dt}'
			and Day0Amount>0
		) t2 on t1.ad_id=t2.ad_id and t1.dt = t2.CreateTime
		group by 1,2,3
	) a
) b
where rn=1;
