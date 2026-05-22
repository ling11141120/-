----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_offline_label
-- workflow_version : 72
-- create_user      : zhengtt
-- task_name        : ads_offline_label_stat_en
-- task_version     : 17
-- update_time      : 2025-05-15 16:09:08
-- sql_path         : \starrocks\tbl_ads_offline_label\ads_offline_label_stat_en
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_offline_label_stat where dt = '${bf_1_dt}' and product_id = 3366;

-- SQL语句
insert into ads.ads_offline_label_stat
select  a.product_id,a.user_id,
        if(a.nick_name = '', null, a.nick_name) as nick_name,
        case a.sex
            when 1 then '男'
            when 2 then '女'
            when 3 then '保密'
            else '未知'
            end   as sex,
        a.age,
        if(a.nation = '', null, a.nation) as nation,
        if(a.province = '', null, a.province) as province,
        if(a.city = '', null, a.city) as city,
        a.group_hash,
        a.group_id_1,a.group_id_2,a.group_id_3,a.group_id_4,a.server_version,a.continous_sign_days,
        if(a.reg_nation = '', null, a.reg_nation) as reg_nation,
        if(a.reg_province = '', null, a.reg_province) as reg_province,
        if(a.reg_city = '', null, a.reg_city) as reg_city,
        a.reg_time,a.reg_language,a.cur_language,a.coin_cnt,
        a.certificate_cnt,a.medal_cnt,a.register_day,a.is_new_user,a.recharged,
        if(a.is_nopay is null, -99, a.is_nopay) as is_nopay,
        a.is_iaa,
        if(a.is_invite is null, -99, a.is_invite) as is_invite,
        a.medal_expire_time,a.last_welfare_purcharse_time,a.last_plus_purcharse_time,
        a.welfare_expire_time,a.plus_expire_time,a.highest_recharge,a.auto_change_tag,
        if(a.ad_tag = '', null, a.ad_tag) as ad_tag,
        a.ad_quality,
        b.imei,b.imsi,b.guid,b.mac,b.model,b.manufacturer,b.price_level,b.screen_width,b.screen_height,
        b.os_type,b.os_verison,b.app_id,c.first_login_time,c.last_login_time,c.new_login_time,c.first_login_ip,
        c.last_login_ip,c.new_login_ip,c.first_login_location,c.last_login_location,c.new_login_location,c.remain_day,
        c.login_days,c.login_times,
        if(c.user_login_type is null,'流失用户',c.user_login_type) as user_login_type,
        if(d.start_read_chapters is null,0,d.start_read_chapters) as start_read_chapters,
        if(e.start_read_time is null,0,e.start_read_time) as start_read_time,
        d.start_day_read_chapters,
        e.start_day_read_time,if(d.total_read_chp is null,0,d.total_read_chp) as total_read_chp,e.total_read_time,d.total_read_bookid,d.total_read_books,
        e.more_onem_total_read_bookid,e.more_onem_total_read_books,d.total_read_days,
        if(d.new_chp_book_cnt is null,0,d.new_chp_book_cnt) as new_chp_book_cnt,
        d.new_chp_bookid_chpid,e.read_time_td/d.total_read_days as read_time_da_avg,f.start_subscribe,
        f.start_subscribe_type,f.start_subscribe_time,f.last_subscribe,f.last_subscribe_type,f.last_subscribe_time,
        f.is_month_card,f.is_subscribeing,f.subscribe_cnt,f.shopitems,
        if(f.mul_subscribe is null,0,f.mul_subscribe) as mul_subscribe,
        if(f.his_subscribe is null,0,f.his_subscribe) as his_subscribe,
        f.first_recharge,f.first_recharge_time,f.total_recharge,f.recharge_cnt,f.recharge_avg,f.recharge_max,
        f.month_recharge_max,f.last_recharge,f.last_recharge_time,f.start_bat_ulk_gear,f.start_bat_ulk_chp_cnt,
        f.total_bat_ulk_cnt,f.total_fix_ulk_cnt,f.start_sup_ulk_chp_cnt,f.sup_ulk_cnt,f.sup_ulk_sum,f.coin_consumption,
        f.certificate_consumption,f.purcharse_cnt,f.last_purcharse_time,f.total_consumption,
        null as recency,null as frequency,null as monetary,null as r_score,null as f_score,null as m_score,
        null as rfm_customer_tag,null as rfm_value_tag,null as rfm_vocational_tag,null as cac,null as pbp,
        null as ltv1,null as ltv2,null as ltv3,null as ltv4,null as ltv5,null as ltv6,null as ltv7,
        null as ltv15,null as ltv30,null as ltv45,null as ltv60,null as ltv90,null as recent_frequency_1d,
        null as recent_frequency_2d,null as recent_frequency_3d,null as recent_frequency_4d,
        null as recent_frequency_5d,null as recent_frequency_6d,null as recent_frequency_7d,
        null as recent_frequency_15d,null as recent_frequency_30d,null as recent_frequency_60d,
        null as recent_frequency_90d,null as recent_monetary_1d,null as recent_monetary_2d,
        null as recent_monetary_3d,null as recent_monetary_4d,null as recent_monetary_5d,
        null as recent_monetary_6d,null as recent_monetary_7d,null as recent_monetary_15d,
        null as recent_monetary_30d,null as recent_monetary_60d,null as recent_monetary_90d,
        a.mt,a.corever,a.current_language2,a.country,
        case country_level
            when 1 then 't1'
            when 2 then 't2'
            end   as country_level,
        g.first_book,g.last_book,null as first_adid,
        null as last_adid,a.dt,a.account,h.last_active_dt,i.user_ad_source,j.shop_item_type,ifnull(j.cancel_subscription_time,'1970-01-01') as cancel_subscription_time
		,ifnull(k.vip_expire_time,'1970-01-01') as vip_expire_time,ifnull(k.svip_expire_time,'1970-01-01') as svip_expire_time,ifnull(k.sign_expire_time,'1970-01-01') as sign_expire_time
