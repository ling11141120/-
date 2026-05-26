----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_trade_author_translate_remuneration_ew
-- workflow_version : 4
-- create_user      : zhugl
-- task_name        : tbl_dws_trade_author_translate_remuneration_ew
-- task_version     : 4
-- update_time      : 2024-04-11 17:08:55
-- sql_path         : \starrocks\tbl_dws_trade_author_translate_remuneration_ew\tbl_dws_trade_author_translate_remuneration_ew
----------------------------------------------------------------
-- SQL语句
insert overwrite dws.dws_trade_author_translate_remuneration_ew
select
	dt,
	to_language,
	book_id,
	CASE
		WHEN weekOFYEAR(days_sub(a.dt ,-4)) = 1 AND MONTH(days_sub(a.dt ,-4)) = 12 THEN YEAR(days_sub(a.dt ,-4)) + 1
		WHEN weekOFYEAR(days_sub(a.dt ,-4)) in(52, 53) AND MONTH(days_sub(a.dt ,-4)) = 1 THEN YEAR(days_sub(a.dt ,-4)) - 1
		ELSE YEAR(days_sub(a.dt ,-4)) END * 100 + weekOFYEAR(days_sub(a.dt ,-4)) AS week_id,
	author_id,
	book_name,
	sum(font_length)font_length_sum,
	sum(total_price)total_price_sum,
	a.year_month_str,
	admin_name,
	max(day_target)day_target,
	max(month_target)month_target,
	author_name,
	workday_month_pass,
	workday_month,
	year_month_id,
    now() as etl_time
from
	dwd.dwd_trade_author_translate_remuneration a
left join
(
	select
		max(month_timespan) workday_month ,
		MAX(DAY('${bf_1_dt}'))  workday_month_pass,
		yearmonthstr,
		cast (yearmonthid as int)year_month_id
	from
		dim.dim_date
	where
		year(datestr) between year('${bf_1_dt}')-1 and year('${bf_1_dt}')
	group BY 3, 4 )b on
	a.year_month_str = b.yearmonthstr
where
	book_id > 0
	and remuneration_type = 1
	and Role_Type = 3
	and st NOT in (3, 5, 7)
	and year(dt) >= year('${bf_1_dt}')-1
group by 1, 2, 3, 4, 5, 6, 9, 10, 13, 14, 15, 16;
