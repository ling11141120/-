----------------------------------------------------------------
-- 程序功能：海阅上月数据是否与旧订单重复
-- 程序名：P_ads_sr_finance_book_recharge_consume_info_delete
-- 目标表：ads.ads_sr_finance_book_recharge_consume_info_delete
-- 负责人：xjc
-- 开发日期：2026-06-09
----------------------------------------------------------------

-- 验证数据唯一
insert overwrite ads.ads_sr_finance_book_recharge_consume_info_delete
select order_id
  from ads.ads_sr_finance_book_recharge_consume_info
 group by order_id
having count(1) > 1
;