from
(   select 	dt,product_id,user_id,nick_name,sex,age,nation,province,city,group_hash,group_id_1,group_id_2,
            group_id_3,group_id_4,server_version,continous_sign_days,reg_nation,reg_province,reg_city,
            reg_time,reg_language,cur_language,coin_cnt,certificate_cnt,medal_cnt,register_day,is_new_user,
            recharged,is_nopay,is_iaa,is_invite,medal_expire_time,last_welfare_purcharse_time,
            last_plus_purcharse_time,welfare_expire_time,plus_expire_time,highest_recharge,
            auto_change_tag,ad_tag,ad_quality,mt,corever,current_language2,country,country_level,account
    from ads.ads_offline_label_user_account_info
    where dt = '${bf_1_dt}' and product_id = 3366
    ) a
left join
(   select 	product_id,user_id,imei,imsi,guid,mac,model,manufacturer,
            price_level,screen_width,screen_height,os_type,os_verison,app_id
    from  ads.ads_offline_label_user_device_info
    where  dt = '${bf_1_dt}' and product_id = 3366
) b
on a.product_id = b.product_id and a.user_id = b.user_id
left join
(   select 	product_id,user_id,first_login_time,last_login_time,new_login_time,first_login_ip,
            last_login_ip,new_login_ip,first_login_location,last_login_location,
            new_login_location,remain_day,login_days,login_times,user_login_type
    from ads.ads_offline_label_user_login_info
    where  dt = '${bf_1_dt}' and product_id = 3366
    ) c
on a.product_id = c.product_id and a.user_id = c.user_id
left join
(   select 	product_id,user_id,start_read_chapters,start_day_read_chapters,total_read_chp,
            total_read_bookid,total_read_books,total_read_days,new_chp_book_cnt,new_chp_bookid_chpid
    from ads.ads_offline_label_user_read_chapter
    where dt = '${bf_1_dt}' and product_id = 3366
) d
on a.product_id = d.product_id and a.user_id = d.user_id
left join
(   select 	product_id,user_id,start_read_time,start_day_read_time,total_read_time,
              more_onem_total_read_bookid,more_onem_total_read_books,read_time_td
    from ads.ads_offline_label_user_read_time
    where dt = '${bf_1_dt}' and product_id = 3366
) e
on a.product_id = e.product_id and a.user_id = e.user_id
left join
(   select 	user_id,product_id,start_subscribe,start_subscribe_type,start_subscribe_time,last_subscribe,
            last_subscribe_type,last_subscribe_time,is_month_card,is_subscribeing,subscribe_cnt,
            shopitems,mul_subscribe,his_subscribe,first_recharge,first_recharge_time,total_recharge,
            recharge_cnt,recharge_avg,recharge_max,month_recharge_max,last_recharge,last_recharge_time,
            start_bat_ulk_gear,start_bat_ulk_chp_cnt,total_bat_ulk_cnt,total_fix_ulk_cnt,
            start_sup_ulk_chp_cnt,sup_ulk_cnt,sup_ulk_sum,coin_consumption,certificate_consumption,
            purcharse_cnt,last_purcharse_time,total_consumption
    from ads.ads_offline_label_user_recharge_consume
    where dt = '${bf_1_dt}' and product_id = 3366
    ) f
on a.product_id = f.product_id and a.user_id = f.user_id
left join
(   select dt,product_id,user_id,mt,corever,current_language2,first_book,last_book
    from ads.ads_offline_label_user_info_wide_a_view
    where dt = '${bf_1_dt}' and product_id = 3366
    ) g
on a.product_id = g.product_id and a.user_id = g.user_id and a.mt = g.mt
    and a.corever = g.corever and a.current_language2 = g.current_language2
left join
(
	select product_id,user_id,max(dt) as last_active_dt
	from dws.dws_user_wide_active_ed
	where  product_id = 3366
	group by 1,2
) h on a.product_id=h.product_id and a.user_id=h.user_id
left join dim.`dim_user_all_info` i on a.product_id=i.product_id and a.user_id=i.user_id and i.product_id=3366
left join (
	select product_id,user_id,shop_item_type,cancel_subscription_time from (
		select product_id,user_id,
				case when shop_item_id in (850) then 'VIP'
					when shop_item_id in (810) then 'SVIP'
					 when shop_item_id in (830,840,800) then '签到卡'
				end as shop_item_type,
				cancel_time as cancel_subscription_time,
				row_number() over(partition by product_id,user_id order by cancel_time desc) rn
		from  dwd.`dwd_pay_order_notify`
		where order_status=1 and date(cancel_time)<='${bf_1_dt}' and shop_item_id in(850,810,830,840,800) and notify_type=3
	) a
	where rn=1
) j on a.product_id=j.product_id and a.user_id=j.user_id and j.product_id=3366
left join dwd.`dwd_sr_user_subscribe_expire_time` k on a.product_id=k.product_id and a.user_id=k.user_id and k.product_id=3366
;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_offline_label
-- workflow_version : 72
-- create_user      : zhengtt
-- task_name        : ads_offline_label_stat_other
-- task_version     : 17
-- update_time      : 2025-05-15 16:09:08
-- sql_path         : \starrocks\tbl_ads_offline_label\ads_offline_label_stat_other
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_offline_label_stat where dt = '${bf_1_dt}' and product_id not in (3322,3366,3388);

