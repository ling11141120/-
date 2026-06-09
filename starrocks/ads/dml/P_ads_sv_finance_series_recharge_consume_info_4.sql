----------------------------------------------------------------
-- 程序功能：海剧补充消耗主键id
-- 程序名：P_ads_sv_finance_series_recharge_consume_info
-- 目标表：ads.ads_sv_finance_series_recharge_consume_info
-- 负责人：xjc
-- 开发日期：2026-06-09
----------------------------------------------------------------

insert into ads.ads_sv_finance_series_recharge_consume_info
select
    a.dt,
    a.product_id,
    a.user_id,
    a.series_id,
    if(a.order_id = '-', b.Id, a.order_id) as order_id,
    a.coo_order_id,
    a.shop_item_id,
    a.report_type,
    a.amount,
    a.remain_amount,
    a.remain_amount_all,
    a.cost,
    a.test_flag,
    a.order_time,
    a.expiration_time,
    a.duration_time,
    now() as etl_time
from (
         select
             *,
             row_number() over (partition by user_id, series_id, amount, remain_amount_all, order_time) as rn
         from ads.ads_sv_finance_series_recharge_consume_info
         where dt >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
           and dt <= last_day(date_sub('${dt}', interval 1 month))
     ) a
         left join (
    select
        Id,
        UserId,
        BookId,
        Amount,
        RemainAmount,
        CreateTime,
        row_number() over (partition by UserId, BookId, Amount, RemainAmount, CreateTime) as rn
    from dwd.dwd_finance_sv_usermoneylog_view
    where date(CreateTime) >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
      and date(CreateTime) <= last_day(date_sub('${dt}', interval 1 month))
) b
                   on a.user_id = b.UserId and a.series_id = b.BookId
                       and if(a.series_id = 0 and b.Amount < 0, b.Amount, abs(a.amount)) = b.Amount and a.remain_amount_all = b.RemainAmount and a.order_time = b.CreateTime and a.rn = b.rn
;
