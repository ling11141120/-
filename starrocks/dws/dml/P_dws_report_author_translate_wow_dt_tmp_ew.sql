----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_report_author_translate_wow_dt_tmp_ew
-- workflow_version : 6
-- create_user      : zhugl
-- task_name        : dws_report_author_translate_wow_dt_tmp_ew
-- task_version     : 5
-- update_time      : 2024-03-07 14:59:10
-- sql_path         : \starrocks\tbl_dws_report_author_translate_wow_dt_tmp_ew\dws_report_author_translate_wow_dt_tmp_ew
----------------------------------------------------------------
-- SQL语句
insert overwrite dws.dws_report_author_translate_wow_dt_tmp_ew
select
	To_Language,
	week_id,
	max(FontLength_before_cnt)over(partition by To_Language order by FontLength_before_cnt rows between unbounded preceding and unbounded following ) font_length_before_cnt,
	max(FontLength_now_cnt)over(partition by To_Language order by FontLength_now_cnt rows between unbounded preceding and unbounded following ) font_length_now_cnt,
	Font_Length_year_cnt,
	before_4week_flag,
    now() as etl_time
from
	(
	select
		To_Language,
		CASE
			WHEN weekOFYEAR(days_sub(a.dt ,-4)) = 1 AND MONTH(days_sub(a.dt ,-4)) = 12 THEN YEAR(days_sub(a.dt ,-4)) + 1
			WHEN weekOFYEAR(days_sub(a.dt ,-4)) in(52, 53) AND MONTH(days_sub(a.dt ,-4)) = 1 THEN YEAR(days_sub(a.dt ,-4)) - 1
			ELSE YEAR(days_sub(a.dt ,-4)) END * 100 + weekOFYEAR(days_sub(a.dt ,-4)) AS week_id,
		sum(IF(date(a.dt) >= before_week_start and date(a.dt) <= before_week_end , Font_Length, 0)) FontLength_before_cnt,
		sum(IF(date(a.dt) >= now_week_start and date(a.dt) <= date(DATE_SUB('${dt}', INTERVAL 1 DAY )) , Font_Length, 0)) FontLength_now_cnt,
		sum(Font_Length)Font_Length_year_cnt,
		if(date(a.dt)>= before_4week, 'Y', 'N') before_4week_flag
	FROM
		dwd.dwd_trade_author_translate_remuneration a
	join (
		select
			date(days_sub(datestr,7)) before_week_end ,
			date(days_sub(datestr,7 + pmod(weekid + 3,7))) before_week_start,
			date(days_sub(datestr,pmod(weekid + 3,7))) now_week_start,
			date(DATE_SUB('${dt}', INTERVAL 1 DAY )) before_date,
			date(days_sub(datestr, 21 + pmod(weekid + 3, 7))) before_4week
		from
			dim.dim_date
		where
			datestr = date(DATE_SUB('${dt}', INTERVAL 1 DAY )) ) c on date(a.dt) <= date(DATE_SUB('${dt}', INTERVAL 1 DAY ))
	where
		(date(a.dt) >= before_4week or year(a.dt)= year(DATE_SUB('${dt}', INTERVAL 1 DAY )) and  	book_id > 0)
	and remuneration_type = 1
	and Role_Type = 3
	and st NOT in (3, 5, 7)
	group by 1, 2, 6)a
order by
	To_Language,
	week_id,
	FontLength_before_cnt;
