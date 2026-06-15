-------------------------------------------------
-- 应用报表：阅读-策略效果报表/海阅广告效能报表
-------------------------------------------------

select
  z1.*
  ,CONCAT(ad_type,COALESCE(t3.ad_position_name,'')) as ad_position_name
  ,case when ad_position_id in ('18','62') then '半屏广告解锁'
        when ad_position_id in ('57') then '赠送免费章节弹窗激励视频'
        when ad_position_id in ('60','64') then '半屏广告解锁'

        when ad_position_id in ('19','63') then '签到弹窗-额外签到奖励'
        when ad_position_id in ('5','61') then '积分大厅激励任务'
        when ad_position_id in ('23') then '每日任务领取奖励'
        when ad_position_id in ('29') then '积分中心-宝箱'
        when ad_position_id in ('福利中心') then '福利中心任务'

        else '其他' end as ad_position_location
  ,case when ad_position_id in ('18','62','57','60','64') then '阅读页'
        when ad_position_id in ('19','63','5','61','23','29','福利中心') then '福利中心'
        else '其他' end as ad_position_scene
  ,coalesce(adinfo.name,'-') as strategy_name
  ,coalesce(adinfo.plancode,'-') as strategy_code
  ,case when  ad_strategy_id=1110010 then 'L0：福利中心v1.1（正常用户）'
     when  ad_strategy_id=1110024 then 'L5：D0未充值_D3+有充值-签到额外奖励和任务包含三方链接'
     when  ad_strategy_id=1110035 then 'L4：福利中心D3+未充值用户提升三方链接广告次数'
     when  ad_strategy_id=1110008 then '：【QA测试】福利中心（A版测试）'
     when  ad_strategy_id=1110034 then 'L8：福利中心-VIP投流'
     when  ad_strategy_id=1200008 then 'L7：福利中心-自然量无H5任务'
     when  ad_strategy_id=1110016 then 'L4V1：C1 D3+未充值-Mobking签到切流-10%'
     else  concat(coalesce(plancode,'/'),'：',adinfo.name)  end as strategy_ifno
