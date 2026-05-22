----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_ad_iaa_scale
-- workflow_version : 25
-- create_user      : chenmo
-- task_name        : ads_ad_iaa_scale
-- task_version     : 13
-- update_time      : 2026-04-21 15:51:18
-- sql_path         : \starrocks\tbl_ads_ad_iaa_scale\ads_ad_iaa_scale
----------------------------------------------------------------
-- SQL语句
-- =====================================================================================
-- 说明: 按ProductId、Mt、Core每天统计AdMob和Max的真实收入和预估收入比例
-- 数据源:
--   预估收入: dws.dws_advertisement_user_position_amt_ed (所有产品)
--   真实收入: ads.ads_bi_ad_video_income (海剧6833) + ads.ads_bi_read_adv_income_report_advdata (海阅)
-- 输出: ads.ads_ad_iaa_scale (StarRocks)
-- 比例计算规则:
--   1. 比例 = 真实广告收入 / 预估广告收入
--   2. 被除数（真实收入）为0时，比例设为1
--   3. 除数（预估收入）为0时，比例设为1
--   4. 比例超过2时，设置为1
-- =====================================================================================

insert into ads.ads_ad_iaa_scale
select
    -- Id生成规则: yyyyMMdd(8位) + product_id(4位) + mt(2位) + core(2位) = 16位bigint
    concat(
        date_format(coalesce(a.dt, b.dt), '%Y%m%d'),
        lpad(coalesce(a.product_id, b.product_id), 4, '0'),
        lpad(coalesce(a.mt, b.mt), 2, '0'),
        lpad(coalesce(a.core, b.core), 2, '0')
    ) as Id,
    coalesce(a.dt, b.dt) as AmountDate,
    coalesce(a.product_id, b.product_id) as ProductId,
    coalesce(a.mt, b.mt) as Mt,
    coalesce(a.core, b.core) as Core,
    -- AdMob比例计算: 真实收入/预估收入, 被除数或除数为0默认1, 超过2设置为1
    case
        when b.admob_real_income is null or b.admob_real_income = 0 then 1
        when a.admob_estimated_income is null or a.admob_estimated_income = 0 then 1
         when b.admob_real_income / a.admob_estimated_income > 2 then 1
        else round(b.admob_real_income / a.admob_estimated_income, 5)
    end as AdMobRatio,
    -- Max比例计算: 真实收入/预估收入, 被除数或除数为0默认1, 超过2设置为1
    case
        when b.max_real_income is null or b.max_real_income = 0 then 1
        when a.max_estimated_income is null or a.max_estimated_income = 0 then 1
--         when b.max_real_income / a.max_estimated_income > 2 then 1
        else round(b.max_real_income / a.max_estimated_income, 5)
    end as MaxRatio,
    -- AdMob真实收入
    coalesce(b.admob_real_income, 0) as AdMobRealIncome,
    -- AdMob预估收入
    coalesce(a.admob_estimated_income, 0) as AdMobEstimatedIncome,
    -- Max真实收入
    coalesce(b.max_real_income, 0) as MaxRealIncome,
    -- Max预估收入
    coalesce(a.max_estimated_income, 0) as MaxEstimatedIncome,
    now() as CreateTime,
    now() as UpdateTime,
    now() as etl_time
from (
    -- 预估收入统计（所有产品）
    select
        dt,
        product_id,
        mt,
        core,
        -- AdMob预估收入: ads_name='Admob'
        sum(case when ads_name = 'Admob' then amt else 0 end) as admob_estimated_income,
        -- Max预估收入: ads_name in ('MAX','Max')
        sum(case when ads_name in ('MAX', 'Max') then amt else 0 end) as max_estimated_income
    from dws.dws_advertisement_user_position_amt_ed
    where dt >= '2026-01-01' and dt >= date_sub('${bf_1_dt}', interval 30 day) and dt <= '${bf_1_dt}' and product_id != 2311
    group by 1, 2, 3, 4
) a
full outer join (
    -- 真实收入统计（海剧+海阅）
    select
        dt,
        product_id,
        mt,
        core,
        -- AdMob真实收入
        sum(admob_real_income) as admob_real_income,
        -- Max真实收入
        sum(max_real_income) as max_real_income
    from (
        -- 海剧真实收入 (product_id=6833)
        select
            dt,
            product_id,
            mt,
            core,
            -- AdMob真实收入: tps=1
            sum(case when tps = 1 then ad_amount else 0 end) as admob_real_income,
            -- Max真实收入: tps=3
            sum(case when tps = 3 then ad_amount else 0 end) as max_real_income
        from ads.ads_bi_ad_video_income
        where dt >= '2026-01-01' and dt >= date_sub('${bf_1_dt}', interval 30 day) and dt <= '${bf_1_dt}'
          and product_id = 6833
          and tps in (1, 3)  -- 1=AdMob真实, 3=Max真实
        group by 1, 2, 3, 4
        union all
        -- 海阅真实收入 (product_id<>6833)
        select
            dt,
            product_id,
            mt,
            corever as core,
            -- AdMob真实收入: tps=1
            sum(case when tps = 1 then ad_amt else 0 end) as admob_real_income,
            -- Max真实收入: tps=3
            sum(case when tps = 3 then ad_amt else 0 end) as max_real_income
        from ads.ads_bi_read_adv_income_report_advdata
        where dt >= '2026-01-01' and dt >= date_sub('${bf_1_dt}', interval 30 day) and dt <= '${bf_1_dt}'
          and product_id <> 6833
          and tps in (1, 3)  -- 1=AdMob真实, 3=Max真实
        group by 1, 2, 3, 4
    ) real_income
    group by 1, 2, 3, 4
) b
on a.dt = b.dt
   and a.product_id = b.product_id
   and a.mt = b.mt
   and a.core = b.core
where coalesce(a.dt, b.dt) is not null
  and coalesce(a.product_id, b.product_id) is not null
  and coalesce(a.mt, b.mt) is not null
  and coalesce(a.core, b.core) is not null;
