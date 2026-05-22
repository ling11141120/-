----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_ab_exp_distinct_stat_di
-- workflow_version : 11
-- create_user      : xixg
-- task_name        : dwm_ab_exp_distinct_stat_di
-- task_version     : 10
-- update_time      : 2025-06-10 15:59:27
-- sql_path         : \starrocks\tbl_dwm_ab_exp_distinct_stat_di\dwm_ab_exp_distinct_stat_di
----------------------------------------------------------------
-- SQL语句
-- 实验用户
INSERT INTO dwm.`dwm_ab_exp_distinct_stat_di`
(dt, exp_id, exp_grp_id, exp_grp_ver_id, exp_grp_users, etl_time)
SELECT
    dt AS dt,
    exp_id AS exp_id,
    exp_grp_id AS exp_grp_id,
    exp_grp_ver_id AS exp_grp_ver_id,
    TO_BITMAP(user_id) AS exp_grp_users,
    now()
FROM dwd.dwd_ab_exp_user_detail_di
WHERE dt = '${dt}'
;

-- SQL语句
-- 策略命中用户
INSERT INTO dwm.`dwm_ab_exp_distinct_stat_di`
(dt, exp_id, exp_grp_id, exp_grp_ver_id, strategy_hit_users, etl_time)
SELECT
    dt AS dt,
    exp_id AS exp_id,
    exp_grp_id AS exp_grp_id,
    exp_grp_ver_id AS exp_grp_ver_id,
    TO_BITMAP(user_id) AS exp_grp_users,
    now()
FROM dwm.dwm_ab_exp_strategy_hit_user_di
WHERE dt = '${dt}'
;

-- SQL语句
-- 曝光数据
INSERT INTO dwm.`dwm_ab_exp_distinct_stat_di`
(dt, exp_id, exp_grp_id, exp_grp_ver_id, exposure_users,click_users, watch_users, unlock_users,pay_unlock_users, etl_time)
 -- 短剧曝光用户
with t1 as(
	select
		b.ab_id as exp_id,b.version_id as exp_grp_id,c.exp_grp_ver_id,
		dt,
		position_type,
		channel_id,
		list_id,
		event_strategy_id,
		login_id,
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
				event_tm,
				dic_lang.remarks   current_language2,
				split(activity_link, '_')[5] event_strategy_id,
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
				dt = '${dt}'
				and product_id = '6833'
				and activity_link is not null
		) a
		inner join ods.ods_ab_hj_related b  on a.event_strategy_id = b.strategy_id
		inner join dwd.dwd_ab_exp_version_detail c on b.ab_id = c.exp_id and b.version_id=c.exp_grp_id and  a.event_tm >= c.exp_start_time and c.exp_end_time>a.event_tm
			and a.event_tm >= c.start_time and c.end_time>a.event_tm
	where 1=1
	and activity_or_shorplay !=0
	group by 1,2,3,4,5,6,7,8,9
),
--短剧点击用户
t2 as(
	select
		b.ab_id as exp_id,b.version_id as exp_grp_id,c.exp_grp_ver_id,
		dt,
		position_type,
		channel_id,
		list_id,
		event_strategy_id,
		login_id,
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
				event_tm,
				dic_lang.remarks   current_language2,
				split(activity_link, '_')[5] event_strategy_id,
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
				dt = '${dt}'
				and product_id = '6833'
				and activity_link is not null
		) a
		inner join ods.ods_ab_hj_related b  on a.event_strategy_id = b.strategy_id
		inner join dwd.dwd_ab_exp_version_detail c on b.ab_id = c.exp_id and b.version_id=c.exp_grp_id and  a.event_tm >= c.exp_start_time and c.exp_end_time>a.event_tm
			and a.event_tm >= c.start_time and c.end_time>a.event_tm
	where 1=1
	and activity_or_shorplay !=0
	group by 1,2,3,4,5,6,7,8,9
),
-- 阅读用户
t3  as(
	select
		b.ab_id as exp_id,b.version_id as exp_grp_id,c.exp_grp_ver_id,
		dt,
		position_type,
		channel_id,
		list_id,
		event_strategy_id,
		login_id,
		max(channel_name) channel_name,
		max(list_name) list_name,
		count(distinct episode_id) watch_epis
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
				event_tm,
				episode_id,
				dic_lang.remarks   current_language2,
				split(activity_link, '_')[5] event_strategy_id,
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
			where
				dt = '${dt}'
				and product_id = '6833'
				and activity_link is not null
		) a
		inner join ods.ods_ab_hj_related b  on a.event_strategy_id = b.strategy_id
		inner join dwd.dwd_ab_exp_version_detail c on b.ab_id = c.exp_id and b.version_id=c.exp_grp_id and  a.event_tm >= c.exp_start_time and c.exp_end_time>a.event_tm
			and a.event_tm >= c.start_time and c.end_time>a.event_tm
	where 1=1
	and activity_or_shorplay !=0
	group by 1,2,3,4,5,6,7,8,9
),
-- 解锁用户
t4 as (
	select
		b.ab_id as exp_id,b.version_id as exp_grp_id,c.exp_grp_ver_id,
		dt,
		position_type,
		channel_id,
		list_id,
		event_strategy_id,
		login_id,
		max(channel_name) channel_name,
		max(list_name) list_name,
		-- 1.单章解锁 2.批量解锁 3.vip 4.全站限免 5.单剧限免 6.超点解锁 7.任务解锁 8.广告解锁 9.全剧购买 10.打包购买 11.跨集批量解锁
		count( case when  unlock_type in ('1','2','3','6','9','10','11') then  login_id end ) pay_unlock_user, -- 付费解锁用户
		count(distinct   episode_id ) all_unlock_epis, 	-- 解锁总集数
		count(distinct case when  unlock_type in ('1','2','3','6','9','10','11') then  episode_id end ) unlock_epis,   -- 付费解锁总集数
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
			event_tm,
			episode_id,
			unlock_type,
			coin_consume,
			gift_consume,
			split(activity_link, '_')[5] event_strategy_id,
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
			dt = '${dt}'
			and product_id = '6833'
			and activity_link is not null
		) a
		inner join ods.ods_ab_hj_related b  on a.event_strategy_id = b.strategy_id
		inner join dwd.dwd_ab_exp_version_detail c on b.ab_id = c.exp_id and b.version_id=c.exp_grp_id and  a.event_tm >= c.exp_start_time and c.exp_end_time>a.event_tm
			and a.event_tm >= c.start_time and c.end_time>a.event_tm
	where
	1=1
	and activity_or_shorplay !=0
	group by 1,2,3,4,5,6,7,8,9
)
SELECT
        t1.dt AS dt,
        t1.exp_id AS exp_id,
        t1.exp_grp_id AS exp_grp_id,
        t1.exp_grp_ver_id AS exp_grp_ver_id,
        TO_BITMAP(t1.login_id) AS exposure_users,
        TO_BITMAP(t2.login_id) AS click_users,
        TO_BITMAP(t3.login_id) AS watch_users,
        TO_BITMAP(t4.login_id) AS unlock_users,
		TO_BITMAP(t4.pay_unlock_user) AS pay_unlock_users,
        now()
