----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_cv_advertise_spend_di
-- workflow_version : 8
-- create_user      : linq
-- task_name        : ads_bi_cv_advertise_spend_di
-- task_version     : 7
-- update_time      : 2024-10-16 15:55:45
-- sql_path         : \starrocks\tbl_ads_bi_cv_advertise_spend_di\ads_bi_cv_advertise_spend_di
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_bi_cv_advertise_spend_di where dt>=date_sub('${af_1_dt}',interval 180 day ) and dt<'${af_1_dt}';

-- SQL语句
insert into ads.ads_bi_cv_advertise_spend_di
select date(create_time) as dt,
       sum(cost_amount) as cost_amount,
       sum(reg_num) as reg_num,
       sum(day150_amount_by_ad) as total_income,
       sum(day0_amount_by_ad)+sum(day0_amount) as day0_income,
       round((sum(day0_amount_by_ad)+sum(day0_amount))/sum(cost_amount),4) as day0_roi,
       now() as etl_time
from dwd.dwd_FbAdRoiInstallReferrerVideo_view
where create_time>=date_sub('${af_1_dt}',interval 180 day ) and create_time<'${af_1_dt}'  and
      product_id=6883
group by 1;
