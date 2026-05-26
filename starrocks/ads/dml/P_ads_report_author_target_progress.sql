----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_author_target_progress
-- workflow_version : 1
-- create_user      : zhengtt
-- task_name        : ads_report_author_target_progress
-- task_version     : 1
-- update_time      : 2023-10-10 17:58:59
-- sql_path         : \starrocks\tbl_ads_report_author_target_progress\ads_report_author_target_progress
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_report_author_target_progress
select 	'${bf_1_dt}' as dt,a.SiteId,a.AuthorId,a.RoleType,a.AuthorName,a.DayTarget,a.MonthTarget,b.font_curmonth_reach,
		b.font_curmonth_reach/a.MonthTarget as cur_month_reach,
		a.cur_target,
		b.font_curmonth_reach/a.cur_target as cur_reach_rate,
		a.cur_target-b.font_curmonth_reach as font_diff	 ,now() as etl_time
from
(
	select 	a.SiteId as SiteId,a.WorkDays,a.AuthorId as AuthorId,a.RoleType as RoleType,
			a.AuthorName as AuthorName,a.DayTarget as DayTarget,a.MonthTarget as MonthTarget,
			sum(if(a.entryday <= b.datestr and b.datestr < '${dt}' and b.datestr <= a.departday,1,0))*a.MonthTarget/a.WorkDays as cur_target
	from
	(
		select 	dt,SiteId,WorkDays,AuthorId,RoleType,AuthorName,DayTarget,MonthTarget,
				if(date(EntryTime)  is not null,date(EntryTime),concat(date_format('${bf_1_dt}','%Y-%m'),'-01')) as entryday,
				if(date(DepartTime) is not null,date(DepartTime),date_sub(date_add(concat(date_format('${bf_1_dt}','%Y-%m'),'-01'),interval 1 month),interval 1 day)) as departday
		from  ods.ods_tidb_shuangwen_en_viscauthorconfig
		where date_format(dt,'%Y-%m') = date_format('${bf_1_dt}','%Y-%m')
	) a
	left join
	(
		select datestr,china_workday_flag
		from dim.dim_date
		where   date_format(datestr,'%Y-%m') =  date_format('${bf_1_dt}','%Y-%m') and  china_workday_flag = 'Y'
	) b
	on b.datestr >= a.dt
	group by 1,2,3,4,5,6,7
)a
left join
(
	select 	to_language,author_id,pen_name,role_type,
			sum(font_length) as font_curmonth_reach
	from dwd.dwd_content_translate_remuneration
	where  dt >= date_sub('${dt}',interval dayofmonth('${bf_1_dt}') day) and dt < '${dt}'
	and remuneration_type = 1 and book_id > 0
	group by 1,2,3,4
)b
on a.SiteId = b.to_language and a.AuthorId = b.author_id and a.RoleType = b.role_type;
