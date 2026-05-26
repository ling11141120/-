----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ads_report_first_page
-- workflow_version : 21
-- create_user      : xixg
-- task_name        : ads_report_first_page_data20
-- task_version     : 2
-- update_time      : 2025-06-24 16:29:49
-- sql_path         : \starrocks\sch_ads_report_first_page\ads_report_first_page_data20
----------------------------------------------------------------
-- 前置SQL语句
truncate table ads.ads_report_first_page_data20;

-- SQL语句
INSERT INTO ads.ads_report_first_page_data20
select v.*,NOW() from (
                  select  case when datetypes in (9,10) then 1  -- 1：自营
                               when datetypes in (15,16) then 2  -- 2：分销
                               when datetypes in (24,25) then 3   -- 3：星图
                               when datetypes in (30,31) then 4  -- 4：小程序
                              end as 收入类型,
                          sum(case when  datetypes=9 then charge_money   when datetypes= 15 then charge_money
                                   when  datetypes=24 then charge_money   when datetypes= 30 then charge_money    end) as  本月充值收入  ,
                          sum(case when  datetypes=10 then charge_money  when datetypes= 16 then charge_money
                                   when  datetypes=25 then charge_money  when datetypes= 31 then charge_money  end) as  上个月充值收入   ,
                          sum(case when  datetypes=9 then charge_num when datetypes= 15 then charge_num
                                   when  datetypes=24 then charge_num when datetypes= 30 then charge_num  end) as  本月充值人数  ,
                          sum(case when  datetypes=10 then charge_num when datetypes= 16 then charge_num
                                   when  datetypes=25 then charge_num when datetypes= 31 then charge_num   end) as  上个月充值人数    ,
                          sum(case when  datetypes=9 then charge_order  when datetypes= 15 then charge_order
                                   when  datetypes=24 then charge_order  when datetypes= 30 then charge_order end) as  本月充值笔数  ,
                          sum(case when  datetypes=10 then charge_order when datetypes= 16 then charge_order
                                   when  datetypes=25 then charge_order when datetypes= 31 then charge_order    end) as  上个月充值笔数
                  from ads.ads_report_short_vedio_charge_info
                  where datetypes in( 9,10,15,16,24,25,30,31)
                  group by 1
              ) v;
