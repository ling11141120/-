----------------------------------------------------------------
-- 程序功能：SDK充值汇总加工
-- 程序名：P_ads_srsv_sdk_recharge_summary.sql
-- 目标表：ads.ads_srsv_sdk_recharge_summary
-- 负责人：xjc
-- 开发日期：2026-06-08
----------------------------------------------------------------

delete from ads.ads_srsv_sdk_recharge_summary where dt >= '$[add_months(yyyy-MM, -1)]-01' and dt <='${last_day}';

insert into ads.ads_srsv_sdk_recharge_summary
with member as(
    -- 海剧
    select
        order_id,
        amount,
        case
            when amount=0 and duration_time is null then '整剧购买'
            when duration_time is null then '普通充值'
            when duration_time <0 then '整剧购买'
            when duration_time <=2 then '小时卡'
            when duration_time <=10 then '周卡'
            when duration_time <=35 then '月卡'
            when duration_time <=100 then '季卡'
            when duration_time >100 then '年卡'
            end valid_time
    from ads.ads_sv_finance_series_recharge_consume_info t1
    where dt >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
      and dt <= last_day(date_sub('${dt}', interval 1 month)) and order_id != '-' and report_type = 1
    -- 海阅
    union all
    select
        order_id,
        amount,
        case
            when amount=0 and duration_time is null then '整剧购买'
            when duration_time is null then '普通充值'
            when duration_time <0 then '整剧购买'
            when duration_time <=2 then '小时卡'
            when duration_time <=10 then '周卡'
            when duration_time <=35 then '月卡'
            when duration_time <=100 then '季卡'
            when duration_time >100 then '年卡'
            else '其他'
            end valid_time
    from ads.ads_sr_finance_book_recharge_consume_info t1
    where dt >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
      and dt <= last_day(date_sub('${dt}', interval 1 month)) and order_id != '-' and report_type = 1
)
select
    dt,
    product_id,
    ifnull(country, '') as country,
    pay_channel,
    if_exist,
    test_flag,
    sum(amount) as amount,
    sum(base_amount) as base_amount,
    sum(amount-base_amount) as service_charge,
    now() as etl_time,
    count(distinct order_serial_id)    as recharge_cnt
from (
         select
             a.dt,
             a.product_id,
             a.country,
             a.pay_channel,
             a.order_serial_id,
             if(b.amount = 0 and b.valid_time != '普通充值', '会员充值', '普通充值') as if_exist,
             a.test_flag,
             a.amount,
             a.base_amount,
             a.corp,
             case
                 when del_col='leave' then 'leave'
                 when del_col='del1' and leave_col='leave1' then 'leave'
                 when del_col='del1b' and leave_col='leave1b' then 'leave'
                 when del_col='del3' and leave_col='leave3' then 'leave'
                 else 'del' end del_col1
         from (
                  select
                      date(a.coo_notify_time) as dt,
                      a.product_id,
                      a.order_serial_id,
                      a.country,
                      if(pay_name = ';oglePlay', 'GooglePlay', pay_name) as pay_channel,
                      a.test_flag,
                      ifnull(a.amount, 0)/100 as amount,
                      ifnull(a.base_amount, 0)/100 as base_amount,
                      -- -------- 新增剔除逻辑 -----
                      c.corp,
                      case
                          when  pay_name ='AppStore' and a.core =1 and coo_notify_time>='2021-06-27' and coo_notify_time<'2024-07-01' then 'del1'
                          when  pay_name ='AppStore' and a.core =1 and coo_notify_time>='2024-07-01'  then 'del1b'
                          when  pay_name ='AppStore' and a.core =2 and coo_notify_time>='2021-06-27' and coo_notify_time<'2022-03-27' then 'del2'
                          when  pay_name ='AppStore' and a.core =3  and a.order_id =d.order_number then 'del3b'
                          when  pay_name ='AppStore' and a.core =3 and coo_notify_time>='2021-06-27' and coo_notify_time<'2022-03-27' then 'del3'
                          when  pay_name in('GooglePlay',';oglePlay') and a.core =1 and coo_notify_time>='2021-06-01' and coo_notify_time<'2022-07-01'  then 'del4'
                          when  pay_name in('GooglePlay',';oglePlay')  and a.core in (2,3) and coo_notify_time>='2021-06-01' and coo_notify_time<'2022-06-01' then 'del5a'
                          when  pay_name in('GooglePlay',';oglePlay') and a.core in (2,3) and coo_notify_time>='2024-10-01' and coo_notify_time<'2025-02-01'   then 'del5b'
                          when  pay_name in('GooglePlay',';oglePlay')  and a.core= 4 and coo_notify_time>='2021-06-01' and coo_notify_time<'2022-07-01'  then 'del6'
                          when  pay_name ='PayPal'  and coo_notify_time>='2021-06-01' and coo_notify_time<'2022-02-01'   then 'del7a'
                          when  pay_name ='PayPal' and a.order_id = d.order_number then 'del7b'
                          when  pay_name ='AppGallery' then 'del8' else 'leave'
                          end del_col,
                      case
                          when  pay_name ='AppStore' and a.core =1 and coo_notify_time>='2021-06-27' and coo_notify_time<'2024-07-01'
                              and a.product_id = 3511 and os_type =1 then 'leave1'
                          when  pay_name ='AppStore' and a.core =1 and coo_notify_time>='2024-07-01' and a.product_id = 3511 and os_type in(1,7)  then 'leave1b'
                          when  pay_name ='AppStore' and a.core =3 and coo_notify_time>='2021-06-27' and coo_notify_time<'2022-03-27'
                              and a.product_id in (3511,3311,8858,8888,7757) and os_type =1 then 'leave3'
                          end leave_col
                  from dwd.dwd_srsv_trade_hk_sync_payorder_di_daily a
                           left join
                       dim.dim_srsv_paychannel_view c
                       on a.pay_chanel_id = c.id
                           left join dim.dim_sr_recharge_sdk_exclude d
                                     on a.order_id = d.order_number
                  where d.ym is null and a.coo_notify_time>='2021-06-27'
                    and date(a.coo_notify_time) >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
                    and date(a.coo_notify_time) <= last_day(date_sub('${dt}', interval 1 month))
              ) a
                  join member b
                       on a.order_serial_id = b.order_id
     ) a where del_col1 = 'leave' and corp = 'MOBOREADER'
group by 1, 2, 3, 4, 5, 6
;
