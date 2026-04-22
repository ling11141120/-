-- frm路径：starrocks数据源/畅读海外/首页测试_240605

------------------------------------------------
-- 全部
------------------------------------------------

-- 全部-指标卡-本月或上月同期充值收入/充值人数/充值笔数
-- 海剧：本月-3，上月同期-4
-- 国剧自营：本月-9，上月同期-10
-- 分销：本月-15，上月同期-16
-- 星图：本月-24，上月同期-25
-- 小程序：本月-30，上月同期-31
select datetypes                                -- 日期类型：3-本月，4-上月
     , sum(charge_money)     as charge_money    -- 累计充值
     , sum(charge_money_rmb) as charge_money_rmb
     , sum(charge_order)     as charge_order    -- 充值笔数
     , sum(charge_num)       as charge_num      -- 充值人数
  from (select datetypes
             , charge_money
             , charge_money_rmb
             , charge_order
             , charge_num
          from ads.ads_charge_order -- 海阅的
         where datetypes in (3, 4)
         union all
        select (case when datetypes in (3, 9, 15, 24, 30) then 3 else 4 end) as datetypes
             , charge_money                                                  as charge_money
             , charge_money_rmb                                              as charge_money_rmb
             , charge_order                                                  as charge_order
             , charge_num                                                    as charge_num
          from ads.ads_report_short_vedio_charge_info -- 海剧和国剧的
         where datetypes in (3, 4, 9, 10, 15, 16, 24, 25, 30, 31)
         union all
        select if(date_types = 'cur_month', 3, 4) as datetypes
             , charge_amt                         as charge_amt
             , charge_amt_rmb                     as charge_amt_rmb
             , charge_cnt                         as charge_cnt
             , charge_unt                         as charge_unt
          from ads.ads_cr_trade_recharge    -- 国阅的
         where date_types in ('cur_month', 'last_month') and self_type = 0
        ) a
 group by 1
;

-- 全部-指标卡-今日或昨日同期充值收入/充值人数/充值笔数
-- 海剧：今日：1, 昨日同期：2
-- 国剧：今日：7, 昨日同期：8
-- 分销：今日：13, 昨日同期：14
-- 星图：今日：22, 昨日同期：23
-- 小程序：今日：28,昨日同期：29

select datetypes
     , sum(charge_money)     as charge_money
     , sum(charge_money_rmb) as charge_money_rmb
     , sum(charge_order)     as charge_order
     , sum(charge_num)       as charge_num
  from (select datetypes
             , charge_money
             , charge_money_rmb
             , charge_order
             , charge_num
          from ads.ads_charge_order -- 海阅
         where datetypes in (1, 2)
         union all
        select (case when datetypes in (1, 7, 13, 22, 28) then 1 else 2 end) as datetypes
             , charge_money                                                  as charge_money
             , charge_money_rmb                                              as charge_money_rmb
             , charge_order                                                  as charge_order
             , charge_num                                                    as charge_num
          from ads.ads_report_short_vedio_charge_info -- 海剧和国剧
         where datetypes in (1, 2, 7, 8, 13, 14, 22, 23, 28, 29)
         union all
        select if(date_types = 'today', 1, 2) as datetypes
             , charge_amt                     as charge_amt
             , charge_amt_rmb                 as charge_amt_rmb
             , charge_cnt                     as charge_cnt
             , charge_unt                     as charge_unt
          from ads.ads_cr_trade_recharge -- 国阅
         where date_types in ('today', 'last_day')
        ) a
 group by 1
;

-- 全部-指标卡-本月或上月同期总投放
-- 海阅、海剧、国剧、国阅的数据都在一张表（由于源头数据是来源同一张表，通过product_id来区分）
select datetypes
     , sum(month_spend) as month_spend
  from ads.ads_advertisement_month_toufang
 group by 1
 order by 1
;

