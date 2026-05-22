----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_user_market_channel_info_detail_est_da
-- workflow_version : 9
-- create_user      : hufengju
-- task_name        : dws.dws_user_market_channel_info_detail_est_da  
-- task_version     : 9
-- update_time      : 2024-11-21 10:28:34
-- sql_path         : \starrocks\tbl_dws_user_market_channel_info_detail_est_da\dws.dws_user_market_channel_info_detail_est_da  
----------------------------------------------------------------
-- SQL语句
--===================调度（西五区）dws_user_market_channel_info_detail_est_da=================================
insert into  dws.dws_user_market_channel_info_detail_est_da
select
       '${bf_1_dt}'  as dt ,
       Product_Id,
       user_id,
       mt ,
       corever,
       lang2,
       max_by(first_bookid,updatetime) as first_bookid,
       max_by(last_bookid,updatetime) as first_bookid,
       max_by(last_source,updatetime) as first_bookid,
       max_by(isremarket,updatetime) as first_bookid,
       date_add(max_by(install_date,updatetime),interval -13 hour) as  install_date,
       now() as updatetime
from dws.dws_user_market_channel_info_detail_td
where date(date_add(install_date,interval -13 hour)) < '${dt}'
and dt>='${bf_2_dt}'
group by 1,2,3,4,5,6
;
