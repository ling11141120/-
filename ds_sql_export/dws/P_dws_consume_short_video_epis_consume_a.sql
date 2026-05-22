----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_consume_short_video_epis_consume_a
-- workflow_version : 4
-- create_user      : zhengtt
-- task_name        : dws_consume_short_video_epis_consume_a
-- task_version     : 4
-- update_time      : 2025-04-12 23:51:19
-- sql_path         : \starrocks\tbl_dws_consume_short_video_epis_consume_a\dws_consume_short_video_epis_consume_a
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_consume_short_video_epis_consume_a
select  '${bf_1_dt}' as dt,series_id,epis_num,
        bitmap_union(consume_user_bitmap) as consume_user_bitmap,
        sum(consume_amt) as consume_amt,
        sum(consume_cnt) as consume_cnt,
        bitmap_union(consume_money_user_bitmap) as consume_money_user_bitmap,
        sum(consume_money_amt) as consume_money_amt,
        sum(consume_money_cnt) as consume_money_cnt,
        bitmap_union(consume_cert_user_bitmap) as consume_cert_user_bitmap,
        sum(consume_cert_amt) as consume_cert_amt,
        sum(consume_cert_cnt) as consume_cert_cnt,
        now() as etl_time
from
(   select  b.series_id as series_id,a.epis_num as epis_num,
            bitmap_union(to_bitmap(a.account_id)) as consume_user_bitmap,
            sum(a.consume_value) as consume_amt,
            count(distinct id) as consume_cnt,
            bitmap_union(to_bitmap(if(a.consume_type = 0,a.account_id,null))) as consume_money_user_bitmap,
            sum(if(a.consume_type = 0,a.consume_value,0)) as consume_money_amt,
            count(distinct if(a.consume_type = 0,id,null)) as consume_money_cnt,
            bitmap_union(to_bitmap(if(a.consume_type = 1,a.account_id,null))) as consume_cert_user_bitmap,
            sum(if(a.consume_type = 1,a.consume_value,0)) as consume_cert_amt,
            count(distinct if(a.consume_type = 1,id,null)) as consume_cert_cnt
    from dwd.dwd_sv_consume_user_consume_bill_pdi a
             left join dim.dim_short_video_epis_view b
                       on a.epis_id = b.epis_id
    where a.dt = '${bf_1_dt}' and a.epis_id != 0 and b.series_id is not null
    group by 1,2
    union all
    select  series_id, epis_num, consume_user_bitmap, consume_amt, consume_cnt,
            consume_money_user_bitmap, consume_money_amt, consume_money_cnt,
            consume_cert_user_bitmap, consume_cert_amt, consume_cert_cnt
    from dws.dws_consume_short_video_epis_consume_a
    where dt = '${bf_2_dt}'
    ) a
group by 1,2,3;
