----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_trade_short_video_user_payorder_ed
-- workflow_version : 2
-- create_user      : zhugl
-- task_name        : tbl_dws_trade_short_video_user_payorder_ed
-- task_version     : 2
-- update_time      : 2024-11-29 14:03:53
-- sql_path         : \starrocks\tbl_dws_trade_short_video_user_payorder_ed\tbl_dws_trade_short_video_user_payorder_ed
----------------------------------------------------------------
-- SQL语句
insert into  dws.dws_trade_short_video_user_payorder_ed
with userinfo as (
select user_id,product_id,sex,mt,corever,current_language2,current_language,reg_country,source_chl,ad_quality
from dim.dim_short_video_user_accountinfo),
charge as (
select dt,product_id,user_id,item_count,status,create_time,base_amount from dwd.dwd_trade_short_video_payorder  where dt>='${bf_1_dt}' and  test_flag =0
),
charge_sum as(
select dt,product_id,user_id,first_recharge,first_recharge_tm,last_recharge, last_recharge_tm,max_recharge,sum_recharge,sum_base_amount,cnt_recharge
from (select dt,product_id,user_id,
FIRST_VALUE(item_count)over(partition by product_id,user_id,dt order by create_time rows between unbounded preceding and unbounded following) first_recharge ,-- 首充金额
FIRST_VALUE(create_time)over(partition by product_id,user_id,dt order by create_time rows between unbounded preceding and unbounded following) first_recharge_tm ,-- 首充金额
LAST_VALUE(item_count)over(partition by product_id,user_id,dt order by create_time rows between unbounded preceding and unbounded following) last_recharge ,-- 最后金额
LAST_VALUE(create_time)over(partition by product_id,user_id,dt order by create_time rows between unbounded preceding and unbounded following) last_recharge_tm ,-- 最后金额
max(item_count)over(partition by product_id,user_id,dt order by create_time rows between unbounded preceding and unbounded following) max_recharge ,-- 最大充值金额
sum(item_count)over(partition by product_id,user_id,dt order by create_time rows between unbounded preceding and unbounded following) sum_recharge ,-- 总充值金额
sum(base_amount)over(partition by product_id,user_id,dt order by create_time rows between unbounded preceding and unbounded following) sum_base_amount ,-- 总充值金额
count(item_count)over(partition by product_id,user_id,dt order by create_time rows between unbounded preceding and unbounded following) cnt_recharge ,-- 充值次数
ROW_NUMBER()over(partition by product_id,user_id,dt order by create_time ) nm
FROM  charge  where status =0)a where nm =1),
ref_charge_sum as(
select dt,product_id,user_id,first_ref_recharge,first_ref_recharge_tm,last_ref_recharge,last_ref_recharge_tm,max_ref_recharge,sum_ref_recharge,cnt_ref_recharge
from (select dt,product_id,user_id,
FIRST_VALUE(item_count)over(partition by product_id,user_id,dt order by create_time rows between unbounded preceding and unbounded following) first_ref_recharge ,-- 首充退款金额
FIRST_VALUE(create_time)over(partition by product_id,user_id,dt order by create_time rows between unbounded preceding and unbounded following) first_ref_recharge_tm ,-- 首充退款金额
LAST_VALUE(item_count)over(partition by product_id,user_id,dt order by create_time rows between unbounded preceding and unbounded following) last_ref_recharge ,-- 最后退款金额
LAST_VALUE(create_time)over(partition by product_id,user_id,dt order by create_time rows between unbounded preceding and unbounded following) last_ref_recharge_tm ,-- 最后退款金额
max(item_count)over(partition by product_id,user_id,dt order by create_time rows between unbounded preceding and unbounded following) max_ref_recharge ,-- 最大退款金额
sum(item_count)over(partition by product_id,user_id,dt order by create_time rows between unbounded preceding and unbounded following) sum_ref_recharge ,-- 退款金额
0,
count(item_count)over(partition by product_id,user_id,dt order by create_time rows between unbounded preceding and unbounded following) cnt_ref_recharge ,-- 退款次数
ROW_NUMBER()over(partition by product_id,user_id,dt order by create_time ) nm
FROM  charge  where status =1)a where nm =1),
alluser as (
select dt,product_id,user_id
from(
select dt,product_id,user_id from charge_sum
union all
select dt,product_id,user_id from ref_charge_sum)a
group by dt,product_id,user_id
)
select
COALESCE (charge_sum.dt,ref_charge_sum.dt) dt,
COALESCE (charge_sum.product_id,ref_charge_sum.product_id) product_id,
COALESCE (charge_sum.user_id,ref_charge_sum.user_id) user_id,
userinfo.sex,
userinfo.mt,
userinfo.source_chl,
userinfo.corever,
userinfo.current_language2,
userinfo.current_language,
userinfo.reg_country,
userinfo.ad_quality  ,
first_recharge,
first_recharge_tm,
last_recharge,
last_recharge_tm,
max_recharge,
sum_recharge,
sum_base_amount,
cnt_recharge,
first_ref_recharge,
first_ref_recharge_tm,
last_ref_recharge,
last_ref_recharge_tm,
max_ref_recharge,
sum_ref_recharge,
cnt_ref_recharge,
NOW()  etl_tm
from alluser left  join
userinfo  on alluser.user_id = userinfo.user_id and alluser.product_id = userinfo.product_id
left   join
charge_sum
on alluser.user_id = charge_sum.user_id and alluser.product_id = charge_sum.product_id and alluser.dt = charge_sum.dt
left  join ref_charge_sum
on alluser.user_id = ref_charge_sum.user_id and alluser.product_id = ref_charge_sum.product_id  and alluser.dt = ref_charge_sum.dt
where COALESCE(charge_sum.dt,ref_charge_sum.dt) is not  null;