-- 全部-指标卡-今日投放
select dt
     , sum(amount) as amount
  from (select dt
             , sum(spend) as amount
          from dws.dws_advertisement_toufang_ed -- 海阅、海剧、国剧
         where dt >= date_format(date_sub(curdate(), interval 0 day), '%Y-%m-%d')
         group by 1
         union all
        select dt            as dt
             , sum(cost_amt) as amount
          from dws.dws_cr_ad_advertising_cost_di -- 国阅
         where dt >= date_format(date_sub(curdate(), interval 0 day), '%Y-%m-%d')
           and product_id = 6773
         group by 1
       ) a
 group by 1
;

-- 全部-指标卡-昨日投放
select dt, sum(amount) as amount
  from (select dt
             , sum(spend) as amount
          from dws.dws_advertisement_toufang_ed -- 海阅、海剧、国剧
         where dt = date_format(date_sub(curdate(), interval 1 day), '%Y-%m-%d')
         group by 1
         union all
        select dt
             , sum(cost_amt) as amount
          from dws.dws_cr_ad_advertising_cost_di -- 国阅
         where dt = date_format(date_sub(curdate(), interval 1 day), '%Y-%m-%d')
           and product_id = 6773
         group by 1
       ) a
 group by 1
;

-- 全部-指标卡-上周投放
select dt, sum(amount) as amount
  from (select dt
             , sum(spend) as amount
          from dws.dws_advertisement_toufang_ed -- 海剧、海阅、国剧
         where dt = date_format(date_sub(curdate(), interval 7 day), '%Y-%m-%d')
         group by 1
         union all
        select dt
             , sum(cost_amt) as amount
          from dws.dws_cr_ad_advertising_cost_di -- 国阅的
         where dt = date_format(date_sub(curdate(), interval 7 day), '%Y-%m-%d')
           and product_id = 6773
         group by 1
        ) a
 group by 1
;

-- 全部-指标卡-本季度或上季度同期收入/充值收入/充值人数/充值笔数
-- 海剧：本季度：5, 上季度同期：6, 上个季度完整的：21
-- 国剧自营: 本季度：11, 上季度同期：12, 上个季度完整的：19
-- 分销：本季度：17, 上季度同期：18, 上个季度完整的：20
-- 星图：本季度：26, 上季度同期：27, 上个季度完整的：34
-- 小程序：本季度：32, 上季度同期：33 ,上个季度完整的：35

select datetypes
     , sum(charge_money)     as charge_money
     , sum(charge_money_rmb) as charge_money_rmb
     , sum(charge_order)     as charge_order
     , sum(charge_num)       as charge_num
  from (select datetypes
             , charge_money
             , charge_money_rmb
             , charge_order
             , charge_num
          from ads.ads_charge_order
         where datetypes in (5, 6, 7)
         union all
        select (case when datetypes in (5, 11, 17, 26, 32) then 5
                     when datetypes in (6, 12, 18, 27, 33) then 6
                     else 7
                end)            as datetypes
             , charge_money     as charge_money
             , charge_money_rmb as charge_money_rmb
             , charge_order     as charge_order
             , charge_num       as charge_num
          from ads.ads_report_short_vedio_charge_info
         where datetypes in (5, 6, 21, 11, 12, 19, 17, 18, 20, 26, 27, 34, 32, 33, 35)
         union all
        select case when date_types = 'cur_quarter' then 5
                    when date_types = 'last_quarter' then 6
                    else 7
               end            as datetypes
             , charge_amt     as charge_amt
             , charge_amt_rmb as charge_amt_rmb
             , charge_cnt     as charge_cnt
             , charge_unt     as charge_unt
          from ads.ads_cr_trade_recharge -- 国阅
         where date_types in ('cur_quarter', 'last_quarter', 'last_whole_quarter') and self_type = 0
        ) a
 group by 1
;

-- 全部-柱状图-渠道投入产出分析
select month2
     , recharge                as `充值`
     , recharge_after_fencheng as `分成后充值`
     , promotion_expenses      as `推广费用`
     , spend_rate              as `投放比`
     , recharge_cut_promotion  as `扣除推广后充值`
     , months
  from ads.ads_report_first_page_data33
 order by 1
;