-- SQL语句
insert into ads.ads_offline_label_stat
select  a.product_id,a.user_id,
        if(a.nick_name = '', null, a.nick_name) as nick_name,
        case a.sex
            when 1 then '男'
            when 2 then '女'
            when 3 then '保密'
            else '未知'
            end   as sex,
        a.age,
        if(a.nation = '', null, a.nation) as nation,
        if(a.province = '', null, a.province) as province,
        if(a.city = '', null, a.city) as city,
        a.group_hash,
        a.group_id_1,a.group_id_2,a.group_id_3,a.group_id_4,a.server_version,a.continous_sign_days,
        if(a.reg_nation = '', null, a.reg_nation) as reg_nation,
        if(a.reg_province = '', null, a.reg_province) as reg_province,
        if(a.reg_city = '', null, a.reg_city) as reg_city,
        a.reg_time,a.reg_language,a.cur_language,a.coin_cnt,
        a.certificate_cnt,a.medal_cnt,a.register_day,a.is_new_user,a.recharged,
        if(a.is_nopay is null, -99, a.is_nopay) as is_nopay,
        a.is_iaa,
        if(a.is_invite is null, -99, a.is_invite) as is_invite,
        a.medal_expire_time,a.last_welfare_purcharse_time,a.last_plus_purcharse_time,
        a.welfare_expire_time,a.plus_expire_time,a.highest_recharge,a.auto_change_tag,
        if(a.ad_tag = '', null, a.ad_tag) as ad_tag,
        a.ad_quality,
        b.imei,b.imsi,b.guid,b.mac,b.model,b.manufacturer,b.price_level,b.screen_width,b.screen_height,
        b.os_type,b.os_verison,b.app_id,c.first_login_time,c.last_login_time,c.new_login_time,c.first_login_ip,
        c.last_login_ip,c.new_login_ip,c.first_login_location,c.last_login_location,c.new_login_location,c.remain_day,
        c.login_days,c.login_times,
        if(c.user_login_type is null,'流失用户',c.user_login_type) as user_login_type,
        if(d.start_read_chapters is null,0,d.start_read_chapters) as start_read_chapters,
        if(e.start_read_time is null,0,e.start_read_time) as start_read_time,
        d.start_day_read_chapters,
        e.start_day_read_time,if(d.total_read_chp is null,0,d.total_read_chp) as total_read_chp,e.total_read_time,d.total_read_bookid,d.total_read_books,
        e.more_onem_total_read_bookid,e.more_onem_total_read_books,d.total_read_days,
        if(d.new_chp_book_cnt is null,0,d.new_chp_book_cnt) as new_chp_book_cnt,
        d.new_chp_bookid_chpid,e.read_time_td/d.total_read_days as read_time_da_avg,f.start_subscribe,
        f.start_subscribe_type,f.start_subscribe_time,f.last_subscribe,f.last_subscribe_type,f.last_subscribe_time,
        f.is_month_card,f.is_subscribeing,f.subscribe_cnt,f.shopitems,
        if(f.mul_subscribe is null,0,f.mul_subscribe) as mul_subscribe,
        if(f.his_subscribe is null,0,f.his_subscribe) as his_subscribe,
        f.first_recharge,f.first_recharge_time,f.total_recharge,f.recharge_cnt,f.recharge_avg,f.recharge_max,
        f.month_recharge_max,f.last_recharge,f.last_recharge_time,f.start_bat_ulk_gear,f.start_bat_ulk_chp_cnt,
        f.total_bat_ulk_cnt,f.total_fix_ulk_cnt,f.start_sup_ulk_chp_cnt,f.sup_ulk_cnt,f.sup_ulk_sum,f.coin_consumption,
        f.certificate_consumption,f.purcharse_cnt,f.last_purcharse_time,f.total_consumption,
        null as recency,null as frequency,null as monetary,null as r_score,null as f_score,null as m_score,
        null as rfm_customer_tag,null as rfm_value_tag,null as rfm_vocational_tag,null as cac,null as pbp,
        null as ltv1,null as ltv2,null as ltv3,null as ltv4,null as ltv5,null as ltv6,null as ltv7,
        null as ltv15,null as ltv30,null as ltv45,null as ltv60,null as ltv90,null as recent_frequency_1d,
        null as recent_frequency_2d,null as recent_frequency_3d,null as recent_frequency_4d,
        null as recent_frequency_5d,null as recent_frequency_6d,null as recent_frequency_7d,
        null as recent_frequency_15d,null as recent_frequency_30d,null as recent_frequency_60d,
        null as recent_frequency_90d,null as recent_monetary_1d,null as recent_monetary_2d,
        null as recent_monetary_3d,null as recent_monetary_4d,null as recent_monetary_5d,
        null as recent_monetary_6d,null as recent_monetary_7d,null as recent_monetary_15d,
        null as recent_monetary_30d,null as recent_monetary_60d,null as recent_monetary_90d,
        a.mt,a.corever,a.current_language2,a.country,
        case country_level
            when 1 then 't1'
            when 2 then 't2'
            end   as country_level,
        g.first_book,g.last_book,null as first_adid,
        null as last_adid,a.dt,a.account,h.last_active_dt,i.user_ad_source,j.shop_item_type,ifnull(j.cancel_subscription_time,'1970-01-01') as cancel_subscription_time
		,ifnull(k.vip_expire_time,'1970-01-01') as vip_expire_time,ifnull(k.svip_expire_time,'1970-01-01') as svip_expire_time,ifnull(k.sign_expire_time,'1970-01-01') as sign_expire_time
