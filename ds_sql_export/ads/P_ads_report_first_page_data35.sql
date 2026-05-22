----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ads_report_first_page
-- workflow_version : 21
-- create_user      : xixg
-- task_name        : ads_report_first_page_data35
-- task_version     : 7
-- update_time      : 2025-06-23 18:03:51
-- sql_path         : \starrocks\sch_ads_report_first_page\ads_report_first_page_data35
----------------------------------------------------------------
-- 前置SQL语句
TRUNCATE TABLE ads.ads_report_first_page_data35;

-- SQL语句
INSERT INTO ads.ads_report_first_page_data35
select a.dt as create_date ,sum(a.DAU) DAU,sum(a.new_num) 新增用户数,sum(b.charge_num) 充值人数,sum(b.charge_money) 充值金额,sum(b.fisrt_charge_num) 首充用户数, NOW()
from
    (

        select dt,sum(DAU) DAU,sum(new_num) new_num
        from (
                 select dt,sum(DAU) as DAU,sum(new_num) as new_num
                 from ( -- -------海阅的-------------------
                          select dt,product_id ,count(distinct user_id ) DAU ,bitmap_union_count(if(user_types=0, user_id,null)) new_num
                          from ads.ads_report_user_dau_ed
                          where
                              dt>=date_sub(curdate(),interval 30 day)
                            and  product_id in (3366,3311,3322,3333,3371,3388,3399,3501,3511)
                          group by 1,2
                      ) a group by 1
                 union all
                 -- -------海剧的-------------------
                 select dt,count(distinct user_id) DAU ,
                        count(distinct case when dt=date(reg_time) then user_id end)  as new_num
                 from dws.dws_user_short_video_wide_active_ed  a
                 where
                     dt>=date_sub(curdate(),interval 30 day)
                   and product_id =6833
                 GROUP BY 1
                 union all
-- ----------国剧的-------------------
                 select dt,count(distinct user_id) DAU ,
                        count(distinct case when dt=reg_date then user_id end)  as new_num
                 from dws.dws_user_viedo_cn_login_ed  a
                 where
                     dt>=date_sub(curdate(),interval 30 day)
                   and
                     1 =1
                 GROUP BY 1
                 union all
-- ----------国阅的-------------------
                 select dt,count(distinct user_id) DAU ,
                        count(distinct case when reg_days=0 then user_id end)  as new_num
                 from dws.dws_cr_user_login_di a
                 where
                     dt>=date_sub(curdate(),interval 30 day)  and self_type = 0
                   and
                     1 =1
                 GROUP BY 1

             ) x GROUP BY 1
    ) a
        left join
    (
        select dt,  sum(charge_num) charge_num, sum(charge_money) charge_money, sum(fisrt_charge_num) fisrt_charge_num
        from (
-- -------------海阅的-----------------------
                 select dt, sum(charge_num) charge_num, sum(charge_money) charge_money, sum(fisrt_charge_num) fisrt_charge_num
                 from ads.ads_user_charge_1d
                 where dt>=date_sub(curdate(),interval 30 day)
                   and product_id in (3311,3322,3333,3366,3371,3388,3399,3501,3511)
                 group by 1
                 union all
                 -- -------------海剧的-----------------------
                 select dt,count(distinct user_id) charge_num,
                        round(sum(charge_money),2) charge_money,
                        count(distinct case when dt=First_charge_day then user_id end) fisrt_charge_num

                 from dws.dws_trade_short_viedo_payorder_ed a
                 where
                     dt>=date_sub(curdate(),interval 30 day)
                 group by 1
                 union all
                 -- -------------国剧的-----------------------
                 select dt,count(distinct user_id) charge_num,
                        round(sum(charge_money),2) charge_money,
                        count(distinct case when dt=First_charge_day then user_id end) fisrt_charge_num
                 from dws.dws_trade_viedo_cn_payorder_ed a
                 where
                     dt>=date_sub(curdate(),interval 30 day) and self_type = 0
                 group by 1
                 union all
                 -- -------------国阅的-----------------------
                 select dt,count(distinct user_id) charge_num,
                        round(sum(charge_amt),2) charge_money,
                        count(distinct case when dt=fst_charge_date then user_id end) fisrt_charge_num
                 from  dws.dws_cr_trade_user_recharge_di  a
                 where
                     dt>=date_sub(curdate(),interval 30 day) and self_type = 0
                 group by 1

             ) y group by 1
    ) b
    on a.dt=b.dt
group by 1
;
