-- ====================================================================================
-- 海外阅读
-- ====================================================================================

-------------------------------------
-- 充值收入/充值人数/充值笔数相关
-------------------------------------
select datetypes
     , charge_money
     , charge_money_rmb
     , charge_order
     , charge_num
  from ads.ads_charge_order
 where datetypes in (1, 2, 3, 4) -- 1-今天 2-昨日同期 3-本月 4-上月同期
;
-- ads_charge_order 直接上游
select sum(baseamount)/100.0  as charge_money
     , count(1)               as charge_order
     , count(distinct(UserId)) as charge_num
  from dwd.dwd_trade_user_payorder
 where productid in (3311,3322,3333,3366,3371,3388,3501,3511,3399)
   -- dt根据P_ads_charge_order选择
;
-- dwd_trade_user_payorder 直接上游
select sum(baseamount)/100.0  as charge_money
     , count(1)               as charge_order
     , count(distinct(UserId)) as charge_num
  from ods.ods_book_user_payorder
 where productid in (3311,3322,3333,3366,3371,3388,3501,3511,3399)
   and testflag = 0
   -- dt根据实际情况填写
;
select productid, count(1)
from ods.ods_book_user_payorder
where productid in (3311,3322,3333,3366,3371,3388,3501,3511,3399)
-- dt根据实际情况填写
group by 1
;
          select '3311' as db_name, count(1) as cnt from readernovel_tidb_fr.payorder -- createtime根据实际情况填写
union all select '3322' as db_name, count(1) as cnt from readernovel_tidb_pt.payorder -- createtime根据实际情况填写
union all select '3333' as db_name, count(1) as cnt from readernovel_tidb_ft.payorder -- createtime根据实际情况填写
union all select '3366' as db_name, count(1) as cnt from readernovel_tidb_en.payorder -- createtime根据实际情况填写
union all select '3371' as db_name, count(1) as cnt from readernovel_tidb_ru.payorder -- createtime根据实际情况填写
union all select '3388' as db_name, count(1) as cnt from readernovel_tidb_sp.payorder -- createtime根据实际情况填写
union all select '3501' as db_name, count(1) as cnt from readernovel_tidb_id.payorder -- createtime根据实际情况填写
union all select '3511' as db_name, count(1) as cnt from readernovel_tidb_th.payorder -- createtime根据实际情况填写
union all select '3399' as db_name, count(1) as cnt from readernovel_tidb_jp.payorder -- createtime根据实际情况填写