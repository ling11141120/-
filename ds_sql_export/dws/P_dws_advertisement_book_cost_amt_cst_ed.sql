----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_advertisement_book_cost_amt_cst_ed
-- workflow_version : 1
-- create_user      : yanxh
-- task_name        : dws_advertisement_book_cost_amt_cst_ed
-- task_version     : 1
-- update_time      : 2024-01-11 19:40:25
-- sql_path         : \starrocks\tbl_dws_advertisement_book_cost_amt_cst_ed\dws_advertisement_book_cost_amt_cst_ed
----------------------------------------------------------------
-- SQL语句
delete from   dws.dws_advertisement_book_cost_amt_cst_ed    where dt>='${bf_7_dt}' ;

-- SQL语句
insert into  dws.dws_advertisement_book_cost_amt_cst_ed
    select  dt,product_id,if(product_id=3333 ,333,right(book_id,3)) as site_id,book_id , book_name ,book_channel ,book_nature ,corever ,mt,current_language2 ,  sum(cost_amt) cost_amt,now() as etl_tm
              from  dwm.dwm_advertisement_ad_cost_amt_ed
                  where dt>='${bf_7_dt}' and book_id >0
                 group by 1,2,3,4,5,6,7,8,9,10;
