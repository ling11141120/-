----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_sv_recommendation_conversion_funnel
-- workflow_version : 9
-- create_user      : hufengju
-- task_name        : ads_bi_sv_recommendation_conversion_funnel
-- task_version     : 9
-- update_time      : 2026-05-14 19:32:42
-- sql_path         : \starrocks\tbl_ads_bi_sv_recommendation_conversion_funnel\ads_bi_sv_recommendation_conversion_funnel
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_bi_sv_recommendation_conversion_funnel
with dim_shortplay as(
	select
	series_id,
	all_epis,
	round(all_epis*0.2,0) epis_percent_20,
	  round(all_epis*0.5,0) epis_percent_50,
	pay_epis_from-1 free_epis,
	all_epis-pay_epis_from+1 pay_epis
	from dim.dim_short_video_series_view
),
-- 短剧曝光用户
t1 as(
	select
	dt,
	position_type,
	channel_id,
	list_id,
	event_strategy_id,
	programme_id,
	login_id,
	core,
	mt,
	current_language2,
	max(channel_name) channel_name,
	max(list_name) list_name,
	count(login_id) exp_cnt
	from
		(
		select
			dt,
			case
			when split(activity_link, '_')[1]=202100 and split(activity_link, '_')[2] in (0,1) then '普通弹窗'
			when split(activity_link, '_')[1]=202100 and split(activity_link, '_')[2]=3 then '充值返回推'
			when split(activity_link, '_')[1]=202100 and split(activity_link, '_')[2]=4 then '剧末推'
			when split(activity_link, '_')[1]=202100 and split(activity_link, '_')[2]=9 then '退出观看返回推'
			when split(activity_link, '_')[1]=203200 then '悬浮窗'
			when split(activity_link, '_')[1]=204000 then 'TAB栏'
			when split(activity_link, '_')[1]=204100 then 'banner'
			when split(activity_link, '_')[1]=210010 then 'push'
			when split(activity_link, '_')[1]=210007 then '串剧'
			when split(activity_link, '_')[1]=203600 then '开屏页'
			when split(activity_link, '_')[1]=200200 then '首页'
			when split(activity_link, '_')[1]=200100 then '追剧页'
			when split(activity_link, '_')[1]=200400 then '浏览历史页'
			when split(activity_link, '_')[1]=201500 then '剧集解锁记录'
			when split(activity_link, '_')[1]=200700 then '搜索页'
			when split(activity_link, '_')[1]=203900 then '搜索中间页'
			when split(activity_link, '_')[1]=203100 then '我的评论页'
			when split(activity_link, '_')[1]=204600 then 'edm'
			when split(activity_link, '_')[1]=204700 then 'for you'
			else null end position_type,
			element_id,
			login_id,
			cast(substring(app_id, 4, 3) as int) as core,
			case lower(os) when  'ios' then 1
				when 'android' then 4
				else -99 end as mt,
			dic_lang.remarks   current_language2,
			split(activity_link, '_')[5] event_strategy_id,
			split(activity_link, '_')[10] programme_id,
			split(activity_link, '_')[8] activity_or_shorplay,
			split(activity_link, '_')[6] channel_id,
			split(activity_link, '_')[7] list_id,
			dic_list.Name list_name,
			dic_channel.Name channel_name
		from ads.ads_sensors_cd_video_operationpositionexposure_view a1
		left join dim.dim_dic dic_lang  -- 投放语言
		on a1.current_language2 = dic_lang.enum_id
		and dic_lang.table_name = 'dim_producttype'
		and dic_lang.dic_column = 'language_id'
		left join ads.ads_short_video_center_video_list_view dic_list
		on a1.split(activity_link, '_')[7] = dic_list.Id
		left join ads.ads_short_video_center_video_channel_view dic_channel
		on a1.split(activity_link, '_')[6] = dic_channel.Id
		where
			dt >= '${bf_1_dt}'
			and dt <= '${dt}'
			and product_id = '6833'
			and activity_link is not null
		) a2
	where
	1=1
	and activity_or_shorplay !=0
	and position_type not in ('充值返回推','push')
	group by 1,2,3,4,5,6,7,8,9,10

	union all

	select
	dt,
	position_type,
	channel_id,
	list_id,
	event_strategy_id,
	programme_id,
	login_id,
	core,
	mt,
	current_language2,
	max(channel_name) channel_name,
	max(list_name) list_name,
	count(login_id) exp_cnt
	from
		(
		select
			dt,
			case
			when split(activity_link, '_')[1]=202100 and split(activity_link, '_')[2] in (0,1) then '普通弹窗'
			when split(activity_link, '_')[1]=202100 and split(activity_link, '_')[2]=3 then '充值返回推'
			when split(activity_link, '_')[1]=202100 and split(activity_link, '_')[2]=4 then '剧末推'
			when split(activity_link, '_')[1]=202100 and split(activity_link, '_')[2]=9 then '退出观看返回推'
			when split(activity_link, '_')[1]=203200 then '悬浮窗'
			when split(activity_link, '_')[1]=204000 then 'TAB栏'
			when split(activity_link, '_')[1]=204100 then 'banner'
			when split(activity_link, '_')[1]=210010 then 'push'
			when split(activity_link, '_')[1]=210007 then '串剧'
			when split(activity_link, '_')[1]=203600 then '开屏页'
			when split(activity_link, '_')[1]=200200 then '首页'
			when split(activity_link, '_')[1]=200100 then '追剧页'
			when split(activity_link, '_')[1]=200400 then '浏览历史页'
			when split(activity_link, '_')[1]=201500 then '剧集解锁记录'
			when split(activity_link, '_')[1]=200700 then '搜索页'
			when split(activity_link, '_')[1]=203900 then '搜索中间页'
			when split(activity_link, '_')[1]=203100 then '我的评论页'
			when split(activity_link, '_')[1]=204600 then 'edm'
			when split(activity_link, '_')[1]=204700 then 'for you'
			else null end position_type,
			element_id,
			login_id,
			cast(substring(app_id, 4, 3) as int) as core,
			case lower(os) when  'ios' then 1
				when 'android' then 4
				else -99 end as mt,
			dic_lang.remarks   current_language2,
			split(activity_link, '_')[5] event_strategy_id,
			split(activity_link, '_')[10] programme_id,
			split(activity_link, '_')[8] activity_or_shorplay,
			split(activity_link, '_')[6] channel_id,
			split(activity_link, '_')[7] list_id,
			dic_list.Name list_name,
			dic_channel.Name channel_name
		from ads.ads_sensors_cd_video_operationpositionclick_view a1
		left join dim.dim_dic dic_lang  -- 投放语言
		on a1.current_language2 = dic_lang.enum_id
		and dic_lang.table_name = 'dim_producttype'
		and dic_lang.dic_column = 'language_id'
		left join ads.ads_short_video_center_video_list_view dic_list
		on a1.split(activity_link, '_')[7] = dic_list.Id
		left join ads.ads_short_video_center_video_channel_view dic_channel
		on a1.split(activity_link, '_')[6] = dic_channel.Id
		where
			dt >= '${bf_1_dt}'
			and dt <= '${dt}'
			and product_id = '6833'
			and activity_link is not null
		) a2
	where
	1=1
	and activity_or_shorplay !=0 and position_type='push'
	group by 1,2,3,4,5,6,7,8,9,10
),
--短剧点击用户
t2 as(
	select
	dt,
	position_type,
	channel_id,
	list_id,
	event_strategy_id,
	programme_id,
	login_id,
	core,
	mt,
	current_language2,
	max(channel_name) channel_name,
	max(list_name) list_name,
	count(login_id) clc_cnt
	from
		(
		select
			dt,
			case
			when split(activity_link, '_')[1]=202100 and split(activity_link, '_')[2] in (0,1) then '普通弹窗'
			when split(activity_link, '_')[1]=202100 and split(activity_link, '_')[2]=3 then '充值返回推'
			when split(activity_link, '_')[1]=202100 and split(activity_link, '_')[2]=4 then '剧末推'
			when split(activity_link, '_')[1]=202100 and split(activity_link, '_')[2]=9 then '退出观看返回推'
			when split(activity_link, '_')[1]=203200 then '悬浮窗'
			when split(activity_link, '_')[1]=204000 then 'TAB栏'
			when split(activity_link, '_')[1]=204100 then 'banner'
			when split(activity_link, '_')[1]=210010 then 'push'
			when split(activity_link, '_')[1]=210007 then '串剧'
			when split(activity_link, '_')[1]=203600 then '开屏页'
			when split(activity_link, '_')[1]=200200 then '首页'
			when split(activity_link, '_')[1]=200100 then '追剧页'
			when split(activity_link, '_')[1]=200400 then '浏览历史页'
			when split(activity_link, '_')[1]=201500 then '剧集解锁记录'
			when split(activity_link, '_')[1]=200700 then '搜索页'
			when split(activity_link, '_')[1]=203900 then '搜索中间页'
			when split(activity_link, '_')[1]=203100 then '我的评论页'
			when split(activity_link, '_')[1]=204600 then 'edm'
			when split(activity_link, '_')[1]=204700 then 'for you'
			else null end position_type,
			element_id,
			login_id,
			cast(substring(app_id, 4, 3) as int) as core,
			case lower(os) when  'ios' then 1
				when 'android' then 4
				else -99 end as mt,
			dic_lang.remarks   current_language2,
			split(activity_link, '_')[5] event_strategy_id,
			split(activity_link, '_')[10] programme_id,
			split(activity_link, '_')[8] activity_or_shorplay,
			split(activity_link, '_')[6] channel_id,
			split(activity_link, '_')[7] list_id,
			dic_list.Name list_name,
			dic_channel.Name channel_name
		from ads.ads_sensors_cd_video_operationpositionclick_view a1
		left join dim.dim_dic dic_lang  -- 投放语言
		on a1.current_language2 = dic_lang.enum_id
		and dic_lang.table_name = 'dim_producttype'
		and dic_lang.dic_column = 'language_id'
		left join ads.ads_short_video_center_video_list_view dic_list
		on a1.split(activity_link, '_')[7] = dic_list.Id
		left join ads.ads_short_video_center_video_channel_view dic_channel
		on a1.split(activity_link, '_')[6] = dic_channel.Id
		where
			dt >= '${bf_1_dt}'
			and dt <= '${dt}'
			and product_id = '6833'
			and activity_link is not null
		) a2
	where
	1=1
	and activity_or_shorplay !=0
	group by 1,2,3,4,5,6,7,8,9,10
),
-- 阅读用户
t3  as(
	select
	dt,
	position_type,
	channel_id,
	list_id,
	event_strategy_id,
	programme_id,
	login_id,
	core,
	mt,
	current_language2,
	max(channel_name) channel_name,
	max(list_name) list_name,
	count(distinct episode_id) watch_epis,
	max(case when watch_episode_sort =all_epis then 1 else 0 end) watch_all,
	max(case when watch_episode_sort =epis_percent_20 then 1 else 0 end) watch_percent_20,
	max(case when watch_episode_sort =epis_percent_50 then 1 else 0 end) watch_percent_50
	from
		(
		select
			dt,
			case
			when split(activity_link, '_')[1]=202100 and split(activity_link, '_')[2] in (0,1) then '普通弹窗'
			when split(activity_link, '_')[1]=202100 and split(activity_link, '_')[2]=3 then '充值返回推'
			when split(activity_link, '_')[1]=202100 and split(activity_link, '_')[2]=4 then '剧末推'
			when split(activity_link, '_')[1]=202100 and split(activity_link, '_')[2]=9 then '退出观看返回推'
			when split(activity_link, '_')[1]=203200 then '悬浮窗'
			when split(activity_link, '_')[1]=204000 then 'TAB栏'
			when split(activity_link, '_')[1]=204100 then 'banner'
			when split(activity_link, '_')[1]=210010 then 'push'
			when split(activity_link, '_')[1]=210007 then '串剧'
			when split(activity_link, '_')[1]=203600 then '开屏页'
			when split(activity_link, '_')[1]=200200 then '首页'
			when split(activity_link, '_')[1]=200100 then '追剧页'
			when split(activity_link, '_')[1]=200400 then '浏览历史页'
			when split(activity_link, '_')[1]=201500 then '剧集解锁记录'
			when split(activity_link, '_')[1]=200700 then '搜索页'
			when split(activity_link, '_')[1]=203900 then '搜索中间页'
			when split(activity_link, '_')[1]=203100 then '我的评论页'
			when split(activity_link, '_')[1]=204600 then 'edm'
			when split(activity_link, '_')[1]=204700 then 'for you'
			else null end position_type,
			'' element_id,
			login_id,
			cast(substring(app_id, 4, 3) as int) as core,
			case lower(os) when  'ios' then 1
				when 'android' then 4
				else -99 end as mt,
			episode_id,
			watch_episode_sort,
			all_epis,
			epis_percent_20,
			epis_percent_50,
			dic_lang.remarks   current_language2,
			split(activity_link, '_')[5] event_strategy_id,
			split(activity_link, '_')[10] programme_id,
			split(activity_link, '_')[8] activity_or_shorplay,
			split(activity_link, '_')[6] channel_id,
			split(activity_link, '_')[7] list_id,
			dic_list.Name list_name,
			dic_channel.Name channel_name
		from ads.ads_sensors_cd_video_startwatching_view a1
		left join dim.dim_dic dic_lang  -- 投放语言
		on a1.current_language2 = dic_lang.enum_id
		and dic_lang.table_name = 'dim_producttype'
		and dic_lang.dic_column = 'language_id'
		left join ads.ads_short_video_center_video_list_view dic_list
		on a1.split(activity_link, '_')[7] = dic_list.Id
		left join ads.ads_short_video_center_video_channel_view dic_channel
		on a1.split(activity_link, '_')[6] = dic_channel.Id
		left join dim_shortplay
			on a1.shortplay_id  = dim_shortplay.series_id
		where
			dt >= '${bf_1_dt}'
			and dt <= '${dt}'
			and product_id = '6833'
			and activity_link is not null
		) a2
	where
	1=1
	and activity_or_shorplay !=0
	group by 1,2,3,4,5,6,7,8,9,10
),
-- 解锁用户
t4 as (
	select
		dt,
		position_type,
		channel_id,
		list_id,
		event_strategy_id,
		programme_id,
		login_id,
		core,
		mt,
		sum(b.all_epis) as all_epis,
		max(channel_name) as channel_name,
		max(list_name) as list_name,
		max(all_unlock_epis) as all_unlock_epis,
		max(unlock_epis) as unlock_epis,
		max(unlock_amount) as unlock_amount
	from (
		select
		dt,
		position_type,
		channel_id,
		list_id,
		event_strategy_id,
		programme_id,
		login_id,
		core,
		mt,
		array_distinct(array_agg(a2.shortplay_id order by a2.shortplay_id nulls first))  as all_series_id,
		max(channel_name) channel_name,
		max(list_name) list_name,
		count(distinct episode_id) as all_unlock_epis,
		count(distinct case when  unlock_type in ('1','2','3','6','9','10','11') then  episode_id end ) unlock_epis,
		sum(case when  unlock_type in ('1','2','3','6','9','10','11') then  coin_consume end )+ sum(case when  unlock_type in('1','2','3','6','9','10','11') then  gift_consume  end ) unlock_amount
		from
			(
			select
				dt,
				case
				when split(activity_link, '_')[1]=202100 and split(activity_link, '_')[2] in (0,1) then '普通弹窗'
				when split(activity_link, '_')[1]=202100 and split(activity_link, '_')[2]=3 then '充值返回推'
				when split(activity_link, '_')[1]=202100 and split(activity_link, '_')[2]=4 then '剧末推'
				when split(activity_link, '_')[1]=202100 and split(activity_link, '_')[2]=9 then '退出观看返回推'
				when split(activity_link, '_')[1]=203200 then '悬浮窗'
				when split(activity_link, '_')[1]=204000 then 'TAB栏'
				when split(activity_link, '_')[1]=204100 then 'banner'
				when split(activity_link, '_')[1]=210010 then 'push'
				when split(activity_link, '_')[1]=210007 then '串剧'
				when split(activity_link, '_')[1]=203600 then '开屏页'
				when split(activity_link, '_')[1]=200200 then '首页'
				when split(activity_link, '_')[1]=200100 then '追剧页'
				when split(activity_link, '_')[1]=200400 then '浏览历史页'
				when split(activity_link, '_')[1]=201500 then '剧集解锁记录'
				when split(activity_link, '_')[1]=200700 then '搜索页'
				when split(activity_link, '_')[1]=203900 then '搜索中间页'
				when split(activity_link, '_')[1]=203100 then '我的评论页'
				when split(activity_link, '_')[1]=204600 then 'edm'
				when split(activity_link, '_')[1]=204700 then 'for you'
				else null end position_type,
				'' element_id,
				login_id,
				cast(substring(app_id, 4, 3) as int) as core,
				case lower(os) when  'ios' then 1
					when 'android' then 4
					else -99 end as mt,
				episode_id,
				shortplay_id,
				unlock_type,
				coin_consume,
				gift_consume,
				split(activity_link, '_')[5] event_strategy_id,
				split(activity_link, '_')[10] programme_id,
				split(activity_link, '_')[8] activity_or_shorplay,
				split(activity_link, '_')[6] channel_id,
				split(activity_link, '_')[7] list_id,
				dic_list.Name list_name,
				dic_channel.Name channel_name
			from ads.ads_sensors_cd_video_unlockEpisode_view a1
			left join ads.ads_short_video_center_video_list_view dic_list
			on a1.split(activity_link, '_')[7] = dic_list.Id
			left join ads.ads_short_video_center_video_channel_view dic_channel
			on a1.split(activity_link, '_')[6] = dic_channel.Id
			where
				dt >= '${bf_1_dt}'
				and dt <= '${dt}'
				and product_id = '6833'
				and activity_link is not null
			) a2
			left join dim_shortplay b on a2.shortplay_id = b.series_id
		where 1=1
		and activity_or_shorplay !=0
		group by 1,2,3,4,5,6,7,8,9
	) a
	left join unnest (all_series_id) as unnest on true
	left join dim_shortplay b on unnest=b.series_id
	group by 1,2,3,4,5,6,7,8,9
)
select
	t1.dt , --`日期`,
	ifnull(t1.position_type,'-99') as position_type, -- `场景`,
	ifnull(t1.channel_id,'-99') as channel_id, --  `频道id`,
	ifnull(t1.list_id,'-99') as list_id, -- `榜单id`,
	ifnull(t1.event_strategy_id,'-99') as event_strategy_id, -- `策略id`,
	ifnull(t1.programme_id,'-99') as programme_id, -- 方案id
	if(cast(t1.login_id as bigint(20)) is not null, t1.login_id, '-99') as exp_user_id, -- `曝光用户`,
	ifnull(t1.core,'-99') as core,
	ifnull(t1.mt,'-99') as mt,
	ifnull(t1.current_language2,'-99') as current_language2,
	t1.channel_name, --  `频道名称`,
	m1.Sort as channel_sort, -- 频道位序
	t1.list_name, -- `榜单名称`,
	m2.Sort as list_sort, -- 榜单位序
	exp_cnt, -- `曝光次数`,
	t2.login_id as clc_user_id, -- `点击用户`,
	clc_cnt, -- `点击次数`,
	t3.login_id as watch_user_id, -- `观看用户`,
	t3.watch_epis, -- `观看集数`,
	t3.watch_all,  -- `是否观看最后一集`,
	t3.watch_percent_20, -- `是否观看百分位20集`,
	t3.watch_percent_50,  -- `是否观看百分位50集`
	t4.login_id as unlock_user_id, -- `解锁用户`,
	t4.all_unlock_epis, -- 总解锁集数
	t4.unlock_epis, -- `付费解锁集数`,
	t4.unlock_amount, -- `解锁数量`
	t4.all_epis, -- 解锁剧集所在剧总集数
	now() as etl_time
