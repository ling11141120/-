----------------------------------------------------------------
-- 程序功能：海剧循环删除逻辑导出
-- 程序名：P_ads_sv_finance_series_recharge_consume_info
-- 目标表：ads.ads_sv_finance_series_recharge_consume_info
-- 负责人：xjc
-- 开发日期：2026-06-09
----------------------------------------------------------------

-- 循环删除导出
insert into ads.ads_sv_finance_series_recharge_consume_info
with test_user as (
    select
        distinct user_id
    from dwd.dwd_finance_sv_payorder_view
    where test_flag = 1
)
select
    dt,
    product_id,
    user_id,
    series_id,
    order_id,
    coo_order_id,
    shop_item_id,
    report_type,
    amount,
    remain_amount,
    remain_amount_all,
    cost,
    test_flag,
    order_time,
    expiration_time,
    duration_time,
    now() as etl_time
from (
         select
             dt,
             product_id,
             user_id,
             series_id,
             order_id,
             coo_order_id,
             shop_item_id,
             report_type,
             amount,
             sum(if(dt < date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01'), remain_amount, amount)) over (partition by a.product_id, a.user_id order by a.order_time, a.order_id desc, a.amount desc) as remain_amount,
             remain_amount_all,
             cost,
             test_flag,
             order_time,
             expiration_time,
             duration_time
         from (
                  select
                      a.dt,
                      a.product_id,
                      a.user_id,
                      a.series_id,
                      a.order_id,
                      a.coo_order_id,
                      a.shop_item_id,
                      a.report_type,
                      a.amount,
                      a.remain_amount,
                      a.remain_amount_all,
                      a.cost,
                      if(b.user_id is not null, 1, 0) as test_flag,
                      a.order_time,
                      a.expiration_time,
                      a.duration_time
                  from ads.ads_sv_finance_series_recharge_consume_info a
                           left join test_user b
                                     on a.user_id = b.user_id
                  where report_type = 1 and dt >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
                    and dt <= last_day(date_sub('${dt}', interval 1 month))
                  union all
                  select
                      a.dt,
                      a.product_id,
                      a.user_id,
                      a.series_id,
                      '-' as order_id,
                      '-' as coo_order_id,
                      null as shop_itme_id,
                      a.report_type,
                      a.amount,
                      a.amount_sum,
                      a.remain_amount,
                      null as cost,
                      if(b.user_id is not null, 1, 0) as test_flag,
                      a.order_time,
                      null as expiration_time,
                      null as duration_time
                  from ads.ads_sv_finance_series_recharge_consume_info_jsconsume a
                           left join test_user b
                                     on a.user_id = b.user_id
                  where (report_type = 2 and dt >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
                      and dt <= last_day(date_sub('${dt}', interval 1 month))
                      )
                     or dt < date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
              ) a
     ) a where dt >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
           and dt <= last_day(date_sub('${dt}', interval 1 month))
;
