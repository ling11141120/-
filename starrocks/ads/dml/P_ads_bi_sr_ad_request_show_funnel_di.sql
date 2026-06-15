----------------------------------------------------------------
-- 程序功能： 海阅-广告触达到播放转化bi底表
-- 程序名： P_ads_bi_sr_ad_request_show_funnel_di
-- 目标表： ads.ads_bi_sr_ad_request_show_funnel_di
-- 负责人： tyg
-- 开发日期：2026-06-11
----------------------------------------------------------------

insert into ads.ads_bi_sr_ad_request_to_show_funnel_detail_di
with raw_union as (
    select dt
         , login_id
         , app_id
         , app_core_ver
         , os
         , ad_id
         , app_version
         , ad_type
         , ad_position_id
         , request_result
         , null           as request_duration
         , 'request'      as event_stage
      from ads.ads_bi_sr_ad_request_view
     where dt = '${dt}'

union all

    select dt
         , login_id
         , app_id
         , app_core_ver
         , os
         , ad_id
         , app_version
         , ad_type
         , ad_position_id
         , null           as request_result
         , null           as request_duration
         , 'invocation'   as event_stage
      from ads.ads_bi_sr_ad_invocation_view
     where dt = '${dt}'

union all

    select dt
         , login_id
         , app_id
         , app_core_ver
         , os
         , ad_id
         , app_version
         , ad_type
         , ad_position_id
         , null             as request_result
         , request_duration
         , 'show_success'   as event_stage
      from ads.ads_bi_sr_ad_show_view
     where dt = '${dt}'

union all

    select dt
         , login_id
         , app_id
         , app_core_ver
         , os
         , ad_id
         , app_version
         , ad_type
         , ad_position_id
         , request_result
         , null           as request_duration
         , 'show_fail'    as event_stage
      from ads.ads_bi_sr_ad_trigger_view
     where dt = '${dt}'
)
, stage_data as (
    select dt
         , login_id
         , app_id
         , app_core_ver
         , os
         , ad_id
         , app_version
         , ad_type
         , case when ad_position_id in ('18', '62') then '18'
                when ad_position_id in ('60', '64') then '60'
                when ad_position_id in ('69', '75') then '69'
                when ad_position_id in ('70', '76') then '70'
                when ad_position_id in ('71', '77') then '71'
                when ad_position_id in ('72', '78') then '72'
                when ad_position_id in ('57', '74', '79') then '57'
                when ad_position_id in ('67', '73', '80') then '67'
                when ad_position_id in ('5', '61') then '5'
                when ad_position_id in ('19', '63') then '19'
                when ad_position_id in ('16', '66') then '16'
                when ad_position_id in ('22', '65') then '22'
                else ad_position_id
            end             as ad_position_id
         , request_result
         , request_duration
         , event_stage
      from raw_union
)
, user_info as (
    select distinct user_id
         , current_language2
         , reg_country
      from dws.dws_user_wide_active_period_ed
     where period_type = 'ctt'
)
, ad_type_map as (
    select distinct ad_show_type_name
         , ad_show_type
      from dim.dim_sr_ads_position_view
)
, with_dim as (
    select s.dt
         , case when s.app_core_ver is null then '其他' else cast(s.app_core_ver as varchar) end as core
         , case when s.os in ('Android', 'HarmonyOS') then 'Android'
                when s.os = 'iOS' then 'iOS'
                else 'Unknown'
            end                                       as mt
         , s.ad_id
         , s.app_version
         , coalesce(tm.ad_show_type_name, '未知')       as ad_show_type_name
         , case when s.ad_position_id in ('18', '60', '69', '70', '71', '72', '57', '67', '5', '19', '16', '22') then concat(coalesce(pos.ad_position_name, '未知'), '(合并)')
                when s.ad_position_id = -99 then '未知'
                else coalesce(pos.ad_position_name, '未知')
            end                                       as ad_position_name
         , coalesce(dl.remarks, '未知')                 as put_language
         , coalesce(dc.country, ui.reg_country, '未知') as reg_country
         , s.request_result
         , s.request_duration
         , s.event_stage
      from stage_data as s
      left join user_info as ui
        on cast(s.login_id as bigint) = ui.user_id
      left join ad_type_map as tm
        on s.ad_type = tm.ad_show_type
      left join dim.dim_sr_ads_position_view as pos
        on s.ad_position_id = pos.ad_position
      left join dim.dim_dic as dl
        on ui.current_language2 = dl.enum_id
       and dl.table_name = 'dim_producttype'
       and dl.dic_column = 'language_id'
      left join dim.dim_country_dic as dc
        on ui.reg_country = dc.code
)
select dt
     , core
     , mt
     , ad_id
     , app_version
     , ad_show_type_name
     , ad_position_name
     , put_language
     , reg_country
     , count(case when event_stage = 'request' then 1 end) as ad_request_pv
     , count(case when event_stage = 'request' and request_result = 'success' then 1 end) as ad_request_success_pv
     , count(case when event_stage = 'invocation' then 1 end) as ad_invocation_pv
     , count(case when event_stage = 'show_success' then 1 end) as ad_show_success_pv
     , sum(case when event_stage = 'show_success' then request_duration else 0 end) as total_show_duration
     , count(case when event_stage = 'show_fail' then 1 end) as ad_show_fail_pv
     , now()             as etl_time
  from with_dim
 where dt is not null
   and core is not null
   and mt is not null
   and ad_id is not null
   and app_version is not null
   and ad_show_type_name is not null
   and ad_position_name is not null
   and put_language is not null
   and reg_country is not null
 group by 1, 2, 3, 4, 5, 6, 7, 8, 9
;
