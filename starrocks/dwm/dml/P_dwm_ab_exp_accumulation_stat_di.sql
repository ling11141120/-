-- 曝光数据
INSERT INTO dwm.`dwm_ab_exp_accumulation_stat_di`
with user_exp_grp_ver as (
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
 -- 短剧曝光用户
 t1 as(
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
		count(distinct case when  unlock_type in ('3') then  episode_id end ) vip_unlock_epis,   -- vip解锁总集数
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
,
-- VIP用户解锁花费均摊
vip_value as (
	select dt, user_id,sum(base_amount/(datediff(vip_expire_time, vip_start_time)+1)) as value
	from (
		select
			'${dt}' as dt
			 ,user_id
			 ,if(t1.vip_expire_time is not null,str_to_date(vip_expire_time,'%Y-%m-%d %H:%i:%s'), 
						case when t2.vip_type=1 then date_add(t1.create_time, interval 1 month) -- 1,'月卡'
						   when t2.vip_type=2 then date_add(t1.create_time, interval 3 month) -- 2,'季卡'
						   when t2.vip_type=3 then date_add(t1.create_time, interval 1 year) -- 3,'年卡'
						   when t2.vip_type=4 then date_add(t1.create_time, interval 7 day) -- 4,'周卡'
						  end
				   ) as vip_expire_time
		   ,if(t1.vip_expire_time is null, t1.create_time,
			  case when shop_item_id=810 and vip_type=1 then months_add(vip_expire_time, -effective_time) -- '月卡'
				   when vip_type=2 then months_add(vip_expire_time, -effective_time) -- '季卡'
				   when vip_type=3 then months_add(vip_expire_time, -effective_time) -- '年卡'
				   when vip_type=4 then date_sub(vip_expire_time, effective_time) -- '周卡'
				   else t1.create_time
				  end) as vip_start_time
			 ,base_amount as base_amount
			,create_time			
		from dwd.dwd_trade_short_video_payorder t1 
		left join (
				 select
					 item_id
					  ,shop_item_id
					  ,effective_time
					  ,vip_type
					  ,case when vip_type=1 then '月卡'
							when vip_type=2 then '季卡'
							when vip_type=3 then '年卡'
							when vip_type=4 then '周卡'
					 end as vip_type_info
					  ,goods_attribute
					  ,first_price
					  ,first_effective_time
					  ,max(price) as price
				 from dim.dim_short_video_goods_view
				 where shop_item_id in  (840,810)
				   and is_remove=0
				 group by 1,2,3,4,5,6,7,8
			 ) t2 on SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(t1.ExtInfo,'|',-1),'com.changdu.mobovideo.',-1),'com.changdu.moboshort.',-1),'com.changjian.moboshortcj.',-1),'third.',-1) = t2.item_id
				 and t1.shop_item = t2.shop_item_id
		where dt >=date_add('${dt}',-400)
			and (vip_expire_time>='${dt}' or vip_expire_time is null )
		  and shop_item in (810)
		  and status = 0
	  ) a 
	  group by 1,2
)
,
vip_user_value as (
	select t4.dt,t4.exp_id, t4.exp_grp_id,t4.exp_grp_ver_id,t4.login_id,sum(t4.vip_unlock_epis)*max(b.avg_value) as vip_amount
	from t4 
	left join (
		select t4.dt,login_id,ifnull(sum(vip_value.value)/sum(vip_unlock_epis),0) avg_value
		from t4 
		left join vip_value on t4.dt=vip_value.dt and t4.login_id=vip_value.user_id
		where t4.vip_unlock_epis>0
		group by 1,2
	) b on t4.dt=b.dt and t4.login_id=b.login_id
	where vip_unlock_epis>0
	group by 1,2,3,4,5	
)
,
data1_tmp AS (
	SELECT
		t1.dt AS dt,
		t1.exp_id AS exp_id,
		t1.exp_grp_id AS exp_grp_id,
		t1.exp_grp_ver_id AS exp_grp_ver_id,
		sum(exp_cnt) as exp_cnt,
		sum(clc_cnt) as clc_cnt,
		SUM(watch_episodes) AS watch_episodes,
		SUM(all_unlock_episodes) AS all_unlock_episodes,
		SUM(unlock_epis) AS unlock_episodes,
		round(sum(t4.unlock_amount)+sum(t5.vip_amount),0) as unlock_amount
	from (select dt,login_id,exp_id,exp_grp_id,exp_grp_ver_id,sum(exp_cnt) as exp_cnt from t1 group by 1,2,3,4,5) t1
	left JOIN (select login_id,exp_id,exp_grp_id,exp_grp_ver_id,sum(clc_cnt) as clc_cnt from t2 group by 1,2,3,4) t2
            ON t1.login_id = t2.login_id and t1.exp_id = t2.exp_id and t1.exp_grp_id = t2.exp_grp_id and t1.exp_grp_ver_id = t2.exp_grp_ver_id
	left JOIN (select login_id,exp_id,exp_grp_id,exp_grp_ver_id,sum(watch_epis) as watch_episodes from t3 group by 1,2,3,4) t3
			  ON  t2.login_id = t3.login_id  and t2.exp_id = t3.exp_id and t2.exp_grp_id = t3.exp_grp_id and t2.exp_grp_ver_id = t3.exp_grp_ver_id
	left JOIN (select login_id,exp_id,exp_grp_id,exp_grp_ver_id,sum(all_unlock_epis) as all_unlock_episodes,sum(unlock_epis) as unlock_epis,sum(unlock_amount) as unlock_amount 
				from t4 group by 1,2,3,4
			) t4
			  ON  t3.login_id = t4.login_id  and t3.exp_id = t4.exp_id and t3.exp_grp_id = t4.exp_grp_id and t3.exp_grp_ver_id = t4.exp_grp_ver_id
	left join vip_user_value t5 ON  t5.login_id = t4.login_id  and t5.exp_id = t4.exp_id and t5.exp_grp_id = t4.exp_grp_id and t5.exp_grp_ver_id = t4.exp_grp_ver_id
	GROUP BY 1,2,3,4
),