from
(   select 	dt,product_id,user_id,nick_name,sex,age,nation,province,city,group_hash,group_id_1,group_id_2,
            group_id_3,group_id_4,server_version,continous_sign_days,reg_nation,reg_province,reg_city,
            reg_time,reg_language,cur_language,coin_cnt,certificate_cnt,medal_cnt,register_day,is_new_user,
            recharged,is_nopay,is_iaa,is_invite,medal_expire_time,last_welfare_purcharse_time,
            last_plus_purcharse_time,welfare_expire_time,plus_expire_time,highest_recharge,
            auto_change_tag,ad_tag,ad_quality,mt,corever,current_language2,country,country_level,account
    from ads.ads_offline_label_user_account_info
    where dt = '${bf_1_dt}' and product_id not in (3322,3366,3388)
    ) a
left join
(   select 	product_id,user_id,imei,imsi,guid,mac,model,manufacturer,
            price_level,screen_width,screen_height,os_type,os_verison,app_id
    from  ads.ads_offline_label_user_device_info
    where  dt = '${bf_1_dt}' and product_id not in (3322,3366,3388)
) b
on a.product_id = b.product_id and a.user_id = b.user_id
left join
(   select 	product_id,user_id,first_login_time,last_login_time,new_login_time,first_login_ip,
            last_login_ip,new_login_ip,first_login_location,last_login_location,
            new_login_location,remain_day,login_days,login_times,user_login_type
    from ads.ads_offline_label_user_login_info
    where  dt = '${bf_1_dt}' and product_id not in (3322,3366,3388)
    ) c
on a.product_id = c.product_id and a.user_id = c.user_id
left join
(   select 	product_id,user_id,start_read_chapters,start_day_read_chapters,total_read_chp,
            total_read_bookid,total_read_books,total_read_days,new_chp_book_cnt,new_chp_bookid_chpid
    from ads.ads_offline_label_user_read_chapter
    where dt = '${bf_1_dt}' and product_id not in (3322,3366,3388)
) d
on a.product_id = d.product_id and a.user_id = d.user_id
left join
(   select 	product_id,user_id,start_read_time,start_day_read_time,total_read_time,
              more_onem_total_read_bookid,more_onem_total_read_books,read_time_td
    from ads.ads_offline_label_user_read_time
    where dt = '${bf_1_dt}' and product_id not in (3322,3366,3388)
) e
on a.product_id = e.product_id and a.user_id = e.user_id
left join
(   select 	user_id,product_id,start_subscribe,start_subscribe_type,start_subscribe_time,last_subscribe,
            last_subscribe_type,last_subscribe_time,is_month_card,is_subscribeing,subscribe_cnt,
            shopitems,mul_subscribe,his_subscribe,first_recharge,first_recharge_time,total_recharge,
            recharge_cnt,recharge_avg,recharge_max,month_recharge_max,last_recharge,last_recharge_time,
            start_bat_ulk_gear,start_bat_ulk_chp_cnt,total_bat_ulk_cnt,total_fix_ulk_cnt,
            start_sup_ulk_chp_cnt,sup_ulk_cnt,sup_ulk_sum,coin_consumption,certificate_consumption,
            purcharse_cnt,last_purcharse_time,total_consumption
    from ads.ads_offline_label_user_recharge_consume
    where dt = '${bf_1_dt}' and product_id not in (3322,3366,3388)
    ) f
on a.product_id = f.product_id and a.user_id = f.user_id
left join
(   select dt,product_id,user_id,mt,corever,current_language2,first_book,last_book
    from ads.ads_offline_label_user_info_wide_a_view
    where dt = '${bf_1_dt}' and product_id not in (3322,3366,3388)
    ) g
on a.product_id = g.product_id and a.user_id = g.user_id and a.mt = g.mt
    and a.corever = g.corever and a.current_language2 = g.current_language2
left join
(
	select product_id,user_id,max(dt) as last_active_dt
	from dws.dws_user_wide_active_ed
	where product_id not in (3322,3366,3388)
	group by 1,2
) h on a.product_id=h.product_id and a.user_id=h.user_id
left join dim.`dim_user_all_info` i on a.product_id=i.product_id and a.user_id=i.user_id and i.product_id not in (3322,3366,3388)
left join (
	select product_id,user_id,shop_item_type,cancel_subscription_time from (
		select product_id,user_id,
				case when shop_item_id in (850) then 'VIP'
					when shop_item_id in (810) then 'SVIP'
					 when shop_item_id in (830,840,800) then '签到卡'
				end as shop_item_type,
				cancel_time as cancel_subscription_time,
				row_number() over(partition by product_id,user_id order by cancel_time desc) rn
		from  dwd.`dwd_pay_order_notify`
		where order_status=1 and date(cancel_time)<='${bf_1_dt}' and shop_item_id in(850,810,830,840,800)  and notify_type=3
	) a
	where rn=1
) j on a.product_id=j.product_id and a.user_id=j.user_id and j.product_id not in (3322,3366,3388)
left join dwd.`dwd_sr_user_subscribe_expire_time` k on a.product_id=k.product_id and a.user_id=k.user_id and k.product_id not in (3322,3366,3388)
;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_offline_label
-- workflow_version : 72
-- create_user      : zhengtt
-- task_name        : ads_offline_label_stat_pt
-- task_version     : 18
-- update_time      : 2025-05-15 16:09:08
-- sql_path         : \starrocks\tbl_ads_offline_label\ads_offline_label_stat_pt
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_offline_label_stat where dt = '${bf_1_dt}' and product_id = 3322;

