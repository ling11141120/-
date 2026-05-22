----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dim_language_book_promotion_info_snap
-- workflow_version : 1
-- create_user      : zhengtt
-- task_name        : dim_language_book_promotion_info_snap
-- task_version     : 1
-- update_time      : 2023-10-11 13:35:46
-- sql_path         : \starrocks\tbl_dim_language_book_promotion_info_snap\dim_language_book_promotion_info_snap
----------------------------------------------------------------
-- SQL语句
insert into dim.dim_language_book_promotion_info_snap
select 	'${bf_1_dt}' as dt,
		a.tolanguage as site_id,
		a.tobookid as book_id,
		a.cnbookname as cname,
		a.frombookname as from_book_name,
		a.tobookname  as to_book_name,
		a.ObjectBookType as object_book_type,
		a.IsCostRate as is_cost_rate,
		(case when c.promotion is null then 3
		else c.promotion end ) as Promotion_tp		,now() as etl_time
from
(
	select a.tobookid,a.ToBookName,a.FromBookId,a.FromBookName,a.ToLanguage,a.cnbookname,a.ObjectBookType,a.IsCostRate,a.UpdateTime
	from

	(
			select tobookid*1000+tolanguage as tobookid,ToBookName,FromBookId,FromBookName,ToLanguage,cnbookname,ObjectBookType,IsCostRate,max(UpdateTime) as UpdateTime
			from ods.ods_edit_book_LanguageBookTotal
			where (case when FromBookId in (92641090,168177,104925090)  then ToLanguage != 375 else 1 = 1 end) and date(StatisticsDate) < '${dt}'
			group by 1,2,3,4,5,6,7,8
	)a
	inner join
	(
			select tobookid*1000+tolanguage as tobookid,max(UpdateTime) as UpdateTime
			from ods.ods_edit_book_LanguageBookTotal
			where (case when FromBookId in (92641090,168177,104925090)  then ToLanguage != 375 else 1 = 1 end) and date(StatisticsDate) < '${dt}'
			group by 1
	)b
	on a.tobookid=b.tobookid and a.UpdateTime=b.UpdateTime
)a
left join
(

	select a.CreateTime as CreateTime,(case when a.cost<=1500 then 2
	when a.cost>1500 then 1 end) as promotion,a.bookid as bookid,a.cost as cost
	from (
		select date(it.CreateTime) as CreateTime,ad.bookid as BookId,sum(it.CostAmount) as Cost
		from ods.ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer it
		left join ods.ods_tidb_sharpengine_ads_global_adext ad on it.AdId = ad.AdId
		where it.CreateTime>= '${bf_1_dt}'
		and it.CreateTime< '${dt}'
		group by 1,2
		order by 1,2
	)a
)c
on  a.tobookid = c.bookid;
