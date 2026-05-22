----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_app_paysort_result
-- workflow_version : 7
-- create_user      : linq
-- task_name        : tbl_ads_sv_app_paysort_result
-- task_version     : 4
-- update_time      : 2024-10-16 15:41:45
-- sql_path         : \starrocks\tbl_ads_sv_app_paysort_result\tbl_ads_sv_app_paysort_result
----------------------------------------------------------------
-- SQL语句
insert overwrite ads.ads_sv_app_paysort_result
with pay as (
    select a.dt,
           case when cast(a.product_id as smallint) is null then -1 else a.product_id end product_id,
           case when cast(a.core as smallint) is null then -1 else a.core end core,
           case when c.reg_country ='' or c.reg_country is null or c.reg_country ='UNKNOWN' then 'other' else c.reg_country end country,
           a.order_status,
           a.mt,
           case when a.pay_name ='' or a.pay_name is null or a.pay_name ='undefined' then 'other' else a.pay_name end pay_name, -- 支付方式
           case when a.sub_pay_type ='' or a.sub_pay_type is null or a.sub_pay_type ='undefined' then 'other' else a.sub_pay_type end pay_channel, -- 子渠道（支付id）
           case when a.pay_ment_way ='' or a.pay_ment_way is null or a.pay_ment_way ='undefined' then 'other' else a.pay_ment_way end pay_ment_way, -- 支付渠道(支付渠道名)
           count(1) pay_cnt,
           count(distinct a.user_id) pay_unt,
           sum(case when a.pay_chanel_id in(336651, 336617) then a.amount * 0.014 else a.amount end) pay_amt,
           sum(case when a.dt<'2021-02-01' and a.pay_chanel_id in(336651,336617) then a.amount*0.014
               when a.dt<'2021-02-01' and a.pay_chanel_id not in(336651,336617) then a.amount*0.7
               when a.dt>='2021-02-01' then a.base_amount end) pay_amt2
    from(
        select dt,product_id,user_id,core,order_status,mt,pay_name,sub_pay_type,pay_chanel_id,pay_ment_way,
               cast((amount/100) as decimal(10,2)) as amount,cast((base_amount/100) as decimal(10,2)) as base_amount
        from ads.ads_report_trade_hkpayorder_detail_view
        where dt between DATE_FORMAT(DATE_SUB('${bf_1_dt}',89),'%Y-%m-%d') and '${bf_1_dt}'
          and product_id=6833 and test_flag!=1
    )a
    left join dim.dim_short_video_user_accountinfo c on a.user_id=c.user_id and a.product_id =c.product_id
    GROUP BY 1,2,3,4,5,6,7,8,9
)
select
 product_id
,country
,pay_name
,pay_channel
,pay_ment_way
,IFNULL(round(pay_amt_l3d,4),0.00) pay_amt_l3d
,IFNULL(round(pay_amt_l7d,4),0.00) pay_amt_l7d
,IFNULL(round(pay_amt_l14d,4),0.00) pay_amt_l14d
,IFNULL(round(pay_amt_l30d,4),0.00) pay_amt_l30d
,IFNULL(round(pay_amt_l60d,4),0.00) pay_amt_l60d
,IFNULL(round(pay_amt_l90d,4),0.00) pay_amt_l90d
,IFNULL(round(pay_s_cnt_l3d*100/pay_t_cnt_l3d,4),0.00) pay_success_rate_l3d
,IFNULL(round(pay_s_cnt_l7d*100/pay_t_cnt_l7d,4),0.00) pay_success_rate_l7d
,IFNULL(round(pay_s_cnt_l14d*100/pay_t_cnt_l14d,4),0.00) pay_success_rate_l14d
,IFNULL(round(pay_s_cnt_l30d*100/pay_t_cnt_l30d,4),0.00) pay_success_rate_l30d
,IFNULL(round(pay_s_cnt_l60d*100/pay_t_cnt_l60d,4),0.00) pay_success_rate_l60d
,IFNULL(round(pay_s_cnt_l90d*100/pay_t_cnt_l90d,4),0.00) pay_success_rate_l90d
,CURRENT_TIMESTAMP() etl_time
from(
	select
	 product_id
	,country
	,pay_name
	,pay_channel
	,pay_ment_way
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
	from pay
	where country <>'other'
    and product_id <> -1
    and core <> -1
    and pay_name <>'other'
    and pay_channel <>'other'
    and pay_ment_way <>'other'
    group by product_id,country,pay_name,pay_channel,pay_ment_way
) res;
