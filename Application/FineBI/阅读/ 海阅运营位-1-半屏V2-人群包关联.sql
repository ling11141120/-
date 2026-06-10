-------------------------------------------------
-- 应用报表：海阅-策略效果报表/海阅运营位漏斗报表
-------------------------------------------------

SELECT  t1.dt 日期
      ,count(distinct t1.user_id) as `活跃UV`
      ,count(distinct t2.user_id) as `人群包活跃`
      ,count(distinct t3.identity_user_id) as `资源位触达`
FROM dws.dws_srsv_wide_user_type_info_di t1
left JOIN ads.ads_market_realtime_group_log_view t2
    on t1.user_id = t2.user_id
  and t1.dt >= date(t2.create_time)
  and t1.dt <= end_time
  and t1.dt <= date_add(t2.dt,10)
  and t1.dt >= t2.dt
  and t2.dt between date_add('${开始时间}',-10) and  '${结束时间}'
  ${if(len(人群包ID) == 0,"and t2.dt = '1970-01-01' and 1=2","and  group_id in ('" + 人群包ID + "')")}
left join (
  select
    dt,identity_user_id
 -- from ads.ads_sensors_production_rechargeexposure_view t3
  from ods_log.ods_sensors_cd_video_production_rechargeexposure t3
  where dt between '${开始时间}' and  '${结束时间}'
  and project_id = 5
  and element_id in(100024,100025,100026,100365,100708)
  and recharge_type is not null
  ${if(len(CORE) == 0,"","and  app_core_ver in ('" + CORE + "')")}
	${if(len(包体语言) == 0,"","and  case
	when app_product_id='7777' then '安卓读书'
	when app_product_id='8888' then '畅读书城'
	when app_product_id='3333' then '繁体'
	when app_product_id='3366' then '英语'
	when app_product_id='3388' then '西语'
	when app_product_id='1111' then '小程序'
	when app_product_id='3322' then '葡语'
	when app_product_id='3311' then '法语'
	when app_product_id='3371' then '俄语'
	when app_product_id='3399' then '日语'
	when app_product_id='3501' then '印尼语'
	when app_product_id='3511' then '泰语'
	else app_product_id  end in ('" + 包体语言 + "')")}

	${if(len(终端) == 0,"","and  if(os in ('iOS','Android'),os,'其他')  in ('" + 终端 + "')")}
	${if(位置 = '半屏','and element_id in  (100708)',
	if(位置 = '商店页','and element_id in (100024,100025,100026,100365)',''))}
  group by 1,2
  ) t3
  on t1.dt = t3.dt
  ${if(len(人群包ID) == 0,"  and t1.user_id = t3.identity_user_id","  and t2.user_id = t3.identity_user_id")}
where t1.user_period = 2
	and t1.product_id not in (6833,6883)
    and t1.dt  between '${开始时间}' and  '${结束时间}'
    ${if(len(CORE) == 0,"","and  corever in ('" + CORE + "')")}
	${if(len(终端)  == 0,""," and case
       when mt = 1 then 'iOS'
       when mt = 4 then 'Android'
       else '其他' end in ('" + 终端 + "')")}
	${if(len(包体语言) == 0,"","and  case
	when product_id='7777' then '安卓读书'
	when product_id='8888' then '畅读书城'
	when product_id='3333' then '繁体'
	when product_id='3366' then '英语'
	when product_id='3388' then '西语'
	when product_id='1111' then '小程序'
	when product_id='3322' then '葡语'
	when product_id='3311' then '法语'
	when product_id='3371' then '俄语'
	when product_id='3399' then '日语'
	when product_id='3501' then '印尼语'
	when product_id='3511' then '泰语'
	else product_id end in ('" + 包体语言 + "')")}
	${if(len(注册语言) == 0,"","and  case
	when current_language2 = 1 then '简体'
	when current_language2 = 2 then '繁体'
	when current_language2 = 3 then '英语'
	when current_language2 = 4 then '西语'
	when current_language2 = 5 then '葡语'
	when current_language2 = 6 then '法语'
	when current_language2 = 7 then '俄语'
	when current_language2 = 8 then '意大利语'
	when current_language2 = 9 then '日语'
	when current_language2 = 10 then '阿拉伯语'
	when current_language2 = 11 then '印尼语'
	when current_language2 = 12 then '泰语'
	when current_language2 = 13 then '越南语'
	when current_language2 = 14 then '韩语'
	when current_language2 = 15 then '菲律宾语'
	when current_language2 = 16 then '德语'
	else current_language2  end  in ('" + 注册语言 + "')")}
group by t1.dt