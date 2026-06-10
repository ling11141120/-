-------------------------------------------------
-- 应用报表：海剧-策略效果报表/海剧广告触达到播放转化报表
-------------------------------------------------

with z1 as (
select
t1.dt,
t4.ad_show_type_name,
case
	when t1.ad_position_id1 in ('7','16','13','17','11','24','26','4','14','5','15','6','25','18','23','27') then concat(t2.ad_position_name,'(合并)')
	when t1.ad_position_id1  = -99 then '未知'
	else t2.ad_position_name
	end as ad_position_name,
count(1) as 广告请求PV,
count(case when request_result ='success' then 1 end) as 广告请求成功PV,
0 as 广告调用PV,
0 as 广告展现成功PV,
0 as 累计展现耗时,
0 as 广告展现失败PV
from (
select
	dt,
	login_id,
	ad_type,
	case
		when ad_position_id1 in ('7','16') then '7'
		when ad_position_id1 in ('13','17') then '13'
		when ad_position_id1 in ('11','24','26') then '11'
		when ad_position_id1 in ('4','14') then '4'
		when ad_position_id1 in ('5','15') then '5'
		when ad_position_id1 in ('6','25') then '6'
		when ad_position_id1 in ('18','23','27') then '18'
		else ad_position_id1
	end as ad_position_id1,
	request_result
from ads.ads_sensors_cd_video_adrequest_view
where
	dt between '${开始时间}' and '${结束时间}'
	---and ad_position_id1 <> 0
	and cast(substring_index(app_version, '.', 1) as unsigned) * 100 + cast(substring_index(substring_index(app_version, '.', 2), '.', -1) as unsigned) * 10 + cast(substring_index(substring_index(app_version, '.', 3), '.', -1) as unsigned) >=162
	${if(len(广告ID) == 0,"","and ad_id in ('" + 广告ID + "')")}
	${if(len(APP版本) == 0,"","and app_version in ('" + APP版本 + "')")}
	${if(len(CORE) == 0,"","and case
		when app_id = 683001001 then '1'
		when app_id = 683002001 then '2'
		when app_id = 683003001 then '3'
		when app_id = 683004001 then '4'
		when app_core_ver=15 then '15'
		end in ('" + CORE + "')")}
	${if(len(终端) == 0,"","and case
		when os in ('Android','HarmonyOS') then 'Android'
		when os ='iOS' then 'iOS'
		end in ('" + 终端 + "')")}
) t1
left join dim.dim_sv_ads_position_view t2
on t1.ad_position_id1 = t2.ad_position
left join (
select
ad_show_type_name ,
ad_show_type
from dim.dim_sv_ads_position_view
group by 1,2
) t4
on t1.ad_type = t4.ad_show_type
left join (
select
	user_id,
	current_language2,
	reg_country
from dws.dws_user_short_video_wide_active_period_ed
where period_type ='ctt' and product_id=6833
group by 1,2,3 )t3
on t1.login_id =t3.user_id
left join dim.dim_dic dic_lang  -- 注册/投放语言
on t3.current_language2 = dic_lang.enum_id
and dic_lang.table_name = 'dim_producttype'
and dic_lang.dic_column = 'language_id'
left join dim.dim_country_dic country
on t3.reg_country=country.code
where
1=1
${if(len(投放语言) == 0,"","and dic_lang.remarks in ('" + 投放语言 + "')")}
${if(len(注册国家) == 0,"","and coalesce(country.country,reg_country) in ('" + 注册国家 + "')")}
${if(len(广告类型) == 0,"","and t4.ad_show_type_name in ('" + 广告类型 + "')")}
${if(len(广告位置) == 0,"","and t2.ad_position_name  in ('" + 广告位置 + "')")}
group by 1,2,3
),
---广告调用
z2 as (
select
t1.dt,
t4.ad_show_type_name,
case
	when t1.ad_position_id1 in ('7','16','13','17','11','24','26','4','14','5','15','6','25','18','23','27') then concat(t2.ad_position_name,'(合并)')
	when t1.ad_position_id1  = -99 then '未知'
	else t2.ad_position_name
	end as ad_position_name ,
0 as 广告请求PV,
0 as 广告请求成功PV,
count(1) as 广告调用PV,
0 as 广告展现成功PV,
0 as 累计展现耗时,
0 as 广告展现失败PV
from (
select
	dt,
	login_id,
	ad_type,
	case
		when ad_position_id1 in ('7','16') then '7'
		when ad_position_id1 in ('13','17') then '13'
		when ad_position_id1 in ('11','24','26') then '11'
		when ad_position_id1 in ('4','14') then '4'
		when ad_position_id1 in ('5','15') then '5'
		when ad_position_id1 in ('6','25') then '6'
		when ad_position_id1 in ('18','23','27') then '18'
		else ad_position_id1
	end as ad_position_id1
from ads.ads_sensors_cd_video_adinvocation_view
where
	dt between '${开始时间}' and '${结束时间}'
	---and ad_position_id1 <> 0
	and cast(substring_index(app_version, '.', 1) as unsigned) * 100 + cast(substring_index(substring_index(app_version, '.', 2), '.', -1) as unsigned) * 10 + cast(substring_index(substring_index(app_version, '.', 3), '.', -1) as unsigned) >=162
	${if(len(广告ID) == 0,"","and ad_id in ('" + 广告ID + "')")}
	${if(len(APP版本) == 0,"","and app_version in ('" + APP版本 + "')")}
	${if(len(CORE) == 0,"","and case
		when app_id = 683001001 then '1'
		when app_id = 683002001 then '2'
		when app_id = 683003001 then '3'
		when app_id = 683004001 then '4'
		when app_core_ver=15 then '15'
		end in ('" + CORE + "')")}
	${if(len(终端) == 0,"","and case
		when os in ('Android','HarmonyOS') then 'Android'
		when os ='iOS' then 'iOS'
		end in ('" + 终端 + "')")}
) t1
left join dim.dim_sv_ads_position_view t2
on t1.ad_position_id1 = t2.ad_position
left join (
select
ad_show_type_name ,
ad_show_type
from dim.dim_sv_ads_position_view
group by 1,2
) t4
on t1.ad_type = t4.ad_show_type
left join (
select
	user_id,
	current_language2,
	reg_country
from dws.dws_user_short_video_wide_active_period_ed
where period_type ='ctt' and product_id=6833
group by 1,2,3 )t3
on t1.login_id =t3.user_id
left join dim.dim_dic dic_lang  -- 注册/投放语言
on t3.current_language2 = dic_lang.enum_id
and dic_lang.table_name = 'dim_producttype'
and dic_lang.dic_column = 'language_id'
left join dim.dim_country_dic country
on t3.reg_country=country.code
where
1=1
${if(len(投放语言) == 0,"","and dic_lang.remarks in ('" + 投放语言 + "')")}
${if(len(注册国家) == 0,"","and coalesce(country.country,reg_country) in ('" + 注册国家 + "')")}
${if(len(广告类型) == 0,"","and t4.ad_show_type_name in ('" + 广告类型 + "')")}
${if(len(广告位置) == 0,"","and t2.ad_position_name  in ('" + 广告位置 + "')")}
group by 1,2,3
),
---广告展示成功
z3 as (
select
t1.dt,
t4.ad_show_type_name,
case
	when t1.ad_position_id1 in ('7','16','13','17','11','24','26','4','14','5','15','6','25','18','23','27') then concat(t2.ad_position_name,'(合并)')
	when t1.ad_position_id1  = -99 then '未知'
	else t2.ad_position_name
	end as ad_position_name,
0 as 广告请求PV,
0 as 广告请求成功PV,
0 as 广告调用PV,
count(1) as 广告展现成功PV,
sum(request_duration) as 累计展现耗时,
0 as 广告展现失败PV
from (
select
	dt,
	login_id,
	ad_type,
	case
		when ad_position_id1 in ('7','16') then '7'
		when ad_position_id1 in ('13','17') then '13'
		when ad_position_id1 in ('11','24','26') then '11'
		when ad_position_id1 in ('4','14') then '4'
		when ad_position_id1 in ('5','15') then '5'
		when ad_position_id1 in ('6','25') then '6'
		when ad_position_id1 in ('18','23','27') then '18'
		else ad_position_id1
	end as ad_position_id1,
	request_duration
from ads.ads_sensors_cd_video_adshow_view
where
	dt between '${开始时间}' and '${结束时间}'
	---and ad_position_id1 <> 0
	and cast(substring_index(app_version, '.', 1) as unsigned) * 100 + cast(substring_index(substring_index(app_version, '.', 2), '.', -1) as unsigned) * 10 + cast(substring_index(substring_index(app_version, '.', 3), '.', -1) as unsigned) >=162
	${if(len(广告ID) == 0,"","and ad_id in ('" + 广告ID + "')")}
	${if(len(APP版本) == 0,"","and app_version in ('" + APP版本 + "')")}
	${if(len(CORE) == 0,"","and case
		when app_id = 683001001 then '1'
		when app_id = 683002001 then '2'
		when app_id = 683003001 then '3'
		when app_id = 683004001 then '4'
		when app_core_ver=15 then '15'
		end in ('" + CORE + "')")}
	${if(len(终端) == 0,"","and case
		when os in ('Android','HarmonyOS') then 'Android'
		when os ='iOS' then 'iOS'
		end in ('" + 终端 + "')")}
) t1
left join dim.dim_sv_ads_position_view t2
on t1.ad_position_id1 = t2.ad_position
left join (
select
ad_show_type_name ,
ad_show_type
from dim.dim_sv_ads_position_view
group by 1,2
) t4
on t1.ad_type = t4.ad_show_type
left join (
select
	user_id,
	current_language2,
	reg_country
from dws.dws_user_short_video_wide_active_period_ed
where period_type ='ctt' and product_id=6833
group by 1,2,3 )t3
on t1.login_id =t3.user_id
left join dim.dim_dic dic_lang  -- 注册/投放语言
on t3.current_language2 = dic_lang.enum_id
and dic_lang.table_name = 'dim_producttype'
and dic_lang.dic_column = 'language_id'
left join dim.dim_country_dic country
on t3.reg_country=country.code
where
1=1
${if(len(投放语言) == 0,"","and dic_lang.remarks in ('" + 投放语言 + "')")}
${if(len(注册国家) == 0,"","and coalesce(country.country,reg_country) in ('" + 注册国家 + "')")}
${if(len(广告类型) == 0,"","and t4.ad_show_type_name in ('" + 广告类型 + "')")}
${if(len(广告位置) == 0,"","and t2.ad_position_name  in ('" + 广告位置 + "')")}
group by 1,2,3
),
----广告展示失败
z4 as (
select
t1.dt,
t4.ad_show_type_name,
case
	when t1.ad_position_id1 in ('7','16','13','17','11','24','26','4','14','5','15','6','25','18','23','27') then concat(t2.ad_position_name,'(合并)')
	when t1.ad_position_id1  = -99 then '未知'
	else t2.ad_position_name
	end as ad_position_name,
0 as 广告请求PV,
0 as 广告请求成功PV,
0 as 广告调用PV,
0 as 广告展现成功PV,
0 as 累计展现耗时,
count(1) as 广告展现失败PV
from (
select
	dt,
	login_id,
	ad_type,
	case
		when ad_position_id1 in ('7','16') then '7'
		when ad_position_id1 in ('13','17') then '13'
		when ad_position_id1 in ('11','24','26') then '11'
		when ad_position_id1 in ('4','14') then '4'
		when ad_position_id1 in ('5','15') then '5'
		when ad_position_id1 in ('6','25') then '6'
		when ad_position_id1 in ('18','23','27') then '18'
		else ad_position_id1
	end as ad_position_id1
from ads.ads_sensors_cd_video_adtrigger_view
where
	dt between '${开始时间}' and '${结束时间}'
	---and ad_position_id1 <> 0
	and cast(substring_index(app_version, '.', 1) as unsigned) * 100 + cast(substring_index(substring_index(app_version, '.', 2), '.', -1) as unsigned) * 10 + cast(substring_index(substring_index(app_version, '.', 3), '.', -1) as unsigned) >=162
	${if(len(广告ID) == 0,"","and ad_id in ('" + 广告ID + "')")}
	${if(len(APP版本) == 0,"","and app_version in ('" + APP版本 + "')")}
	${if(len(CORE) == 0,"","and case
		when app_id = 683001001 then '1'
		when app_id = 683002001 then '2'
		when app_id = 683003001 then '3'
		when app_id = 683004001 then '4'
		when app_core_ver=15 then '15'
		end in ('" + CORE + "')")}
	${if(len(终端) == 0,"","and case
		when os in ('Android','HarmonyOS') then 'Android'
		when os ='iOS' then 'iOS'
		end in ('" + 终端 + "')")}
) t1
left join dim.dim_sv_ads_position_view t2
on t1.ad_position_id1 = t2.ad_position
left join (
select
ad_show_type_name ,
ad_show_type
from dim.dim_sv_ads_position_view
group by 1,2
) t4
on t1.ad_type = t4.ad_show_type
left join (
select
	user_id,
	current_language2,
	reg_country
from dws.dws_user_short_video_wide_active_period_ed
where period_type ='ctt' and product_id=6833
group by 1,2,3 )t3
on t1.login_id =t3.user_id
left join dim.dim_dic dic_lang  -- 注册/投放语言
on t3.current_language2 = dic_lang.enum_id
and dic_lang.table_name = 'dim_producttype'
and dic_lang.dic_column = 'language_id'
left join dim.dim_country_dic country
on t3.reg_country=country.code
where
1=1
${if(len(投放语言) == 0,"","and dic_lang.remarks in ('" + 投放语言 + "')")}
${if(len(注册国家) == 0,"","and coalesce(country.country,reg_country) in ('" + 注册国家 + "')")}
${if(len(广告类型) == 0,"","and t4.ad_show_type_name in ('" + 广告类型 + "')")}
${if(len(广告位置) == 0,"","and t2.ad_position_name  in ('" + 广告位置 + "')")}
group by 1,2,3
)

select
dt as 日期,
ad_show_type_name as 广告类型,
ad_position_name as 广告位置,
广告请求PV,
广告请求成功PV,
广告调用PV,
广告展现成功PV,
累计展现耗时,
广告展现失败PV
from z1
union all
select
dt as 日期,
ad_show_type_name as 广告类型,
ad_position_name as 广告位置,
广告请求PV,
广告请求成功PV,
广告调用PV,
广告展现成功PV,
累计展现耗时,
广告展现失败PV
from z2
union all
select
dt as 日期,
ad_show_type_name as 广告类型,
ad_position_name as 广告位置,
广告请求PV,
广告请求成功PV,
广告调用PV,
广告展现成功PV,
累计展现耗时,
广告展现失败PV
from z3
union all
select
dt as 日期,
ad_show_type_name as 广告类型,
ad_position_name as 广告位置,
广告请求PV,
广告请求成功PV,
广告调用PV,
广告展现成功PV,
累计展现耗时,
广告展现失败PV
from z4