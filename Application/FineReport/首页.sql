-- frm路径：starrocks数据源/畅读海外/首页测试_260601

------------------------------------------------
-- 全部
------------------------------------------------

-- 全部-指标卡-本月或上月同期充值收入/充值人数/充值笔数
-- 海剧：本月-3，上月同期-4
-- 国剧自营：本月-9，上月同期-10
-- 分销：本月-15，上月同期-16
-- 星图：本月-24，上月同期-25
-- 小程序：本月-30，上月同期-31
-- 20260601新口径：仅包含海外阅读、海外短剧
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
          from ads.ads_charge_order             -- 海外阅读
         where datetypes in (3, 4)
         union all
        select datetypes
             , charge_money
             , charge_money_rmb
             , charge_order
             , charge_num
          from ads.ads_report_short_vedio_charge_info -- 海外短剧
--          where datetypes in (3, 4, 9, 10, 15, 16, 24, 25, 30, 31)
         where datetypes in (3, 4)
--          union all
--         select if(date_types = 'cur_month', 3, 4) as datetypes
--              , charge_amt                         as charge_amt
--              , charge_amt_rmb                     as charge_amt_rmb
--              , charge_cnt                         as charge_cnt
--              , charge_unt                         as charge_unt
--           from ads.ads_cr_trade_recharge    -- 国阅的
--          where date_types in ('cur_month', 'last_month') and self_type = 0
        ) a
 group by 1
;

-- 全部-指标卡-今日或昨日同期充值收入/充值人数/充值笔数
-- 海剧：今日：1, 昨日同期：2
-- 国剧：今日：7, 昨日同期：8
-- 分销：今日：13, 昨日同期：14
-- 星图：今日：22, 昨日同期：23
-- 小程序：今日：28,昨日同期：29
-- 20260601新口径：仅包含海外阅读、海外短剧
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
          from ads.ads_charge_order             -- 海外阅读
         where datetypes in (1, 2)
         union all
        select datetypes
--              , (case when datetypes in (1, 7, 13, 22, 28) then 1 else 2 end) as datetypes
             , charge_money
             , charge_money_rmb
             , charge_order
             , charge_num
          from ads.ads_report_short_vedio_charge_info -- 海外短剧
--          where datetypes in (1, 2, 7, 8, 13, 14, 22, 23, 28, 29)
         where datetypes in (1, 2)
--          union all
--         select if(date_types = 'today', 1, 2) as datetypes
--              , charge_amt                     as charge_amt
--              , charge_amt_rmb                 as charge_amt_rmb
--              , charge_cnt                     as charge_cnt
--              , charge_unt                     as charge_unt
--           from ads.ads_cr_trade_recharge -- 国阅
--          where date_types in ('today', 'last_day')
        ) a
 group by 1
;

-- 全部-指标卡-本月或上月同期总投放
-- 新口径：海外阅读产品 + 海外短剧产品
select datetypes
     , sum(month_spend) as month_spend
  from ads.ads_advertisement_month_toufang
 where product_id in (3311, 3322, 3333, 3366, 3371, 3388, 3501, 3511, 3399, 6833)
 group by 1
 order by 1
;

-- 全部-指标卡-今日投放
select dt
     , sum(spend) as amount
  from dws.dws_advertisement_toufang_ed
 where dt >= date_format(date_sub(curdate(), interval 0 day), '%Y-%m-%d')
   and product_id in (3311, 3322, 3333, 3366, 3371, 3388, 3501, 3511, 3399, 6833)
 group by 1
;

-- 全部-指标卡-昨日投放
select dt
     , sum(spend) as amount
  from dws.dws_advertisement_toufang_ed
 where dt = date_format(date_sub(curdate(), interval 1 day), '%Y-%m-%d')
   and product_id in (3311, 3322, 3333, 3366, 3371, 3388, 3501, 3511, 3399, 6833)
 group by 1
;

-- 全部-指标卡-上周投放
select dt
     , sum(spend) as amount
  from dws.dws_advertisement_toufang_ed
 where dt = date_format(date_sub(curdate(), interval 7 day), '%Y-%m-%d')
   and product_id in (3311, 3322, 3333, 3366, 3371, 3388, 3501, 3511, 3399, 6833)
 group by 1
;

-- 全部-指标卡-本季度或上季度同期收入/充值收入/充值人数/充值笔数
-- 新口径：仅包含海外阅读、海外短剧；海外短剧 21 映射为上个季度完整值 7
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
        select case when datetypes = 21 then 7 else datetypes end as datetypes
             , charge_money
             , charge_money_rmb
             , charge_order
             , charge_num
          from ads.ads_report_short_vedio_charge_info
         where datetypes in (5, 6, 21)
        ) a
 group by 1
;

