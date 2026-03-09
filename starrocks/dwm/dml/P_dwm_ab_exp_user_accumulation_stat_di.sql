--  广告相关指标
 INSERT INTO dwm.dwm_ab_exp_user_accumulation_stat_di
WITH group_user AS (
    SELECT *  FROM
        (
            SELECT
                exp_id,
                exp_grp_id,
                exp_grp_ver_id,
                user_id AS account,
                min(hit_time) min_time,
                row_number() over(partition by user_id order by min(hit_time)) row_1
            FROM dwm.dwm_ab_exp_strategy_hit_user_di
            group by 1,2,3,4
        ) t1
    WHERE row_1 = 1
),
group_user_today AS (
--获取最新的版本
    SELECT *  FROM
        (
            SELECT
                exp_id,
                exp_grp_id,
                exp_grp_ver_id,
                user_id AS account,
                max(date(hit_time)) max_day,
                row_number() over(partition by user_id order by max(hit_time)) row_1
            FROM dwm.dwm_ab_exp_strategy_hit_user_di
            WHERE dt <= '${dt}'
            group by 1,2,3,4
        ) t1
    WHERE row_1 = 1
),
user_exp_grp_ver as (
	select 
		exp_id,exp_grp_id,exp_grp_ver_id,strategy_id,user_id,
		min(exp_start_time) as exp_start_time,
		max(exp_end_time) as exp_end_time,
		min(start_time) as start_time,
		max(end_time) as end_time,
		min(hit_time) as hit_time
	from dwm.dwm_ab_exp_strategy_hit_user_di
	group by 1,2,3,4,5
),


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
)
,

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
-- 充值数据
pay_amount_data AS (
	SELECT
		t123.exp_id AS exp_id,
		t123.exp_grp_id AS exp_grp_id,
		t123.exp_grp_ver_id AS exp_grp_ver_id,
		t123.account AS user_id,
		sum( case when t2.create_time>t123.min_time then t2.base_amount end)/100  AS recharge_amount,
		sum( case when t2.create_time>t123.min_time then t2.item_count end) AS recharge_amount_pre,
		sum( case when t2.create_time>t123.min_time and if_thirdpay = '三方支付' then t2.base_amount end)/100  AS third_recharge_amount,
		count( case when t2.create_time>t123.min_time then t2.user_id end) AS recharge_times
	FROM t123
	LEFT JOIN pay_tmp t2
		   ON t123.account = t2.user_id and t123.exp_id = t2.exp_id and t123.exp_grp_id = t2.exp_grp_id and t123.exp_grp_ver_id = t2.exp_grp_ver_id
	GROUP BY 1,2,3,4
),

-- 广告数据
ad_tmp AS (
	 select
		 t1.dt,t1.user_id
		 ,b.exp_id 
		 ,b.exp_grp_id 
		 ,b.exp_grp_ver_id 
		 ,sv_adp.ad_show_type_name ,
		 sv_adp.ad_position_name ,
		 case
			 when ads_name='Topon' then 'Topon'
			 when ads_name='Max' then 'Max'
			 when ads_name='Admob' then 'Admob'
			 else '其他' end `广告来源`,
		 amt,
		 cnt
	 from dws.dws_advertisement_user_position_amt_ed t1
	 inner join group_user_today b ON t1.user_id = b.account and t1.dt>=b.max_day
	 left join dim.dim_sv_ads_position_view sv_adp
						on t1.positions  = sv_adp.ad_position --  广告位ID
	 where product_id ='6833'
	   and t1.dt = '${dt}'
)
,