-- 充值数据与消费数据

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
    where test_flag=0
      and dt >= date_add('${dt}',-1)
      and dt <= date_add('${dt}',1)
      and date(create_time) = '${dt}'
)
--select * from pay_tmp where user_id=155899481
,
consume_tmp as (
	select
		dt,create_time,account_id
		,b.exp_id 
		 ,b.exp_grp_id 
		 ,b.exp_grp_ver_id 
		 ,consume_type,consume_value
	from ads.ads_consume_short_video_consume_view t0
		INNER JOIN user_exp_grp_ver b ON t0.account_id = b.user_id and t0.create_time>=b.start_time and t0.create_time < b.end_time and t0.create_time>=b.hit_time
	where consume_type in (0,1)
	  and dt >= date_add('${dt}',-1)
	  and dt <= date_add('${dt}',1)
	  and date(create_time) = '${dt}'
)

,data2_tmp AS (
	select dt,exp_id,exp_grp_id,exp_grp_ver_id
	,max(recharge_amount) as recharge_amount
	,max(recharge_amount_pre) as recharge_amount_pre
	,max(third_recharge_amount) as third_recharge_amount
	,max(recharge_times) as recharge_times
	,max(coin_consume) as coin_consume
	,max(gift_consume) as gift_consume
	,max(consume_times) as consume_times
from (
	SELECT
		'${dt}' AS dt,
		t123.exp_id AS exp_id,
		t123.exp_grp_id AS exp_grp_id,
		t123.exp_grp_ver_id AS exp_grp_ver_id,
		sum( case when t2.create_time>t123.min_time then t2.base_amount end)/100  AS recharge_amount,
		sum( case when t2.create_time>t123.min_time then t2.item_count end) AS recharge_amount_pre,
		sum( case when t2.create_time>t123.min_time and if_thirdpay = '三方支付' then t2.base_amount end)/100  AS third_recharge_amount,
		count( case when t2.create_time>t123.min_time then t2.user_id end) AS recharge_times,
		0 as  coin_consume,
		0 as  gift_consume,
		0 as  consume_times
	FROM t123
	LEFT JOIN pay_tmp t2
			ON t123.account = t2.user_id and t123.exp_id = t2.exp_id and t123.exp_grp_id = t2.exp_grp_id and t123.exp_grp_ver_id = t2.exp_grp_ver_id
	GROUP BY 1,2,3,4
	
	union all
	
		SELECT
		'${dt}' AS dt,
		t123.exp_id AS exp_id,
		t123.exp_grp_id AS exp_grp_id,
		t123.exp_grp_ver_id AS exp_grp_ver_id,
		0 as  recharge_amount,
		0 as  recharge_amount_pre,
		0 as  third_recharge_amount,
		0 as  recharge_times,
		sum( case when t3.create_time>t123.min_time and consume_type =0 then t3.consume_value end)/100 coin_consume,
		sum( case when t3.create_time>t123.min_time and consume_type =1 then t3.consume_value end)/100 gift_consume,
		count( case when t3.create_time>t123.min_time then t3.account_id end) consume_times
	FROM t123
	LEFT JOIN consume_tmp t3
			  ON t123.account = t3.account_id and t123.exp_id = t3.exp_id and t123.exp_grp_id = t3.exp_grp_id and t123.exp_grp_ver_id = t3.exp_grp_ver_id
	GROUP BY 1,2,3,4
) a
group by 1,2,3,4
)

,

--  广告相关指标
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
group_user AS (
--获取最早的版本
    SELECT *  FROM
        (
            SELECT
                exp_id,
                exp_grp_id,
                exp_grp_ver_id,
                user_id AS account,
                min(hit_time) min_day,
                row_number() over(partition by user_id order by min(hit_time)) row_1
            FROM dwm.dwm_ab_exp_strategy_hit_user_di
            group by 1,2,3,4
        ) t1
    WHERE row_1 = 1
),