-- 全部-柱状图-渠道投入产出分析
-- 新口径：海外阅读产品 + 海外短剧产品
select date_format(concat(month, 11), '%y-%m') as month2
     , sum(charge_itemcount)                       as `充值`
     , sum(charge_money)                           as `分成后充值`
     , sum(spend)                                  as `推广费用`
     , case when sum(charge_money) = 0 then null else sum(spend) / sum(charge_money) end as `投放比`
     , sum(charge_money) - sum(spend)              as `毛利润`
     , date_format(date_sub(date_format(curdate(), '%Y-%m-01'), interval 12 month), '%y-%m') as months
  from ads.ads_trade_month_recharge_toufang
 where month >= date_format(date_sub(date_format(curdate(), '%Y-%m-01'), interval 12 month), '%Y%m')
   and month <= date_format(curdate(), '%Y%m')
   and product_id in (3311, 3322, 3333, 3366, 3371, 3388, 3501, 3511, 3399, 6833)
 group by 1
 order by 1
;

-- 全部-柱状图+表格-分产品按月收入曲线（废弃）
select product_type_name       as ProductTypeName
     , month2
     , recharge                as `充值`
     , recharge_after_fencheng as `分成后充值`
     , promotion_expenses      as `推广费用`
     , spend_rate              as `投放比`
     , recharge_cut_promotion  as `毛利润`
     , total_recharge          as `总充值`
     , month                   as months
  from ads.ads_report_first_page_data32
 order by 1 desc, 2
;

-- 全部-表格-含分销月度指标详情
select date_format(concat(month, 11), '%y-%m') as month2
     , sum(charge_itemcount)                   as `充值`
     , sum(charge_money)                       as `分成后充值`
     , sum(spend)                              as `推广费用`
     , case when sum(charge_money) = 0 then null else sum(spend) / sum(charge_money) end as `投放比`
     , sum(charge_money) - sum(spend)          as `毛利润`
     , case when sum(spend) = 0 then null else (sum(charge_money) - sum(spend)) / sum(spend) end as `毛利率`
     , date_format(date_sub(date_format(curdate(), '%Y-%m-01'), interval 18 month), '%y-%m') as months
  from ads.ads_trade_month_recharge_toufang
 where month >= date_format(date_sub(date_format(curdate(), '%Y-%m-01'), interval 18 month), '%Y%m')
   and month <= date_format(curdate(), '%Y%m')
   and product_id in (3311, 3322, 3333, 3366, 3371, 3388, 3501, 3511, 3399, 6833)
 group by 1
 order by 1 desc
;

-- 全部-表格-不含分销广告收入
select month2
     , sum(`广告收入`) as `广告收入`
  from (select date_format(dt, '%y-%m') as month2
             , sum(amt)                 as `广告收入`
          from dws.dws_advertisement_user_position_amt_ed
         where dt >= date_format(date_sub(curdate(), interval 18 month), '%Y-%m-01')
           and (    product_id <> 6833
                 or (    product_id = 6833
                     and coalesce(core, -1) not in (2, 3)
                    )
               )
         group by 1
         union all
         select date_format(date_add(date_start, interval 13 hour), '%y-%m') as month2
              , sum(IaaRevenue)                                              as `广告收入`
           from ods.ods_tidb_sharpengine_ads_global_tiktokminisiaadailyinsightbyhour
          where date_add(date_start, interval 13 hour) >= date_format(date_sub(curdate(), interval 18 month), '%Y-%m-01')
           group by 1
       ) t
group by 1
order by 1 desc
;

-- 全部-表格-不含分销畅读收入
select date_format(CreateTime, '%y-%m')  as month2
     , sum(BaseAmount)                   as `分成后充值`
     , sum(BaseAmount) - sum(CostAmount) as `扣除推广后充值`
     , sum(CostAmount) / sum(BaseAmount) as `投放比`
  from sharpengine_ads_global.tmp_report_业务总表
 where CreateTime >= date_format(date_sub(curdate(), interval 18 month), '%Y-%m-01')
   and DataType = '畅读'
   and ProductType in ('海剧', '海阅')
 group by 1
 order by 1 desc
;

