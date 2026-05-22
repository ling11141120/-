----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_alg_update_repay_feat
-- workflow_version : 43
-- create_user      : admin
-- task_name        : alg_update_repay_feat
-- task_version     : 6
-- update_time      : 2025-04-02 20:39:41
-- sql_path         : \starrocks\tbl_alg_update_repay_feat\alg_update_repay_feat
----------------------------------------------------------------
-- SQL语句
insert into alg.alg_update_repay_feat
select
 '${bf_1_dt}' dt
,x1.UserId as user_id,x1.last_recharge_time,x1.pay_total,x1.pay_max,x1.pay_min,x1.pay_avg,x1.pay_times
,IFNULL(x2.pay_total_30d,0) pay_total_30d
,IFNULL(x2.pay_max_30d,0) pay_max_30d
,IFNULL(x2.pay_avg_30d,0) pay_avg_30d

,IFNULL(x2.pay_total_15d,0) pay_total_15d
,IFNULL(x2.pay_max_15d,0) pay_max_15d
,IFNULL(x2.pay_avg_15d,0) pay_avg_15d

,IFNULL(x2.pay_total_7d,0) pay_total_7d
,IFNULL(x2.pay_max_7d,0) pay_max_7d
,IFNULL(x2.pay_avg_7d,0) pay_avg_7d

,IFNULL(x2.pay_total_3d,0) pay_total_3d
,IFNULL(x2.pay_max_3d,0) pay_max_3d
,IFNULL(x2.pay_avg_3d,0) pay_avg_3d

,IFNULL(x2.pay_total_1d,0) pay_total_1d
,IFNULL(x2.pay_max_1d,0) pay_max_1d
,IFNULL(x2.pay_avg_1d,0) pay_avg_1d
,CURRENT_TIMESTAMP() etl_tm
from
(
  select
   UserId
  ,max(last_recharge_time) last_recharge_time
  ,sum(pay_amt*pay_num) pay_total
  ,max(pay_amt) pay_max
  ,min(pay_amt) pay_min
  ,sum(pay_amt*pay_num)/sum(pay_num)  pay_avg
  ,max(pay_model_max) pay_times
  from (
    select
     UserId
    ,ItemCount as pay_amt
    ,count(1) as pay_num
    ,max(createtime) last_recharge_time
    ,FIRST_VALUE(ItemCount) over(partition by UserId order by count(1) desc,ItemCount desc) pay_model_max
    from dwd.dwd_trade_user_payorder
    where dt <= '${bf_1_dt}'
    and testflag=0  and ItemCount>0
    group by 1, 2
  ) res
  group by UserId
) x1 left join
(
    select
      UserId,
      sum(if(datediff( '${bf_1_dt}', dt)<=29, ItemCount, 0)) pay_total_30d,
      max(if(datediff( '${bf_1_dt}', dt)<=29, ItemCount, 0)) pay_max_30d,
      avg(if(datediff( '${bf_1_dt}', dt)<=29, ItemCount, null)) pay_avg_30d,

      sum(if(datediff( '${bf_1_dt}', dt)<=14, ItemCount, 0)) pay_total_15d,
      max(if(datediff( '${bf_1_dt}', dt)<=14, ItemCount, 0)) pay_max_15d,
      avg(if(datediff( '${bf_1_dt}', dt)<=14, ItemCount, null)) pay_avg_15d,

      sum(if(datediff( '${bf_1_dt}', dt)<=6, ItemCount, 0)) pay_total_7d,
      max(if(datediff( '${bf_1_dt}', dt)<=6, ItemCount, 0)) pay_max_7d,
      avg(if(datediff( '${bf_1_dt}', dt)<=6, ItemCount, null)) pay_avg_7d,

      sum(if(datediff( '${bf_1_dt}', dt)<=2, ItemCount, 0)) pay_total_3d,
      max(if(datediff( '${bf_1_dt}', dt)<=2, ItemCount, 0)) pay_max_3d,
      avg(if(datediff( '${bf_1_dt}', dt)<=2, ItemCount, null)) pay_avg_3d,

      sum(if(datediff( '${bf_1_dt}', dt)=0, ItemCount, 0)) pay_total_1d,
      max(if(datediff( '${bf_1_dt}', dt)=0, ItemCount, 0)) pay_max_1d,
      avg(if(datediff( '${bf_1_dt}', dt)=0, ItemCount, null)) pay_avg_1d

    from dwd.dwd_trade_user_payorder
    where dt between DATE_SUB('${bf_1_dt}',29) and '${bf_1_dt}' and testflag=0  and ItemCount>0
    group by UserId
) x2  on x1.UserId= x2.UserId;
