-------------------------------------------------
-- 应用报表：海剧-策略效果报表/海剧PUSH下发监控报表
-------------------------------------------------

/*
  20260306
  PUSH底表替换，逻辑优化，ads_user_push_behavior_df project_id = 8
  底表不含桌面组件数据
*/

with dau as (
select
	${if(维度1 == "汇总","'汇总'", "a1.dt")} `维度1`,
	count(distinct a1.user_id) as dau,
	count(distinct case when app_notify=1 then a1.user_id end) msg_on
from dws.dws_user_short_video_wide_active_period_ed a1
left join dim.dim_short_video_user_accountinfo_daily a2
on a1.user_id=a2.user_id and a1.dt=a2.dt
where
	1=1
	and a1.product_id = 6833
       and period_type = 'ctt'
	and a1.dt BETWEEN  '${开始时间}' and '${结束时间}'
	${if(len(CORE) == 0,"","and a1.corever  in ('" + CORE + "')")}
	${if(len(终端) == 0,"","and  case
	when a1.mt=1 then 'iOS'
	when a1.mt=4 then 'Android'
 else '其他' end in ('" + 终端 + "')")}
GROUP by 1
) ,
z1 as (
SELECT  t1.dt
       ,t1.user_id
       ,coalesce(t1.core,t2.corever)                       AS core
       ,CASE WHEN t1.mt IN ('Android','iOS') THEN t1.mt
             WHEN t2.mt2 = 1 THEN 'iOS'
             WHEN t2.mt2 = 4 THEN 'Android'  ELSE '其他' END AS os
       ,t1.push_id
       ,case when t1.push_id = 101 then '本地PUSH'
             else t1.push_type end as push_type
       ,t1.push_name
       ,is_send
       ,is_received
       ,is_click
       ,is_act
FROM ads.ads_user_push_behavior_df t1
LEFT JOIN dim.dim_user_account_info_view t2
ON t1.user_id = t2.id
WHERE project_id = 8
AND t1.dt BETWEEN  '${开始时间}' AND '${结束时间}'

----本地push曝光
UNION ALL

select a.dt
    ,a.user_id
    ,a.corever
    ,a.os
    ,0 as push_id
    ,a.push_type
    ,a.push_name
    ,a.is_send
    ,a.is_received
    ,a.is_click
    ,if(z_dau.user_id is not null,1,0) as is_act
    from (
        SELECT dt
        ,user_id
        ,corever
        ,os
        ,push_type
        ,push_name
        ,COUNT(distinct if(event = '曝光',1,null))                            AS is_send
        ,COUNT(distinct if(event = '曝光',1,null))                            AS is_received
        ,COUNT(distinct if(event = '点击',1,null)) AS is_click
        from (
            SELECT  a2.dt
                ,a2.login_id AS user_id
                ,substr(a2.app_id,-4,1) corever
                ,a2.os       AS os
                ,'本地PUSH' push_type
                ,case when push_type='1' then '本地PUSH-定时签到'
                    when push_type='2' then '本地PUSH-沉默召回'
                    when push_type='3' then '本地PUSH-解锁屏幕'  else '其他' END AS push_name

                ,'曝光'       AS event
            FROM ads.ads_sensors_cd_video_ElmentExposure_view a2
            WHERE a2.dt BETWEEN  '${开始时间}' and '${结束时间}'
            AND a2.element_id = 210050   -- 本地PUSH
        )a
        group by 1,2,3,4,5,6
    )a
    left join dws.dws_user_short_video_wide_active_period_ed  z_dau
    ON a.user_id = z_dau.user_id AND a.dt = z_dau.dt AND z_dau.period_type = 'ctt'
    group by 1,2,3,4,5,6,7,8,9,10,11




UNION ALL
( -- 桌面组件
SELECT  dt
       ,user_id
       ,core
       ,os
       ,push_id
       ,push_type
       ,push_name
       ,COUNT(distinct if(event = '曝光',1,null))                            AS is_send
       ,COUNT(distinct if(event = '曝光',1,null))                            AS is_received
       ,COUNT(distinct if(event = '点击',1,null)) AS is_click
       ,1 as is_act
FROM
(
    ----实时活动曝光下发送达

         SELECT  a1.dt
              ,a1.login_id             AS user_id
              ,substr(a1.app_id,-4,1) AS core
              ,a1.os AS OS
              ,0 as push_id  ---20260509增加
              ,CASE WHEN os = 'Android' THEN '伪实时活动'
                  ELSE '实时活动' END push_type
              ,CASE
                     WHEN page_name IN ('视频内容页','200800') THEN '继续观看'  -- WHEN os = 'Android' THEN '伪实时活动通知'
                     WHEN page_name IN ('签到页','福利中心页','201000') THEN '福利中心'
                     WHEN page_name IN ('for you','MiniDrama') THEN 'for you' else '其他'
               END AS push_name
              ,'曝光'                    AS event
       FROM ads.ads_sensors_cd_video_ElmentExposure_view a1
       WHERE a1.dt  BETWEEN  '${开始时间}' and '${结束时间}'
       AND element_id = 210015
       AND project_id = 8

  ----小窗播放曝光
  	UNION ALL
        SELECT  a2.dt
            ,a2.login_id            AS user_id
            ,substr(a2.app_id,-4,1) AS core
            ,a2.os
            ,0 as push_id  ---20260509增加
            ,'小窗播放' push_type
            ,'小窗播放' push_name
            ,'曝光'                   AS event
        FROM ads.ads_sensors_cd_video_ElmentExposure_view a2
        WHERE a2.dt BETWEEN  '${开始时间}' and '${结束时间}'
        AND a2.element_id = 210012
        AND (substr(a2.app_id, -4, 1) = 4 AND replace(left(app_version, 5) , '.', '') >= 172 AND os = 'Android')
  	UNION ALL
        SELECT  a2.dt
            ,a2.login_id AS user_id
            ,substr(a2.app_id,-4,1) corever
            ,a2.os       AS os
            ,0 as push_id  ---20260509增加
            ,'正在播放' push_type
            ,'正在播放' push_name
            ,'曝光'       AS event
        FROM ads.ads_sensors_cd_video_ElmentExposure_view a2
        WHERE a2.dt BETWEEN  '${开始时间}' and '${结束时间}'
        AND a2.element_id = 210032
        AND a2.os = 'Android'
        AND substr(a2.app_id, -4, 1) = 1

 ----实时活动、live通知点击
  	UNION ALL
        SELECT  t1.dt
            ,login_id                                                                     AS user_id
            ,substr(t1.app_id,-4,1)                                                      AS core     ------需要增加pushID
            ,t1.os                                                                        AS os
            ,case when  t1.push_type in(3,4) and t1.os='iOS' then t1.push_id else 0 end         as push_id  ---20260509增加
            ,CASE WHEN os = 'Android' THEN '伪实时活动'
            WHEN t1.push_type in(3,4) and os='iOS' THEN 'Live通知'------20260509新增ios live通知
            ELSE '实时活动' END push_type
            ,CASE WHEN t1.push_type=4 and os='iOS' then dim_push.push_position_name  ------20260509新增ios live通知
                    WHEN page_name IN ('视频内容页','200800') THEN '继续观看'
                    WHEN page_name IN ('签到页','福利中心页','201000') THEN '福利中心'
                    WHEN page_name IN ('for you','MiniDrama') THEN 'for you'
                    ELSE '其他' END AS push_name
            ,'点击'                                                                         AS event
        FROM ads.ads_sensors_cd_video_elmentclick_view t1
        ------20260509新增ios live通知
        left JOIN
        ads.ads_tidb_short_video_center_push_position_view dim_push
	    ON t1.push_id = dim_push.id

        WHERE t1.dt  BETWEEN  '${开始时间}' and '${结束时间}'
        AND t1.element_id = 210015
        AND t1.project_id = 8
  	UNION ALL
        SELECT  a2.dt
            ,login_id               AS user_id
            ,substr(a2.app_id,-4,1) AS core
            ,a2.os as OS
            ,0 as push_id  ---20260509增加
            ,'小窗播放'                 AS push_type
            ,'小窗播放'                 AS push_name
            ,'点击'                  AS event
        FROM ads.ads_sensors_cd_video_elmentclick_view a2
        WHERE a2.dt  BETWEEN  '${开始时间}' and '${结束时间}'
        AND a2.element_id = 210012
        and (substr(a2.app_id,-4,1) = 4 and replace(left(app_version,5) , '.','') >= 172 and os = 'Android')
  	UNION ALL
        SELECT  a3.dt
            ,login_id as user_id
            ,substr(a3.app_id,-4,1) as core
            ,a3.os as OS
            ,0 as push_id  ---20260509增加
            ,'正在播放' as push_type
            ,'正在播放' as push_name
            ,'点击'                  AS event
        FROM ads.ads_sensors_cd_video_elmentclick_view a3
        WHERE a3.dt  BETWEEN  '${开始时间}' and '${结束时间}'
        AND a3.element_id = 210032
        AND a3.os = 'Android'
        AND substr(a3.app_id, -4, 1) = 1
) z0
GROUP BY  1,2,3,4,5,6,7  )
)




,
z2 as (
       select
              ${if(维度1 == "日期"," z1.dt  ", "'汇总'")} as  `维度1`
              ,${if(维度2 == "PUSH类型","z1.push_type  ", "'-'")}   `维度2`
              ,${if(维度3 == "PUSH名称","z1.push_name  ", "'-'")}   `维度3`
              ,0 as   `下发PV`
              ,count(distinct if(is_send=1 , z1.user_id,null)) as   `下发UV`
              ,count(distinct if(is_send=1 and is_act=1, z1.user_id,null)) as   `下发活跃UV`
              ,0 as   `送达PV`
              ,count(distinct if(is_received=1 , z1.user_id,null)) as   `送达UV`
              ,count(distinct if(is_received=1 and is_act=1, z1.user_id,null)) as   `送达活跃UV`
              ,0 as `点击PV`
              ,count(distinct if(is_click=1 , z1.user_id,null)) as   `点击UV`
       from z1
       where 1=1
       ${if(len(CORE) == 0,"","and z1.core  in ('" + CORE + "')")}
       ${if(len(终端) == 0,"","and  z1.os in ('" + 终端 + "')")}
       ${if(len(PUSHID) == 0,"","and push_id  in ('" + PUSHID + "')")}
       ${if(len(PUSH类型) == 0,"","and push_type  in ('" + PUSH类型 + "')")}
       ${if(len(PUSH名称) == 0,"","and push_name  in ('" + PUSH名称 + "')")}
       group by 1,2,3
)
select
     dau.维度1
    ,z2.维度2
    ,z2.维度3
    ,dau.dau as dau
    ,dau.msg_on 通知打开用户数
    ,0 as `消息生成PV`
    ,0 as `消息生成UV`
    ,z2.`下发PV`
    ,z2.`下发UV`
    ,z2.`下发活跃UV`
    ,z2.`送达活跃UV`
    ,z2.`送达PV`
    ,z2.`送达UV`
    ,z2.`点击PV`
    ,z2.`点击UV`
from dau
full join z2
on dau.维度1 = z2.维度1