-- 全部-表格明细
-- 新口径：仅包含海外阅读、海外短剧
with dau as (
    select dt
         , sum(dau)     as dau
         , sum(new_num) as new_num
      from (select dt
                 , count(distinct user_id) as dau
                 , bitmap_union_count(if(user_types = 0, user_id, null)) as new_num
              from ads.ads_report_user_dau_ed
             where dt >= date_sub(curdate(), interval 30 day)
               and product_id in (3311, 3322, 3333, 3366, 3371, 3388, 3501, 3511, 3399)
             group by 1
             union all
            select dt
                 , count(distinct user_id) as dau
                 , count(distinct case when dt = date(reg_time) then user_id end) as new_num
              from dws.dws_user_short_video_wide_active_ed
             where dt >= date_sub(curdate(), interval 30 day)
               and product_id = 6833
             group by 1
           ) a
     group by 1
)
, charge as (
    select dt
         , sum(charge_num)       as charge_num
         , sum(charge_money)     as charge_money
         , sum(first_charge_num) as first_charge_num
      from (select dt
                 , sum(charge_num)       as charge_num
                 , sum(charge_money)     as charge_money
                 , sum(fisrt_charge_num) as first_charge_num
              from ads.ads_user_charge_1d
             where dt >= date_sub(curdate(), interval 30 day)
               and product_id in (3311, 3322, 3333, 3366, 3371, 3388, 3501, 3511, 3399)
             group by 1
             union all
            select dt
                 , count(distinct user_id) as charge_num
                 , round(sum(charge_money), 2) as charge_money
                 , count(distinct case when dt = first_charge_day then user_id end) as first_charge_num
              from dws.dws_trade_short_viedo_payorder_ed
             where dt >= date_sub(curdate(), interval 30 day)
               and product_id = 6833
             group by 1
           ) a
     group by 1
)
select a.dt                as create_date
     , a.dau               as DAU
     , a.new_num           as `新增用户数`
     , b.charge_num        as `充值人数`
     , b.charge_money      as `充值金额`
     , b.first_charge_num  as `首充用户数`
  from dau a
  left join charge b
    on a.dt = b.dt
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
     , sum(charge_itemcount)                   as `充值`
     , sum(charge_money)                       as `分成后充值`
     , sum(spend)                              as `推广费用`
     , sum(spend) / sum(charge_money)          as `投放比`
     , sum(charge_money) - sum(spend)          as `毛利润`
     , date_format(date_sub(date_format(curdate(), '%Y-%m-01'), interval 12 month), '%y-%m') as months
  from ads.ads_trade_month_recharge_toufang
 where month >= date_format(date_sub(date_format(curdate(), '%Y-%m-01'), interval 12 month), '%Y%m')
   and product_id in (3311, 3322, 3333, 3366, 3371, 3388, 3501, 3511, 3399)
 group by 1
 order by 1
;

-- 海外阅读-柱状图+表格-分产品按月收入曲线（废弃）
select product_type_name         as ProductTypeName
     , month2
     , recharge                  as `充值`
     , recharge_after_fencheng   as `分成后充值`
     , promotion_expenses        as `推广费用`
     , spend_rate                as `投放比`
     , recharge_cut_promotion    as `毛利润`
     , total_recharge            as `总充值`
     , months
  from ads.ads_report_first_page_data6
 order by 1 desc, 2
;

-- 海外阅读-表格-含分销月度指标详情
-- 对应数据集：阅读-月度指标详情
select date_format(concat(month, 11), '%y-%m') as month2
     , sum(charge_itemcount)                   as `充值`
     , sum(charge_money)                       as `分成后充值`
     , sum(spend)                              as `推广费用`
     , case when sum(charge_money) = 0 then null
            else sum(spend) / sum(charge_money)
        end                                    as `投放比`
     , sum(charge_money) - sum(spend)          as `毛利润`
     , case when sum(spend) = 0 then null
            else (sum(charge_money) - sum(spend)) / sum(spend)
        end                                    as `毛利率`
     , date_format(date_sub(date_format(curdate(), '%Y-%m-01'), interval 18 month), '%y-%m') as months
  from ads.ads_trade_month_recharge_toufang
 where month >= date_format(date_sub(date_format(curdate(), '%Y-%m-01'), interval 18 month), '%Y%m')
   and month <= date_format(curdate(), '%Y%m')
   and product_id in (3311, 3322, 3333, 3366, 3371, 3388, 3501, 3511, 3399)
 group by 1
 order by 1 desc
;

-- 海外阅读-表格-不含分销广告收入
-- 对应数据集：阅读-畅读月度指标-sr
select month2
     , sum(`广告收入`) as `广告收入`
  from (select date_format(dt, '%y-%m') as month2
             , sum(amt)                 as `广告收入`
          from dws.dws_advertisement_user_position_amt_ed
         where dt >= date_format(date_sub(curdate(), interval 18 month), '%Y-%m-01')
           and product_id in (3311, 3322, 3333, 3366, 3371, 3388, 3501, 3511, 3399)
         group by 1
         union all
         select date_format(date_add(date_start, interval 13 hour), '%y-%m') as month2
              , sum(IaaRevenue)                                              as `广告收入`
           from ods.ods_tidb_sharpengine_ads_global_tiktokminisiaadailyinsightbyhour
          where productid in (3311, 3322, 3333, 3366, 3371, 3388, 3501, 3511, 3399)
            and date_add(date_start, interval 13 hour) >= date_format(date_sub(curdate(), interval 18 month), '%Y-%m-01')
           group by 1
       ) t
group by 1
order by 1 desc
;