-- SQL语句
insert into ads.ads_offline_label_stat
select  a.product_id,a.user_id,
        if(a.nick_name = '', null, a.nick_name) as nick_name,
        case a.sex
            when 1 then '男'
            when 2 then '女'
            when 3 then '保密'
            else '未知'
            end   as sex,
        a.age,
        if(a.nation = '', null, a.nation) as nation,
        if(a.province = '', null, a.province) as province,
        if(a.city = '', null, a.city) as city,
        a.group_hash,
        a.group_id_1,a.group_id_2,a.group_id_3,a.group_id_4,a.server_version,a.continous_sign_days,
        if(a.reg_nation = '', null, a.reg_nation) as reg_nation,
        if(a.reg_province = '', null, a.reg_province) as reg_province,
        if(a.reg_city = '', null, a.reg_city) as reg_city,
        a.reg_time,a.reg_language,a.cur_language,a.coin_cnt,
        a.certificate_cnt,a.medal_cnt,a.register_day,a.is_new_user,a.recharged,
        if(a.is_nopay is null, -99, a.is_nopay) as is_nopay,
        a.is_iaa,
        if(a.is_invite is null, -99, a.is_invite) as is_invite,
        a.medal_expire_time,a.last_welfare_purcharse_time,a.last_plus_purcharse_time,
        a.welfare_expire_time,a.plus_expire_time,a.highest_recharge,a.auto_change_tag,
        if(a.ad_tag = '', null, a.ad_tag) as ad_tag,
        a.ad_quality,
        b.imei,b.imsi,b.guid,b.mac,b.model,b.manufacturer,b.price_level,b.screen_width,b.screen_height,
        b.os_type,b.os_verison,b.app_id,c.first_login_time,c.last_login_time,c.new_login_time,c.first_login_ip,
        c.last_login_ip,c.new_login_ip,c.first_login_location,c.last_login_location,c.new_login_location,c.remain_day,
        c.login_days,c.login_times,
        if(c.user_login_type is null,'流失用户',c.user_login_type) as user_login_type,
        if(d.start_read_chapters is null,0,d.start_read_chapters) as start_read_chapters,
        if(e.start_read_time is null,0,e.start_read_time) as start_read_time,
        d.start_day_read_chapters,
        e.start_day_read_time,if(d.total_read_chp is null,0,d.total_read_chp) as total_read_chp,e.total_read_time,d.total_read_bookid,d.total_read_books,
        e.more_onem_total_read_bookid,e.more_onem_total_read_books,d.total_read_days,
        if(d.new_chp_book_cnt is null,0,d.new_chp_book_cnt) as new_chp_book_cnt,
        d.new_chp_bookid_chpid,e.read_time_td/d.total_read_days as read_time_da_avg,f.start_subscribe,
        f.start_subscribe_type,f.start_subscribe_time,f.last_subscribe,f.last_subscribe_type,f.last_subscribe_time,
        f.is_month_card,f.is_subscribeing,f.subscribe_cnt,f.shopitems,
        if(f.mul_subscribe is null,0,f.mul_subscribe) as mul_subscribe,
        if(f.his_subscribe is null,0,f.his_subscribe) as his_subscribe,
        f.first_recharge,f.first_recharge_time,f.total_recharge,f.recharge_cnt,f.recharge_avg,f.recharge_max,
        f.month_recharge_max,f.last_recharge,f.last_recharge_time,f.start_bat_ulk_gear,f.start_bat_ulk_chp_cnt,
        f.total_bat_ulk_cnt,f.total_fix_ulk_cnt,f.start_sup_ulk_chp_cnt,f.sup_ulk_cnt,f.sup_ulk_sum,f.coin_consumption,
        f.certificate_consumption,f.purcharse_cnt,f.last_purcharse_time,f.total_consumption,
        null as recency,null as frequency,null as monetary,null as r_score,null as f_score,null as m_score,
        null as rfm_customer_tag,null as rfm_value_tag,null as rfm_vocational_tag,null as cac,null as pbp,
        null as ltv1,null as ltv2,null as ltv3,null as ltv4,null as ltv5,null as ltv6,null as ltv7,
        null as ltv15,null as ltv30,null as ltv45,null as ltv60,null as ltv90,null as recent_frequency_1d,
        null as recent_frequency_2d,null as recent_frequency_3d,null as recent_frequency_4d,
        null as recent_frequency_5d,null as recent_frequency_6d,null as recent_frequency_7d,
        null as recent_frequency_15d,null as recent_frequency_30d,null as recent_frequency_60d,
        null as recent_frequency_90d,null as recent_monetary_1d,null as recent_monetary_2d,
        null as recent_monetary_3d,null as recent_monetary_4d,null as recent_monetary_5d,
        null as recent_monetary_6d,null as recent_monetary_7d,null as recent_monetary_15d,
        null as recent_monetary_30d,null as recent_monetary_60d,null as recent_monetary_90d,
        a.mt,a.corever,a.current_language2,a.country,
        case country_level
            when 1 then 't1'
            when 2 then 't2'
            end   as country_level,
        g.first_book,g.last_book,null as first_adid,
        null as last_adid,a.dt,a.account,h.last_active_dt,i.user_ad_source,j.shop_item_type,ifnull(j.cancel_subscription_time,'1970-01-01') as cancel_subscription_time
		,ifnull(k.vip_expire_time,'1970-01-01') as vip_expire_time,ifnull(k.svip_expire_time,'1970-01-01') as svip_expire_time,ifnull(k.sign_expire_time,'1970-01-01') as sign_expire_time
