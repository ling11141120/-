----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_consume_short_video_cn_consume_ed
-- workflow_version : 7
-- create_user      : linq
-- task_name        : dws_consume_short_video_cn_consume_ed
-- task_version     : 7
-- update_time      : 2024-03-29 13:49:42
-- sql_path         : \starrocks\tbl_dws_consume_short_video_cn_consume_ed\dws_consume_short_video_cn_consume_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_consume_short_video_cn_consume_ed where dt>='${bf_3_dt}' and dt<'${dt}';

-- SQL语句
insert into dws.dws_consume_short_video_cn_consume_ed
select dt,
       6883 as product_id,
       ref_user_id,
       tv_id,
       ifnull(series_id, -99) as series_id,
       ifnull(series, -99) as series,
       b.corever2,
       b.Current_Language2,
       b.mt2,
       b.chL2,
       b.reg_country,
       b.sex,
       b.create_time as reg_time,
       sum(pay_amount) consume_amt,
       count(1)           consume_cnt,
       now() as etl_time
from dwd.dwd_consume_short_video_cn_consume_view a
left join dim.dim_video_cn_accountinfo_view b on a.ref_user_id=b.account
where dt>='${bf_3_dt}' and dt<'${dt}'
group by 1,2,3,4,5,6,7,8,9,10,11,12,13;