-- 海外阅读-表格-不含分销畅读收入
-- 对应数据集：阅读-畅读月度指标-tidb
select date_format(CreateTime, '%y-%m')  as month2
     , sum(BaseAmount)                   as `分成后充值`
     , sum(BaseAmount) - sum(CostAmount) as `扣除推广后充值`
     , sum(CostAmount) / sum(BaseAmount) as `投放比`
  from sharpengine_ads_global.tmp_report_业务总表
 where CreateTime >= date_format(date_sub(curdate(), interval 18 month), '%Y-%m-01')
   and DataType = '畅读'
   and ProductType = '海阅'
 group by 1
 order by 1 desc
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
     , sum(charge_money) - sum(spend)        as `毛利润`
     , date_format(date_sub(date_format(curdate(), '%Y-%m-01'), interval 12 month), '%y-%m') as months
  from ads.ads_trade_month_recharge_toufang
 where month >= date_format(date_sub(date_format(curdate(), '%Y-%m-01'), interval 12 month), '%Y%m')
   and product_id in (6833)
 group by 1
 order by 1
;

-- 海外短剧-柱状图+表格-分产品按月收入曲线（废弃）
select ProductTypeName
     , date_format(concat(month, 11), '%y-%m') as month2
     , sum(charge_itemcount)                    as `充值`
     , round(sum(charge_money), 0)              as `分成后充值`
     , sum(spend)                               as `推广费用`
     , sum(spend) / sum(charge_money)           as `投放比`
     , sum(charge_money) - sum(spend)           as `毛利润`
     , null                                     as `总充值`
     , date_format(date_sub(date_format(curdate(), '%Y-%m-01'), interval 12 month), '%y-%m') as months
  from ads.ads_trade_month_recharge_toufang a
  left join dim.DIM_ProductType b
    on a.Product_Id = b.ProductId
   and b.ProductTypeName not in ('韩语阅读', '菲律宾宾语')
 where month >= date_format(date_sub(date_format(curdate(), '%Y-%m-01'), interval 12 month), '%Y%m')
   and product_id in (6833)
 group by 1, 2
 order by 1 desc, 2
;

-- 海外短剧-表格-含分销月度指标详情
-- 对应数据集：短剧-月度指标详情
select date_format(concat(month, 11), '%y-%m') as month2
     , sum(charge_itemcount)                   as `充值`
     , sum(charge_money)                       as `分成后充值`
     , sum(spend)                              as `推广费用`
     , case when sum(charge_money) = 0 then null else sum(spend) / sum(charge_money) end as `投放比`
     , sum(charge_money) - sum(spend)          as `毛利润`
     , case when sum(spend) = 0 then null else (sum(charge_money) - sum(spend)) / sum(spend) end as `毛利率`
     , date_format(date_sub(date_format(curdate(), '%Y-%m-01'), interval 18 month), '%y-%m') as months
  from ads.ads_trade_month_recharge_toufang
 where month >= date_format(date_sub(date_format(curdate(), '%Y-%m-01'), interval 18 month), '%Y%m')
   and month <= date_format(curdate(), '%Y%m')
   and product_id in (6833)
 group by 1
 order by 1 desc
;

-- 海外短剧-表格-不含分销广告收入
-- 对应数据集：短剧-畅读月度指标-sr
select month2
     , sum(`广告收入`) as `广告收入`
  from (select date_format(dt, '%y-%m') as month2
             , sum(amt)                 as `广告收入`
          from dws.dws_advertisement_user_position_amt_ed
         where dt >= date_format(date_sub(curdate(), interval 18 month), '%Y-%m-01')
           and product_id = 6833
           and coalesce(core, -1) not in (2, 3)
         group by 1
         union all
         select date_format(date_add(date_start, interval 13 hour), '%y-%m') as month2
              , sum(IaaRevenue)                                              as `广告收入`
           from ods.ods_tidb_sharpengine_ads_global_tiktokminisiaadailyinsightbyhour
          where productid = 6833
            and date_add(date_start, interval 13 hour) >= date_format(date_sub(curdate(), interval 18 month), '%Y-%m-01')
           group by 1
       ) t
group by 1
order by 1 desc
;

-- 海外短剧-表格-不含分销畅读收入
-- 对应数据集：短剧-畅读月度指标-tidb
select date_format(CreateTime, '%y-%m')  as month2
     , sum(BaseAmount)                   as `分成后充值`
     , sum(BaseAmount) - sum(CostAmount) as `扣除推广后充值`
     , sum(CostAmount) / sum(BaseAmount) as `投放比`
  from sharpengine_ads_global.tmp_report_业务总表
 where CreateTime >= date_format(date_sub(curdate(), interval 18 month), '%Y-%m-01')
   and DataType = '畅读'
   and ProductType = '海剧'
 group by 1
 order by 1 desc
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
