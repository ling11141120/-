----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_srsv_finance_user_pay_ymd
-- workflow_version : 5
-- create_user      : chenmo
-- task_name        : ads_srsv_finance_user_pay_ym
-- task_version     : 4
-- update_time      : 2025-04-14 15:19:20
-- sql_path         : \starrocks\tbl_ads_srsv_finance_user_pay_ymd\ads_srsv_finance_user_pay_ym
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_srsv_finance_user_pay_ym
with z1 as
(
select
   -- dt,
   left(dt, 7) ym,
	'MoboReader（阅读）' as types,
   count(distinct id) as con_user
from dim.dim_user_account_info_view
where dt>='2021-06-01'
group by 1,2
union all
select
	  left(dt, 7) ym,
	'MoboReels（短剧）' as types,
   count(distinct user_id) as con_user
from dim.dim_short_video_user_accountinfo
where dt>='2023-07-01'
group by 1,2

),

z2 as
(
select
    a1.ym,
    'MoboReader（阅读）' as types,
    count(distinct a1.user_id) con_user
from (
	select
		left(dt, 7) ym,
		user_id
	from ads.ads_report_trade_hkpayorder_detail_view
	where
		dt>='2021-06-01'
		and test_flag =0
		and order_status =1
		and product_id in (3311,3322,3333,3355,3366,3371,3377,3388,3399,3501,3511,7777,8888)
	group by 1,2
	union all
	select
        left(dt, 7) ym,
        user_id
	from dwd.dwd_consume_user_consume
	where
	dt>='2021-06-01'
	and types=1
	group by 1,2
) a1
group by 1,2

union all

select
	a1.ym,
	'MoboReels（短剧）' as types,
	count(distinct a1.user_id) con_user
from (
	select
		left(dt, 7) ym,
		user_id
	from ads.ads_report_trade_hkpayorder_detail_view
	where
		dt>='2023-07-01'
		and test_flag =0
		and order_status =1
		and product_id in (6833)
	group by 1,2
    union all
    select
        left(dt, 7) ym,
        account_id user_id
	from dwd.dwd_consume_short_video_consume_view
	where
	dt>='2023-07-01'
	and consume_type=0
	group by 1,2
) a1
group by 1,2

)

select
concat(z1.ym,'-01') as ym,
z1.types project_id,
z2.con_user mau,
z1.con_user user_num,
sum(z1.con_user) over(partition by z1.types order by z1.ym) user_total,
now() etl_time
from z1
left join z2
on z1.ym=z2.ym  and z1.types=z2.types
order by ym desc
limit 4;
