----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_author_translate
-- workflow_version : 6
-- create_user      : zhugl
-- task_name        : tbl_ads_report_author_translate
-- task_version     : 6
-- update_time      : 2023-12-06 14:10:19
-- sql_path         : \starrocks\tbl_ads_report_author_translate\tbl_ads_report_author_translate
----------------------------------------------------------------
-- SQL语句
insert into  ads.ads_report_author_translate
select
	date(DATE_SUB('${dt}' , INTERVAL 1 DAY )) dt,
	a.to_language,
	b.week_id,
	if(c.GradeType is null, -1 , c.GradeType) grade_type,
	if(c.CapacityTarget is null, 0 ,CapacityTarget) capacity_target,
	cast(font_length_sum / 10000.0 as decimal(10, 4)) font_length_sum,
	cast(font_length_sum / 10000.0 / c.CapacityTarget as decimal(10, 4))Capacity_Target_rate ,
	cast(font_length_sum / 10000.0 / c.CapacityTarget / workday_month_rate as decimal(10, 4)) spi_rate,
	Font_Length_year_cnt,
	Font_Length_before_cnt,
	Font_Length_now_cnt,
	cast((Font_Length_now_cnt-Font_Length_before_cnt)/ Font_Length_before_cnt as decimal(10, 4)) wow_rate,
	before_4week_flag,
    now()
FROM
	(
	select
		to_language,
		year_month_id ,
		sum(font_length_sum) font_length_sum,
		max(workday_month_pass)/ max(workday_month) workday_month_rate
	from
		dws.dws_trade_author_translate_remuneration_ew a
	where
		year_month_id = (year(DATE_SUB('${dt}', INTERVAL 1 day ))* 100 + month(DATE_SUB('${dt}', INTERVAL 1 day )))
	group by 1, 2) a
left join dws.dws_report_author_translate_wow_dt_tmp_ew b on
	a.to_language = b.to_language
left join (
	select
		*
	from
		ods.ods_tidb_shuangwen_en_viscgradeconfig
	where
		CreateTime >= DATE_SUB('${dt}', INTERVAL 2 MONTH )) c
on
	a.To_Language = c.SiteId and year_month_id = year(c.MonthTime)* 100 + month(c.MonthTime);

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_author_translate
-- workflow_version : 6
-- create_user      : zhugl
-- task_name        : tbl_ads_report_author_translate_1
-- task_version     : 1
-- update_time      : 2023-12-06 14:10:19
-- sql_path         : \starrocks\tbl_ads_report_author_translate\tbl_ads_report_author_translate_1
----------------------------------------------------------------
-- SQL语句
insert  into ads.ads_report_author_translate
select
b.dt,
b.to_language,
b.week_id,
b.grade_type,
b.capacity_target,
a.font_length_sum,
b.Capacity_Target_rate,
b.spi_rate,
b.font_length_year_cnt,
b.font_length_before_cnt,
b.font_length_now_cnt,
b.wow_rate,
b.before_4week_flag,
b.now() from
(	select
		to_language,
		year_month_id ,
		sum(font_length_sum/10000) font_length_sum,
		max(workday_month_pass)/ max(workday_month) workday_month_rate
	from
		dws.dws_trade_author_translate_remuneration_ew a
	where
		year_month_id = (year(DATE_SUB(DATE_SUB(CURDATE(),interval  day(CURDATE()) day), INTERVAL 1 day ))* 100 + month(DATE_SUB(DATE_SUB(CURDATE(),interval  day(CURDATE()) day), INTERVAL 1 day )))
	group by 1, 2)a
join 	ads.ads_report_author_translate b
on b.dt=DATE_SUB(CURDATE(),interval  day(CURDATE()) day) and
a.to_language= b.to_language ;
