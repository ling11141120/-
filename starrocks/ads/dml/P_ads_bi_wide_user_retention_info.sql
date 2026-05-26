----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_wide_user_retention_info
-- workflow_version : 21
-- create_user      : yanxh
-- task_name        : ads_bi_wide_user_retention_info
-- task_version     : 13
-- update_time      : 2025-12-23 11:49:57
-- sql_path         : \starrocks\tbl_ads_bi_wide_user_retention_info\ads_bi_wide_user_retention_info
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_bi_wide_user_retention_info
with
-- ========== 公共数据层 ==========
-- 活跃用户数据源（阅读+海剧）- 合并两个产品线的活跃数据，全局复用避免重复扫描
base_active_users as (
    select dt, product_id, user_id, mt, corever
    from dws.dws_user_wide_active_ed
    where product_id in (3311,3322,3333,3366,3371,3388,3501,3511)
    union all
    select dt, product_id, user_id, mt, corever
    from dws.dws_user_short_video_wide_active_ed
    where product_id in (6833)
),
-- 用户维度信息（统一获取）- 提前JOIN所有维度表，生成宽表，避免在每个留存计算中重复JOIN
base_user_dimensions as (
    select
        a.dt, a.product_id, a.user_id, a.corever, a.mt, a.reg_country, a.country_level,
        a.current_language2, a.source, a.last_source, a.user_period, a.is_pay, a.chl2, a.chl,
        b.user_ad_source,
        a.book_id  -- dws表已经将空字符串和NULL转为-1，直接使用
    from dws.dws_srsv_wide_user_type_info_di a
    left join dim.dim_user_other_info_view b
        on a.product_id = b.product_id and a.user_id = b.id
    where a.product_id in (3311,3322,3333,3366,3371,3388,3501,3511,6833)
),
-- ========== 活跃用户留存计算 ==========
-- 短周期留存（0-30天）- 计算活跃用户在31天内的每日留存情况
retention_active_short as (
    select
        a.dt,
        md5(concat_ws('_', a.dt, a.product_id, a.corever, a.mt, a.reg_country, a.country_level,
            a.current_language2, a.source, a.last_source, a.user_period, a.is_pay,
            datediff(b.dt, a.dt), a.chl2, a.chl, a.user_ad_source, a.book_id)) as md5_key,
        a.product_id, a.corever, a.mt, a.reg_country, a.country_level, a.current_language2,
        a.source, a.last_source, a.user_period, a.is_pay, a.chl2, a.chl, a.user_ad_source, a.book_id,
        datediff(b.dt, a.dt) as reg_days,
        count(distinct b.user_id) as retention_num,
        now() as etl_time
    from base_user_dimensions a
    left join base_active_users b
        on a.product_id = b.product_id
        and a.user_id = b.user_id
        and b.dt >= date_sub('${bf_1_dt}', interval 31 day)
        and b.dt >= a.dt
        and b.dt <= date_add(a.dt, interval 31 day)
    where a.dt >= date_sub('${bf_1_dt}', interval 31 day)
        and a.dt <= '${bf_1_dt}'
        and a.user_period = 2
    group by a.dt, a.product_id, a.corever, a.mt, a.reg_country, a.country_level,
        a.current_language2, a.source, a.last_source, a.user_period, a.is_pay,
        datediff(b.dt, a.dt), a.chl2, a.chl, a.user_ad_source, a.book_id
),
-- 长周期留存（60、90、120、150、180天）- 计算活跃用户在特定长周期节点的留存情况
retention_active_long as (
    select
        a.dt,
        md5(concat_ws('_', a.dt, a.product_id, a.corever, a.mt, a.reg_country, a.country_level,
            a.current_language2, a.source, a.last_source, a.user_period, a.is_pay,
            datediff(b.dt, a.dt), a.chl2, a.chl, a.user_ad_source, a.book_id)) as md5_key,
        a.product_id, a.corever, a.mt, a.reg_country, a.country_level, a.current_language2,
        a.source, a.last_source, a.user_period, a.is_pay, a.chl2, a.chl, a.user_ad_source, a.book_id,
        datediff(b.dt, a.dt) as reg_days,
        count(distinct b.user_id) as retention_num,
        now() as etl_time
    from base_user_dimensions a
    inner join base_active_users b
        on a.product_id = b.product_id
        and a.user_id = b.user_id
        and b.dt = '${bf_1_dt}'
        and (
            (a.dt = date_sub(b.dt, interval 60 day)) or
            (a.dt = date_sub(b.dt, interval 90 day)) or
            (a.dt = date_sub(b.dt, interval 120 day)) or
            (a.dt = date_sub(b.dt, interval 150 day)) or
            (a.dt = date_sub(b.dt, interval 180 day))
        )
    where a.user_period = 2
        and (
            (a.dt = date_sub('${bf_1_dt}', interval 60 day)) or
            (a.dt = date_sub('${bf_1_dt}', interval 90 day)) or
            (a.dt = date_sub('${bf_1_dt}', interval 120 day)) or
            (a.dt = date_sub('${bf_1_dt}', interval 150 day)) or
            (a.dt = date_sub('${bf_1_dt}', interval 180 day))
        )
    group by a.dt, a.product_id, a.corever, a.mt, a.reg_country, a.country_level,
        a.current_language2, a.source, a.last_source, a.user_period, a.is_pay,
        datediff(b.dt, a.dt), a.chl2, a.chl, a.user_ad_source, a.book_id
),
-- ========== 新用户留存计算 ==========
-- 短周期留存（0-30天）- 计算新用户在31天内的每日留存情况
retention_new_short as (
    select
        a.dt,
        md5(concat_ws('_', a.dt, a.product_id, a.corever, a.mt, a.reg_country, a.country_level,
            a.current_language2, a.source, a.last_source, a.user_period, a.is_pay,
            datediff(b.dt, a.dt), a.chl2, a.chl, a.user_ad_source, a.book_id)) as md5_key,
        a.product_id, a.corever, a.mt, a.reg_country, a.country_level, a.current_language2,
        a.source, a.last_source, a.user_period, a.is_pay, a.chl2, a.chl, a.user_ad_source, a.book_id,
        datediff(b.dt, a.dt) as reg_days,
        count(distinct b.user_id) as retention_num,
        now() as etl_time
    from base_user_dimensions a
    left join base_active_users b
        on a.product_id = b.product_id
        and a.user_id = b.user_id
        and b.dt >= date_sub('${bf_1_dt}', interval 31 day)
        and b.dt >= a.dt
        and b.dt <= date_add(a.dt, interval 31 day)
    where a.dt >= date_sub('${bf_1_dt}', interval 31 day)
        and a.dt <= '${bf_1_dt}'
        and a.user_period = 1
    group by a.dt, a.product_id, a.corever, a.mt, a.reg_country, a.country_level,
        a.current_language2, a.source, a.last_source, a.user_period, a.is_pay,
        datediff(b.dt, a.dt), a.chl2, a.chl, a.user_ad_source, a.book_id
),
-- 长周期留存（60、90、120、150、180天）- 计算新用户在特定长周期节点的留存情况
retention_new_long as (
    select
        a.dt,
        md5(concat_ws('_', a.dt, a.product_id, a.corever, a.mt, a.reg_country, a.country_level,
            a.current_language2, a.source, a.last_source, a.user_period, a.is_pay,
            datediff(b.dt, a.dt), a.chl2, a.chl, a.user_ad_source, a.book_id)) as md5_key,
        a.product_id, a.corever, a.mt, a.reg_country, a.country_level, a.current_language2,
        a.source, a.last_source, a.user_period, a.is_pay, a.chl2, a.chl, a.user_ad_source, a.book_id,
        datediff(b.dt, a.dt) as reg_days,
        count(distinct b.user_id) as retention_num,
        now() as etl_time
    from base_user_dimensions a
    inner join base_active_users b
        on a.product_id = b.product_id
        and a.user_id = b.user_id
        and b.dt = '${bf_1_dt}'
        and (
            (a.dt = date_sub(b.dt, interval 60 day)) or
            (a.dt = date_sub(b.dt, interval 90 day)) or
            (a.dt = date_sub(b.dt, interval 120 day)) or
            (a.dt = date_sub(b.dt, interval 150 day)) or
            (a.dt = date_sub(b.dt, interval 180 day))
        )
    where a.user_period = 1
        and (
            (a.dt = date_sub('${bf_1_dt}', interval 60 day)) or
            (a.dt = date_sub('${bf_1_dt}', interval 90 day)) or
            (a.dt = date_sub('${bf_1_dt}', interval 120 day)) or
            (a.dt = date_sub('${bf_1_dt}', interval 150 day)) or
            (a.dt = date_sub('${bf_1_dt}', interval 180 day))
        )
    group by a.dt, a.product_id, a.corever, a.mt, a.reg_country, a.country_level,
        a.current_language2, a.source, a.last_source, a.user_period, a.is_pay,
        datediff(b.dt, a.dt), a.chl2, a.chl, a.user_ad_source, a.book_id
),
-- ========== RMT用户留存计算 ==========
-- 短周期留存（0-30天）- 计算RMT用户在31天内的每日留存，需匹配mt和corever
retention_rmt_short as (
    select
        a.dt,
        md5(concat_ws('_', a.dt, a.product_id, a.corever, a.mt, a.reg_country, a.country_level,
            a.current_language2, a.source, a.last_source, a.user_period, a.is_pay,
            datediff(b.dt, a.dt), a.chl2, a.chl, a.user_ad_source, a.book_id)) as md5_key,
        a.product_id, a.corever, a.mt, a.reg_country, a.country_level, a.current_language2,
        a.source, a.last_source, a.user_period, a.is_pay, a.chl2, a.chl, a.user_ad_source, a.book_id,
        datediff(b.dt, a.dt) as reg_days,
        count(distinct b.user_id) as retention_num,
        now() as etl_time
    from base_user_dimensions a
    left join base_active_users b
        on a.product_id = b.product_id
        and a.user_id = b.user_id
        and a.mt = b.mt
        and a.corever = b.corever
        and b.dt >= date_sub('${bf_1_dt}', interval 31 day)
        and b.dt >= a.dt
        and b.dt <= date_add(a.dt, interval 31 day)
    where a.dt >= date_sub('${bf_1_dt}', interval 31 day)
        and a.dt <= '${bf_1_dt}'
        and a.user_period = 3
    group by a.dt, a.product_id, a.corever, a.mt, a.reg_country, a.country_level,
        a.current_language2, a.source, a.last_source, a.user_period, a.is_pay,
        datediff(b.dt, a.dt), a.chl2, a.chl, a.user_ad_source, a.book_id
),
-- 长周期留存（60、90、120、150、180天）- 计算RMT用户在特定长周期节点的留存，需匹配mt和corever
retention_rmt_long as (
    select
        a.dt,
        md5(concat_ws('_', a.dt, a.product_id, a.corever, a.mt, a.reg_country, a.country_level,
            a.current_language2, a.source, a.last_source, a.user_period, a.is_pay,
            datediff(b.dt, a.dt), a.chl2, a.chl, a.user_ad_source, a.book_id)) as md5_key,
        a.product_id, a.corever, a.mt, a.reg_country, a.country_level, a.current_language2,
        a.source, a.last_source, a.user_period, a.is_pay, a.chl2, a.chl, a.user_ad_source, a.book_id,
        datediff(b.dt, a.dt) as reg_days,
        count(distinct b.user_id) as retention_num,
        now() as etl_time
    from base_user_dimensions a
    inner join base_active_users b
        on a.product_id = b.product_id
        and a.user_id = b.user_id
        and a.mt = b.mt
        and a.corever = b.corever
        and b.dt = '${bf_1_dt}'
        and (
            (a.dt = date_sub(b.dt, interval 60 day)) or
            (a.dt = date_sub(b.dt, interval 90 day)) or
            (a.dt = date_sub(b.dt, interval 120 day)) or
            (a.dt = date_sub(b.dt, interval 150 day)) or
            (a.dt = date_sub(b.dt, interval 180 day))
        )
    where a.user_period = 3
        and (
            (a.dt = date_sub('${bf_1_dt}', interval 60 day)) or
            (a.dt = date_sub('${bf_1_dt}', interval 90 day)) or
            (a.dt = date_sub('${bf_1_dt}', interval 120 day)) or
            (a.dt = date_sub('${bf_1_dt}', interval 150 day)) or
            (a.dt = date_sub('${bf_1_dt}', interval 180 day))
        )
    group by a.dt, a.product_id, a.corever, a.mt, a.reg_country, a.country_level,
        a.current_language2, a.source, a.last_source, a.user_period, a.is_pay,
        datediff(b.dt, a.dt), a.chl2, a.chl, a.user_ad_source, a.book_id
)
-- ========== 合并所有留存数据 ==========
select * from retention_active_short
union all
select * from retention_active_long
union all
select * from retention_new_short
union all
select * from retention_new_long
union all
select * from retention_rmt_short
union all
select * from retention_rmt_long;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_srsv_wide_user_type_info_di_v3
-- workflow_version : 14
-- create_user      : chenmo
-- task_name        : tbl_ads_bi_wide_user_retention_info_v3
-- task_version     : 7
-- update_time      : 2025-12-23 17:53:41
-- sql_path         : \starrocks\tbl_dws_srsv_wide_user_type_info_di_v3\tbl_ads_bi_wide_user_retention_info_v3
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_bi_wide_user_retention_info where dt = '${bf_1_dt}';

