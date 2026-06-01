------------------------------------------------
-- title：【沙盘海阅】当日充值金额统计异常
-- level：P1
-- 浮动值差异 <= 5%
-- 频率：0 6/30 * * * ?
------------------------------------------------

select round(abs(cast((t1.charge_money - t2.charge_money) / t2.charge_money * 100 as double)), 2) as ratio
  from (select sum(baseamount)/100.0 as charge_money
          from dwd.dwd_trade_user_payorder
         where dt >= current_date
           and testflag = 0
           and productid in (3311, 3322, 3333, 3366, 3371, 3388, 3501, 3511, 3399)
       ) as t1
      ,(select charge_money from ads.ads_charge_order where datetypes = 1) as t2

------------------------------------------------
-- title：分层质量监控(dwd)
-- level：P1
-- 浮动值差异 <= 5%
-- 频率：0 4/30 * * * ?
------------------------------------------------
select abs(cast((a1.baseamount - a2.baseamount) / a2.baseamount * 100 as double)) as ratio
  from (select sum(baseamount) baseamount from dwd.dwd_trade_user_payorder where dt = current_date and TestFlag=0) as a1
      ,(select sum(baseamount) baseamount from ods.ods_book_user_payorder where dt = current_date and TestFlag=0) as a2
;

------------------------------------------------
-- title：ods同步延迟-语言库缩写(productId)
-- level：P1
-- 浮动值差异指标：视语言库情况
-- 频率：0 0/30 * * * ?
------------------------------------------------
-- 指标：<= 1800
select unix_timestamp(now()) - max(unix_timestamp(createtime)) as diff
from ods.ods_book_user_payorder where dt = current_date
and productid = 3333
;
-- 指标：<= 1800
select unix_timestamp(now()) - max(unix_timestamp(createtime)) as diff
from ods.ods_book_user_payorder where dt = current_date
and productid = 3311
;
-- 指标：<= 1800
select unix_timestamp(now()) - max(unix_timestamp(createtime)) as diff
from ods.ods_book_user_payorder where dt = current_date
and productid = 3322
;
-- 指标：<= 1800
select unix_timestamp(now()) - max(unix_timestamp(createtime)) as diff
from ods.ods_book_user_payorder where dt = current_date
and productid = 3371
;
-- 指标：<= 3600
select unix_timestamp(now()) - max(unix_timestamp(createtime)) as diff
from ods.ods_book_user_payorder where dt = current_date
and productid = 3501
;
-- 指标：<= 1800
select unix_timestamp(now()) - max(unix_timestamp(createtime)) as diff
from ods.ods_book_user_payorder where dt = current_date
and productid = 3388
;
-- 指标：<= 1800
select unix_timestamp(now()) - max(unix_timestamp(createtime)) as diff
from ods.ods_book_user_payorder where dt = current_date
and productid = 3511
;
-- 指标：<= 1800
select unix_timestamp(now()) - max(unix_timestamp(createtime)) as diff
from ods.ods_book_user_payorder where dt = current_date
and productid = 3366
;