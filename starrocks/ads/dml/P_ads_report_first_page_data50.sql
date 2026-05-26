----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ads_report_first_page
-- workflow_version : 21
-- create_user      : xixg
-- task_name        : ads_report_first_page_data50
-- task_version     : 1
-- update_time      : 2025-06-24 16:17:30
-- sql_path         : \starrocks\sch_ads_report_first_page\ads_report_first_page_data50
----------------------------------------------------------------
-- 前置SQL语句
truncate table ads.ads_report_first_page_data50;

-- SQL语句
INSERT INTO ads.ads_report_first_page_data50
select b.dt as create_date ,
       a.DAU,
       a.new_num 新增用户数,
       b.charge_num 充值人数,
       b.charge_money 充值金额,
       b.fisrt_charge_num 首充用户数,
       b.fisrt_charge_money 新增付费用户充值总额,
       NOW()
from
    (

        select dt,count(distinct user_id) charge_num,
               round(sum(charge_money),2) charge_money,
               count(distinct case when dt=First_charge_day then user_id end) fisrt_charge_num ,
               sum( case when dt=First_charge_day then charge_money end) fisrt_charge_money
        from dws.dws_trade_short_viedo_payorder_ed a
        where dt>=date_sub(curdate(),interval 30 day)
          and 1 =1
        group by 1

    ) b
left join
    (
        select dt,count(distinct user_id) DAU ,
               count(distinct case when dt=date(reg_time) then user_id end)  as new_num
        from dws.dws_user_short_video_wide_active_ed  a
        where dt>=date_sub(curdate(),interval 30 day)
          and product_id=6833
          and 1 =1
        GROUP BY 1
    ) a
on a.dt=b.dt;