-- 广告数据
ad_tmp AS (
	 select
		 t1.dt,t1.user_id
		 ,b.exp_id 
		 ,b.exp_grp_id 
		 ,b.exp_grp_ver_id 
		 ,sv_adp.ad_show_type_name   `广告类型`,
		 sv_adp.ad_position_name  `广告位置`,
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
),

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
         where
             not DATE_FORMAT(expire_time, '%Y%m%d%H%i%s') LIKE '9999%'
     )unlock
 where dt = '${dt}'
 group by 1,2,3,4,5
)

,
data3_tmp AS (
SELECT
    '${dt}' AS dt,
    a.exp_id AS exp_id,
    a.exp_grp_id AS exp_grp_id,
    a.exp_grp_ver_id AS exp_grp_ver_id,
    sum( case when t4.dt>=a.min_day then t4.amt end) AS total_adv_amount,
    sum( case when t4.dt>=a.min_day and t4.广告类型!='H5'then t4.amt end) AS adv_amount,
    sum( case when t4.dt>=a.min_day and t4.广告类型='H5' then t4.amt end) AS third_h5_amount,
    -- sum(case when group_type='对照组' then `广告解锁剧集人数` end) over(partition by min_day) group6_adv_unlock_uv,
    max(ad_unlock_user_num)  AS  adv_unlock_times
FROM group_user a
         LEFT JOIN ad_tmp t4
                   ON a.account = t4.user_id and a.exp_id = t4.exp_id and a.exp_grp_id = t4.exp_grp_id and a.exp_grp_ver_id = t4.exp_grp_ver_id
         LEFT JOIN ad_unlock_tmp t5
                   ON a.account = t5.user_id and a.exp_id = t5.exp_id and a.exp_grp_id = t5.exp_grp_id and a.exp_grp_ver_id = t5.exp_grp_ver_id
GROUP BY 1,2,3,4
)


SELECT
     dt,
     exp_id,
     exp_grp_id,
     exp_grp_ver_id,
	 MAX(exp_cnt) as exp_cnt,
	 MAX(clc_cnt) as clc_cnt,
     MAX(watch_episodes),
	 max(all_unlock_episodes) as all_unlock_episodes,
     MAX(unlock_episodes),
	 max(unlock_amount) as unlock_amount,
     MAX(recharge_amount),
     MAX(recharge_amount_pre),
     MAX(third_recharge_amount),
     MAX(recharge_times),
     MAX(coin_consume),
     MAX(gift_consume),
     MAX(consume_times),
     MAX(total_adv_amount),
     MAX(adv_amount),
     MAX(third_h5_amount),
     MAX(adv_unlock_times),
     NOW()
FROM
(
	SELECT
		dt,
		exp_id,
		exp_grp_id,
		exp_grp_ver_id,
		watch_episodes,
		all_unlock_episodes,
		unlock_episodes,
		unlock_amount,
		exp_cnt,
		clc_cnt,
		0 AS recharge_amount,
		0 AS recharge_amount_pre,
		0 AS third_recharge_amount,
		0 AS recharge_times,
		0 AS coin_consume,
		0 AS gift_consume,
		0 AS consume_times,
		0 AS total_adv_amount,
		0 AS adv_amount,
		0 AS third_h5_amount,
		0 AS adv_unlock_times
	FROM data1_tmp
	UNION ALL
	SELECT
		dt,
		exp_id,
		exp_grp_id,
		exp_grp_ver_id,
		0 as exp_cnt,
		0 as clc_cnt,
		0 AS watch_episodes,
		0 as all_unlock_episodes,
		0 AS unlock_episodes,
		0 as unlock_amount,
		recharge_amount,
		recharge_amount_pre,
		third_recharge_amount,
		recharge_times,
		coin_consume,
		gift_consume,
		consume_times,
		0 AS total_adv_amount,
		0 AS adv_amount,
		0 AS third_h5_amount,
		0 AS adv_unlock_times
	FROM data2_tmp
	UNION ALL
	SELECT
		dt,
		exp_id,
		exp_grp_id,
		exp_grp_ver_id,
		0 as exp_cnt,
		0 as clc_cnt,
		0 AS watch_episodes,
		0 as all_unlock_episodes,
		0 AS unlock_episodes,
		0 as unlock_amount,
		0 AS recharge_amount,
		0 AS recharge_amount_pre,
		0 AS third_recharge_amount,
		0 AS recharge_times,
		0 AS coin_consume,
		0 AS gift_consume,
		0 AS consume_times,
		total_adv_amount,
		adv_amount,
		third_h5_amount,
		adv_unlock_times
	FROM data3_tmp
) a
GROUP BY 1,2,3,4