-- 全部-柱状图+表格-分产品按月收入曲线
select product_type_name       as ProductTypeName
     , month2
     , recharge                as `充值`
     , recharge_after_fencheng as `分成后充值`
     , promotion_expenses      as `推广费用`
     , spend_rate              as `投放比`
     , recharge_cut_promotion  as `扣除推广后充值`
     , total_recharge          as `总充值`
     , month                   as months
  from ads.ads_report_first_page_data32
 order by 1 desc, 2
;

-- 全部-表格明细
select create_date
     , DAU
     , new_num          as `新增用户数`
     , charge_num       as `充值人数`
     , charge_money     as `充值金额`
     , first_charge_num as `首充用户数`
  from ads.ads_report_first_page_data35
order by 1 desc
;

------------------------------------------------
-- 海外阅读
------------------------------------------------

-- 海外阅读-指标卡-本月或上月同期充值收入/充值人数/充值笔数
select datetypes
     , charge_money
     , charge_money_rmb
     , charge_order
     , charge_num
  from ads.ads_charge_order
 where datetypes in (3, 4)
;

-- 海外阅读-指标卡-今日或昨日同期充值收入/充值人数/充值笔数
-- datetypes：1-今日，2-昨日同期
select datetypes
     , charge_money
     , charge_money_rmb
     , charge_order
     , charge_num
  from ads.ads_charge_order
 where datetypes in (1, 2)
;

-- 海外阅读-指标卡-本月或上月同期总投放
select datetypes
     , sum(month_spend) as month_spend
  from ads.ads_advertisement_month_toufang
 where product_id not in (6833, 6883)
 group by 1
;

-- 海外阅读-指标卡-今日投放
select dt
     , sum(spend) as amount
  from dws.dws_advertisement_toufang_ed
 where dt >= date_format(date_sub(curdate(), interval 0 day), '%Y-%m-%d')
   and product_id not in (6833, 6883)
 group by 1
 order by 1 desc
;

-- 海外阅读-指标卡-昨日投放
select dt
     , sum(spend) as amount
  from dws.dws_advertisement_toufang_ed
 where dt = date_format(date_sub(curdate(), interval 1 day), '%Y-%m-%d')
   and product_id not in (6833, 6883)
 group by 1
 order by 1 desc
;

-- 海外阅读-指标卡-上周投放
select dt
     , sum(spend) as amount
  from dws.dws_advertisement_toufang_ed
 where dt = date_format(date_sub(curdate(), interval 7 day), '%Y-%m-%d')
   and product_id not in (6833, 6883)
 group by 1
 order by 1 desc
;

-- 海外阅读-指标卡-本季度或上季度同期收入/充值收入/充值人数/充值笔数
select datetypes
     , charge_money
     , charge_money_rmb
     , charge_order
     , charge_num
  from ads.ads_charge_order
 where datetypes in (5, 6, 7)
;

-- 海外阅读-柱状图-渠道投入产出分析
select date_format(concat(month, 11), '%y-%m') as month2
     , sum(charge_itemcount)                 as `充值`
     , sum(charge_money)                     as `分成后充值`
     , sum(spend)                            as `推广费用`
     , sum(spend) / sum(charge_money)        as `投放比`
     , sum(charge_money) - sum(spend)        as `扣除推广后充值`
     , date_format(date_sub(curdate(), interval 1 year), '%y-%m') as months
  from ads.ads_trade_month_recharge_toufang
 where month >= date_format(date_sub(curdate(), interval 1 year), '%Y%m')
   and product_id in (3311, 3322, 3333, 3366, 3371, 3388, 3501, 3511, 3399)
 group by 1
 order by 1
;

-- 海外阅读-柱状图+表格-分产品按月收入曲线
select product_type_name         as ProductTypeName
     , month2
     , recharge                  as `充值`
     , recharge_after_fencheng   as `分成后充值`
     , promotion_expenses        as `推广费用`
     , spend_rate                as `投放比`
     , recharge_cut_promotion    as `扣除推广后充值`
     , total_recharge            as `总充值`
     , months
  from ads.ads_report_first_page_data6
 order by 1 desc, 2
;

-- 海外阅读-表格明细
select create_date
     , DAU
     , new_num          as `新增用户数`
     , charge_num       as `充值人数`
     , charge_money     as `充值金额`
     , first_charge_num as `首充用户数`
  from ads.ads_report_first_page_data2
 order by 1 desc
