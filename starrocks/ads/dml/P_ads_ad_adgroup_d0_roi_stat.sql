----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_ad_adgroup_d0_roi_stat
-- workflow_version : 7
-- create_user      : xixg
-- task_name        : ads_ad_adgroup_d0_roi_stat
-- task_version     : 7
-- update_time      : 2025-05-09 17:20:34
-- sql_path         : \starrocks\tbl_ads_ad_adgroup_d0_roi_stat\ads_ad_adgroup_d0_roi_stat
----------------------------------------------------------------
-- SQL语句
INSERT INTO  ads.ads_ad_adgroup_d0_roi_stat
-- 广告组的花费、D0广告收入统计（放大的收入，所以要乘以 * (IFNULL(c.Ratio, 1))）
WITH tmp_ad_group_stat AS (
    SELECT
        a.CreateTime AS dt,
        a.ProductId AS product_id,
        a.AdSetId AS ad_set_id,
        SUM(a.CostAmount) AS cost_amount,
        IFNULL(SUM(Day0Amount), 0) AS d0_recharge_income,
        IFNULL(SUM(Day0AmountByAd * (IFNULL(c.Ratio, 1))), 0) AS d0_ad_income
    FROM ods.ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer a
             LEFT JOIN ods.ods_tidb_sharpengine_ads_global_FbAccount b
                       ON a.FbAccount = b.Account
             LEFT JOIN ods.ods_ad_sharpengine_ads_global_AdMobScale c
                       ON a.ProductId = c.ProductId
                           AND a.Mt = c.Mt
                           AND a.Core = c.Core
                           AND a.CreateTime = c.AmountDateStr
    WHERE  a.dt = '${bf_1_dt}'
      AND (b.FbAccountType = 0 OR b.FbAccountType IS NULL)
      AND a.core not in (2,3)
    GROUP BY 1,2,3
),

     tmp_d0_roi AS (

         SELECT
             dt,
             product_id,
             ad_set_id ,
             d0_recharge_income,
             d0_ad_income,
             cost_amount,
             (d0_recharge_income+d0_ad_income)/cost_amount AS d0_roi
         FROM tmp_ad_group_stat
         WHERE cost_amount > 1000                                                                                          -- 广告组的当日收入大于1000的
     ),

     tmp_ad_set AS (
         SELECT
             AdSetId AS ad_set_id,
             AdSetName AS ad_set_name
         FROM ods.ods_tidb_sharpengine_ads_global_adext
         GROUP BY AdSetId,AdSetName
     )

SELECT
    a.dt,
    a.product_id,
    ifnull(a.ad_set_id,-99) as ad_set_id,
    b.ad_set_name,
    a.d0_ad_income,
    a.cost_amount,
    a.d0_roi,
    NOW()
FROM tmp_d0_roi a
         LEFT JOIN tmp_ad_set  b
                   ON a.ad_set_id = b.ad_set_id;
