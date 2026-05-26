----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_ad_iaa_scale
-- workflow_version : 25
-- create_user      : chenmo
-- task_name        : sr_to_ads_sr_AdIaaScale
-- task_version     : 5
-- update_time      : 2025-12-29 18:51:44
-- sql_path         : \starrocks\tbl_ads_ad_iaa_scale\sr_to_ads_sr_AdIaaScale
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_ad_iaa_scale_external
select
    Id,
    AmountDate,
    ProductId,
    Mt,
    Core,
    AdMobRatio,
    MaxRatio,
    AdMobRealIncome,
    AdMobEstimatedIncome,
    MaxRealIncome,
    MaxEstimatedIncome,
    CreateTime,
    UpdateTime
from ads.ads_ad_iaa_scale
where AmountDate >= date_sub('${bf_1_dt}', interval 30 day) and AmountDate <= '${bf_1_dt}';
