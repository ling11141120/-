----------------------------------------------------------------
-- 程序功能： 北斗短剧用户分类统计表
-- 程序名： P_ads_sv_beidou_series_user_type_di
-- 目标表： ads.ads_sv_beidou_series_user_type_di
-- 负责人： roger
-- 开发日期：2026-01-26
-- 版本号： v1.0
----------------------------------------------------------------

insert into ads.ads_sv_beidou_series_user_type_di
with 
-- 当日观看用户
watch_user as (
    select dt
         , account_id as user_id
         , series_id
    from dwd.dwd_video_short_video_epis_history
    where dt >= '${bf_4_dt}'
      and dt <= '${dt}'
      and series_id is not null
    group by dt
           , account_id
           , series_id
),

-- 关联用户表和字典表获取core, language_code, country_name
user_with_info as (
    select w.dt
         , w.user_id
         , w.series_id
         , coalesce(u.corever2, 0)              as core
         , coalesce(u.current_language2, 0)     as language_code
         , coalesce(dic.cd_val_desc, 'Unknown') as country -- 国家名称(如:美国)
    from watch_user w
    left join dim.dim_short_video_user_accountinfo u
      on w.user_id = u.user_id
    left join dim.dim_pub_code_mapping_dict dic
      on dic.cd_col = 'ctry_cd'
     and dic.cd_val = u.reg_country
),

-- 用户充值类型(关联维表当日分区，获取用户类型)
-- 订阅用户：历史有订阅记录; IAP用户：有充值但未订阅; 免费用户：关联不上
user_pay_type as (
    select user_id
         , user_type                  as pay_type
         , date(first_pay_time)       as first_pay_date
         , date(first_subscribe_time) as first_subscribe_date
    from dim.dim_sv_user_pay_type_df
    where dt = (select max(dt) from dim.dim_sv_user_pay_type_df)
),

-- 用户分类聚合(按core, language_code分组)
user_type_stat as (
    select w.dt
         , w.core
         , w.language_code
         , w.series_id
         , case when p.pay_type is null then '免费用户'
                when w.dt >= p.first_subscribe_date then '订阅用户'
                when w.dt >= p.first_pay_date then 'IAP用户'
                else '免费用户'
            end as user_type
         , w.country
         , bitmap_agg(w.user_id) as user_count
    from user_with_info w
    left join user_pay_type p on w.user_id = p.user_id
    group by 1, 2, 3, 4, 5, 6
)

-- 最终输出
select s.dt
     , s.core
     , s.language_code
     , s.series_id
     , s.user_type
     , s.country
     , dic.cd_val_desc as language_name
     , v.series_code
     , v.series_name
     , s.user_count
     , now() as etl_time
from user_type_stat s
left join dim.dim_short_video_series_view v
    on s.series_id = v.series_id
left join dim.dim_pub_code_mapping_dict dic
    on dic.app_plat = 'pub'
   and dic.cd_col = 'lang_cd'
   and dic.cd_val = s.language_code
;
