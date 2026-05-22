----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_alg_tf_book_amount_agg_7d
-- workflow_version : 11
-- create_user      : zhengtt
-- task_name        : alg_tf_book_amount_agg_7d_tmp
-- task_version     : 7
-- update_time      : 2024-10-16 12:03:19
-- sql_path         : \starrocks\tbl_alg_tf_book_amount_agg_7d\alg_tf_book_amount_agg_7d_tmp
----------------------------------------------------------------
-- 前置SQL语句
truncate table alg.alg_tf_book_amount_agg_7d_tmp;

-- SQL语句
INSERT into alg.alg_tf_book_amount_agg_7d_tmp
select
    x1.dt dt,
    x1.mt mt,
    x2.book_id book_id,
    count(distinct x1.ad_id) ad_num,
    sum(coalesce(dev_num, 0)) dev_num,
    sum(coalesce(reg_num, 0)) reg_num,
    sum(cast(coalesce(cost_amount, 0) as int)) cost_amount,
    sum(coalesce(day0_paynum, 0)) day0_paynum,
    sum(coalesce(day1_paynum, 0)) day1_paynum,
    sum(coalesce(day2_paynum, 0)) day2_paynum,
    sum(coalesce(day3_paynum, 0)) day3_paynum,
    sum(coalesce(day4_paynum, 0)) day4_paynum,
    sum(coalesce(day5_paynum, 0)) day5_paynum,
    sum(coalesce(day6_paynum, 0)) day6_paynum,
    sum(coalesce(day7_paynum, 0)) day7_paynum,
    sum(coalesce(day0_first_paynum, 0)) day0_first_paynum,
    sum(coalesce(day1_first_paynum, 0)) day1_first_paynum,
    sum(coalesce(day2_first_paynum, 0)) day2_first_paynum,
    sum(coalesce(day3_first_paynum, 0)) day3_first_paynum,
    sum(coalesce(day4_first_paynum, 0)) day4_first_paynum,
    sum(coalesce(day5_first_paynum, 0)) day5_first_paynum,
    sum(coalesce(day6_first_paynum, 0)) day6_first_paynum,
    sum(coalesce(day7_first_paynum, 0)) day7_first_paynum,
    sum(coalesce(Day0FirstPayTimes, 0)) day0_first_paytimes,
    sum(cast(coalesce(day0_amount, 0) as int)) day0_amount,
    sum(cast(coalesce(day1_amount, 0) as int)) day1_amount,
    sum(cast(coalesce(day2_amount, 0) as int)) day2_amount,
    sum(cast(coalesce(day3_amount, 0) as int)) day3_amount,
    sum(cast(coalesce(day4_amount, 0) as int)) day4_amount,
    sum(cast(coalesce(day5_amount, 0) as int)) day5_amount,
    sum(cast(coalesce(day6_amount, 0) as int)) day6_amount,
    sum(cast(coalesce(day7_amount, 0) as int)) day7_amount,
    sum(cast(coalesce(day15_amount, 0) as int)) day15_amount,
    sum(cast(coalesce(day30_amount, 0) as int)) day30_amount,
    sum(cast(coalesce(day40_amount, 0) as int)) day40_amount,
    sum(cast(coalesce(day50_amount, 0) as int)) day50_amount,
    sum(cast(coalesce(day60_amount, 0) as int)) day60_amount,
    sum(cast(coalesce(day70_amount, 0) as int)) day70_amount,
    sum(cast(coalesce(day80_amount, 0) as int)) day80_amount,
    sum(cast(coalesce(day90_amount, 0) as int)) day90_amount
from dwd.dwd_advertisement_fbadroiinstallreferrer_view x1
join
(    select ad_id, book_id
	from dwd.dwd_advertisement_adext_view
	where book_id>0
    group by ad_id, book_id
	)x2
on x1.ad_id=x2.ad_id
where dt between '2023-01-01' and  '2024-12-31' and x1.ad_id not like '%$%' and reg_num>0 and cost_amount>0
group by x1.dt, x1.mt, x2.book_id
order by dt, book_id;
