-------------------------------------------------
-- 应用报表：海剧-用户维度报表/海剧用户长期价值报表
-------------------------------------------------

WITH z1 as (
SELECT
`DT_DAY`,
if(  dayofweek(DT_DAY)=2, DT_DAY ,cast(previous_day(DT_DAY, 'Monday') as  STRING) )   as `DT_WEEK`, -- 时差问题
substr(DT_DAY,1,7) as  `DT_MONTH`,
 z2.DAYN,
 z3.*,
--  unt as `人数`,
 case when z2.DAYN <10 then concat('L0', z2.DAYN)
 else concat('L', z2.DAYN)  end as `趋势`,   -- DAYN标记
 unt,
 ltv0 as `ltv0`,   --  NULL处理
 pay_user_cnt0 累计前0天付费用户数 ,
 case z2.DAYN
  when 0 then ltv0
  when 1 then if(ltv1=0,null,ltv1)
  when 2 then if(ltv2=0,null,ltv2)
  when 3 then if(ltv3=0,null,ltv3)
  when 4 then if(ltv4=0,null,ltv4)
  when 5 then if(ltv5=0,null,ltv5)
  when 6 then if(ltv6=0,null,ltv6)
  when 7 then if(ltv7=0,null,ltv7)
  when 8 then if(ltv8=0,null,ltv8)
  when 9 then if(ltv9=0,null,ltv9)
  when 10 then if(ltv10=0,null,ltv10)
  when 11 then if(ltv11=0,null,ltv11)
  when 12 then if(ltv12=0,null,ltv12)
  when 13 then if(ltv13=0,null,ltv13)
  when 14 then if(ltv14=0,null,ltv14)
  when 15 then if(ltv15=0,null,ltv15)
  when 16 then if(ltv16=0,null,ltv16)
  when 17 then if(ltv17=0,null,ltv17)
  when 18 then if(ltv18=0,null,ltv18)
  when 19 then if(ltv19=0,null,ltv19)
  when 20 then if(ltv20=0,null,ltv20)
  when 21 then if(ltv21=0,null,ltv21)
  when 22 then if(ltv22=0,null,ltv22)
  when 23 then if(ltv23=0,null,ltv23)
  when 24 then if(ltv24=0,null,ltv24)
  when 25 then if(ltv25=0,null,ltv25)
  when 26 then if(ltv26=0,null,ltv26)
  when 27 then if(ltv27=0,null,ltv27)
  when 28 then if(ltv28=0,null,ltv28)
  when 29 then if(ltv29=0,null,ltv29)
  when 30 then if(ltv30=0,null,ltv30)
  when 45 then if(ltv45=0,null,ltv45)
  when 60 then if(ltv60=0,null,ltv60)
  when 90 then if(ltv90=0,null,ltv90)
  when 120 then if(ltv120=0,null,ltv120) end as `LTVN`,
 case z2.DAYN
  when 0 then pay_user_cnt0
  when 1 then pay_user_cnt1
  when 2 then pay_user_cnt2
  when 3 then pay_user_cnt3
  when 4 then pay_user_cnt4
  when 5 then pay_user_cnt5
  when 6 then pay_user_cnt6
  when 7 then pay_user_cnt7
  when 8 then pay_user_cnt8
  when 9 then pay_user_cnt9
  when 10 then pay_user_cnt10
  when 11 then pay_user_cnt11
  when 12 then pay_user_cnt12
  when 13 then pay_user_cnt13
  when 14 then pay_user_cnt14
  when 15 then pay_user_cnt15
  when 16 then pay_user_cnt16
  when 17 then pay_user_cnt17
  when 18 then pay_user_cnt18
  when 19 then pay_user_cnt19
  when 20 then pay_user_cnt20
  when 21 then pay_user_cnt21
  when 22 then pay_user_cnt22
  when 23 then pay_user_cnt23
  when 24 then pay_user_cnt24
  when 25 then pay_user_cnt25
  when 26 then pay_user_cnt26
  when 27 then pay_user_cnt27
  when 28 then pay_user_cnt28
  when 29 then pay_user_cnt29
  when 30 then pay_user_cnt30
  when 45 then pay_user_cnt45
  when 60 then pay_user_cnt60
  when 90 then pay_user_cnt90
  when 120 then pay_user_cnt120
 end as `累计前N天付费用户数`
from
(
SELECT
    cast(dt as varchar) as `DT_DAY`,
    -- cast(which_weeks as varchar) `周`,
    -- IF(which_months <10,concat('0',which_months) , which_months) `月`,
    --  concat(cast(which_weeks as varchar) ,'-', min(  cast(dt as varchar)  ) over (partition by  cast(which_weeks as varchar)  ) )     `周信息`,
    sum(unt) as unt,
    sum(ltv0) ltv0,
    sum(ltv1) ltv1,
    sum(ltv2) ltv2,
    sum(ltv3) ltv3,
    sum(ltv4) ltv4,
    sum(ltv5) ltv5,
    sum(ltv6) ltv6,
    sum(ltv7) ltv7,
    sum(ltv8) ltv8,
    sum(ltv9) ltv9,
    sum(ltv10) ltv10,
    sum(ltv11) ltv11,
    sum(ltv12) ltv12,
    sum(ltv13) ltv13,
    sum(ltv14) ltv14,
    sum(ltv15) ltv15,
    sum(ltv16) ltv16,
    sum(ltv17) ltv17,
    sum(ltv18) ltv18,
    sum(ltv19) ltv19,
    sum(ltv20) ltv20,
    sum(ltv21) ltv21,
    sum(ltv22) ltv22,
    sum(ltv23) ltv23,
    sum(ltv24) ltv24,
    sum(ltv25) ltv25,
    sum(ltv26) ltv26,
    sum(ltv27) ltv27,
    sum(ltv28) ltv28,
    sum(ltv29) ltv29,
    sum(ltv30) ltv30,
	sum(ltv45) ltv45,
    sum(ltv60) ltv60,
    sum(ltv90) ltv90,
    sum(ltv120) ltv120,
    sum(pay_user_cnt0) pay_user_cnt0,
    sum(pay_user_cnt1) pay_user_cnt1,
    sum(pay_user_cnt2) pay_user_cnt2,
    sum(pay_user_cnt3) pay_user_cnt3,
    sum(pay_user_cnt4) pay_user_cnt4,
    sum(pay_user_cnt5) pay_user_cnt5,
    sum(pay_user_cnt6) pay_user_cnt6,
    sum(pay_user_cnt7) pay_user_cnt7,
    sum(pay_user_cnt8) pay_user_cnt8,
    sum(pay_user_cnt9) pay_user_cnt9,
    sum(pay_user_cnt10) pay_user_cnt10,
    sum(pay_user_cnt11) pay_user_cnt11,
    sum(pay_user_cnt12) pay_user_cnt12,
    sum(pay_user_cnt13) pay_user_cnt13,
    sum(pay_user_cnt14) pay_user_cnt14,
    sum(pay_user_cnt15) pay_user_cnt15,
    sum(pay_user_cnt16) pay_user_cnt16,
    sum(pay_user_cnt17) pay_user_cnt17,
    sum(pay_user_cnt18) pay_user_cnt18,
    sum(pay_user_cnt19) pay_user_cnt19,
    sum(pay_user_cnt20) pay_user_cnt20,
    sum(pay_user_cnt21) pay_user_cnt21,
    sum(pay_user_cnt22) pay_user_cnt22,
    sum(pay_user_cnt23) pay_user_cnt23,
    sum(pay_user_cnt24) pay_user_cnt24,
    sum(pay_user_cnt25) pay_user_cnt25,
    sum(pay_user_cnt26) pay_user_cnt26,
    sum(pay_user_cnt27) pay_user_cnt27,
    sum(pay_user_cnt28) pay_user_cnt28,
    sum(pay_user_cnt29) pay_user_cnt29,
    sum(pay_user_cnt30) pay_user_cnt30,
	sum(pay_user_cnt45) pay_user_cnt45,
    sum(pay_user_cnt60) pay_user_cnt60,
    sum(pay_user_cnt90) pay_user_cnt90,
    sum(pay_user_cnt120) pay_user_cnt120,
    1 as rk
from  ${if(时区='东八区','ads.ads_bi_charge_ltv_view  t1',
        if(时区='西五区','ads.ads_bi_charge_ltv_est_view t1',
          'ads.ads_bi_charge_ltv_view  t1'))}
left join dim.dim_dic  dic2
  on t1.current_language2 = dic2.enum_id
  and dic2.table_name = 'dim_producttype'
  and dic2.dic_column = 'language_id'
left join dim.dim_dic  dic_mt  -- mt
 on t1.mt = dic_mt.enum_id
 and dic_mt.table_name = 'dim_user_accountinfo_df'
 and dic_mt.dic_column = 'mt'
where dt >= '${开始时间}'
  and dt <= '${结束时间}'
  and product_id = 6833
  ${if(时区='西五区', 'and dt < hours_add(now(),-38)' ,'')}  -- 西五区在第二天14点之后数据才完整
  ${if(len(CORE) == 0,"","and  case  when corever=15 then 'H5'  else corever end in ('" + CORE + "')")}
  ${if(len(终端) == 0,"","and  dic_mt.enum_name in ('" + 终端 + "')")}
  ${if(len(注册语言) == 0,"","and  dic2.remarks in ('" + 注册语言 + "')")}
  ${if(len(国家等级) == 0,"","and  cast(country_level as varchar) in ('" + 国家等级 + "')")}
  ${if(len(渠道) == 0,"","and  case
	when source = 1 then '自然和其他'
	when source = 2 then '官网'
	when source = 3 then '付费'
	else source end   in ('" + 渠道 + "')")}
  ${if(len(用户周期) == 0,"","and  case
	when user_period =1 then '新用户'
	when user_period =3 then 'RMT'
	else user_period end in ('" + 用户周期 + "')")}
  ${if(len(媒体) == 0,"","and case
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
	end in ('" + 媒体 + "')")}
  ${if(len(渠道来源) == 0,"","and case
		when source_chl in ('fbgroup','fbpage','fbpost','social') then '社媒'
		when source_chl in ('unattributed','google-play','organic','(not set)','none') then '自然量'
		when source_chl in ('exlink','officialsite','pinterest','podcasts','rss','webshare','seoyt') then 'SEO媒体'
		when source_chl in ('facebook','fbs2s','tt','adwords','mediago','appleadservice','sem','mapit','tiktok app','applovin','kwai') then '广告媒体'
		else '其他'
    end in ('" + 渠道来源 + "')")}
    ${if(len(最新引流渠道) == 0,"","and source_chl in ('" + 最新引流渠道 + "')")}
GROUP BY 1 ) z1
LEFT JOIN
(
	SELECT  DAYOFYEAR(datestr) AS DAYN ,1   AS rk
	FROM dim.dim_date
	WHERE DAYOFYEAR(datestr) <= 30 or DAYOFYEAR(datestr) IN (45, 60, 90, 120)
	AND yearid = 2024
	GROUP BY  1
	UNION
	SELECT  0 AS DAYN,1   AS rk
) z2
ON z1.rk = z2.rk
LEFT JOIN
(
	SELECT  datestr
	       ,ROW_NUMBER() over(order by datestr)                     AS `排序`
	       ,ROW_NUMBER() over(order by datestr) /7                  AS `排序/7`
	    --   ,CEIL(ROW_NUMBER() over(order by datestr) /7)            AS `周维度`
           ,previous_day(datestr, 'Monday')                          as `周维度`
--            ,substr(datestr,1,7)                                     as  `月维度`
--	       ,CEIL((date_diff('day','${结束时间}','${开始时间}') +1)/7) AS `标记最大周`
	       ,date_diff('day',now() ,datestr) - 1                     AS `DAYN极限`
	FROM dim.dim_date
	WHERE datestr >= '${开始时间}'
	AND datestr <= '${结束时间}'
) z3
ON z1.DT_DAY = z3.datestr
)

select
  case when '${日期维度}' = '日' then DT_DAY
       when '${日期维度}' = '周' then DT_WEEK
       when '${日期维度}' = '月' then DT_MONTH
   else DT_DAY end as `周期`,
   `趋势`,
    case when '${日期维度}' = '日' then min(DT_DAY)
       when '${日期维度}' = '周' then CONCAT(min(DT_WEEK),  '(',weekofyear(MIN(DT_WEEK)),')')
       when '${日期维度}' = '月' then min(DT_MONTH)
   else  min(DT_DAY)  end as `日期维度`,
   SUM(LTVN)/sum(unt) as `LTV`,
   SUM(LTVN)/SUM(LTV0) AS `LTV-趋势`,
   SUM(累计前N天付费用户数)/sum(unt) as `付费率`,
   SUM(累计前N天付费用户数)/SUM(累计前0天付费用户数) AS `付费率-趋势`,
   SUM(LTVN)/sum(累计前N天付费用户数) as `累计ARPPU`,
   SUM(LTVN)/sum(累计前N天付费用户数)/(SUM(LTV0)/sum(累计前0天付费用户数)) AS `累计ARPPU-趋势`,
   count(if(DAYN >  `DAYN极限` ,1,null)) as `是否超过DAYN统计`,
   count(distinct DT_DAY) as `统计天数`
from z1
group by 1,2
having count(if(DAYN >  `DAYN极限` ,1,null))  = 0

${if(日期维度 == '周',"and  count(distinct DT_DAY) = 7 ","")}