from (select dt,login_id,exp_id,exp_grp_id,exp_grp_ver_id from t1 group by 1,2,3,4,5) t1
left JOIN (select login_id,exp_id,exp_grp_id,exp_grp_ver_id from t2 group by 1,2,3,4) t2
            ON t1.login_id = t2.login_id and t1.exp_id = t2.exp_id and t1.exp_grp_id = t2.exp_grp_id and t1.exp_grp_ver_id = t2.exp_grp_ver_id
left JOIN (select login_id,exp_id,exp_grp_id,exp_grp_ver_id from t3 group by 1,2,3,4) t3
            ON  t2.login_id = t3.login_id and t2.exp_id = t3.exp_id and t2.exp_grp_id = t3.exp_grp_id and t2.exp_grp_ver_id = t3.exp_grp_ver_id
left JOIN (select login_id,exp_id,exp_grp_id,exp_grp_ver_id,pay_unlock_user from t4 group by 1,2,3,4,5) t4
          ON  t3.login_id = t4.login_id  and t3.exp_id = t4.exp_id and t3.exp_grp_id = t4.exp_grp_id and t3.exp_grp_ver_id = t4.exp_grp_ver_id
;

-- SQL语句
-- 充值数据与消费数据
INSERT INTO dwm.`dwm_ab_exp_distinct_stat_di`
(dt, exp_id, exp_grp_id, exp_grp_ver_id, recharge_users, consume_users,adv_unlock_users, etl_time)
WITH user_exp_grp_ver as (
	select
		exp_id,exp_grp_id,exp_grp_ver_id,strategy_id,user_id,
		min(exp_start_time) as exp_start_time,
		max(exp_end_time) as exp_end_time,
		min(start_time) as start_time,
		max(end_time) as end_time,
		min(hit_time) as hit_time
	from dwm.dwm_ab_exp_strategy_hit_user_di
	group by 1,2,3,4,5
)
,
-- 安装、激活信息
t123 as(
select
     t5.*,
     t6.series_code
 from
     (
         select
             t3.*,
             t4.source_series_id
         from
             (
                 select
                     a.*,
                     t2.install_date,
                     t2.book_id series_id,
                     row_number() over(partition by account order by install_date desc ) row_2
                 from (SELECT *  FROM
					    (
						    SELECT
						        exp_id,exp_grp_id,exp_grp_ver_id,
						        user_id AS account,
						        min(hit_time) min_time,
						        row_number() over(partition by user_id order by min(hit_time)) row_1
						    FROM user_exp_grp_ver
						    group by 1,2,3,4
					    ) t1
					    WHERE row_1 = 1
				    ) a
                left join ads.ads_user_install_info_view t2
                      on  a.account= t2.user_id
                          and t2.install_date<=a.min_time
                          and t2.install_date>=date_add(a.min_time ,-30)
             ) t3
             left join dim.dim_short_video_series_view t4 on t3.series_id= t4.series_id
        	 where row_2 = 1
     ) t5
       left join  dim.dim_short_video_source_series_view t6
                    on t5.source_series_id =t6.series_id
),
-- 订单
pay_tmp as (
    select
        dt,create_time,t0.user_id
        ,b.exp_id
         ,b.exp_grp_id
         ,b.exp_grp_ver_id
         ,item_count,base_amount,shop_item,package_id,
        case
            when SPLIT(get_json_string(custom_data, '$.sendId'), '_')[1]='201300' then '商店页'
            when SPLIT(get_json_string(custom_data, '$.sendId'), '_')[1]='200900' then '半屏'
            when SPLIT(get_json_string(custom_data, '$.sendId'), '_')[1]='203300' then 'H5'
            else '其他' end recharge_source,
        get_json_string(custom_data, '$.activityId')  activity_id,
        get_json_string(custom_data, '$.strategyId') strategy_id,
        case when subpay_type  in ('GooglePlay','AppStore','AppGallery') then '原生支付' else '三方支付' end if_thirdpay
    from ads.ads_short_video_payorder_view t0
    INNER JOIN user_exp_grp_ver b ON t0.user_id = b.user_id and t0.create_time>=b.start_time and t0.create_time < b.end_time and t0.create_time>=b.hit_time
                                        and  t0.create_time>=b.exp_start_time and t0.create_time < b.exp_end_time
    where test_flag=0
      and dt >= date_add('${dt}',-1)
      and dt <= date_add('${dt}',1)
      and date(create_time) = '${dt}'
),
-- 消费
consume_tmp as (
select
    dt,create_time,account_id
    ,b.exp_id
     ,b.exp_grp_id
     ,b.exp_grp_ver_id
     ,consume_type,consume_value
from ads.ads_consume_short_video_consume_view t0
    INNER JOIN user_exp_grp_ver b ON t0.account_id = b.user_id and t0.create_time>=b.start_time and t0.create_time < b.end_time and t0.create_time>=b.hit_time
                                    and  t0.create_time>=b.exp_start_time and t0.create_time < b.exp_end_time
where consume_type in (0,1)
  and dt >= date_add('${dt}',-1)
  and dt <= date_add('${dt}',1)
  and date(create_time) = '${dt}'
)
,ad_unlock_tmp AS (
 select
     dt
     ,exp_id
	 ,exp_grp_id
	 ,exp_grp_ver_id
	 ,user_id
 from(
         select
             CAST(t0.create_time AS DATE) dt,
             t0.user_id
			 ,b.exp_id
			 ,b.exp_grp_id
			 ,b.exp_grp_ver_id
         from ads.ads_short_video_series_unlock_view t0
		INNER JOIN user_exp_grp_ver b ON t0.user_id = b.user_id and t0.create_time>=b.start_time and t0.create_time < b.end_time and t0.create_time>=b.hit_time
										and  t0.create_time>=b.exp_start_time and t0.create_time < b.exp_end_time
         where
             not DATE_FORMAT(expire_time, '%Y%m%d%H%i%s') LIKE '9999%'
     )unlock
 where dt = '${dt}'
 group by 1,2,3,4,5
)

SELECT
    '${dt}' AS dt,
    t123.exp_id AS exp_id,
    t123.exp_grp_id AS exp_grp_id,
    t123.exp_grp_ver_id AS exp_grp_ver_id,
    to_bitmap(CASE WHEN t2.create_time>t123.min_time THEN t2.user_id END) AS recharge_users,
    to_bitmap(case when t3.create_time>t123.min_time then t3.account_id END) AS consume_users,
    to_bitmap(t4.user_id) AS consume_users,
    now()
FROM t123
LEFT JOIN pay_tmp t2
        ON t123.account = t2.user_id and t123.exp_id = t2.exp_id and t123.exp_grp_id = t2.exp_grp_id and t123.exp_grp_ver_id = t2.exp_grp_ver_id
LEFT JOIN consume_tmp t3
          ON t123.account = t3.account_id and t123.exp_id = t3.exp_id and t123.exp_grp_id = t3.exp_grp_id and t123.exp_grp_ver_id = t3.exp_grp_ver_id
LEFT JOIN ad_unlock_tmp t4
          ON t123.account = t4.user_id and t123.exp_id = t4.exp_id and t123.exp_grp_id = t4.exp_grp_id and t123.exp_grp_ver_id = t4.exp_grp_ver_id
;
