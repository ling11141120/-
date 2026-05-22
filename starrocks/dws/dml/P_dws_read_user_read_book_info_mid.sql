----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_read_user_read_book_info_mid
-- workflow_version : 3
-- create_user      : xixg
-- task_name        : dws_read_user_read_book_info_mid
-- task_version     : 3
-- update_time      : 2025-05-30 18:42:27
-- sql_path         : \starrocks\tbl_dws_read_user_read_book_info_mid\dws_read_user_read_book_info_mid
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_read_user_read_book_info_mid
select  '${bf_1_dt}' as dt,a.user_id,
        a.book_id,
        a.product_id,
        max(a.max_serial_number)  max_serial_number,
        sum(a.read_chpts) read_chpts ,
        now() as etl_time
from(
        select  a.user_id,
                a.book_id,
                a.product_id,
                max(ifnull(a.max_serial_number,0))  max_serial_number,
                sum(ifnull(a.read_chpts,0)) read_chpts
        from dws.dws_read_user_read_book_info_ed  a
                 inner join dws.dws_user_login_l30d_temp b
                            on a.product_id=b.product_id
                                and a.user_id =b.user_id
                                and  b.dt= '${bf_1_dt}'
        where a.dt =  '${bf_1_dt}'
        group by 1,2,3
        union all
        select user_id ,
               book_id,
               product_id ,
               max_serial_number,
               read_chpts
        from dws.dws_read_user_read_book_info_mid
        where dt = '${bf_2_dt}'
    ) a
group by 1,2,3 ,4;
