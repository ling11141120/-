----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ads_report_first_page
-- workflow_version : 21
-- create_user      : xixg
-- task_name        : ads_report_first_page_data19
-- task_version     : 1
-- update_time      : 2025-06-24 18:54:34
-- sql_path         : \starrocks\sch_ads_report_first_page\ads_report_first_page_data19
----------------------------------------------------------------
-- 前置SQL语句
truncate table ads.ads_report_first_page_data19;

-- SQL语句
INSERT INTO ads.ads_report_first_page_data19
select v.*, NOW()  from (
                  select  case when datetypes in (11,12,19) then 1  -- 1：自营
                               when datetypes in (17,18,20) then 2  -- 2：分销
                               when datetypes in (26,27,34) then 3   -- 3：星图
                               when datetypes in (32,33,35) then 4  -- 4：小程序
                              end as 收入类型,
                          sum(case when  datetypes=11 then charge_money   when datetypes= 17 then charge_money
                                   when  datetypes=26 then charge_money   when datetypes= 32 then charge_money    end) as  本季度充值收入  ,
                          sum(case when  datetypes=12 then charge_money  when datetypes= 18 then charge_money
                                   when  datetypes=27 then charge_money  when datetypes= 33 then charge_money  end) as  上个季度同期充值收入   ,
                          sum(case when  datetypes=11 then charge_num when datetypes= 17 then charge_num
                                   when  datetypes=26 then charge_num when datetypes= 32 then charge_num  end) as  本季度充值人数  ,
                          sum(case when  datetypes=12 then charge_num when datetypes= 18 then charge_num
                                   when  datetypes=27 then charge_num when datetypes= 33 then charge_num   end) as  上个季度同期充值人数    ,
                          sum(case when  datetypes=11 then charge_order  when datetypes= 17 then charge_order
                                   when  datetypes=26 then charge_order  when datetypes= 32 then charge_order end) as  本季度充值笔数  ,
                          sum(case when  datetypes=12 then charge_order when datetypes= 18 then charge_order
                                   when  datetypes=27 then charge_order when datetypes= 33 then charge_order    end) as  上个季度同期充值笔数   ,

                          sum(case when  datetypes=19 then charge_money  when datetypes= 20 then charge_money
                                   when  datetypes=34 then charge_money  when datetypes= 35 then charge_money  end) as  上个季度充值收入,
                          sum(case when  datetypes=19 then charge_num  when datetypes= 20 then charge_num
                                   when  datetypes=34 then charge_num  when datetypes= 35 then charge_num  end) as  上个季度充值人数,
                          sum(case when  datetypes=19 then charge_order  when datetypes= 20 then charge_order
                                   when  datetypes=34 then charge_order  when datetypes= 35 then charge_order  end) as  上个季度充值笔数
                  from  ads.ads_report_short_vedio_charge_info   where datetypes in(11,12,19,17,18,20,26,27,34,32,33,35)
                  group by 1
              ) v;
