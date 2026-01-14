insert into ads.ads_sv_user_watch_series_di
select a.user_id,bitmap_to_string(a.watch_series_td) as watch_series_td,now() as etl_time,now() as row_update_time
from ads.ads_wide_short_video_user_info_a a
join (
    select account_id as user_id
    from dwd.dwd_video_short_video_epis_history
    where dt='${bf_1_dt}'
    group by 1
    )b on a.user_id=b.user_id
where dt='${bf_1_dt}' and product_id=6833;