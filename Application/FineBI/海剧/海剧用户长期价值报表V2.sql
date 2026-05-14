-------------------------------------------------
-- 应用报表：海剧-用户维度报表/海剧用户长期价值报表
-------------------------------------------------

select *
from(
SELECT
	dt,
    unt,
	country `注册国家`,
	cast(product_id as STRING) `产品名称`,
    GREATEST(  ltv0,ltv1,ltv2,ltv3,ltv4,
ltv5,ltv6,ltv7,ltv8,ltv9,
ltv10,ltv11,ltv12,ltv13,ltv14,
ltv15,ltv16,ltv17,ltv18,ltv19,
ltv20,ltv21,ltv22,ltv23,ltv24,
ltv25,ltv26,ltv27,ltv28,ltv29,
ltv30,ltv60,ltv90,ltv120   ) as `累计LTV`,
  	if(ltv0=0, null, ltv0) ltv0,
	if(ltv1=0, null, ltv1) ltv1,
	if(ltv2=0, null, ltv2) ltv2,
	if(ltv3=0, null, ltv3) ltv3,
	if(ltv4=0, null, ltv4) ltv4,
	if(ltv5=0, null, ltv5) ltv5,
	if(ltv6=0, null, ltv6) ltv6,
	if(ltv7=0, null, ltv7) ltv7,
	if(ltv8=0, null, ltv8) ltv8,
	if(ltv9=0, null, ltv9) ltv9,
	if(ltv10=0, null, ltv10) ltv10,
	if(ltv11=0, null, ltv11) ltv11,
	if(ltv12=0, null, ltv12) ltv12,
	if(ltv13=0, null, ltv13) ltv13,
	if(ltv14=0, null, ltv14) ltv14,
	if(ltv15=0, null, ltv15) ltv15,
	if(ltv16=0, null, ltv16) ltv16,
	if(ltv17=0, null, ltv17) ltv17,
	if(ltv18=0, null, ltv18) ltv18,
	if(ltv19=0, null, ltv19) ltv19,
	if(ltv20=0, null, ltv20) ltv20,
	if(ltv21=0, null, ltv21) ltv21,
	if(ltv22=0, null, ltv22) ltv22,
	if(ltv23=0, null, ltv23) ltv23,
	if(ltv24=0, null, ltv24) ltv24,
	if(ltv25=0, null, ltv25) ltv25,
	if(ltv26=0, null, ltv26) ltv26,
	if(ltv27=0, null, ltv27) ltv27,
	if(ltv28=0, null, ltv28) ltv28,
	if(ltv29=0, null, ltv29) ltv29,
	if(ltv30=0, null, ltv30) ltv30,
	if(ltv60=0, null, ltv60) ltv60,
	if(ltv90=0, null, ltv90) ltv90,
	if(ltv120=0, null, ltv120) ltv120,
	if(pay_user_cnt0=0, null, pay_user_cnt0) pay_user_cnt0,
	if(pay_user_cnt1=0, null, pay_user_cnt1) pay_user_cnt1,
	if(pay_user_cnt2=0, null, pay_user_cnt2) pay_user_cnt2,
	if(pay_user_cnt3=0, null, pay_user_cnt3) pay_user_cnt3,
	if(pay_user_cnt4=0, null, pay_user_cnt4) pay_user_cnt4,
	if(pay_user_cnt5=0, null, pay_user_cnt5) pay_user_cnt5,
	if(pay_user_cnt6=0, null, pay_user_cnt6) pay_user_cnt6,
	if(pay_user_cnt7=0, null, pay_user_cnt7) pay_user_cnt7,
	if(pay_user_cnt8=0, null, pay_user_cnt8) pay_user_cnt8,
	if(pay_user_cnt9=0, null, pay_user_cnt9) pay_user_cnt9,
	if(pay_user_cnt10=0, null, pay_user_cnt10) pay_user_cnt10,
	if(pay_user_cnt11=0, null, pay_user_cnt11) pay_user_cnt11,
	if(pay_user_cnt12=0, null, pay_user_cnt12) pay_user_cnt12,
	if(pay_user_cnt13=0, null, pay_user_cnt13) pay_user_cnt13,
	if(pay_user_cnt14=0, null, pay_user_cnt14) pay_user_cnt14,
	if(pay_user_cnt15=0, null, pay_user_cnt15) pay_user_cnt15,
	if(pay_user_cnt16=0, null, pay_user_cnt16) pay_user_cnt16,
	if(pay_user_cnt17=0, null, pay_user_cnt17) pay_user_cnt17,
	if(pay_user_cnt18=0, null, pay_user_cnt18) pay_user_cnt18,
	if(pay_user_cnt19=0, null, pay_user_cnt19) pay_user_cnt19,
	if(pay_user_cnt20=0, null, pay_user_cnt20) pay_user_cnt20,
	if(pay_user_cnt21=0, null, pay_user_cnt21) pay_user_cnt21,
	if(pay_user_cnt22=0, null, pay_user_cnt22) pay_user_cnt22,
	if(pay_user_cnt23=0, null, pay_user_cnt23) pay_user_cnt23,
	if(pay_user_cnt24=0, null, pay_user_cnt24) pay_user_cnt24,
	if(pay_user_cnt25=0, null, pay_user_cnt25) pay_user_cnt25,
	if(pay_user_cnt26=0, null, pay_user_cnt26) pay_user_cnt26,
	if(pay_user_cnt27=0, null, pay_user_cnt27) pay_user_cnt27,
	if(pay_user_cnt28=0, null, pay_user_cnt28) pay_user_cnt28,
	if(pay_user_cnt29=0, null, pay_user_cnt29) pay_user_cnt29,
	if(pay_user_cnt30=0, null, pay_user_cnt30) pay_user_cnt30,
	if(pay_user_cnt60=0, null, pay_user_cnt60) pay_user_cnt60,
	if(pay_user_cnt90=0, null, pay_user_cnt90) pay_user_cnt90,
	if(pay_user_cnt120=0, null, pay_user_cnt120) pay_user_cnt120,
  	case
  		when country_level =1 then 'T1'
  		when country_level =2 then 'T2'
  		else '其他'
 	end as  `国家等级`,
  cast(dt as varchar) `日`,
  concat( if(dayofweek(dt)=2, dt ,cast(previous_day(dt, 'Monday') as  STRING)) ,'(', weekofyear(dt) ,')' ) as `周`,
	substr(dt,1,7) as `月`,
  dic_mt.enum_name  `平台`,
	case when corever=15 then 'H5'
    else corever 	end as core,
	case
		when source = 1 then '自然和其他'
		when source = 2 then '官网'
		when source = 3 then '付费'
		else source
	end `渠道`,
	dic_reglang.remarks `注册语言`,
	case
		when user_period =1 then '新用户'
		when user_period =3 then 'RMT'
		else user_period
	end `用户周期`,
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
	end as `媒体`,
	case
		when source_chl in ('fbgroup','fbpage','fbpost','social') then '社媒'
		when source_chl in ('unattributed','google-play','organic','(not set)','none') then '自然量'
		when source_chl in ('exlink','officialsite','pinterest','podcasts','rss','webshare','seoyt') then 'SEO媒体'
		when source_chl in ('facebook','fbs2s','tt','adwords','mediago','appleadservice','sem','mapit','tiktok app','applovin','kwai') then '广告媒体'
		else '其他'
    end as '渠道来源',
	source_chl
from (
	select
		dt,
		unt,
		reg_country,
		product_id,
		corever,
		ltv0,
		ltv1,
		ltv2,
		ltv3,
		ltv4,
		ltv5,
		ltv6,
		ltv7,
		ltv8,
		ltv9,
		ltv10,
		ltv11,
		ltv12,
		ltv13,
		ltv14,
		ltv15,
		ltv16,
		ltv17,
		ltv18,
		ltv19,
		ltv20,
		ltv21,
		ltv22,
		ltv23,
		ltv24,
		ltv25,
		ltv26,
		ltv27,
		ltv28,
		ltv29,
		ltv30,
		ltv60,
		ltv90,
		ltv120,
		pay_user_cnt0,
		pay_user_cnt1,
		pay_user_cnt2,
		pay_user_cnt3,
		pay_user_cnt4,
		pay_user_cnt5,
		pay_user_cnt6,
		pay_user_cnt7,
		pay_user_cnt8,
		pay_user_cnt9,
		pay_user_cnt10,
		pay_user_cnt11,
		pay_user_cnt12,
		pay_user_cnt13,
		pay_user_cnt14,
		pay_user_cnt15,
		pay_user_cnt16,
		pay_user_cnt17,
		pay_user_cnt18,
		pay_user_cnt19,
		pay_user_cnt20,
		pay_user_cnt21,
		pay_user_cnt22,
		pay_user_cnt23,
		pay_user_cnt24,
		pay_user_cnt25,
		pay_user_cnt26,
		pay_user_cnt27,
		pay_user_cnt28,
		pay_user_cnt29,
		pay_user_cnt30,
		pay_user_cnt60,
		pay_user_cnt90,
		pay_user_cnt120,
		country_level,
		which_weeks,
		mt,
		source,
		current_language2,
		which_months,
		user_period,
		chl,
		source_chl
from  ${if(时区='东八区','ads.ads_bi_charge_ltv_view  t1',
        if(时区='西五区','ads.ads_bi_charge_ltv_est_view t1',
          'ads.ads_bi_charge_ltv_view  t1'))}
	where product_id ="6833"
        AND dt >= '${开始时间}'
		and dt <= '${结束时间}'
    ${if(时区='西五区', 'and dt < hours_add(now(),-38)' ,'')}  -- 西五区在第二天14点之后数据才完整
  ${if(len(CORE) == 0,"","and  corever  in ('" + CORE + "')")}
   ${if(len(最新引流渠道) == 0,"","and source_chl in ('" + 最新引流渠道 + "')")}
	)a
left join (
		select
			country,
			code
		from dim.dim_country_dic
		)b
on a.reg_country=b.code
  left join dim.dim_dic dic_reglang  -- 注册/投放语言
on a.current_language2 = dic_reglang.enum_id
and dic_reglang.table_name = 'dim_producttype'
and dic_reglang.dic_column = 'language_id'
  left join dim.dim_dic  dic_mt  -- mt
 on a.mt = dic_mt.enum_id
 and dic_mt.table_name = 'dim_user_accountinfo_df'
 and dic_mt.dic_column = 'mt'
)t1
 where
	1=1
	${if(len(终端) == 0,"","and  平台 in ('" + 终端 + "')")}
	${if(len(渠道) == 0,"","and  渠道 in ('" + 渠道 + "')")}
	${if(len(注册语言) == 0,"","and  注册语言 in ('" + 注册语言 + "')")}
	${if(len(用户周期) == 0,"","and  用户周期 in ('" + 用户周期 + "')")}
    ${if(len(国家等级) == 0,"","and  国家等级 in ('" + 国家等级 + "')")}
