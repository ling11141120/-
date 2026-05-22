----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ads_report_first_page
-- workflow_version : 21
-- create_user      : xixg
-- task_name        : ads_report_first_page_data16
-- task_version     : 1
-- update_time      : 2025-06-24 16:43:21
-- sql_path         : \starrocks\sch_ads_report_first_page\ads_report_first_page_data16
----------------------------------------------------------------
-- 前置SQL语句
truncate table ads.ads_report_first_page_data16;

-- SQL语句
INSERT INTO ads.ads_report_first_page_data16
select a.dt as create_date ,
       a.DAU,
       a.new_num 新增用户数,
       c.charge_num 充值人数,
       b.charge_money 充值金额,
       c.fisrt_charge_num 首充用户数,
       c.fisrt_charge_money 新增付费用户充值总额,
       NOW()
from
    (
        select dt,count(distinct user_id) DAU ,
               count(distinct case when dt=reg_date then user_id end)  as new_num
        from dws.dws_user_viedo_cn_login_ed  a
        where  dt>=date_sub(curdate(),interval 30 day)  and self_type = 1
          and  1 =1
        GROUP BY 1

    ) a
left join
    (	select dt,round(sum(charge_money),2) charge_money
         from dws.dws_trade_viedo_cn_payorder_ed  a
         where  dt>=date_sub(curdate(),interval 30 day) and self_type = 1
           and 1 =1
         group by 1
    ) b
on a.dt=b.dt
left join
    (	select dt,count(distinct user_id) charge_num,
                count(distinct case when dt=First_charge_day then user_id end) fisrt_charge_num ,
                sum( case when dt=First_charge_day then charge_money end) fisrt_charge_money
         from dws.dws_trade_viedo_cn_payorder_ed a
         where  dt>=date_sub(curdate(),interval 30 day) and self_type = 3
           and 1 =1
         group by 1
    ) c
on a.dt = c.dt;
