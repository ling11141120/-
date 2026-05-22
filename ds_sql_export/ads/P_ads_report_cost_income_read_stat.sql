----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_cost_income_read_stat
-- workflow_version : 2
-- create_user      : zhengtt
-- task_name        : ads_report_cost_income_read_stat
-- task_version     : 2
-- update_time      : 2024-11-14 18:26:47
-- sql_path         : \starrocks\tbl_ads_report_cost_income_read_stat\ads_report_cost_income_read_stat
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_report_cost_income_read_stat  where product_id = 0 and dt = '${dt}';

-- SQL语句
insert into ads.ads_report_cost_income_read_stat
select 	a.dt,a.product_id,a.book_id,a.book_name,a.origin_book_name as from_book_name,
        a.object_book_name as to_book_name,a.object_book_type,a.is_cost_rate,a.promotion_status,d.publish_length as publish_length,
        a.cost_amt_7,a.amount_7,a.cost_amt_30,a.amount_30,a.cost_amt_curmon,
        a.amount_curmon,a.cost_amt_YTD as cost_amt_td, a.amount_YTD as amount_td,a.cost_rate_judge,
        b.read_7d as read_7d_unt,b.read_30d as read_30d_unt,c.consume_7d as consume_7d_unt,
        c.consume_30d as consume_30d_unt,now() as etl_time
from
( 	select 	dt,product_id,book_id,book_name,origin_book_name,object_book_name,
               Promotion_status,object_book_type, is_cost_rate,cost_amt_7,
               amount_7,cost_amt_30,amount_30,cost_amt_curmon,amount_curmon,
               cost_amt_YTD,amount_YTD,etl_time,
               case when cost_amt_curmon is null or cost_amt_curmon = 0 then 3
                    when if(cost_amt_curmon is null,0,cost_amt_curmon) < if(amount_curmon is null,0,amount_curmon) then 1
                    else 2
                   end cost_rate_judge
    from ads.ads_report_cost_income
    where dt = '${dt}'
    ) a
left join
( 	select 	book_id ,count(distinct if(dt >= DATE_SUB(current_date(),INTERVAL 7 day),user_id,null)) as read_7d,
               count(distinct if(dt >= DATE_SUB(current_date(),INTERVAL 30 day),user_id,null)) as read_30d
    from dws.dws_read_user_readbook_ed
    where dt >= DATE_SUB('${dt}',INTERVAL 30 day) and dt < '${dt}'
    group by book_id
    )b
on a.book_id = b.book_id
left join
( 	select 	book_id ,count(distinct if(dt >= DATE_SUB(current_date(),INTERVAL 7 day),user_id,null)) as consume_7d,
               count(distinct if(dt >= DATE_SUB(current_date(),INTERVAL 30 day),user_id,null)) as consume_30d
    from dws.dws_consume_user_consume_ed
    where dt >= DATE_SUB('${dt}',INTERVAL 30 day) and dt < '${dt}'
    group by book_id
    )c
on a.book_id = c.book_id
left join ads.ads_report_book_capacity_rate_stat d
on a.book_id = d.book_id and a.dt = d.dt;
