----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_consume_video_last7_days_consume_da
-- workflow_version : 5
-- create_user      : hufengju
-- task_name        : ads_sv_consume_video_last7_days_consume_da
-- task_version     : 2
-- update_time      : 2024-12-11 17:13:31
-- sql_path         : \starrocks\tbl_ads_sv_consume_video_last7_days_consume_da\ads_sv_consume_video_last7_days_consume_da
----------------------------------------------------------------
-- SQL语句
--=============海剧：海剧近7天代币消耗累计汇总表 ====================================
insert into ads.`ads_sv_consume_video_last7_days_consume_da`
select '${dt}' as dt,a.series_id,ifnull(b.language,-99) as language,sum(a.consume_td) as consume_td,now() as etl_tm
from (
	select series_id,sum(consume_value) as consume_td
	from dwd.dwd_sv_consume_user_consume_bill_pdi
	where dt>='${bf_6_dt}' and dt<'${dt}'
	and consume_type=0
	group by 1

	union all

	select b.series_id,sum(a.consume_value) as consume_td
	from (
	 	select epis_id,consume_value
	    from dwd.dwd_sv_user_consume_info_view
	    where dt='${dt}'
	) a
	left join dim.dim_short_video_epis_view b on a.epis_id=b.epis_id
	group by 1
) a
left join
(
	select series_id ,`language` as language
	from dim.dim_sv_series_hi
	where language >0 and series_id>0
	group by 1,2
) b on a.series_id = b.series_id
where a.series_id>0
group by 1,2,3;
