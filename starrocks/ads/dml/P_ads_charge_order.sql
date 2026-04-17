-- 今天
insert into ads.ads_charge_order 
select 1 as datetypes, sum(baseamount)/100.0  as charge_money,sum(baseamount)/100.0*6.5 as charge_money_rmb,COUNT(1) as charge_order,count(distinct(UserId)) as charge_num  ,now() as etl_time
from dwd.dwd_trade_user_payorder where dt>=CURDATE() and testflag=0 and productid in (3311,3322,3333,3366,3371,3388,3501,3511,3399)
;

-- 昨日同期
insert into ads.ads_charge_order
select 2 as datetypes, sum(baseamount)/100.0  as charge_money,sum(baseamount)/100.0*6.5 as charge_money_rmb,COUNT(1) as charge_order,count(distinct(UserId)) as charge_num  ,now() as etl_time
from dwd.dwd_trade_user_payorder where dt>=date_add(CURDATE(),interval -1 day) and CreateTime<=date_add(now(),interval -1 day) and testflag=0 and productid in (3311,3322,3333,3366,3371,3388,3501,3511,3399)
;

-- 本月
insert into ads.ads_charge_order  
select 3 as datetypes, sum(baseamount)/100.0  as charge_money,sum(baseamount)/100.0*6.5 as charge_money_rmb,COUNT(1) as charge_order,count(distinct(UserId)) as charge_num ,now() as etl_time 
from dwd.dwd_trade_user_payorder where dt>=DATE_SUB(CURDATE(),INTERVAL dayofmonth(now())-1 DAY) and   testflag=0 and productid in (3311,3322,3333,3366,3371,3388,3501,3511,3399)
;

-- 上月同期
insert into ads.ads_charge_order 
select 4 as datetypes, sum(baseamount)/100.0  as charge_money,sum(baseamount)/100.0*6.5 as charge_money_rmb,COUNT(1) as charge_order,count(distinct(UserId)) as charge_num  ,now() as etl_time
from dwd.dwd_trade_user_payorder where dt>=date_sub(date_sub(curdate(),interval day(curdate()) - 1 day),interval 1 month) and 
CreateTime<= case when day(now()) > day(date_sub(now(),interval 1 month))
 then DATE_FORMAT(date_sub(now(),interval 1 month),'%Y-%m-%d 23:59:59')
 else date_sub(now(),interval 1 month) end 
and testflag=0 and productid in (3311,3322,3333,3366,3371,3388,3501,3511,3399)
;

-- 本季度
insert into ads.ads_charge_order 
select 5 as datetypes, sum(baseamount)/100.0  as charge_money,sum(baseamount)/100.0*6.5 as charge_money_rmb,COUNT(1) as charge_order,count(distinct(UserId)) as charge_num  ,now() as etl_time
from  dwd.dwd_trade_user_payorder where dt>= DATE_SUB(CURDATE() ,  INTERVAL 3 month ) and 
CreateTime > DATE_SUB(NOW(),  INTERVAL 3 month ) AND CreateTime < now() and QUARTER(CreateTime) = QUARTER(now())  and testflag=0 and productid in (3311,3322,3333,3366,3371,3388,3501,3511,3399)
;

-- 上季度同期
insert into ads.ads_charge_order 
select 6 as datetypes, sum(baseamount)/100.0  as charge_money,sum(baseamount)/100.0*6.5 as charge_money_rmb,COUNT(1) as charge_order,count(distinct(UserId)) as charge_num ,now() as etl_time 
from  dwd.dwd_trade_user_payorder where
  dt>= DATE_SUB(CURDATE() ,  INTERVAL 6 month ) and 
CreateTime > DATE_SUB(NOW(),  INTERVAL 6 month ) and CreateTime <= DATE_SUB(NOW(),  INTERVAL 3 month )  and QUARTER(CreateTime) =QUARTER( DATE_SUB(NOW(),  INTERVAL 3 month ) )  and testflag=0 and productid in (3311,3322,3333,3366,3371,3388,3501,3511,3399)
;

-- 本季度完整
insert into ads.ads_charge_order 
select datetypes,charge_money,charge_money_rmb,charge_order,charge_num,etl_time
from
(   select 7 as datetypes, sum(baseamount)/100.0  as charge_money,sum(baseamount)/100.0*6.5 as charge_money_rmb,COUNT(1) as charge_order,count(distinct(UserId)) as charge_num ,now() as etl_time
    from  dwd.dwd_trade_user_payorder
    where 
   -- dt>=DATE_SUB(CURDATE() ,  INTERVAL 3 month ) and 
    QUARTER(CreateTime) = QUARTER(DATE_SUB(NOW(),  INTERVAL 3 month )) and year(CreateTime) = year(DATE_SUB(NOW(),  INTERVAL 3 month )) and testflag=0 and productid in (3311,3322,3333,3366,3371,3388,3501,3511,3399)
    ) b
;