;

------------------------------------------------
-- 海外短剧
------------------------------------------------

-- 海外短剧-指标卡-本月或上月同期充值收入/充值人数/充值笔数
select *
  from ads.ads_report_short_vedio_charge_info
 where datetypes in (3, 4)
;

-- 海外短剧-指标卡-今日或昨日同期充值收入/充值人数/充值笔数
select datetypes
     , ifnull(charge_money, 0)     as charge_money
     , ifnull(charge_money_rmb, 0) as charge_money_rmb
     , ifnull(charge_order, 0)     as charge_order
     , ifnull(charge_num, 0)       as charge_num
     , etl_time
  from ads.ads_report_short_vedio_charge_info
 where datetypes in (1, 2)
;

-- 海外短剧-指标卡-本月或上月同期总投放
select datetypes
     , sum(month_spend) as month_spend
  from ads.ads_advertisement_month_toufang
 where product_id = 6833
 group by 1
;

-- 海外短剧-指标卡-今日投放
select dt
     , sum(spend) as amount
  from dws.dws_advertisement_toufang_ed
 where dt >= date_format(date_sub(curdate(), interval 0 day), '%Y-%m-%d')
   and product_id = 6833
 group by 1
 order by 1 desc
;

-- 海外短剧-指标卡-昨日投放
select dt
     , sum(spend) as amount
  from dws.dws_advertisement_toufang_ed
 where dt = date_format(date_sub(curdate(), interval 1 day), '%Y-%m-%d')
   and product_id = 6833
 group by 1
 order by 1 desc
;

-- 海外短剧-指标卡-上周投放
select dt
     , sum(spend) as amount
  from dws.dws_advertisement_toufang_ed
 where dt = date_format(date_sub(curdate(), interval 7 day), '%Y-%m-%d')
   and product_id = 6833
 group by 1
 order by 1 desc
;

-- 海外短剧-指标卡-本季度或上季度同期收入/充值收入/充值人数/充值笔数
select *
  from ads.ads_report_short_vedio_charge_info
 where datetypes in (5, 6, 21)
;

-- 海外短剧-柱状图-渠道投入产出分析
select date_format(concat(month, 11), '%y-%m') as month2
     , sum(charge_itemcount)                 as `充值`
     , sum(charge_money)                     as `分成后充值`
     , sum(spend)                            as `推广费用`
     , sum(spend) / sum(charge_money)        as `投放比`
     , sum(charge_money) - sum(spend)        as `扣除推广后充值`
     , date_format(date_sub(curdate(), interval 1 year), '%y-%m') as months
  from ads.ads_trade_month_recharge_toufang
 where month >= date_format(date_sub(curdate(), interval 1 year), '%Y%m')
   and product_id in (6833)
 group by 1
 order by 1
;

-- 海外短剧-柱状图+表格-分产品按月收入曲线
select ProductTypeName
     , date_format(concat(month, 11), '%y-%m') as month2
     , sum(charge_itemcount)                    as `充值`
     , round(sum(charge_money), 0)              as `分成后充值`
     , sum(spend)                               as `推广费用`
     , sum(spend) / sum(charge_money)           as `投放比`
     , sum(charge_money) - sum(spend)           as `扣除推广后充值`
     , null                                     as `总充值`
     , date_format(date_sub(curdate(), interval 1 year), '%y-%m') as months
  from ads.ads_trade_month_recharge_toufang a
  left join dim.DIM_ProductType b
    on a.Product_Id = b.ProductId
   and b.ProductTypeName not in ('韩语阅读', '菲律宾宾语')
 where month >= date_format(date_sub(curdate(), interval 1 year), '%Y%m')
   and product_id in (6833)
 group by 1, 2
 order by 1 desc, 2
;

-- 海外短剧-表格明细
select create_date
     , DAU
     , new_num          as `新增用户数`
     , charge_num       as `充值人数`
     , charge_money     as `充值金额`
     , first_charge_num as `首充用户数`
  from ads.ads_report_first_page_data50
 order by 1 desc
