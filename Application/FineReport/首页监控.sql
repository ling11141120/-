------------------------------------------------
-- 业务：海阅
-- title：【沙盘】海阅-月同期充值金额波动异常
-- level：P1
-- 指标：<= 5%
-- 频率：30min
------------------------------------------------

with this_mon as (
    select sum(baseamount) / 100.0 as charge_money
      from dwd.dwd_trade_user_payorder
     where dt >= date_trunc('month', current_date())
       and testflag = 0 and productid in (3311,3322,3333,3366,3371,3388,3501,3511,3399)
)
, last_mon as (
    select sum(baseamount) / 100.0 as charge_money
      from dwd.dwd_trade_user_payorder
     where dt >= date_trunc('month', date_sub(current_date, interval 1 month))
       and CreateTime <= case when day(current_date) > day(date_sub(current_date, interval 1 month)) then date_format(date_sub(current_date, interval 1 month), '%Y-%m-%d 23:59:59')
                              else date_sub(now(), interval 1 month)
                          end
       and testflag = 0 and productid in (3311,3322,3333,3366,3371,3388,3501,3511,3399)
)
select abs(((select charge_money from this_mon) - (select charge_money from last_mon)) / (select charge_money from last_mon) * 100) as ratio
;

------------------------------------------------
-- 业务：海阅
-- title：【沙盘】海阅-日同期充值金额波动异常
-- level：P1
-- 指标：<= 5%
-- 频率：30min
------------------------------------------------

with today_data as (
    select sum(baseamount)/100.0 as charge_money
      from dwd.dwd_trade_user_payorder
     where dt >= current_date
       and testflag = 0
       and productid in (3311, 3322, 3333, 3366, 3371, 3388, 3501, 3511, 3399)
)
, yes_data as (
    select sum(baseamount)/100.0 as charge_money
      from dwd.dwd_trade_user_payorder
     where dt >= date_sub(current_date, interval 1 day)
       and createtime <= date_sub(now(), interval 1 day)
       and testflag = 0
       and productid in (3311, 3322, 3333, 3366, 3371, 3388, 3501, 3511, 3399)
)
select abs(((select charge_money from today_data) - (select charge_money from yes_data)) / (select charge_money from yes_data) * 100) as ratio
;

------------------------------------------------
-- 业务：海阅
-- title：【沙盘】海阅-payorder-[语言库]同步延迟（原标题：阅读payorder-……）
-- level：P1
-- 指标：视语言库情况
-- 频率：30min
------------------------------------------------
-- 指标：<= 1800
select UNIX_TIMESTAMP(now()) - max(UNIX_TIMESTAMP(createtime)) as diff
from ods.ods_book_user_payorder where dt = CURRENT_DATE
and productid = 3333
;
-- 指标：<= 1800
select UNIX_TIMESTAMP(now()) - max(UNIX_TIMESTAMP(createtime)) as diff
from ods.ods_book_user_payorder where dt = CURRENT_DATE
and productid = 3311
;
-- 指标：<= 1800
select UNIX_TIMESTAMP(now()) - max(UNIX_TIMESTAMP(createtime)) as diff
from ods.ods_book_user_payorder where dt = CURRENT_DATE
and productid = 3322
;
-- 指标：<= 1800
select UNIX_TIMESTAMP(now()) - max(UNIX_TIMESTAMP(createtime)) as diff
from ods.ods_book_user_payorder where dt = CURRENT_DATE
and productid = 3371
;
-- 指标：<= 3600
select UNIX_TIMESTAMP(now()) - max(UNIX_TIMESTAMP(createtime)) as diff
from ods.ods_book_user_payorder where dt = CURRENT_DATE
and productid = 3501
;
-- 指标：<= 1800
select UNIX_TIMESTAMP(now()) - max(UNIX_TIMESTAMP(createtime)) as diff
from ods.ods_book_user_payorder where dt = CURRENT_DATE
and productid = 3388
;
-- 指标：<= 1800
select UNIX_TIMESTAMP(now()) - max(UNIX_TIMESTAMP(createtime)) as diff
from ods.ods_book_user_payorder where dt = CURRENT_DATE
and productid = 3511
;
-- 指标：<= 1800
select UNIX_TIMESTAMP(now()) - max(UNIX_TIMESTAMP(createtime)) as diff
from ods.ods_book_user_payorder where dt = CURRENT_DATE
and productid = 3366
;