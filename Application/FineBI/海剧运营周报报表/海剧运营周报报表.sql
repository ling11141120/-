-- Active: 1776048021149@@192.168.100.116@19030@ads
with z1 as 
(select * from (
select 
	'海阅' AS identifier,
	dt,
	period_type,
	period_week,
	case 
		when mt='1' then 'iOS'
		when mt='4' then 'Android'
		else '其他'
	end as '平台',
	case 
		when country_level='1' then 'T1'
		when country_level='2' then 'T2'
	end as '国家等级',
	country as '国家',
	dic_reglang.remarks '注册语言',
	user_type,
	user_value,
	null as chl,
	case 
		when source_chl in ('fbgroup','fbpage','fbpost','social') then '社媒'
		when source_chl in ('unattributed','google-play','organic','(not set)','none') then '自然量'
		when source_chl in ('exlink','officialsite','pinterest','podcasts','rss','webshare','seoyt') then 'SEO媒体'
		when source_chl in ('facebook','fbs2s','tt','adwords','mediago','appleadservice','sem','mapit','tiktok app','applovin','kwai') then '广告媒体'
            when source_chl = 'pwa' then 'pwa'
         when source_chl  = 'pwa_edm' then 'pwa_edm'
		else '其他'
    end as '渠道来源',
	COALESCE(corever,'其他')  as 'core',
	source_chl,
	dau,
	recharge_cnt,
	consume_money,
    consume_pay_vip,
	consume_all,
	consume_money_cnt,
    consume_pay_vip_cnt,
	consume_all_cnt,
	recharge_amount,
	recharge_item_amt,
	vip_recharge_amt,
	limit_free_amt,
	consume_user_pay_cnt,
	consume_wide_all_cnt,
  	ad_amt,
	natural_consume_money,
	natural_presented_money,
	case 
	when cast(period_week as int)<10  
	then concat(substr(dt,1,4),'-0',period_week)
	when cast(period_week as int)>=52 and substr(dt,6,2) ='01' 
	then concat(substr(date_add(dt,-30),1,4),'-',period_week)
	else  concat(substr(dt,1,4),'-',period_week)  end week
from (
	select 
	*		
	from ads.ads_bi_growth_operations_weekly
	where 
		dt >='${开始时间}' and dt<='${结束时间}'
		and period_type in ('${用户类型}') 
	${if(len(是否VIP投流) == 0,"","and  if(vip_type in ('VIP投流','VIP投流1H'),'VIP投流','普通用户') in ('" + 是否VIP投流 + "')")}

    )a
left join (
	select 
		country,
		code
	from dim.dim_country_dic	
	)b
on a.reg_country=b.code
  left join dim.dim_dic dic_reglang  -- 注册语言
    on a.reg_language = dic_reglang.enum_id
    and dic_reglang.table_name = 'dim_producttype'
    and dic_reglang.dic_column = 'language_id'
)a
where 
1=1
	${if(len(平台) == 0,"","and  平台 in ('" + 平台 + "')")} 
	${if(len(国家等级) == 0,"","and  国家等级 in ('" + 国家等级 + "')")} 
	${if(len(注册语言) == 0,"","and  注册语言 in ('" + 注册语言 + "')")}
	${if(len(core) == 0,"","and  core in ('" + core + "')")}
	${if(len(渠道来源) == 0,"","and  
		case 
			when source_chl in ('fbgroup','fbpage','fbpost','social') then '社媒'
			when source_chl in ('unattributed','google-play','organic','(not set)','none') then '自然量'
			when source_chl in ('exlink','officialsite','pinterest','podcasts','rss','webshare','seoyt') then 'SEO媒体'
			when source_chl in ('facebook','fbs2s','tt','adwords','mediago','appleadservice','sem','mapit','tiktok app','applovin','kwai') then '广告媒体'
                   when source_chl = 'pwa' then 'pwa'
         when source_chl  = 'pwa_edm' then 'pwa_edm'
			else '其他'
        end in ('" + 渠道来源 + "')")} 
	${if(len(source_chl) == 0,"","and  source_chl in ('" + source_chl + "')")} 
),	
z2 as 	
(select * from (
select 
	'海剧' AS identifier,
	dt,
	period_type,
	period_week,
	case 
		when mt='1' then 'iOS'
		when mt='4' then 'Android'
		else '其他'
	end as '平台',
	case 
		when country_level= '1' then 'T1'
  		when country_level= '2' then 'T2'
	end as '国家等级',
	country as '国家',
	dic_reglang.remarks '注册语言',
	user_type,
	user_value,
	case
		when chl='moboreels-Android-GP' then '谷歌'
		when chl='moboreels-Android-UAxiaomi' then '小米'
		when chl='moboreels-Android-UAchuanyin' then '传音'
		when chl='moboreels-Android-YZnubia' then '努比亚'
		when chl='moboreels-Android-huaweistore' then '华为'
		when chl='moboreels-iOS-AppStore' then '苹果'
		when chl='en_core4_android_google' then '阅读core4'
		when chl='moboshort-Android-GP' then '短剧core2安卓'
  		when chl='moboreels-Android-UAoppo' then 'OPPO'
		when chl='moboreels-Android-UAvivo' then 'VIVO'
		else '其他'
	end as chl,
	case 
		when source_chl in ('fbgroup','fbpage','fbpost','social') then '社媒'
		when source_chl in ('unattributed','google-play','organic','(not set)','none') then '自然量'
		when source_chl in ('exlink','officialsite','pinterest','podcasts','rss','webshare','seoyt') then 'SEO媒体'
		when source_chl in ('facebook','fbs2s','tt','adwords','mediago','appleadservice','sem','mapit','tiktok app','applovin','kwai') then '广告媒体'
            when source_chl = 'pwa' then 'pwa'
         when source_chl  = 'pwa_edm' then 'pwa_edm'
		else '其他'
    end as '渠道来源',
    COALESCE(corever,'其他')  'core',
	source_chl,
	dau,
	recharge_cnt,
	consume_money,
    consume_pay_vip,
	consume_all,
	consume_money_cnt,
    consume_pay_vip_cnt,
	consume_all_cnt,
	recharge_amount,
	recharge_item_amt,
	vip_recharge_amt,
	limit_free_amt,
	consume_user_pay_cnt,
	consume_wide_all_cnt,
  	ad_amt,	
	natural_consume_money,
	natural_presented_money,
	case 
	when cast(period_week as int)<10  
	then concat(substr(dt,1,4),'-0',period_week)
	when cast(period_week as int)>=52 and substr(dt,6,2) ='01' 
	then concat(substr(date_add(dt,-30),1,4),'-',period_week)
	else  concat(substr(dt,1,4),'-',period_week)  end week
from (
	select 
	*
	from ads.ads_bi_video_growth_operations_weekly
	where 
		product_id = 6833
		and dt >='${开始时间}' and dt<='${结束时间}'
		and period_type in ('${用户类型}') 
    )a
left join (
	select 
		country,
		code
	from dim.dim_country_dic	
	)b 
on a.reg_country=b.code	 
  left join dim.dim_dic dic_reglang  -- 注册语言
    on a.reg_language = dic_reglang.enum_id
    and dic_reglang.table_name = 'dim_producttype'
    and dic_reglang.dic_column = 'language_id'
)a
where 
1=1
	${if(len(平台) == 0,"","and  平台 in ('" + 平台 + "')")} 
	${if(len(国家等级) == 0,"","and  国家等级 in ('" + 国家等级 + "')")} 
	${if(len(注册语言) == 0,"","and  注册语言 in ('" + 注册语言 + "')")}
	${if(len(core) == 0,"","and  core in ('" + core + "')")} 
	${if(len(渠道来源) == 0,"","and  
	case 
		when source_chl in ('fbgroup','fbpage','fbpost','social') then '社媒'
		when source_chl in ('unattributed','google-play','organic','(not set)','none') then '自然量'
		when source_chl in ('exlink','officialsite','pinterest','podcasts','rss','webshare','seoyt') then 'SEO媒体'
		when source_chl in ('facebook','fbs2s','tt','adwords','mediago','appleadservice','sem','mapit','tiktok app','applovin','kwai') then '广告媒体'
          when source_chl = 'pwa' then 'pwa'
         when source_chl  = 'pwa_edm' then 'pwa_edm'
		else '其他'
    end in ('" + 渠道来源 + "')")} 
	${if(len(source_chl) == 0,"","and  source_chl in ('" + source_chl + "')")} 	
),	
z3 as	
(select * from (
select 
	'国剧' AS identifier,
	dt,
	period_type,
	period_week,
	case 
		when mt='1' then 'iOS'
		when mt='4' then 'Android'
		else '其他'
	end as '平台',
	case 
		when country_level= '1' then 'T1'
  		when country_level= '2' then 'T2'
	end as '国家等级',
	null as '国家',
	case 
		when reg_language='1' then '中文'
		else '其他'
	end as '注册语言',
	user_type,
	user_value,
	null as chl,
	null as '渠道来源',
	null as core,
	null as source_chl,
	dau,
	recharge_cnt,
	consume_money,
    consume_pay_vip,
	consume_all,
	consume_money_cnt,
    consume_pay_vip_cnt,
	consume_all_cnt,
	recharge_amount,
	recharge_item_amt,
	vip_recharge_amt,
	limit_free_amt,
	consume_user_pay_cnt,
	consume_wide_all_cnt,
  	0 as ad_amt,
	natural_consume_money,
	natural_presented_money,
	case 
	when cast(period_week as int)<10  
	then concat(substr(dt,1,4),'-0',period_week)
	when cast(period_week as int)>=52 and substr(dt,6,2) ='01' 
	then concat(substr(date_add(dt,-30),1,4),'-',period_week)
	else  concat(substr(dt,1,4),'-',period_week)  end week
from ads.ads_bi_video_growth_operations_weekly
where 
	product_id = 6883
	and dt >='${开始时间}' and dt<='${结束时间}'
	and period_type in ('${用户类型}') 
    )a
where 
1=1
	${if(len(平台) == 0,"","and  平台 in ('" + 平台 + "')")} 
	${if(len(国家等级) == 0,"","and  国家等级 in ('" + 国家等级 + "')")} 
	${if(len(注册语言) == 0,"","and  注册语言 in ('" + 注册语言 + "')")} 
	${if(len(core) == 0,"","and  core in ('" + core + "')")} 	
)
select 
	dt,
	period_type,
	period_week,
	平台,
	国家等级,
	国家,
	注册语言,
	user_type,
	user_value,
	chl,
	渠道来源,
	core,
	source_chl,
	dau,
	recharge_cnt,
	consume_money,
    consume_pay_vip,
	consume_all,
	consume_money_cnt,
    consume_pay_vip_cnt,
	consume_all_cnt,
	recharge_amount,
	recharge_item_amt,
	vip_recharge_amt,
	limit_free_amt,
	consume_user_pay_cnt,
	consume_wide_all_cnt,
  	ad_amt,
	ifnull(natural_consume_money,0) + ifnull(natural_presented_money,0)非引流消耗金额,
	ifnull(natural_consume_money,0) 非引流阅币消耗金额,
	week
from ${if(identifier='海阅','z1',
  if(identifier='海剧','z2',
  if(identifier='国剧','z3','z1')))}
;