;

------------------------------------------------
-- 国内短剧
------------------------------------------------

-- 国内短剧-指标卡-本月或上月同期充值收入/充值人数/充值笔数
select income_type                 as `收入类型`
     , curr_month_recharge_amount  as `本月充值收入`
     , last_month_recharge_amount  as `上个月充值收入`
     , curr_month_recharge_users   as `本月充值人数`
     , last_month_recharge_users   as `上个月充值人数`
     , curr_month_recharge_times   as `本月充值笔数`
     , last_month_recharge_times   as `上个月充值笔数`
  from ads.ads_report_first_page_data20
 order by 1
;

-- 国内短剧-指标卡-今日或昨日同期充值收入/充值人数/充值笔数
select *
  from (select case when datetypes in (7, 8) then 1
                    when datetypes in (13, 14) then 2
                    when datetypes in (22, 23) then 3
                    when datetypes in (28, 29) then 4
               end as `收入类型`
             , sum(case when datetypes = 7 then charge_money
                        when datetypes = 13 then charge_money
                        when datetypes = 22 then charge_money
                        when datetypes = 28 then charge_money
                   end) as `今日充值收入`
             , sum(case when datetypes = 8 then charge_money
                        when datetypes = 14 then charge_money
                        when datetypes = 23 then charge_money
                        when datetypes = 29 then charge_money
                   end) as `昨日充值收入`
             , sum(case when datetypes = 7 then charge_num
                        when datetypes = 13 then charge_num
                        when datetypes = 22 then charge_num
                        when datetypes = 28 then charge_num
                   end) as `今日充值人数`
             , sum(case when datetypes = 8 then charge_num
                        when datetypes = 14 then charge_num
                        when datetypes = 23 then charge_num
                        when datetypes = 29 then charge_num
                   end) as `昨日充值人数`
             , sum(case when datetypes = 7 then charge_order
                        when datetypes = 13 then charge_order
                        when datetypes = 22 then charge_order
                        when datetypes = 28 then charge_order
                   end) as `今日充值笔数`
             , sum(case when datetypes = 8 then charge_order
                        when datetypes = 14 then charge_order
                        when datetypes = 23 then charge_order
                        when datetypes = 29 then charge_order
                   end) as `昨日充值笔数`
          from ads.ads_report_short_vedio_charge_info
         where datetypes in (7, 8, 13, 14, 22, 23, 28, 29)
         group by 1
       ) v
 order by 1
;

-- 国内短剧-指标卡-本月或上月同期总投放
select datetypes
     , sum(month_spend) as month_spend
  from ads.ads_advertisement_month_toufang
 where product_id = 6883
 group by 1
;

-- 国内短剧-指标卡-今日投放
select dt
     , sum(spend) as amount
  from dws.dws_advertisement_toufang_ed
 where dt >= date_format(date_sub(curdate(), interval 0 day), '%Y-%m-%d')
   and product_id = 6883
 group by 1
 order by 1 desc
;

-- 国内短剧-指标卡-昨日投放
select dt
     , sum(spend) as amount
  from dws.dws_advertisement_toufang_ed
 where dt = date_format(date_sub(curdate(), interval 1 day), '%Y-%m-%d')
   and product_id = 6883
 group by 1
 order by 1 desc
;

-- 国内短剧-指标卡-上周投放
select dt
     , sum(spend) as amount
  from dws.dws_advertisement_toufang_ed
 where dt = date_format(date_sub(curdate(), interval 7 day), '%Y-%m-%d')
   and product_id = 6883
 group by 1
 order by 1 desc
;

