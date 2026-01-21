insert into dws.dws_video_user_watch_new_epis_series_td_a
select t1.dt,t1.product_id,t1.user_id,fst_watch_tm,lst_watch_tm,t1.watch_days_td,
       t1.watch_cnt_td,t2.new_epis_series_td,now() as etl_time
from(
    select dt,product_id,user_id,
           fst_watch_tm,
           lst_watch_tm,
           watch_days_td,
           watch_cnt_td
       from dws.dws_video_user_watch_series_td_a
       where dt='${bf_1_dt}'
)t1
left join (
    -- 最新剧集
    select product_id,user_id,bitmap_union(to_bitmap(concat(series_id,99999,epis_num))) as new_epis_series_td
    from(
        select a.product_id,a.user_id,a.series_id,a.epis_num
        from dws.dws_video_user_watch_a_agg_mid1 a
        inner join(
            select series_id,max(epis_num) as max_epis_num from dim.dim_short_video_epis_view where is_delete=0 group by 1
            ) b on a.series_id=b.series_id and a.epis_num=b.max_epis_num
        where a.product_id=6833
    )c
    group by 1,2
)t2 on t1.product_id=t2.product_id and t1.user_id=t2.user_id;