--  今日充值收入
insert into ads.ads_report_short_vedio_charge_info ( datetypes, charge_money, charge_money_rmb, charge_order, charge_num
                                                   , etl_time)
select *
  from (select 1                         as datetypes
             , sum(base_amount)          as charge_money
             , sum(base_amount) * 6.5    as charge_money_rmb
             , count(1)                  as charge_order
             , count(distinct (User_Id)) as charge_num
             , now()                     as etl_time
          from dwd.dwd_trade_sharpenginepaycenter_payorder_view
         where Create_Time >= CURDATE() and test_flag = 0 and product_id in (6833) and Order_Status = 1
        ) b
;
--  昨日同期收入
insert into ads.ads_report_short_vedio_charge_info ( datetypes, charge_money, charge_money_rmb, charge_order, charge_num
                                                   , etl_time)
select *
  from (select 2                         as datetypes
             , sum(base_amount)          as charge_money
             , sum(base_amount) * 6.5    as charge_money_rmb
             , count(1)                  as charge_order
             , count(distinct (user_id)) as charge_num
             , now()                     as etl_time
          from dwd.dwd_trade_sharpenginepaycenter_payorder_view
         where Create_Time >= date_add(CURDATE(), interval -1 day) and Create_Time <= date_add(now(), interval -1 day)
           and test_flag = 0 and product_id in (6833) and Order_Status = 1
        ) b;


-- 本月收入
insert into ads.ads_report_short_vedio_charge_info ( datetypes, charge_money, charge_money_rmb, charge_order, charge_num
                                                   , etl_time)
select *
  from (select 3                         as datetypes
             , sum(base_amount)          as charge_money
             , sum(base_amount) * 6.5    as charge_money_rmb
             , count(1)                  as charge_order
             , count(distinct (user_id)) as charge_num
             , now()                     as etl_time
          from dwd.dwd_trade_sharpenginepaycenter_payorder_view
         where Create_Time >= date_sub(CURDATE(), interval dayofmonth(now()) - 1 day) and test_flag = 0
           and product_id in (6833) and Order_Status = 1
        ) b
;


-- 上月同期收入
insert into ads.ads_report_short_vedio_charge_info ( datetypes, charge_money, charge_money_rmb, charge_order, charge_num
                                                   , etl_time)
select *
  from (select 4                         as datetypes
             , sum(base_amount)          as charge_money
             , sum(base_amount) * 6.5    as charge_money_rmb
             , count(1)                  as charge_order
             , count(distinct (user_id)) as charge_num
             , now()                     as etl_time
          from dwd.dwd_trade_sharpenginepaycenter_payorder_view
         where Create_Time >= date_sub(date_sub(curdate(), interval day(curdate()) - 1 day), interval 1 month)
           and Create_Time <= case when day(now()) > day(date_sub(now(), interval 1 month))
                                       then date_format(date_sub(now(), interval 1 month), '%Y-%m-%d 23:59:59')
                                   else date_sub(now(), interval 1 month)
                              end
           and test_flag = 0 and product_id in (6833) and Order_Status = 1
        ) b;


-- 本季度收入
insert into ads.ads_report_short_vedio_charge_info ( datetypes, charge_money, charge_money_rmb, charge_order, charge_num
                                                   , etl_time)
select *
  from (select 5                         as datetypes
             , sum(base_amount)          as charge_money
             , sum(base_amount) * 6.5    as charge_money_rmb
             , count(1)                  as charge_order
             , count(distinct (user_id)) as charge_num
             , now()                     as etl_time
          from dwd.dwd_trade_sharpenginepaycenter_payorder_view
         where Create_Time > date_sub(NOW(), interval 3 month) and Create_Time < now()
           and quarter(Create_Time) = quarter(now()) and test_flag = 0 and product_id in (6833) and Order_Status = 1
        ) b
;

-- 上季度同期收入
insert into ads.ads_report_short_vedio_charge_info ( datetypes, charge_money, charge_money_rmb, charge_order, charge_num
                                                   , etl_time)
select *
  from (select 6                         as datetypes
             , sum(base_amount)          as charge_money
             , sum(base_amount) * 6.5    as charge_money_rmb
             , count(1)                  as charge_order
             , count(distinct (user_id)) as charge_num
             , now()                     as etl_time
          from dwd.dwd_trade_sharpenginepaycenter_payorder_view
         where Create_Time > date_sub(NOW(), interval 6 month) and Create_Time <= date_sub(NOW(), interval 3 month)
           and quarter(Create_Time) = quarter(date_sub(NOW(), interval 3 month)) and test_flag = 0
           and product_id in (6833) and Order_Status = 1
        ) b;


-- -------------------上个季度完整的充值收入--------------------
insert into ads.ads_report_short_vedio_charge_info (datetypes, charge_money, charge_money_rmb, charge_order, charge_num)
select datetypes, charge_money, charge_money_rmb, charge_order, charge_num
  from (select 21                        as datetypes
             , sum(base_amount)          as charge_money
             , sum(base_amount) * 6.5    as charge_money_rmb
             , count(1)                  as charge_order
             , count(distinct (user_id)) as charge_num
          from dwd.dwd_trade_sharpenginepaycenter_payorder_view
         where quarter(Create_Time) = quarter(date_sub(NOW(), interval 3 month))
           and year(Create_Time) = year(date_sub(NOW(), interval 3 month)) and test_flag = 0 and product_id in (6833)
           and Order_Status = 1
        ) b
;