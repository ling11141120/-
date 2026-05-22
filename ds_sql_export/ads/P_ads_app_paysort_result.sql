----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_app_paysort_result
-- workflow_version : 8
-- create_user      : doupz
-- task_name        : ads_app_paysort_result
-- task_version     : 4
-- update_time      : 2024-10-16 15:40:57
-- sql_path         : \starrocks\tbl_ads_app_paysort_result\ads_app_paysort_result
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_app_paysort_result
select
 product_id
,core
,country
,pay_name  -- 支付名称
,pay_ment_way  -- 需要新增渠道名称
,pay_channel -- 渠道id
,IFNULL(round(pay_amt_l3d*100/sum(pay_amt_l3d) over(partition by product_id,core,country),4),0.00) pay_amt_rate_l3d
,IFNULL(round(pay_amt_l7d*100/sum(pay_amt_l7d) over(partition by product_id,core,country),4),0.00) pay_amt_rate_l7d
,IFNULL(round(pay_amt_l14d*100/sum(pay_amt_l14d) over(partition by product_id,core,country),4),0.00) pay_amt_rate_l14d
,IFNULL(round(pay_amt_l30d*100/sum(pay_amt_l30d) over(partition by product_id,core,country),4),0.00) pay_amt_rate_l30d
,IFNULL(round(pay_amt_l60d*100/sum(pay_amt_l60d) over(partition by product_id,core,country),4),0.00) pay_amt_rate_l60d
,IFNULL(round(pay_amt_l90d*100/sum(pay_amt_l90d) over(partition by product_id,core,country),4),0.00) pay_amt_rate_l90d
,IFNULL(round(pay_s_cnt_l3d*100/pay_t_cnt_l3d,4),0.00) pay_success_rate_l3d
,IFNULL(round(pay_s_cnt_l7d*100/pay_t_cnt_l7d,4),0.00) pay_success_rate_l7d
,IFNULL(round(pay_s_cnt_l14d*100/pay_t_cnt_l14d,4),0.00) pay_success_rate_l14d
,IFNULL(round(pay_s_cnt_l30d*100/pay_t_cnt_l30d,4),0.00) pay_success_rate_l30d
,IFNULL(round(pay_s_cnt_l60d*100/pay_t_cnt_l60d,4),0.00) pay_success_rate_l60d
,IFNULL(round(pay_s_cnt_l90d*100/pay_t_cnt_l90d,4),0.00) pay_success_rate_l90d
,CURRENT_TIMESTAMP() etl_time
from (

	select
	 product_id
	,core
	,country
	,pay_name
	,pay_ment_way
	,pay_channel
	,sum(case when order_status =1 and dt>=DATE_FORMAT(DATE_SUB('${bf_1_dt}',2),'%Y-%m-%d') then pay_amt else 0 end) pay_amt_l3d
	,sum(case when order_status =1 and dt>=DATE_FORMAT(DATE_SUB('${bf_1_dt}',6),'%Y-%m-%d') then pay_amt else 0 end) pay_amt_l7d
	,sum(case when order_status =1 and dt>=DATE_FORMAT(DATE_SUB('${bf_1_dt}',13),'%Y-%m-%d') then pay_amt else 0 end) pay_amt_l14d
	,sum(case when order_status =1 and dt>=DATE_FORMAT(DATE_SUB('${bf_1_dt}',29),'%Y-%m-%d') then pay_amt else 0 end) pay_amt_l30d
	,sum(case when order_status =1 and dt>=DATE_FORMAT(DATE_SUB('${bf_1_dt}',59),'%Y-%m-%d') then pay_amt else 0 end) pay_amt_l60d
	,sum(case when order_status =1 and dt>=DATE_FORMAT(DATE_SUB('${bf_1_dt}',89),'%Y-%m-%d') then pay_amt else 0 end) pay_amt_l90d

	,sum(case when order_status =1 and dt>=DATE_FORMAT(DATE_SUB('${bf_1_dt}',2),'%Y-%m-%d') then pay_cnt else 0 end) pay_s_cnt_l3d
	,sum(case when order_status =1 and dt>=DATE_FORMAT(DATE_SUB('${bf_1_dt}',6),'%Y-%m-%d') then pay_cnt else 0 end) pay_s_cnt_l7d
	,sum(case when order_status =1 and dt>=DATE_FORMAT(DATE_SUB('${bf_1_dt}',13),'%Y-%m-%d') then pay_cnt else 0 end) pay_s_cnt_l14d
	,sum(case when order_status =1 and dt>=DATE_FORMAT(DATE_SUB('${bf_1_dt}',29),'%Y-%m-%d') then pay_cnt else 0 end) pay_s_cnt_l30d
	,sum(case when order_status =1 and dt>=DATE_FORMAT(DATE_SUB('${bf_1_dt}',59),'%Y-%m-%d') then pay_cnt else 0 end) pay_s_cnt_l60d
	,sum(case when order_status =1 and dt>=DATE_FORMAT(DATE_SUB('${bf_1_dt}',89),'%Y-%m-%d') then pay_cnt else 0 end) pay_s_cnt_l90d

	,sum(case when dt>=DATE_FORMAT(DATE_SUB('${bf_1_dt}',2),'%Y-%m-%d') then pay_cnt else 0 end) pay_t_cnt_l3d
	,sum(case when dt>=DATE_FORMAT(DATE_SUB('${bf_1_dt}',6),'%Y-%m-%d') then pay_cnt else 0 end) pay_t_cnt_l7d
	,sum(case when dt>=DATE_FORMAT(DATE_SUB('${bf_1_dt}',13),'%Y-%m-%d') then pay_cnt else 0 end) pay_t_cnt_l14d
	,sum(case when dt>=DATE_FORMAT(DATE_SUB('${bf_1_dt}',29),'%Y-%m-%d') then pay_cnt else 0 end) pay_t_cnt_l30d
	,sum(case when dt>=DATE_FORMAT(DATE_SUB('${bf_1_dt}',59),'%Y-%m-%d') then pay_cnt else 0 end) pay_t_cnt_l60d
	,sum(case when dt>=DATE_FORMAT(DATE_SUB('${bf_1_dt}',89),'%Y-%m-%d') then pay_cnt else 0 end) pay_t_cnt_l90d

from (
    select a.dt,
           case when cast(a.product_id as smallint) is null then -1 else a.product_id end product_id,
           case when cast(a.core as smallint) is null then -1 else a.core end core,
           case when c.reg_country2 ='' or c.reg_country2 is null or c.reg_country2 ='UNKNOWN' then 'other' else c.reg_country2 end country,
           a.order_status,

           case when a.pay_name ='' or a.pay_name is null or a.pay_name ='undefined' then 'other' else a.pay_name end pay_name, -- 支付方式
		   case when a.pay_ment_way ='' or a.pay_ment_way is null or a.pay_ment_way ='undefined' then 'other' else a.pay_ment_way end pay_ment_way, -- 渠道名称
           case when a.sub_pay_type ='' or a.sub_pay_type is null or a.sub_pay_type ='undefined' then 'other' else a.sub_pay_type end pay_channel, -- 子渠道id
           count(1) pay_cnt,
           sum(case when a.pay_chanel_id in(336651, 336617) then cast((a.amount/100) as decimal(10,2)) * 0.014 else cast((a.amount/100) as decimal(10,2)) end) pay_amt
    from
         ads.ads_report_trade_hkpayorder_detail_view a
left join -- ----关联账户表获取用户国家--------------------
	 ( select product_id,id,reg_country2 from dim.dim_user_account_info_view )c
	 on a.user_id=c.id and a.product_id =c.product_id
	 where
	 a.dt between DATE_FORMAT(DATE_SUB('${bf_1_dt}',89),'%Y-%m-%d') and '${bf_1_dt}'
	 and a.test_flag=0                         -- 筛选正式数据
	 and a.product_id not in (6832,6833,33999) -- 排除海剧、异常数据
	   GROUP BY 1,2,3,4,5,6,7,8
) a
where
      country <>'other'
    and product_id <> -1
    and core <> -1
    and pay_name <>'other'
    and pay_ment_way <>'other'
    and pay_channel <>'other'

	 group by 1,2,3,4,5,6
       ) res;

-- 后置SQL语句
DELETE from ads.ads_app_paysort_result where etl_time  < '${dt}';