from  (
    -- 原始广告位曝光
SELECT  dt
       ,login_id
       ,ad_position_id
       ,if(ad_position_id in ('19','63','5','61','23','29'),programme_id, ad_strategy_id)  as ad_strategy_id
       ,'曝光'     AS event
       ,'' as ad_type
       ,COUNT(1) AS pv
       ,0        AS amount
FROM ads.ads_sensors_production_ad_position_exposure_view
WHERE dt >= '${开始时间}' and dt <= '${结束时间}'
    and ad_position_id is not null
GROUP BY  1,2,3,4
UNION ALL
-- 福利中心H5广告曝光 (策略ID存方案）
select
       dt
       ,login_id
       ,'福利中心'           AS `ad_position_id`
       ,event_strategy_id as ad_strategy_id
       ,'曝光'     AS event
       ,'H5-' as ad_type
       ,COUNT(1) AS pv
       ,0 AS amount
from ads.ads_sensors_production_element_expose_view
  WHERE dt >= '${开始时间}' and dt <= '${结束时间}'
  and element_id = '100772'
  and type = '121'
group by 1,2,3,4
UNION ALL
-- H5广告位广告曝光
select
        dt
       ,login_id
       ,ad_position_id      AS `ad_position_id`
       ,if(ad_position_id in ('19','63','5','61','23','29'),programme_id, ad_strategy_id)  ad_strategy_id
       ,'曝光'     AS event
       ,'H5-' as ad_type
       ,COUNT(1) AS pv
       ,0 AS amount
from ads.ads_sensors_production_element_expose_view
  WHERE dt >= '${开始时间}' and dt <= '${结束时间}'
  and  element_id = '100356'
  and ad_position_id  > 0  -- 241113从19、60改为 > 0
group by 1,2,3,4
UNION ALL
-- 原始广告位点击
SELECT  dt
       ,login_id
       ,ad_position_id
       ,if(ad_position_id in ('19','63','5','61','23','29'),programme_id, ad_strategy_id)  ad_strategy_id
       ,'点击'     AS event
       ,'' as ad_type
       ,COUNT(1) AS pv
       ,0        AS amount
FROM ads.ads_sensors_production_adpositionclick_view
WHERE dt >= '${开始时间}' and dt <= '${结束时间}'
GROUP BY  1,2,3,4
UNION ALL
--   福利中心H5广告点击+收益  (神策有，数仓没有，用人群包转）
SELECT  t1.dt
       ,login_id
       ,'福利中心'           AS `ad_position_id`
       -- ,case parent_group_id
       --  when 180009 then 660018
       --  when 210008 then 360001
       --  when 600424 then 360002
       --  when 604010	then 540028
       --  when 8051865 then 1110010
       --  when 8062288 then 1110024
       --  when 8062871 then 1110024
       --  when 8064043 then 1110035
       --  when 8066069 then 1110008
       --  when 8070906 then 1110034
       --  when 8071666 then 1200008
       --  when 8071971 then 1110016 end as ad_strategy_id
       ,event_strategy_id as ad_strategy_id
       ,'点击'  AS event
       ,'H5-' as ad_type
       ,COUNT(1)         AS ad_click_count
       ,SUM(H5peramount) AS amount
--FROM dwd.dwd_sensors_production_complete_task_click_view t1
FROM ads.ads_sensors_production_complete_task_click_view t1
LEFT JOIN
(
	SELECT  dt
	       ,SUM(amt)/SUM(cnt ) AS H5peramount
	FROM dws.dws_advertisement_user_position_amt_ed
	WHERE dt >= '${开始时间}' and dt <= '${结束时间}'
	AND positions = '59'
	GROUP BY  dt
) t2
ON t1.dt = t2.dt
WHERE t1.dt >= '${开始时间}' and t1.dt <= '${结束时间}'
AND element_id = '100772'
AND type = '121'
GROUP BY  1,2,3,4
UNION ALL
 -- 广告位H5广告点击+收益
SELECT  t1.dt
       ,login_id
       ,ad_position_id
       ,if(ad_position_id in ('19','63','5','61','23','29'),programme_id, ad_strategy_id)  ad_strategy_id
       ,'点击'  AS event
       ,'H5-' as ad_type
       ,COUNT(1)         AS ad_click_count
       ,SUM(H5peramount) AS amount
FROM ads.ads_sensors_production_element_click_view t1
LEFT JOIN
(
	SELECT  dt
	       ,SUM(amt)/SUM(cnt ) AS H5peramount
	FROM dws.dws_advertisement_user_position_amt_ed
	WHERE dt >= '${开始时间}' and dt <= '${结束时间}'
	AND positions = '59'
	GROUP BY  dt
) t2
ON t1.dt = t2.dt
WHERE t1.dt >= '${开始时间}' and t1.dt <= '${结束时间}'
AND element_id = '100356'
AND ad_position_id > 0 -- 241113从19、60改为 > 0
AND app_product_id is not null
GROUP BY  1,2,3,4
UNION ALL
-- 广告位观看完成
SELECT  dt
       ,login_id
       ,ad_position_id
       ,if(ad_position_id in ('19','63','5','61','23','29'),programme_id, ad_strategy_id)  ad_strategy_id
       ,'观看完成'   AS event
       ,'' as ad_type
       ,COUNT(1) AS pv
       ,0 AS amount
FROM ads.ads_sensors_production_ad_watch_success_view
WHERE dt >= '${开始时间}' and dt <= '${结束时间}'
GROUP BY  1,2,3,4
UNION ALL
-- 常规广告收益
SELECT  dt
       ,login_id
       ,ad_position_id
       ,if(ad_position_id in ('19','63','5','61','23','29'),programme_id, ad_strategy_id)  ad_strategy_id
       ,'收益'       AS event
       ,'' as ad_type
       ,0            AS pv
       ,SUM( CASE WHEN os IN ('4','Android','HarmonyOS') AND ad_platform = 'AdMob' THEN ad_revenue/10000000000 else ad_revenue/10000 end ) AS amount
FROM ads.ads_sensors_production_ad_revenue_action_view
WHERE dt >= '${开始时间}' and dt <= '${结束时间}'
GROUP BY  1,2,3,4
union all --CORE2/3收益数据
SELECT   dt
        ,user_id
        ,'' AS ad_position_id
        ,0 AS ad_strategy_id
        ,'收益'
        ,'CORE2/3' as ad_type
        ,0 as pv
        ,sum(amt) as amount
FROM dws.dws_advertisement_user_position_amt_ed  -- 预估收益
WHERE  dt >= '${开始时间}' and dt <= '${结束时间}'
and core <> 1 and product_id  <> '6833'
GROUP BY  1,2
) z1
left join dim.dim_tag_center_ads_strategy_view  adinfo
 on z1.ad_strategy_id = adinfo.id
 left join dim.dim_sr_ads_position_view  t3
ON z1.ad_position_id = t3.ad_position
 left join  dws.dws_user_wide_active_period_ed t4
   on z1.dt = t4.dt
  --and period_type = 'ctt'
   and t4.dt >= '${开始时间}' and t4.dt <= '${结束时间}'
   and z1.login_id = t4.user_id
   ${if(len(周期类型) == 0,"","and period_type in ('" + 周期类型 + "')")}
 left join dim.dim_dic dic_lang
	on t4.current_language2 = dic_lang.enum_id
		and dic_lang.table_name = 'dim_producttype'
		and dic_lang.dic_column = 'language_id'
 left join dim.dim_dic  dic_mt
	on t4.mt = dic_mt.enum_id
		and dic_mt.table_name = 'dim_user_accountinfo_df'
		and dic_mt.dic_column = 'mt'
 left join dim.dim_country_dic b
	on t4.reg_country=b.code
where 1=1
--and event = '曝光'
    ${if(len(广告策略ID) == 0,"","and adinfo.id in ('" + 广告策略ID + "')")}
    ${if(len(广告策略代号) == 0,"","and adinfo.name in ('" + 广告策略代号 + "')")}
    ${if(len(周期类型) == 0,"","and period_type in ('" + 周期类型 + "')")}
    ${if(len(用户类型) == 0,"","and user_type in ('" + 用户类型 + "')")}
    ${if(len(注册国家) == 0,"","and coalesce(b.country,reg_country) in ('" + 注册国家 + "')")}
    ${if(len(投放语言) == 0,"","and dic_lang.remarks in ('" + 投放语言 + "')")}
    ${if(len(国家等级) == 0,"","and
        case
            when country_level =1 then 'T1'
            when country_level =2 then 'T2'
            else '其他'
        end in ('" + 国家等级 + "')")}
    ${if(len(终端) == 0,"","and dic_mt.enum_name in ('" + 终端 + "')")}
    ${if(len(CORE) == 0,"","and COALESCE(t4.corever,'其他') in ('" + CORE + "')")}
