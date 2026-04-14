insert into dim.dim_short_video_user_accountinfo_daily
select
    '${dt}' as dt,
    product_id,
    user_id,
    app_notify,
    now() as update_time
from dim.dim_short_video_user_accountinfo;