-- 国内短剧-指标卡-本季度或上季度同期收入/充值收入/充值人数/充值笔数
select *
  from (select case when datetypes in (11, 12, 19) then 1
                    when datetypes in (17, 18, 20) then 2
                    when datetypes in (26, 27, 34) then 3
                    when datetypes in (32, 33, 35) then 4
               end as `收入类型`
             , sum(case when datetypes = 11 then charge_money
                        when datetypes = 17 then charge_money
                        when datetypes = 26 then charge_money
                        when datetypes = 32 then charge_money
                   end) as `本季度充值收入`
             , sum(case when datetypes = 12 then charge_money
                        when datetypes = 18 then charge_money
                        when datetypes = 27 then charge_money
                        when datetypes = 33 then charge_money
                   end) as `上个季度同期充值收入`
             , sum(case when datetypes = 11 then charge_num
                        when datetypes = 17 then charge_num
                        when datetypes = 26 then charge_num
                        when datetypes = 32 then charge_num
                   end) as `本季度充值人数`
             , sum(case when datetypes = 12 then charge_num
                        when datetypes = 18 then charge_num
                        when datetypes = 27 then charge_num
                        when datetypes = 33 then charge_num
                   end) as `上个季度同期充值人数`
             , sum(case when datetypes = 11 then charge_order
                        when datetypes = 17 then charge_order
                        when datetypes = 26 then charge_order
                        when datetypes = 32 then charge_order
                   end) as `本季度充值笔数`
             , sum(case when datetypes = 12 then charge_order
                        when datetypes = 18 then charge_order
                        when datetypes = 27 then charge_order
                        when datetypes = 33 then charge_order
                   end) as `上个季度同期充值笔数`
             , sum(case when datetypes = 19 then charge_money
                        when datetypes = 20 then charge_money
                        when datetypes = 34 then charge_money
                        when datetypes = 35 then charge_money
                   end) as `上个季度充值收入`
             , sum(case when datetypes = 19 then charge_num
                        when datetypes = 20 then charge_num
                        when datetypes = 34 then charge_num
                        when datetypes = 35 then charge_num
                   end) as `上个季度充值人数`
             , sum(case when datetypes = 19 then charge_order
                        when datetypes = 20 then charge_order
                        when datetypes = 34 then charge_order
                        when datetypes = 35 then charge_order
                   end) as `上个季度充值笔数`
          from ads.ads_report_short_vedio_charge_info
         where datetypes in (11, 12, 19, 17, 18, 20, 26, 27, 34, 32, 33, 35)
         group by 1
       ) v
 order by 1
;

-- 国内短剧-柱状图-渠道投入产出分析
select date_format(concat(month, 11), '%y-%m') as month2
     , sum(charge_itemcount)                 as `充值`
     , sum(charge_money)                     as `分成后充值`
     , sum(spend)                            as `推广费用`
     , sum(spend) / sum(charge_money)        as `投放比`
     , sum(charge_money) - sum(spend)        as `扣除推广后充值`
     , date_format(date_sub(curdate(), interval 1 year), '%y-%m') as months
  from ads.ads_trade_month_recharge_toufang
 where month >= date_format(date_sub(curdate(), interval 1 year), '%Y%m')
   and product_id in (6883)
 group by 1
 order by 1
;

-- 国内短剧-柱状图+表格-分产品按月收入曲线
select product_type_name       as ProductTypeName
     , month2
     , recharge                as `充值`
     , recharge_after_fencheng as `分成后充值`
     , promotion_expenses      as `推广费用`
     , spend_rate              as `投放比`
     , recharge_cut_promotion  as `扣除推广后充值`
     , total_recharge          as `总充值`
     , month                   as months
  from ads.ads_report_first_page_data10
 order by 1 desc, 2
;

-- 国内短剧-表格明细
select create_date
     , DAU
     , new_num          as `新增用户数`
     , charge_num       as `充值人数`
     , charge_money     as `充值金额`
     , first_charge_num as `首充用户数`
  from ads.ads_report_first_page_data14
 order by 1 desc
;

------------------------------------------------
-- 国内阅读
------------------------------------------------

-- 国内阅读-指标卡-本月或上月同期充值收入/充值人数/充值笔数
select self_type                                  as `收入类型`
     , sum(case when date_types = 'cur_month' then charge_amt end)  as `本月充值收入`
     , sum(case when date_types = 'last_month' then charge_amt end) as `上月同期充值收入`
     , sum(case when date_types = 'cur_month' then charge_unt end)  as `本月充值人数`
     , sum(case when date_types = 'last_month' then charge_unt end) as `上个月充值人数`
     , sum(case when date_types = 'cur_month' then charge_cnt end)  as `本月充值笔数`
     , sum(case when date_types = 'last_month' then charge_cnt end) as `上个月充值笔数`
  from ads.ads_cr_trade_recharge
 where date_types in ('cur_month', 'last_month')
 group by 1
 order by 1
