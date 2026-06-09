----------------------------------------------------------------
-- 程序功能：海剧循环删除逻辑初次导入
-- 程序名：P_ads_sv_finance_series_recharge_consume_info_jsconsume
-- 目标表：ads.ads_sv_finance_series_recharge_consume_info_jsconsume
-- 负责人：xjc
-- 开发日期：2026-06-09
----------------------------------------------------------------

insert overwrite ads.ads_sv_finance_series_recharge_consume_info_jsconsume
select
    dt,
    row_number() over (order by product_id, user_id, order_time, amount) as one_id,
    product_id,
    user_id,
    series_id,
    order_time,
    amount,
    remain_amount,
    report_type,
    sum(if(dt < date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01'), amount_sum, amount)) over (partition by product_id, user_id order by order_time) as amount_sum,
    now() as etl_time
from (
         select
             dt,
             product_id,
             user_id,
             null as series_id,
             amount,
             remain_amount,
             order_time,
             1 as report_type,
             0 as amount_sum
         from ads.ads_sv_finance_series_recharge_consume_info
         where amount != 0 and report_type = 1
           and dt >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
           and dt <= last_day(date_sub('${dt}', interval 1 month))
         union all
         select
             date(CreateTime) as dt,
             6833 as product_id,
             UserId as user_id,
             BookId as book_id,
             concat('-', Amount) as amount,
             RemainAmount as remain_amount,
             CreateTime,
             2 as report_type,
             0 as amount_sum
         from dwd.dwd_finance_sv_usermoneylog_view
         where date(CreateTime) >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
           and date(CreateTime) <= last_day(date_sub('${dt}', interval 1 month))
         union all
         select
             a.dt,
             a.product_id,
             a.user_id,
             a.series_id,
             a.amount,
             a.remain_amount_all,
             a.order_time,
             a.report_type,
             a.remain_amount
         from (
                  select
                      *,
                      row_number() over (partition by product_id, user_id order by order_time desc, remain_amount) as rn
                  from ads.ads_sv_finance_series_recharge_consume_info
                  where dt < date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
              ) a where rn = 1
     ) a;