from
(   select 	dt,product_id,user_id,nick_name,sex,age,nation,province,city,group_hash,group_id_1,group_id_2,
            group_id_3,group_id_4,server_version,continous_sign_days,reg_nation,reg_province,reg_city,
            reg_time,reg_language,cur_language,coin_cnt,certificate_cnt,medal_cnt,register_day,is_new_user,
            recharged,is_nopay,is_iaa,is_invite,medal_expire_time,last_welfare_purcharse_time,
            last_plus_purcharse_time,welfare_expire_time,plus_expire_time,highest_recharge,
            auto_change_tag,ad_tag,ad_quality,mt,corever,current_language2,country,country_level,account
    from ads.ads_offline_label_user_account_info
    where dt = '${bf_1_dt}' and product_id = 3322
    ) a
left join
(   select 	product_id,user_id,imei,imsi,guid,mac,model,manufacturer,
            price_level,screen_width,screen_height,os_type,os_verison,app_id
    from  ads.ads_offline_label_user_device_info
    where  dt = '${bf_1_dt}' and product_id = 3322
) b
on a.product_id = b.product_id and a.user_id = b.user_id
left join
(   select 	product_id,user_id,first_login_time,last_login_time,new_login_time,first_login_ip,
            last_login_ip,new_login_ip,first_login_location,last_login_location,
            new_login_location,remain_day,login_days,login_times,user_login_type
    from ads.ads_offline_label_user_login_info
    where  dt = '${bf_1_dt}' and product_id = 3322
    ) c
on a.product_id = c.product_id and a.user_id = c.user_id
left join
(   select 	product_id,user_id,start_read_chapters,start_day_read_chapters,total_read_chp,
            total_read_bookid,total_read_books,total_read_days,new_chp_book_cnt,new_chp_bookid_chpid
    from ads.ads_offline_label_user_read_chapter
    where dt = '${bf_1_dt}' and product_id = 3322
) d
on a.product_id = d.product_id and a.user_id = d.user_id
left join
(   select 	product_id,user_id,start_read_time,start_day_read_time,total_read_time,
              more_onem_total_read_bookid,more_onem_total_read_books,read_time_td
    from ads.ads_offline_label_user_read_time
    where dt = '${bf_1_dt}' and product_id = 3322
) e
on a.product_id = e.product_id and a.user_id = e.user_id
left join
(   select 	user_id,product_id,start_subscribe,start_subscribe_type,start_subscribe_time,last_subscribe,
            last_subscribe_type,last_subscribe_time,is_month_card,is_subscribeing,subscribe_cnt,
            shopitems,mul_subscribe,his_subscribe,first_recharge,first_recharge_time,total_recharge,
            recharge_cnt,recharge_avg,recharge_max,month_recharge_max,last_recharge,last_recharge_time,
            start_bat_ulk_gear,start_bat_ulk_chp_cnt,total_bat_ulk_cnt,total_fix_ulk_cnt,
            start_sup_ulk_chp_cnt,sup_ulk_cnt,sup_ulk_sum,coin_consumption,certificate_consumption,
            purcharse_cnt,last_purcharse_time,total_consumption
    from ads.ads_offline_label_user_recharge_consume
    where dt = '${bf_1_dt}' and product_id = 3322
    ) f
on a.product_id = f.product_id and a.user_id = f.user_id
left join
(   select dt,product_id,user_id,mt,corever,current_language2,first_book,last_book
    from ads.ads_offline_label_user_info_wide_a_view
    where dt = '${bf_1_dt}' and product_id = 3322
    ) g
on a.product_id = g.product_id and a.user_id = g.user_id and a.mt = g.mt
    and a.corever = g.corever and a.current_language2 = g.current_language2
left join
(
	select product_id,user_id,max(dt) as last_active_dt
	from dws.dws_user_wide_active_ed
	where  product_id = 3322
	group by 1,2
) h on a.product_id=h.product_id and a.user_id=h.user_id
left join dim.`dim_user_all_info` i on a.product_id=i.product_id and a.user_id=i.user_id and i.product_id=3322
left join (
	select product_id,user_id,shop_item_type,cancel_subscription_time from (
		select product_id,user_id,
				case when shop_item_id in (850) then 'VIP'
					when shop_item_id in (810) then 'SVIP'
					 when shop_item_id in (830,840,800) then '签到卡'
				end as shop_item_type,
				cancel_time as cancel_subscription_time,
				row_number() over(partition by product_id,user_id order by cancel_time desc) rn
		from  dwd.`dwd_pay_order_notify`
		where order_status=1 and date(cancel_time)<='${bf_1_dt}'  and shop_item_id in(850,810,830,840,800) and notify_type=3
	) a
	where rn=1
) j on a.product_id=j.product_id and a.user_id=j.user_id and j.product_id=3322
left join dwd.`dwd_sr_user_subscribe_expire_time` k on a.product_id=k.product_id and a.user_id=k.user_id and k.product_id=3322
;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_offline_label
-- workflow_version : 72
-- create_user      : zhengtt
-- task_name        : ads_offline_label_stat_sp
-- task_version     : 9
-- update_time      : 2025-05-15 16:09:08
-- sql_path         : \starrocks\tbl_ads_offline_label\ads_offline_label_stat_sp
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_offline_label_stat where dt = '${bf_1_dt}' and product_id = 3388;