;

-- 国内阅读-指标卡-今日或昨日同期充值收入/充值人数/充值笔数
select self_type                                as `收入类型`
     , sum(case when date_types = 'today' then charge_amt end)    as `今日充值收入`
     , sum(case when date_types = 'last_day' then charge_amt end) as `昨日充值收入`
     , sum(case when date_types = 'today' then charge_unt end)    as `今日充值人数`
     , sum(case when date_types = 'last_day' then charge_unt end) as `昨日充值人数`
     , sum(case when date_types = 'today' then charge_cnt end)    as `今日充值笔数`
     , sum(case when date_types = 'last_day' then charge_cnt end) as `昨日充值笔数`
  from ads.ads_cr_trade_recharge
 where date_types in ('today', 'last_day')
 group by 1
 order by 1
;

-- 国内阅读-指标卡-本月或上月同期总投放
select datetypes
     , sum(month_spend) as month_spend
  from ads.ads_advertisement_month_toufang
 where product_id = 6773
 group by 1
;

-- 国内阅读-指标卡-今日投放
select dt
     , sum(cost_amt) as amount
  from dws.dws_cr_ad_advertising_cost_di
 where dt >= date_format(date_sub(curdate(), interval 0 day), '%Y-%m-%d')
   and product_id = 6773
 group by 1
;

-- 国内阅读-指标卡-昨日投放
select dt
     , sum(cost_amt) as amount
  from dws.dws_cr_ad_advertising_cost_di
 where dt = date_format(date_sub(curdate(), interval 1 day), '%Y-%m-%d')
   and product_id = 6773
 group by 1
;

-- 国内阅读-指标卡-上周投放
select dt
     , sum(cost_amt) as amount
  from dws.dws_cr_ad_advertising_cost_di
 where dt = date_format(date_sub(curdate(), interval 7 day), '%Y-%m-%d')
   and product_id = 6773
 group by 1
;

-- 国内阅读-指标卡-本季度或上季度同期收入/充值收入/充值人数/充值笔数
select self_type                                         as `收入类型`
     , sum(case when date_types = 'cur_quarter' then charge_amt end)         as `本季度充值收入`
     , sum(case when date_types = 'last_quarter' then charge_amt end)        as `上季度同期充值收入`
     , sum(case when date_types = 'cur_quarter' then charge_unt end)         as `本季度充值人数`
     , sum(case when date_types = 'last_quarter' then charge_unt end)        as `上个季度同期充值人数`
     , sum(case when date_types = 'cur_quarter' then charge_cnt end)         as `本季度充值笔数`
     , sum(case when date_types = 'last_quarter' then charge_cnt end)        as `上个季度同期充值笔数`
     , sum(case when date_types = 'last_whole_quarter' then charge_amt end)  as `上个季度充值收入`
     , sum(case when date_types = 'last_whole_quarter' then charge_unt end)  as `上个季度充值人数`
     , sum(case when date_types = 'last_whole_quarter' then charge_cnt end)  as `上个季度充值笔数`
  from ads.ads_cr_trade_recharge
 where date_types in ('cur_quarter', 'last_quarter', 'last_whole_quarter')
 group by 1
 order by 1
;

-- 国内阅读-柱状图-渠道投入产出分析
select month2
     , recharge                as `充值`
     , recharge_after_fencheng as `分成后充值`
     , promotion_expenses      as `推广费用`
     , spend_rate              as `投放比`
     , recharge_cut_promotion  as `扣除推广后充值`
     , month                   as months
  from ads.ads_report_first_page_data24
 order by 1
;

-- 国内阅读-柱状图+表格-分产品按月收入曲线
select product_type_name       as ProductTypeName
     , month2
     , recharge                as `充值`
     , recharge_after_fencheng as `分成后充值`
     , promotion_expenses      as `推广费用`
     , spend_rate              as `投放比`
     , recharge_cut_promotion  as `扣除推广后充值`
     , total_recharge          as `总充值`
     , month                   as months
  from ads.ads_report_first_page_data23
 order by 1 desc, 2
