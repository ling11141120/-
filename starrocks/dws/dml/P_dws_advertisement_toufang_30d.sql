----------------------------------------------------------------
-- 程序功能： 广告投放30日汇总表
-- 程序名： P_dws_advertisement_toufang_30d
-- 目标表： dws.dws_advertisement_toufang_30d
-- 负责人： linq
-- 开发日期：2026-06-26
----------------------------------------------------------------

-- SQL语句
insert overwrite dws.dws_advertisement_toufang_30d
select month                         -- 月份
     , type                          -- 投放渠道类型
     , product_id                    -- 产品id
     , corever                       -- corever
     , current_language2             -- 投放语言
     , mt                            -- 终端
     , daysnum                       -- 当月天数
     , sum(Spend)        as spend    -- 投放金额
     , now()             as etl_time -- etl清洗时间
  from (select date_format(dt, '%Y%m') as month
             , type
             , product_id
             , corever
             , current_language2
             , mt
             , if(concat(year(dt),month(dt)) = concat(year(now()), month(now()))
                  ,day(curdate())
                  ,dayofmonth(date_sub(date_add(date_trunc('month', dt), interval 1 month), interval 1 day))
                 )                     as daysnum
             , spend
          from dws.dws_advertisement_toufang_ed
         where product_id not in (7777, 8888)
       ) as t1
 group by month, daysnum, type, product_id, corever, current_language2, mt
;
