----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_consume_short_video_consume_stat_ed
-- workflow_version : 4
-- create_user      : zhengtt
-- task_name        : dws_consume_short_video_consume_stat_ed
-- task_version     : 4
-- update_time      : 2024-10-16 15:54:15
-- sql_path         : \starrocks\tbl_dws_consume_short_video_consume_stat_ed\dws_consume_short_video_consume_stat_ed
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_consume_short_video_consume_stat_ed
select  a.dt,6833 as product_id,a.account_id as user_id,
        sum(a.consume_value) as consume_amt,
        count(distinct id) as consume_cnt,
        bitmap_union(to_bitmap(concat(b.series_id,a.epis_num))) as consume_epis_bitmap,
        sum(if(a.consume_type = 0,a.consume_value,0)) as consume_money_amt,
        count( distinct if(a.consume_type = 0,id,null)) as consume_money_cnt,
        bitmap_union(to_bitmap(if(a.consume_type = 0,concat(b.series_id,a.epis_num),null))) as consume_money_epis_bitmap,
        sum(if(a.consume_type = 1,a.consume_value,0)) as consume_cert_amt,
        count(distinct if(a.consume_type = 1,id,null)) as consume_cert_cnt,
        bitmap_union(to_bitmap(if(a.consume_type = 1,concat(b.series_id,a.epis_num),null))) as consume_cert_epis_bitmap,
        now() as etl_time
from dwd.dwd_sv_consume_user_consume_bill_pdi a
         left join dim.dim_short_video_epis_view b
                   on a.epis_id = b.epis_id
where a.dt = '${bf_1_dt}' and  a.epis_id != 0 and b.series_id is not null
group by 1,2,3;
