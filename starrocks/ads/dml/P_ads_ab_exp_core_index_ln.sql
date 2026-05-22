----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_ab_exp_core_index_ln
-- workflow_version : 16
-- create_user      : chenmo
-- task_name        : ads_ab_exp_core_index_ln
-- task_version     : 4
-- update_time      : 2025-09-12 10:36:46
-- sql_path         : \starrocks\tbl_ads_ab_exp_core_index_ln\ads_ab_exp_core_index_ln
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_ab_exp_core_index_ln
SELECT
    a.exp_id,
    a.exp_grp_id,
    '${bf_1_dt}' as dt,
    a.project_id,
    a.exp_grp_ver_id,
    ROUND(a.l14_recharge_user/a.l14_exposure_uv,4)   AS l14_payRate,  -- 付费率
    ROUND(a.l30_recharge_user/a.l30_exposure_uv,4)   AS l30_payRate,  -- 付费率
    ROUND(a.l14_recharge_amount/a.l14_exposure_uv,4) as l14_oneExposureArpu, -- 单人曝光ARPU
    ROUND(a.l30_recharge_amount/a.l30_exposure_uv,4) as l30_oneExposureArpu, -- 单人曝光ARPU
    ROUND((l14_signin_recharge_amount+l14_svip_recharge_amount)/a.l14_recharge_amount,4) as l14_dingYueAmountPercent, -- 订阅金额占比
    ROUND((l30_signin_recharge_amount+l30_svip_recharge_amount)/a.l30_recharge_amount,4) as l30_dingYueAmountPercent, -- 订阅金额占比
	ROUND((a.l14_recharge_amount/a.l14_exposure_uv)+((l14_signin_recharge_amount+l14_svip_recharge_amount)/a.l14_exposure_uv)*0.36 ,4) as l14_predictARPU,  -- 预估ARPU
	ROUND((a.l30_recharge_amount/a.l30_exposure_uv)+((l30_signin_recharge_amount+l30_svip_recharge_amount)/a.l30_exposure_uv)*0.36 ,4) as l30_predictARPU,  -- 预估ARPU
    NOW() as saveTime,
    NOW() as updateTime
FROM (
    select
         a.exp_id, -- 实验ID
         a.exp_grp_id, -- 实验组ID
         b.project_id,
         a.exp_grp_ver_id, -- 实验组ID
         count(distinct case when a.exposure_pv>0  then if(a.dt < least(date_add(date(start_time), interval 14 day), b.end_time), a.user_id, null) end)  as l14_exposure_uv, -- 充值曝光uv
         count(distinct case when a.exposure_pv>0  then if(a.dt < least(date_add(date(start_time), interval 30 day), b.end_time), a.user_id, null) end)  as l30_exposure_uv, -- 充值曝光uv
         sum(case when a.recharge_amount>0 then  if(a.dt < least(date_add(date(start_time), interval 14 day), b.end_time), a.recharge_un, 0) end) as l14_recharge_user, -- 充值用户数
         sum(case when a.recharge_amount>0 then  if(a.dt < least(date_add(date(start_time), interval 30 day), b.end_time), a.recharge_un, 0) end) as l30_recharge_user, -- 充值用户数
         sum(if(a.dt < least(date_add(date(start_time), interval 14 day), b.end_time), a.recharge_amount, 0)) as l14_recharge_amount, -- 充值金额
         sum(if(a.dt < least(date_add(date(start_time), interval 30 day), b.end_time), a.recharge_amount, 0)) as l30_recharge_amount, -- 充值金额
         sum(if(a.dt < least(date_add(date(start_time), interval 14 day), b.end_time), a.signin_recharge_amount, 0)) as l14_signin_recharge_amount, -- 签到卡-充值金额
         sum(if(a.dt < least(date_add(date(start_time), interval 30 day), b.end_time), a.signin_recharge_amount, 0)) as l30_signin_recharge_amount, -- 签到卡-充值金额
         sum(if(a.dt < least(date_add(date(start_time), interval 14 day), b.end_time), a.svip_recharge_amount, 0)) as l14_svip_recharge_amount, -- SVIP-充值金额
         sum(if(a.dt < least(date_add(date(start_time), interval 30 day), b.end_time), a.svip_recharge_amount, 0)) as l30_svip_recharge_amount -- SVIP-充值金额
    from dwm.`dwm_ab_exp_recharge_data_di` a
    left join dwd.dwd_ab_exp_version_detail b
         ON a.exp_id = b.exp_id
             AND a.exp_grp_id = b.exp_grp_id
             AND a.exp_grp_ver_id = b.exp_grp_ver_id
    where a.dt <= '${bf_1_dt}' and a.dt <= date(b.exp_end_time) and date(b.exp_end_time) >= '${bf_1_dt}' and date(b.end_time) >= '${bf_1_dt}'
    GROUP BY 1,2,3,4
) a;

