----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_translate_book_data_da
-- workflow_version : 2
-- create_user      : hufengju
-- task_name        : ads_sr_translate_book_data_da
-- task_version     : 2
-- update_time      : 2025-06-19 15:33:42
-- sql_path         : \starrocks\tbl_ads_sr_translate_book_data_da\ads_sr_translate_book_data_da
----------------------------------------------------------------
-- SQL语句
insert into ads.`ads_sr_translate_book_data_da`
	SELECT
	a.dt	-- 日期
	,a.target_book_id as book_id	-- 目标书ID
	,a.book_language_id  -- 语言id
	,a.income_last_7d_30d	-- 7天折30天收入  -- 7天折30天收入
	,a.chapters_l20_publish_l7d --`最新20章-D7收入发布时间`   -- 最新20章-D7收入发布时间
	,b.plevel
	,now() as etl_time
	from ads.ads_content_translate_remuneration_plan_p_da a
	left join   ads.ads_content_book_plevel_capacity_p_da b on a.target_book_id = b.book_id and a.dt=b.dt
	where a.dt = '${bf_1_dt}'
	  and not  starts_with(a.book_code, 'X')
	  and (income_last_7d_30d is not null or chapters_l20_publish_l7d is not null or plevel is not null)
	;
