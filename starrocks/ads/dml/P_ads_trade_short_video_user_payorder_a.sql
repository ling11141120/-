----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_trade_short_video_user_payorder_a
-- workflow_version : 1
-- create_user      : zhugl
-- task_name        : tbl_ads_trade_short_video_user_payorder_a
-- task_version     : 1
-- update_time      : 2023-12-28 14:14:48
-- sql_path         : \starrocks\tbl_ads_trade_short_video_user_payorder_a\tbl_ads_trade_short_video_user_payorder_a
----------------------------------------------------------------
-- SQL语句
insert  into ads.ads_trade_short_video_user_payorder_a
select
a.product_id,
a.user_id,
a.sex,
a.mt,
a.source_chl,
a.corever,
a.current_language2,
a.current_language,
a.reg_country,
a.ad_quality,
first_recharge,
max_recharge,
sum_recharge,
cnt_recharge,
sum_recharge/cnt_recharge avg_recharge,
sum_ref_recharge*-1,
cnt_ref_recharge,
NOW() etl_tm
from (select
dt,product_id,user_id,sex,mt,source_chl,corever,current_language2,current_language,reg_country,ad_quality,
FIRST_VALUE(first_recharge)over(partition by product_id,user_id order by first_recharge_tm rows between unbounded preceding and unbounded following) first_recharge ,-- 首充金额
max(max_recharge)over(partition by product_id,user_id order by first_recharge_tm rows between unbounded preceding and unbounded following) max_recharge ,-- 最大充值金额
sum(sum_recharge)over(partition by product_id,user_id order by first_recharge_tm rows between unbounded preceding and unbounded following) sum_recharge ,-- 总充值金额
sum(cnt_recharge)over(partition by product_id,user_id order by first_recharge_tm rows between unbounded preceding and unbounded following) cnt_recharge ,-- 充值次数
-- 退款
sum(sum_ref_recharge)over(partition by product_id,user_id order by first_recharge_tm rows between unbounded preceding and unbounded following) sum_ref_recharge ,-- 总充值金额
sum(cnt_ref_recharge)over(partition by product_id,user_id order by first_recharge_tm rows between unbounded preceding and unbounded following) cnt_ref_recharge ,-- 充值次数
ROW_NUMBER()over(partition by product_id,user_id order by first_recharge_tm ) nm
FROM  dws.dws_trade_short_video_user_payorder_ed )a where nm =1;