from t1
left join t2
on t1.dt=t2.dt and t1.position_type=t2.position_type and t1.channel_id=t2.channel_id and t1.list_id=t2.list_id and t1.event_strategy_id=t2.event_strategy_id and t1.login_id = t2.login_id
	and t1.core=t2.core and t1.mt=t2.mt and t1.current_language2=t2.current_language2 and t1.programme_id=t2.programme_id
left join t3
on t2.dt=t3.dt and t2.position_type=t3.position_type and  t2.channel_id=t3.channel_id and t2.list_id=t3.list_id and t2.event_strategy_id=t3.event_strategy_id and t2.login_id = t3.login_id
	and t3.core=t2.core and t3.mt=t2.mt and t3.current_language2=t2.current_language2 and t3.programme_id=t2.programme_id
left join t4
on t3.dt=t4.dt and t3.position_type=t4.position_type and t3.channel_id=t4.channel_id and t3.list_id=t4.list_id and t4.event_strategy_id=t3.event_strategy_id and t3.login_id = t4.login_id
	and t3.core=t4.core and t3.mt=t4.mt and t3.programme_id=t4.programme_id
left join ods.ods_tidb_short_video_center_schema_channel m1 on t1.programme_id=m1.SchemeId  and t1.channel_id=m1.ChannelId and m1.DelStatus=0
left join ods.ods_tidb_short_video_center_channel_list m2 on t1.channel_id=m2.ChannelId  and t1.list_id=m2.ListId and m2.DelStatus=0
;