-- 广告解锁
ad_unlock_tmp AS (
 select
     dt
     ,exp_id 
	 ,exp_grp_id 
	 ,exp_grp_ver_id 
	 ,user_id
	 ,count(user_id) as ad_unlock_user_num
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
,

adv_data_tmp AS (
SELECT
    '${dt}' AS dt,
    a.exp_id AS exp_id,
    a.exp_grp_id AS exp_grp_id,
    a.exp_grp_ver_id AS exp_grp_ver_id,
    a.account AS user_id,
    sum( case when t4.dt>=a.min_time then t4.amt end) AS total_adv_amount,
    sum( case when t4.dt>=a.min_time and t4.ad_show_type_name !='H5'then t4.amt end) AS adv_amount,
    sum( case when t4.dt>=a.min_time and t4.ad_show_type_name ='H5' then t4.amt end) AS third_h5_amount,
    -- sum(case when group_type='对照组' then `广告解锁剧集人数` end) over(partition by min_day) group6_adv_unlock_uv,
    max(ad_unlock_user_num)  AS  adv_unlock_times,
    now()
FROM group_user a
LEFT JOIN ad_tmp t4
    ON a.account = t4.user_id and a.exp_id = t4.exp_id and a.exp_grp_id = t4.exp_grp_id and a.exp_grp_ver_id = t4.exp_grp_ver_id
LEFT JOIN ad_unlock_tmp t5
          ON a.account = t5.user_id and a.exp_id = t5.exp_id and a.exp_grp_id = t5.exp_grp_id and a.exp_grp_ver_id = t5.exp_grp_ver_id
GROUP BY 1,2,3,4,5
)
,
-- 付费解锁
pay_unlock as 
(
	select 
		b.ab_id as exp_id,b.version_id as exp_grp_id,c.exp_grp_ver_id,
		dt,
		event_strategy_id,
		login_id as user_id,
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
			and unlock_type in ('1','2','3','6','9','10','11')
			and product_id = '6833'
			and activity_link is not null 
		) a 
		inner join ods.ods_ab_hj_related b  on a.event_strategy_id = b.strategy_id 
		inner join dwd.dwd_ab_exp_version_detail c on b.ab_id = c.exp_id and b.version_id=c.exp_grp_id and  a.event_tm >= c.exp_start_time and c.exp_end_time>a.event_tm
			and a.event_tm >= c.start_time and c.end_time>a.event_tm  
	where 
	1=1 
	and activity_or_shorplay !=0	
	and unlock_type in ('1','2','3','6','9','10','11')
	group by 1,2,3,4,5,6
)
select 
	dt,exp_id,exp_grp_id,exp_grp_ver_id,user_id,
	max(recharge_amount) as recharge_amount,max(total_adv_amount) as total_adv_amount,max(adv_amount) as adv_amount,max(third_h5_amount) as third_h5_amount,max(adv_unlock_times) as adv_unlock_times,max(unlock_amount) as unlock_amount,now()
from (
	SELECT
			'${dt}' AS dt,
			a.exp_id AS exp_id,
			a.exp_grp_id AS exp_grp_id,
			a.exp_grp_ver_id AS exp_grp_ver_id,
			a.user_id,
			ifnull(b.recharge_amount,0) as recharge_amount,
			ifnull(a.total_adv_amount,0) as total_adv_amount,
			ifnull(a.adv_amount,0) as adv_amount,
			ifnull(a.third_h5_amount,0) as third_h5_amount,
			ifnull(a.adv_unlock_times,0) as adv_unlock_times,
			0 as unlock_amount,
			NOW()
	FROM adv_data_tmp a
	LEFT JOIN pay_amount_data b
		ON a.exp_id = b.exp_id
		AND a.exp_grp_id = b.exp_grp_id
		AND a.exp_grp_ver_id = b.exp_grp_ver_id
		AND a.user_id = b.user_id
		
		union all 

	SELECT
			'${dt}' AS dt,
			a.exp_id AS exp_id,
			a.exp_grp_id AS exp_grp_id,
			a.exp_grp_ver_id AS exp_grp_ver_id,
			a.user_id,
			0 as recharge_amount,
			0 as total_adv_amount,
			0 as adv_amount,
			0 as third_h5_amount,
			0 as adv_unlock_times,
			unlock_amount,
			NOW()
	FROM pay_unlock a 
) a 
group by 1,2,3,4,5