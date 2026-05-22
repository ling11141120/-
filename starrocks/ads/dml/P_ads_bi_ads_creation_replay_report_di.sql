----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_ads_creation_replay_report_di
-- workflow_version : 3
-- create_user      : hufengju
-- task_name        : ads_bi_ads_creation_replay_report_di
-- task_version     : 3
-- update_time      : 2025-01-22 19:56:47
-- sql_path         : \starrocks\tbl_ads_bi_ads_creation_replay_report_di\ads_bi_ads_creation_replay_report_di
----------------------------------------------------------------
-- 前置SQL语句
delete from `ads`.`ads_bi_ads_creation_replay_report_di` where dt>='${bf_1_dt}';

-- SQL语句
insert into `ads`.`ads_bi_ads_creation_replay_report_di`
with t1 as (
	select
		t.date_key as dt,
		t.project_code as product_type ,
		t.current_language,
		t.source_chl,
		t.priority_type,
		t.ad_priority,
		CONCAT(HOUR(date_add(t.create_time,interval t.account_tz hour)),':',floor(MINUTE(date_add(t.create_time,interval t.account_tz hour))/30)*30) AS publish_time,
		count(distinct b.ad_set_id) as ad_set_count,
		sum(a.cost_amount) as cost_amount,
		sum(a.day0_amount)/sum(a.cost_amount * ifnull(ifnull(c.r0_std, d.r0_std), 0)) as d0_reach_rate,
		now() as etl_tm
	from dwd.dwd_ads_arrange_task_log_view t
	left join  dwd.dwd_ad_fb_ad_roi_install_referrer_timezone_di_view a on t.object_id = a.ad_set_id and t.date_key = a.create_time
	left join dwd.dwd_advertisement_adext_view b on a.product_id = b.product_id and a.ad_id = b.ad_id
	left join dwd.dwd_advertisement_book_roi_stdcfg_daily_view c on c.book_id = b.book_id and c.mt = b.mt and c.date_key = a.create_time
	left join dwd.dwd_advertisement_put_product_stdcfg_daily_view d on d.current_language2 = b.current_language2 and d.mt = b.mt and d.book_channel = (case when b.book_channel not in (0, 1) then 1 else b.book_channel end) and d.date_key =a.create_time
	where t.date_key  >= '${bf_1_dt}' and t.project_code=1
	and a.source_chl  in ('facebook', 'fbs2s', 'tt', 'tiktok app')
	group by 1,2,3,4,5,6,7

	union all

	select
		t.date_key as dt,
		t.project_code as product_type ,
		t.current_language,
		t.source_chl,
		t.priority_type,
		t.ad_priority,
		CONCAT(HOUR(date_add(t.create_time,interval t.account_tz hour)),':',floor(MINUTE(date_add(t.create_time,interval t.account_tz hour))/30)*30) AS publish_time,
		count(distinct b.ad_set_id) as ad_set_count,
		sum(a.cost_amount) as cost_amount,
		sum(a.day0_amount)/sum(a.cost_amount * ifnull(ifnull(c.r0_std, d.r0_std), 0)) as d0_reach_rate,
		now() as etl_tm
	from dwd.dwd_ads_arrange_task_log_view t
	left join  dwd.dwd_ad_fb_ad_roi_install_referrer_timezone_di_view a on t.object_id = a.ad_set_id and t.date_key = a.create_time
	left join dwd.dwd_advertisement_adext_view b on a.product_id = b.product_id and a.ad_id = b.ad_id
	left join dim.dim_sv_videoroistdcfgdaily_view c on c.video_id = b.book_id and c.mt = b.mt and c.date_key = a.create_time
	left join dwd.dwd_sv_ad_put_product_video_roi_stdCfg_daily_view d on d.current_language2 = b.current_language2 and d.mt = b.mt and d.date_key =a.create_time  and  d.source_chl = a.source_chl and d.date_key =a.create_time
	where t.date_key  >= '${bf_1_dt}' and t.project_code=2
	and a.source_chl  in ('facebook', 'fbs2s', 'tt', 'tiktok app')
	group by 1,2,3,4,5,6,7
)
select
	dt,
	case product_type when 1 then '海阅' when 2 then '海剧' END AS product_type,
	case current_language
		when  1 then '简体'
		when  2 then '繁体'
		when  3 then '英语'
		when  4 then '西语'
		when  5 then '葡语'
		when  6 then '法语'
		when  7 then '俄语'
		when  8 then '意大利语'
		when  9 then '日语'
		when  10 then '阿拉伯语'
		when  11 then '印尼语'
		when  12 then '泰语'
		when  13 then '越南语'
		when  14 then '韩语'
		when  15 then '菲律宾语'
		when  16 then '德语'
		else '其他'
	end as current_language,
	source_chl,
	case priority_type
		when  -1 then 'A'
		when  -2 then 'B'
		when  -3 then 'C'
		when  -4 then 'D'
		when  -5 then 'E'
		when  -6 then 'F'
		when  -7 then 'G'
		when  -8 then 'H'
		when  -9 then 'I'
		else priority_type
	end as priority_type,
	ad_priority,
	publish_time,
	ad_set_count,
	cost_amount,
	d0_reach_rate,
	etl_tm
from t1;