-- SQL语句
insert into ads.ads_offline_label_stat
select  a.product_id,a.user_id,
        if(a.nick_name = '', null, a.nick_name) as nick_name,
        case a.sex
            when 1 then '男'
            when 2 then '女'
            when 3 then '保密'
            else '未知'
            end   as sex,
        a.age,
        if(a.nation = '', null, a.nation) as nation,
        if(a.province = '', null, a.province) as province,
        if(a.city = '', null, a.city) as city,
        a.group_hash,
        a.group_id_1,a.group_id_2,a.group_id_3,a.group_id_4,a.server_version,a.continous_sign_days,
        if(a.reg_nation = '', null, a.reg_nation) as reg_nation,
        if(a.reg_province = '', null, a.reg_province) as reg_province,
        if(a.reg_city = '', null, a.reg_city) as reg_city,
        a.reg_time,a.reg_language,a.cur_language,a.coin_cnt,
        a.certificate_cnt,a.medal_cnt,a.register_day,a.is_new_user,a.recharged,
        if(a.is_nopay is null, -99, a.is_nopay) as is_nopay,
        a.is_iaa,
        if(a.is_invite is null, -99, a.is_invite) as is_invite,
        a.medal_expire_time,a.last_welfare_purcharse_time,a.last_plus_purcharse_time,
        a.welfare_expire_time,a.plus_expire_time,a.highest_recharge,a.auto_change_tag,
        if(a.ad_tag = '', null, a.ad_tag) as ad_tag,
        a.ad_quality,
        b.imei,b.imsi,b.guid,b.mac,b.model,b.manufacturer,b.price_level,b.screen_width,b.screen_height,
        b.os_type,b.os_verison,b.app_id,c.first_login_time,c.last_login_time,c.new_login_time,c.first_login_ip,
        c.last_login_ip,c.new_login_ip,c.first_login_location,c.last_login_location,c.new_login_location,c.remain_day,
        c.login_days,c.login_times,
        if(c.user_login_type is null,'流失用户',c.user_login_type) as user_login_type,
        if(d.start_read_chapters is null,0,d.start_read_chapters) as start_read_chapters,
        if(e.start_read_time is null,0,e.start_read_time) as start_read_time,
        d.start_day_read_chapters,
        e.start_day_read_time,if(d.total_read_chp is null,0,d.total_read_chp) as total_read_chp,e.total_read_time,d.total_read_bookid,d.total_read_books,
        e.more_onem_total_read_bookid,e.more_onem_total_read_books,d.total_read_days,
        if(d.new_chp_book_cnt is null,0,d.new_chp_book_cnt) as new_chp_book_cnt,
        d.new_chp_bookid_chpid,e.read_time_td/d.total_read_days as read_time_da_avg,f.start_subscribe,
        f.start_subscribe_type,f.start_subscribe_time,f.last_subscribe,f.last_subscribe_type,f.last_subscribe_time,
        f.is_month_card,f.is_subscribeing,f.subscribe_cnt,f.shopitems,
        if(f.mul_subscribe is null,0,f.mul_subscribe) as mul_subscribe,
        if(f.his_subscribe is null,0,f.his_subscribe) as his_subscribe,
        f.first_recharge,f.first_recharge_time,f.total_recharge,f.recharge_cnt,f.recharge_avg,f.recharge_max,
        f.month_recharge_max,f.last_recharge,f.last_recharge_time,f.start_bat_ulk_gear,f.start_bat_ulk_chp_cnt,
        f.total_bat_ulk_cnt,f.total_fix_ulk_cnt,f.start_sup_ulk_chp_cnt,f.sup_ulk_cnt,f.sup_ulk_sum,f.coin_consumption,
        f.certificate_consumption,f.purcharse_cnt,f.last_purcharse_time,f.total_consumption,
        null as recency,null as frequency,null as monetary,null as r_score,null as f_score,null as m_score,
        null as rfm_customer_tag,null as rfm_value_tag,null as rfm_vocational_tag,null as cac,null as pbp,
        null as ltv1,null as ltv2,null as ltv3,null as ltv4,null as ltv5,null as ltv6,null as ltv7,
        null as ltv15,null as ltv30,null as ltv45,null as ltv60,null as ltv90,null as recent_frequency_1d,
        null as recent_frequency_2d,null as recent_frequency_3d,null as recent_frequency_4d,
        null as recent_frequency_5d,null as recent_frequency_6d,null as recent_frequency_7d,
        null as recent_frequency_15d,null as recent_frequency_30d,null as recent_frequency_60d,
        null as recent_frequency_90d,null as recent_monetary_1d,null as recent_monetary_2d,
        null as recent_monetary_3d,null as recent_monetary_4d,null as recent_monetary_5d,
        null as recent_monetary_6d,null as recent_monetary_7d,null as recent_monetary_15d,
        null as recent_monetary_30d,null as recent_monetary_60d,null as recent_monetary_90d,
        a.mt,a.corever,a.current_language2,a.country,
        case country_level
            when 1 then 't1'
            when 2 then 't2'
            end   as country_level,
        g.first_book,g.last_book,null as first_adid,
        null as last_adid,a.dt,a.account,h.last_active_dt,i.user_ad_source,j.shop_item_type,ifnull(j.cancel_subscription_time,'1970-01-01') as cancel_subscription_time
		,ifnull(k.vip_expire_time,'1970-01-01') as vip_expire_time,ifnull(k.svip_expire_time,'1970-01-01') as svip_expire_time,ifnull(k.sign_expire_time,'1970-01-01') as sign_expire_time
