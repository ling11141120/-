----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_alg_tf_book_amount_agg_7d
-- workflow_version : 11
-- create_user      : zhengtt
-- task_name        : alg_tf_book_amount_agg_7d
-- task_version     : 3
-- update_time      : 2024-10-16 12:03:19
-- sql_path         : \starrocks\tbl_alg_tf_book_amount_agg_7d\alg_tf_book_amount_agg_7d
----------------------------------------------------------------
-- 前置SQL语句
truncate table alg.alg_tf_book_amount_agg_7d;

-- SQL语句
INSERT into alg.alg_tf_book_amount_agg_7d
select
    x1.dt,
    x1.mt,
    x1.book_id,
    sum(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, ad_num, 0)) ad_num,
    sum(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, dev_num, 0)) dev_num,
    sum(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, reg_num, 0)) reg_num,
    sum(cast(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, cost_amount, 0) as int)) cost_amount,
    sum(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day0_paynum, 0)) day0_paynum,
    sum(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day1_paynum, 0)) day1_paynum,
    sum(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day2_paynum, 0)) day2_paynum,
    sum(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day3_paynum, 0)) day3_paynum,
    sum(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day4_paynum, 0)) day4_paynum,
    sum(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day5_paynum, 0)) day5_paynum,
    sum(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day6_paynum, 0)) day6_paynum,
    sum(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day7_paynum, 0)) day7_paynum,
    sum(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day0_first_paynum, 0)) day0_first_paynum,
    sum(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day1_first_paynum, 0)) day1_first_paynum,
    sum(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day2_first_paynum, 0)) day2_first_paynum,
    sum(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day3_first_paynum, 0)) day3_first_paynum,
    sum(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day4_first_paynum, 0)) day4_first_paynum,
    sum(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day5_first_paynum, 0)) day5_first_paynum,
    sum(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day6_first_paynum, 0)) day6_first_paynum,
    sum(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day7_first_paynum, 0)) day7_first_paynum,
    sum(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day0_first_paytimes, 0)) day0_first_paytimes,
    sum(cast(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day0_amount, 0) as int)) day0_amount,
    sum(cast(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day1_amount, 0) as int)) day1_amount,
    sum(cast(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day2_amount, 0) as int)) day2_amount,
    sum(cast(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day3_amount, 0) as int)) day3_amount,
    sum(cast(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day4_amount, 0) as int)) day4_amount,
    sum(cast(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day5_amount, 0) as int)) day5_amount,
    sum(cast(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day6_amount, 0) as int)) day6_amount,
    sum(cast(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day7_amount, 0) as int)) day7_amount,
    sum(cast(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day15_amount, 0) as int)) day15_amount,
    sum(cast(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day30_amount, 0) as int)) day30_amount,
    sum(cast(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day40_amount, 0) as int)) day40_amount,
    sum(cast(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day50_amount, 0) as int)) day50_amount,
    sum(cast(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day60_amount, 0) as int)) day60_amount,
    sum(cast(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day70_amount, 0) as int)) day70_amount,
    sum(cast(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day80_amount, 0) as int)) day80_amount,
    sum(cast(if(datediff(x1.dt, x2.dt)<=7 and datediff(x1.dt, x2.dt)>=0, day90_amount, 0) as int)) day90_amount
from
(   select dt, mt, book_id
    from alg.alg_tf_book_amount_agg_7d_tmp
    group by dt, mt, book_id
	)x1
left join
(   select 	dt,mt,book_id,ad_num,dev_num,reg_num,cost_amount,day0_paynum,day1_paynum,
			day2_paynum,day3_paynum,day4_paynum,day5_paynum,day6_paynum,day7_paynum,
			day0_first_paynum,day1_first_paynum,day2_first_paynum,day3_first_paynum,
			day4_first_paynum,day5_first_paynum,day6_first_paynum,day7_first_paynum,
			day0_first_paytimes,day0_amount,day1_amount,day2_amount,day3_amount,day4_amount,
			day5_amount,day6_amount,day7_amount,day15_amount,day30_amount,day40_amount,
			day50_amount,day60_amount,day70_amount,day80_amount,day90_amount
			from alg.alg_tf_book_amount_agg_7d_tmp
	)x2
on x1.book_id=x2.book_id and x1.mt=x2.mt
group by x1.dt, x1.mt, x1.book_id
order by x1.dt, x1.book_id;
