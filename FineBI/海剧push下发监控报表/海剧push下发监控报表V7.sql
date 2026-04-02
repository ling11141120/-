/*
  20260306
  PUSH底表替换，逻辑优化，ads_user_push_behavior_df project_id = 8
  底表不含桌面组件数据
*/

with dau as (
    select ${if(维度1 == "汇总","'汇总'", "a1.dt")}                       as `维度1`
         , count(distinct a1.user_id)                                   as dau
         , count(distinct case when app_notify = 1 then a1.user_id end) as msg_on
      from dws.dws_user_short_video_wide_active_period_ed  a1
      left join dim.dim_short_video_user_accountinfo_daily a2
        on a1.user_id = a2.user_id and a1.dt = a2.dt
     where 1 = 1
       and a1.product_id = 6833
       and period_type = 'ctt'
       and a1.dt between '${开始时间}' and '${结束时间}'
       ${if(len(CORE) == 0,"","and a1.corever  in ('" + CORE + "')")}
       ${if(len(终端) == 0,"","and  case when a1.mt=1 then 'iOS' when a1.mt=4 then 'Android' else '其他' end in ('" + 终端 + "')")}
     group by 1
)
, z1 as (
    select t1.dt
         , t1.user_id
         , coalesce(t1.core, t2.corever) as core
         , case when t1.mt in ('Android', 'iOS') then t1.mt
                when t2.mt2 = 1 then 'iOS'
                when t2.mt2 = 4 then 'Android'
                else '其他'
            end                           as os
         , t1.push_id
         , case when t1.push_id = 101 then '本地PUSH'
                else t1.push_type
            end                           as push_type
         , t1.push_name
         , is_send
         , is_received
         , is_click
         , is_act
      from ads.ads_user_push_behavior_df       t1
      left join dim.dim_user_account_info_view t2
        on t1.user_id = t2.id
     where project_id = 8
       and t1.dt between '${开始时间}' and '${结束时间}'
     union all
    -- 桌面组件
    select dt
         , user_id
         , core
         , os
         , 0                                           as push_id
         , push_type
         , push_name
         , count(distinct if(event = '曝光', 1, null))  as is_send
         , count(distinct if(event = '曝光', 1, null))  as is_received
         , count(distinct if(event = '点击', 1, null))  as is_click
         , 1                                           as is_act
      from (select a1.dt
                 , a1.login_id              as user_id
                 , substr(a1.app_id, -4, 1) as core
                 , a1.os                    as OS
                 , case when os = 'Android' then '伪实时活动'
                        else '实时活动'
                    end                      as push_type
                 , case
              when page_name in ('视频内容页', '200800') then '开始播放' -- WHEN os = 'Android' THEN '伪实时活动通知'
              when page_name in ('签到页', '福利中心页', '201000') then '去领取'
              when page_name in ('for you', 'MiniDrama') then 'for you'
              else '其他'
                   end                      as push_name
                 , '曝光'                   as event
              from ads.ads_sensors_cd_video_ElmentExposure_view a1
             where a1.dt between '${开始时间}' and '${结束时间}'
               and element_id = 210015
               and project_id = 8
             union all
            select a2.dt
                 , a2.login_id              as user_id
                 , substr(a2.app_id, -4, 1) as core
                 , a2.os                    as OS
                 , '小窗播放'               as push_type
                 , '小窗播放'               as push_name
                 , '曝光'                   as event
              from ads.ads_sensors_cd_video_ElmentExposure_view a2
             where a2.dt between '${开始时间}' and '${结束时间}'
               and a2.element_id = 210012
               and (substr(a2.app_id, -4, 1) = 4 and replace(left (app_version, 5), '.', '') >= 172 and
                    os = 'Android')
             union all
            select a2.dt
                 , a2.login_id              as user_id
                 , substr(a2.app_id, -4, 1) as corever
                 , a2.os                    as os
                 , '正在播放'               as push_type
                 , '正在播放'               as push_name
                 , '曝光'                   as event
              from ads.ads_sensors_cd_video_ElmentExposure_view a2
             where a2.dt between '${开始时间}' and '${结束时间}'
               and a2.element_id = 210032
               and a2.os = 'Android'
               and substr(a2.app_id, -4, 1) = 1
             union all
            select a2.dt
                 , a2.login_id              as user_id
                 , substr(a2.app_id, -4, 1) as corever
                 , a2.os                    as os
                 , '本地PUSH'               as push_type
                 , '本地PUSH'               as push_name
                 , '曝光'                   as event
              from ads.ads_sensors_cd_video_ElmentExposure_view a2
             where a2.dt between '${开始时间}' and '${结束时间}'
               and a2.element_id = 210050 -- 本地PUSH
             union all
            select t1.dt
                 , login_id                                                       as user_id
                 , substr(t1.app_id, -4, 1)                                       as core
                 , t1.os                                                          as os
                 , case when os = 'Android' then '伪实时活动' else '实时活动' end as push_type
                 , case when page_name in ('视频内容页', '200800') then '开始播放'
                        when page_name in ('签到页', '福利中心页', '201000') then '去领取'
                        when page_name in ('for you', 'MiniDrama') then 'for you'
                        else '其他'
                   end                                                            as push_name
                 , '点击'                                                         as event
              from ads.ads_sensors_cd_video_elmentclick_view t1
             where t1.dt between '${开始时间}' and '${结束时间}'
               and element_id = 210015
               and project_id = 8
             union all
            select a2.dt
                 , login_id                 as user_id
                 , substr(a2.app_id, -4, 1) as core
                 , a2.os                    as OS
                 , '小窗播放'               as push_type
                 , '小窗播放'               as push_name
                 , '点击'                   as event
              from ads.ads_sensors_cd_video_elmentclick_view a2
             where a2.dt between '${开始时间}' and '${结束时间}'
               and a2.element_id = 210012
               and (substr(a2.app_id, -4, 1) = 4 and replace(left (app_version, 5), '.', '') >= 172 and
                    os = 'Android')
             union all
            select a3.dt
                 , login_id                 as user_id
                 , substr(a3.app_id, -4, 1) as core
                 , a3.os                    as OS
                 , '正在播放'               as push_type
                 , '正在播放'               as push_name
                 , '点击'                   as event
              from ads.ads_sensors_cd_video_elmentclick_view a3
             where a3.dt between '${开始时间}' and '${结束时间}'
               and a3.element_id = 210032
               and a3.os = 'Android'
               and substr(a3.app_id, -4, 1) = 1
            ) z0
     group by 1, 2, 3, 4, 5, 6, 7

)
, z2 as (select ${if(维度1 == "日期"," z1.dt  ", "'汇总'")}                            as `维度1`
              , ${if(维度2 == "PUSH类型","z1.push_type  ", "'-'")}                    as `维度2`
              , ${if(维度3 == "PUSH名称","z1.push_name  ", "'-'")}                    as `维度3`
              , 0                                                                    as `下发PV`
              , count(distinct if(is_send = 1, z1.user_id, null))                    as `下发UV`
              , count(distinct if(is_send = 1 and is_act = 1, z1.user_id, null))     as `下发活跃UV`
              , 0                                                                    as `送达PV`
              , count(distinct if(is_received = 1, z1.user_id, null))                as `送达UV`
              , count(distinct if(is_received = 1 and is_act = 1, z1.user_id, null)) as `送达活跃UV`
              , 0                                                                    as `点击PV`
              , count(distinct if(is_click = 1, z1.user_id, null))                   as `点击UV`
           from z1
          where 1 = 1
              ${if(len(CORE) == 0,"","and z1.core  in ('" + CORE + "')")} ${if(len(终端) == 0,"","and  z1.os in ('" + 终端 + "')")} ${if(len(PUSHID) == 0,"","and push_id  in ('" + PUSHID + "')")} ${if(len(PUSH类型) == 0,"","and push_type  in ('" + PUSH类型 + "')")} ${if(len(PUSH名称) == 0,"","and push_name  in ('" + PUSH名称 + "')")}
          group by 1, 2, 3
)
select dau.`维度1`
     , z2.`维度2`
     , z2.`维度3`
     , dau.dau as dau
     , dau.msg_on `通知打开用户数`
     , 0 as `消息生成PV`
     , 0 as `消息生成UV`
     , z2.`下发PV`
     , z2.`下发UV`
     , z2.`下发活跃UV`
     , z2.`送达活跃UV`
     , z2.`送达PV`
     , z2.`送达UV`
     , z2.`点击PV`
     , z2.`点击UV`
  from dau
  full join z2
    on dau.`维度1` = z2.`维度1`