;

-- 国内阅读-表格明细
select create_date
     , DAU
     , new_num          as `新增用户数`
     , charge_num       as `充值人数`
     , charge_money     as `充值金额`
     , first_charge_num as `首充用户数`
  from ads.ads_report_first_page_data26
 order by 1 desc
;
------------------------------------------------
-- 海外阅读
------------------------------------------------

-- 海外阅读-指标卡-本月或上月同期充值收入/充值人数/充值笔数
select datetypes
     , charge_money
     , charge_money_rmb
     , charge_order
     , charge_num
  from ads.ads_charge_order
 where datetypes in (3, 4)
;

-- 海外阅读-指标卡-今日或昨日同期充值收入/充值人数/充值笔数
select datetypes
     , charge_money
     , charge_money_rmb
     , charge_order
     , charge_num
  from ads.ads_charge_order
 where datetypes in (1, 2)
;

-- 海外阅读-指标卡-本月或上月同期总投放
select datetypes
     , sum(month_spend) as month_spend
  from ads.ads_advertisement_month_toufang
 where product_id not in (6833, 6883)
 group by 1
;

-- 海外阅读-指标卡-今日投放
select dt
     , sum(spend) as amount
  from dws.dws_advertisement_toufang_ed
 where dt >= date_format(date_sub(curdate(), interval 0 day), '%Y-%m-%d')
   and product_id not in (6833, 6883)
 group by 1
 order by 1 desc
;

-- 海外阅读-指标卡-昨日投放
select dt
     , sum(spend) as amount
  from dws.dws_advertisement_toufang_ed
 where dt = date_format(date_sub(curdate(), interval 1 day), '%Y-%m-%d')
   and product_id not in (6833, 6883)
 group by 1
 order by 1 desc
;

-- 海外阅读-指标卡-上周投放
select dt
     , sum(spend) as amount
  from dws.dws_advertisement_toufang_ed
 where dt = date_format(date_sub(curdate(), interval 7 day), '%Y-%m-%d')
   and product_id not in (6833, 6883)
 group by 1
 order by 1 desc
;

-- 海外阅读-指标卡-本季度或上季度同期收入/充值收入/充值人数/充值笔数
select datetypes
     , charge_money
     , charge_money_rmb
     , charge_order
     , charge_num
  from ads.ads_charge_order
 where datetypes in (5, 6, 7)
;


-- 海外阅读-柱状图-渠道投入产出分析
select date_format(concat(month, 11), '%y-%m') as month2
     , sum(charge_itemcount)                 as `充值`
     , sum(charge_money)                     as `分成后充值`
     , sum(spend)                            as `推广费用`
     , sum(spend) / sum(charge_money)        as `投放比`
     , sum(charge_money) - sum(spend)        as `扣除推广后充值`
     , date_format(date_sub(curdate(), interval 1 year), '%y-%m') as months
  from ads.ads_trade_month_recharge_toufang
 where month >= date_format(date_sub(curdate(), interval 1 year), '%Y%m')
   and product_id in (3311, 3322, 3333, 3366, 3371, 3388, 3501, 3511, 3399)
 group by 1
 order by 1
;


-- 海外阅读-柱状图+表格-分产品按月收入曲线
select product_type_name         as ProductTypeName
     , month2
     , recharge                  as `充值`
     , recharge_after_fencheng   as `分成后充值`
     , promotion_expenses        as `推广费用`
     , spend_rate                as `投放比`
     , recharge_cut_promotion    as `扣除推广后充值`
     , total_recharge            as `总充值`
     , months
  from ads.ads_report_first_page_data6
 order by 1 desc, 2
;


-- 海外阅读-表格明细
select create_date
     , DAU
     , new_num          as `新增用户数`
     , charge_num       as `充值人数`
     , charge_money     as `充值金额`
     , first_charge_num as `首充用户数`
  from ads.ads_report_first_page_data2
 order by 1 desc
;
