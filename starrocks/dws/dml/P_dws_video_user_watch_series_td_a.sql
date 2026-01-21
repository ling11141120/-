insert into dws.dws_video_user_watch_series_td_a
select t1.dt,t1.product_id,t1.user_id,fst_watch_tm,lst_watch_tm,t1.watch_series_td,t1.watch_tv_td,t1.watch_days_td,
       t1.watch_cnt_td,now() as etl_time
from(
    select dt,product_id,user_id,
           min(fst_watch_tm) as fst_watch_tm,
           max(lst_watch_tm) as lst_watch_tm,
           bitmap_union(watch_series_td) as watch_series_td,
           bitmap_union(watch_tv_td) as watch_tv_td,
           sum(watch_days_td) as watch_days_td,
           sum(watch_cnt_td) as watch_cnt_td
    from(
        select '${bf_1_dt}' as dt,product_id,user_id,fst_watch_tm,lst_watch_tm,watch_series_td,watch_tv_td,watch_days_td,watch_cnt_td
        from dws.dws_video_user_watch_series_td_a
        where dt='${bf_2_dt}'
		and right(user_id,1) in (0,1,2,3,4)
        union all
        select '${bf_1_dt}' as dt,6833 as product_id,account_id as user_id,
               min(create_time) as fst_watch_tm,
               max(create_time) as lst_watch_tm,
               bitmap_union(to_bitmap(series_id)) as watch_series_td,
               bitmap_union(to_bitmap(concat(series_id,99999,epis_num))) as watch_tv_td,
               count(distinct date(create_time)) as watch_days_td,count(1) as watch_cnt_td
        from dwd.dwd_video_short_video_epis_history
        where create_time>='${bf_1_dt}' and create_time<'${dt}'
		and right(account_id,1) in (0,1,2,3,4)
        group by 1,2,3
    ) roll
    group by 1,2,3
)t1
;

insert into dws.dws_video_user_watch_series_td_a
select t1.dt,t1.product_id,t1.user_id,fst_watch_tm,lst_watch_tm,t1.watch_series_td,t1.watch_tv_td,t1.watch_days_td,
       t1.watch_cnt_td,now() as etl_time
from(
    select dt,product_id,user_id,
           min(fst_watch_tm) as fst_watch_tm,
           max(lst_watch_tm) as lst_watch_tm,
           bitmap_union(watch_series_td) as watch_series_td,
           bitmap_union(watch_tv_td) as watch_tv_td,
           sum(watch_days_td) as watch_days_td,
           sum(watch_cnt_td) as watch_cnt_td
    from(
        select '${bf_1_dt}' as dt,product_id,user_id,fst_watch_tm,lst_watch_tm,watch_series_td,watch_tv_td,watch_days_td,watch_cnt_td
        from dws.dws_video_user_watch_series_td_a
        where dt='${bf_2_dt}'
		and right(user_id,1) in (5,6,7,8,9)
        union all
        select '${bf_1_dt}' as dt,6833 as product_id,account_id as user_id,
               min(create_time) as fst_watch_tm,
               max(create_time) as lst_watch_tm,
               bitmap_union(to_bitmap(series_id)) as watch_series_td,
               bitmap_union(to_bitmap(concat(series_id,99999,epis_num))) as watch_tv_td,
               count(distinct date(create_time)) as watch_days_td,count(1) as watch_cnt_td
        from dwd.dwd_video_short_video_epis_history
        where create_time>='${bf_1_dt}' and create_time<'${dt}'
		and right(account_id,1) in (5,6,7,8,9)
        group by 1,2,3
    ) roll
    group by 1,2,3
)t1