-- SQL语句
insert into ads.ads_bi_wide_user_retention_info
with
-- ========== 公共数据层 ==========
-- 活跃用户数据源（阅读+海剧）- 合并两个产品线的活跃数据，全局复用避免重复扫描
base_active_users as (
    select dt, product_id, user_id, mt, corever
    from dws.dws_user_wide_active_ed
    where product_id in (3311,3322,3333,3366,3371,3388,3501,3511)
    union all
    select dt, product_id, user_id, mt, corever
    from dws.dws_user_short_video_wide_active_ed
    where product_id in (6833)
),
-- 用户维度信息（统一获取）- 提前JOIN所有维度表，生成宽表，避免在每个留存计算中重复JOIN
base_user_dimensions as (
    select
        a.dt, a.product_id, a.user_id, a.corever, a.mt, a.reg_country, a.country_level,
        a.current_language2, a.source, a.last_source, a.user_period, a.is_pay, a.chl2, a.chl,
        b.user_ad_source,
        a.book_id  -- dws表已经将空字符串和NULL转为-1，直接使用
    from dws.dws_srsv_wide_user_type_info_di a
    left join dim.dim_user_other_info_view b
        on a.product_id = b.product_id and a.user_id = b.id
    where a.product_id in (3311,3322,3333,3366,3371,3388,3501,3511,6833)
),
-- ========== 活跃用户留存计算 ==========
-- 短周期留存（0-30天）- 计算活跃用户在31天内的每日留存情况
retention_active_short as (
    select
        a.dt,
        md5(concat_ws('_', a.dt, a.product_id, a.corever, a.mt, a.reg_country, a.country_level,
            a.current_language2, a.source, a.last_source, a.user_period, a.is_pay,
            datediff(b.dt, a.dt), a.chl2, a.chl, a.user_ad_source, a.book_id)) as md5_key,
        a.product_id, a.corever, a.mt, a.reg_country, a.country_level, a.current_language2,
        a.source, a.last_source, a.user_period, a.is_pay, a.chl2, a.chl, a.user_ad_source, a.book_id,
        datediff(b.dt, a.dt) as reg_days,
        count(distinct b.user_id) as retention_num,
        now() as etl_time
    from base_user_dimensions a
    left join base_active_users b
        on a.product_id = b.product_id
        and a.user_id = b.user_id
        and b.dt >= date_sub('${bf_1_dt}', interval 31 day)
        and b.dt >= a.dt
        and b.dt <= date_add(a.dt, interval 31 day)
    where a.dt >= date_sub('${bf_1_dt}', interval 31 day)
        and a.dt <= '${bf_1_dt}'
        and a.user_period = 2
    group by a.dt, a.product_id, a.corever, a.mt, a.reg_country, a.country_level,
        a.current_language2, a.source, a.last_source, a.user_period, a.is_pay,
        datediff(b.dt, a.dt), a.chl2, a.chl, a.user_ad_source, a.book_id
),
-- 长周期留存（60、90、120、150、180天）- 计算活跃用户在特定长周期节点的留存情况
retention_active_long as (
    select
        a.dt,
        md5(concat_ws('_', a.dt, a.product_id, a.corever, a.mt, a.reg_country, a.country_level,
            a.current_language2, a.source, a.last_source, a.user_period, a.is_pay,
            datediff(b.dt, a.dt), a.chl2, a.chl, a.user_ad_source, a.book_id)) as md5_key,
        a.product_id, a.corever, a.mt, a.reg_country, a.country_level, a.current_language2,
        a.source, a.last_source, a.user_period, a.is_pay, a.chl2, a.chl, a.user_ad_source, a.book_id,
        datediff(b.dt, a.dt) as reg_days,
        count(distinct b.user_id) as retention_num,
        now() as etl_time
    from base_user_dimensions a
    inner join base_active_users b
        on a.product_id = b.product_id
        and a.user_id = b.user_id
        and b.dt = '${bf_1_dt}'
        and (
            (a.dt = date_sub(b.dt, interval 60 day)) or
            (a.dt = date_sub(b.dt, interval 90 day)) or
            (a.dt = date_sub(b.dt, interval 120 day)) or
            (a.dt = date_sub(b.dt, interval 150 day)) or
            (a.dt = date_sub(b.dt, interval 180 day))
        )
    where a.user_period = 2
        and (
            (a.dt = date_sub('${bf_1_dt}', interval 60 day)) or
            (a.dt = date_sub('${bf_1_dt}', interval 90 day)) or
            (a.dt = date_sub('${bf_1_dt}', interval 120 day)) or
            (a.dt = date_sub('${bf_1_dt}', interval 150 day)) or
            (a.dt = date_sub('${bf_1_dt}', interval 180 day))
        )
    group by a.dt, a.product_id, a.corever, a.mt, a.reg_country, a.country_level,
        a.current_language2, a.source, a.last_source, a.user_period, a.is_pay,
        datediff(b.dt, a.dt), a.chl2, a.chl, a.user_ad_source, a.book_id
),
-- ========== 新用户留存计算 ==========
-- 短周期留存（0-30天）- 计算新用户在31天内的每日留存情况
retention_new_short as (
    select
        a.dt,
        md5(concat_ws('_', a.dt, a.product_id, a.corever, a.mt, a.reg_country, a.country_level,
            a.current_language2, a.source, a.last_source, a.user_period, a.is_pay,
            datediff(b.dt, a.dt), a.chl2, a.chl, a.user_ad_source, a.book_id)) as md5_key,
        a.product_id, a.corever, a.mt, a.reg_country, a.country_level, a.current_language2,
        a.source, a.last_source, a.user_period, a.is_pay, a.chl2, a.chl, a.user_ad_source, a.book_id,
        datediff(b.dt, a.dt) as reg_days,
        count(distinct b.user_id) as retention_num,
        now() as etl_time
    from base_user_dimensions a
    left join base_active_users b
        on a.product_id = b.product_id
        and a.user_id = b.user_id
        and b.dt >= date_sub('${bf_1_dt}', interval 31 day)
        and b.dt >= a.dt
        and b.dt <= date_add(a.dt, interval 31 day)
    where a.dt >= date_sub('${bf_1_dt}', interval 31 day)
        and a.dt <= '${bf_1_dt}'
        and a.user_period = 1
    group by a.dt, a.product_id, a.corever, a.mt, a.reg_country, a.country_level,
        a.current_language2, a.source, a.last_source, a.user_period, a.is_pay,
        datediff(b.dt, a.dt), a.chl2, a.chl, a.user_ad_source, a.book_id
),
-- 长周期留存（60、90、120、150、180天）- 计算新用户在特定长周期节点的留存情况
retention_new_long as (
    select
        a.dt,
        md5(concat_ws('_', a.dt, a.product_id, a.corever, a.mt, a.reg_country, a.country_level,
            a.current_language2, a.source, a.last_source, a.user_period, a.is_pay,
            datediff(b.dt, a.dt), a.chl2, a.chl, a.user_ad_source, a.book_id)) as md5_key,
        a.product_id, a.corever, a.mt, a.reg_country, a.country_level, a.current_language2,
        a.source, a.last_source, a.user_period, a.is_pay, a.chl2, a.chl, a.user_ad_source, a.book_id,
        datediff(b.dt, a.dt) as reg_days,
        count(distinct b.user_id) as retention_num,
        now() as etl_time
    from base_user_dimensions a
    inner join base_active_users b
        on a.product_id = b.product_id
        and a.user_id = b.user_id
        and b.dt = '${bf_1_dt}'
        and (
            (a.dt = date_sub(b.dt, interval 60 day)) or
            (a.dt = date_sub(b.dt, interval 90 day)) or
            (a.dt = date_sub(b.dt, interval 120 day)) or
            (a.dt = date_sub(b.dt, interval 150 day)) or
            (a.dt = date_sub(b.dt, interval 180 day))
        )
    where a.user_period = 1
        and (
            (a.dt = date_sub('${bf_1_dt}', interval 60 day)) or
            (a.dt = date_sub('${bf_1_dt}', interval 90 day)) or
            (a.dt = date_sub('${bf_1_dt}', interval 120 day)) or
            (a.dt = date_sub('${bf_1_dt}', interval 150 day)) or
            (a.dt = date_sub('${bf_1_dt}', interval 180 day))
        )
    group by a.dt, a.product_id, a.corever, a.mt, a.reg_country, a.country_level,
        a.current_language2, a.source, a.last_source, a.user_period, a.is_pay,
        datediff(b.dt, a.dt), a.chl2, a.chl, a.user_ad_source, a.book_id
),
-- ========== RMT用户留存计算 ==========
-- 短周期留存（0-30天）- 计算RMT用户在31天内的每日留存，需匹配mt和corever
retention_rmt_short as (
    select
        a.dt,
        md5(concat_ws('_', a.dt, a.product_id, a.corever, a.mt, a.reg_country, a.country_level,
            a.current_language2, a.source, a.last_source, a.user_period, a.is_pay,
            datediff(b.dt, a.dt), a.chl2, a.chl, a.user_ad_source, a.book_id)) as md5_key,
        a.product_id, a.corever, a.mt, a.reg_country, a.country_level, a.current_language2,
        a.source, a.last_source, a.user_period, a.is_pay, a.chl2, a.chl, a.user_ad_source, a.book_id,
        datediff(b.dt, a.dt) as reg_days,
        count(distinct b.user_id) as retention_num,
        now() as etl_time
    from base_user_dimensions a
    left join base_active_users b
        on a.product_id = b.product_id
        and a.user_id = b.user_id
        and a.mt = b.mt
        and a.corever = b.corever
        and b.dt >= date_sub('${bf_1_dt}', interval 31 day)
        and b.dt >= a.dt
        and b.dt <= date_add(a.dt, interval 31 day)
    where a.dt >= date_sub('${bf_1_dt}', interval 31 day)
        and a.dt <= '${bf_1_dt}'
        and a.user_period = 3
    group by a.dt, a.product_id, a.corever, a.mt, a.reg_country, a.country_level,
        a.current_language2, a.source, a.last_source, a.user_period, a.is_pay,
        datediff(b.dt, a.dt), a.chl2, a.chl, a.user_ad_source, a.book_id
),
-- 长周期留存（60、90、120、150、180天）- 计算RMT用户在特定长周期节点的留存，需匹配mt和corever
retention_rmt_long as (
    select
        a.dt,
        md5(concat_ws('_', a.dt, a.product_id, a.corever, a.mt, a.reg_country, a.country_level,
            a.current_language2, a.source, a.last_source, a.user_period, a.is_pay,
            datediff(b.dt, a.dt), a.chl2, a.chl, a.user_ad_source, a.book_id)) as md5_key,
        a.product_id, a.corever, a.mt, a.reg_country, a.country_level, a.current_language2,
        a.source, a.last_source, a.user_period, a.is_pay, a.chl2, a.chl, a.user_ad_source, a.book_id,
        datediff(b.dt, a.dt) as reg_days,
        count(distinct b.user_id) as retention_num,
        now() as etl_time
    from base_user_dimensions a
    inner join base_active_users b
        on a.product_id = b.product_id
        and a.user_id = b.user_id
        and a.mt = b.mt
        and a.corever = b.corever
        and b.dt = '${bf_1_dt}'
        and (
            (a.dt = date_sub(b.dt, interval 60 day)) or
            (a.dt = date_sub(b.dt, interval 90 day)) or
            (a.dt = date_sub(b.dt, interval 120 day)) or
            (a.dt = date_sub(b.dt, interval 150 day)) or
            (a.dt = date_sub(b.dt, interval 180 day))
        )
    where a.user_period = 3
        and (
            (a.dt = date_sub('${bf_1_dt}', interval 60 day)) or
            (a.dt = date_sub('${bf_1_dt}', interval 90 day)) or
            (a.dt = date_sub('${bf_1_dt}', interval 120 day)) or
            (a.dt = date_sub('${bf_1_dt}', interval 150 day)) or
            (a.dt = date_sub('${bf_1_dt}', interval 180 day))
        )
    group by a.dt, a.product_id, a.corever, a.mt, a.reg_country, a.country_level,
        a.current_language2, a.source, a.last_source, a.user_period, a.is_pay,
        datediff(b.dt, a.dt), a.chl2, a.chl, a.user_ad_source, a.book_id
)
-- ========== 合并所有留存数据 ==========
select * from retention_active_short
union all
select * from retention_active_long
union all
select * from retention_new_short
union all
select * from retention_new_long
union all
select * from retention_rmt_short
union all
select * from retention_rmt_long;