from
(   select 	dt,product_id,user_id,nick_name,sex,age,nation,province,city,group_hash,group_id_1,group_id_2,
            group_id_3,group_id_4,server_version,continous_sign_days,reg_nation,reg_province,reg_city,
            reg_time,reg_language,cur_language,coin_cnt,certificate_cnt,medal_cnt,register_day,is_new_user,
            recharged,is_nopay,is_iaa,is_invite,medal_expire_time,last_welfare_purcharse_time,
            last_plus_purcharse_time,welfare_expire_time,plus_expire_time,highest_recharge,
            auto_change_tag,ad_tag,ad_quality,mt,corever,current_language2,country,country_level,account
    from ads.ads_offline_label_user_account_info
    where dt = '${bf_1_dt}' and  product_id = 3388
    ) a
left join
(   select 	product_id,user_id,imei,imsi,guid,mac,model,manufacturer,
            price_level,screen_width,screen_height,os_type,os_verison,app_id
    from  ads.ads_offline_label_user_device_info
    where  dt = '${bf_1_dt}' and  product_id = 3388
) b
on a.product_id = b.product_id and a.user_id = b.user_id
left join
(   select 	product_id,user_id,first_login_time,last_login_time,new_login_time,first_login_ip,
            last_login_ip,new_login_ip,first_login_location,last_login_location,
            new_login_location,remain_day,login_days,login_times,user_login_type
    from ads.ads_offline_label_user_login_info
    where  dt = '${bf_1_dt}' and  product_id = 3388
    ) c
on a.product_id = c.product_id and a.user_id = c.user_id
left join
(   select 	product_id,user_id,start_read_chapters,start_day_read_chapters,total_read_chp,
            total_read_bookid,total_read_books,total_read_days,new_chp_book_cnt,new_chp_bookid_chpid
    from ads.ads_offline_label_user_read_chapter
    where dt = '${bf_1_dt}' and  product_id = 3388
) d
on a.product_id = d.product_id and a.user_id = d.user_id
left join
(   select 	product_id,user_id,start_read_time,start_day_read_time,total_read_time,
              more_onem_total_read_bookid,more_onem_total_read_books,read_time_td
    from ads.ads_offline_label_user_read_time
    where dt = '${bf_1_dt}' and  product_id = 3388
) e
on a.product_id = e.product_id and a.user_id = e.user_id
left join
(   select 	user_id,product_id,start_subscribe,start_subscribe_type,start_subscribe_time,last_subscribe,
            last_subscribe_type,last_subscribe_time,is_month_card,is_subscribeing,subscribe_cnt,
            shopitems,mul_subscribe,his_subscribe,first_recharge,first_recharge_time,total_recharge,
            recharge_cnt,recharge_avg,recharge_max,month_recharge_max,last_recharge,last_recharge_time,
            start_bat_ulk_gear,start_bat_ulk_chp_cnt,total_bat_ulk_cnt,total_fix_ulk_cnt,
            start_sup_ulk_chp_cnt,sup_ulk_cnt,sup_ulk_sum,coin_consumption,certificate_consumption,
            purcharse_cnt,last_purcharse_time,total_consumption
    from ads.ads_offline_label_user_recharge_consume
    where dt = '${bf_1_dt}' and  product_id = 3388
    ) f
on a.product_id = f.product_id and a.user_id = f.user_id
left join
(   select dt,product_id,user_id,mt,corever,current_language2,first_book,last_book
    from ads.ads_offline_label_user_info_wide_a_view
    where dt = '${bf_1_dt}' and  product_id = 3388
    ) g
on a.product_id = g.product_id and a.user_id = g.user_id and a.mt = g.mt
    and a.corever = g.corever and a.current_language2 = g.current_language2
left join
(
	select product_id,user_id,max(dt) as last_active_dt
	from dws.dws_user_wide_active_ed
	where product_id = 3388
	group by 1,2
) h on a.product_id=h.product_id and a.user_id=h.user_id
left join dim.`dim_user_all_info` i on a.product_id=i.product_id and a.user_id=i.user_id and i.product_id=3388
left join (
	select product_id,user_id,shop_item_type,cancel_subscription_time from (
		select product_id,user_id,
				case when shop_item_id in (850) then 'VIP'
					when shop_item_id in (810) then 'SVIP'
					 when shop_item_id in (830,840,800) then '签到卡'
				end as shop_item_type,
				cancel_time as cancel_subscription_time,
				row_number() over(partition by product_id,user_id order by cancel_time desc) rn
		from  dwd.`dwd_pay_order_notify`
		where order_status=1 and date(cancel_time)<='${bf_1_dt}' and shop_item_id in(850,810,830,840,800) and notify_type=3
	) a
	where rn=1
) j on a.product_id=j.product_id and a.user_id=j.user_id and j.product_id=3388
left join dwd.`dwd_sr_user_subscribe_expire_time` k on a.product_id=k.product_id and a.user_id=k.user_id and k.product_id=3388
;