-- SQL语句
INSERT INTO ads.ads_ab_exp_core_index_ln
SELECT
    a.exp_id,
    a.exp_grp_id,
    '${dt}' as dt,
    a.project_id,
    a.exp_grp_ver_id,
    ROUND(a.l14_recharge_user/a.l14_exposure_uv,4)   AS l14_payRate,  -- 付费率
    ROUND(a.l30_recharge_user/a.l30_exposure_uv,4)   AS l30_payRate,  -- 付费率
    ROUND(a.l14_recharge_amount/a.l14_exposure_uv,4) as l14_oneExposureArpu, -- 单人曝光ARPU
    ROUND(a.l30_recharge_amount/a.l30_exposure_uv,4) as l30_oneExposureArpu, -- 单人曝光ARPU
    ROUND((l14_signin_recharge_amount+l14_svip_recharge_amount)/a.l14_recharge_amount,4) as l14_dingYueAmountPercent, -- 订阅金额占比
    ROUND((l30_signin_recharge_amount+l30_svip_recharge_amount)/a.l30_recharge_amount,4) as l30_dingYueAmountPercent, -- 订阅金额占比
	ROUND((a.l14_recharge_amount/a.l14_exposure_uv)+((l14_signin_recharge_amount+l14_svip_recharge_amount)/a.l14_exposure_uv)*0.36 ,4) as l14_predictARPU,  -- 预估ARPU
	ROUND((a.l30_recharge_amount/a.l30_exposure_uv)+((l30_signin_recharge_amount+l30_svip_recharge_amount)/a.l30_exposure_uv)*0.36 ,4) as l30_predictARPU,  -- 预估ARPU
    NOW() as saveTime,
    NOW() as updateTime
FROM (
    select
         a.exp_id, -- 实验ID
         a.exp_grp_id, -- 实验组ID
         b.project_id,
         a.exp_grp_ver_id, -- 实验组ID
         count(distinct case when a.exposure_pv>0  then if(a.dt < least(date_add(date(start_time), interval 14 day), b.end_time), a.user_id, null) end)  as l14_exposure_uv, -- 充值曝光uv
         count(distinct case when a.exposure_pv>0  then if(a.dt < least(date_add(date(start_time), interval 30 day), b.end_time), a.user_id, null) end)  as l30_exposure_uv, -- 充值曝光uv
         sum(case when a.recharge_amount>0 then  if(a.dt < least(date_add(date(start_time), interval 14 day), b.end_time), a.recharge_un, 0) end) as l14_recharge_user, -- 充值用户数
         sum(case when a.recharge_amount>0 then  if(a.dt < least(date_add(date(start_time), interval 30 day), b.end_time), a.recharge_un, 0) end) as l30_recharge_user, -- 充值用户数
         sum(if(a.dt < least(date_add(date(start_time), interval 14 day), b.end_time), a.recharge_amount, 0)) as l14_recharge_amount, -- 充值金额
         sum(if(a.dt < least(date_add(date(start_time), interval 30 day), b.end_time), a.recharge_amount, 0)) as l30_recharge_amount, -- 充值金额
         sum(if(a.dt < least(date_add(date(start_time), interval 14 day), b.end_time), a.signin_recharge_amount, 0)) as l14_signin_recharge_amount, -- 签到卡-充值金额
         sum(if(a.dt < least(date_add(date(start_time), interval 30 day), b.end_time), a.signin_recharge_amount, 0)) as l30_signin_recharge_amount, -- 签到卡-充值金额
         sum(if(a.dt < least(date_add(date(start_time), interval 14 day), b.end_time), a.svip_recharge_amount, 0)) as l14_svip_recharge_amount, -- SVIP-充值金额
         sum(if(a.dt < least(date_add(date(start_time), interval 30 day), b.end_time), a.svip_recharge_amount, 0)) as l30_svip_recharge_amount -- SVIP-充值金额
    from dwm.`dwm_ab_exp_recharge_data_di` a
    left join dwd.dwd_ab_exp_version_detail b
         ON a.exp_id = b.exp_id
             AND a.exp_grp_id = b.exp_grp_id
             AND a.exp_grp_ver_id = b.exp_grp_ver_id
    where a.dt <= '${dt}' and a.dt <= date(b.exp_end_time) and date(b.exp_end_time) >= '${dt}' and date(b.end_time) >= '${dt}'
    GROUP BY 1,2,3,4
) a;
