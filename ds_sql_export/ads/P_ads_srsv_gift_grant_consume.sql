----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_srsv_gift_grant_consume
-- workflow_version : 3
-- create_user      : chenmo
-- task_name        : ads_srsv_gift_grant_consume
-- task_version     : 3
-- update_time      : 2025-11-18 19:28:00
-- sql_path         : \starrocks\tbl_ads_srsv_gift_grant_consume\ads_srsv_gift_grant_consume
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_srsv_gift_grant_consume
-- 海阅
select
    a.dt,
    a.product_id,
    a.id,
    a.op_type,
    a.user_id,
    a.amount,
    a.book_id,
    b.book_name,
    b.book_code,
    c.langid,
    b.build_time,
    b.normal_chapter_num_f,
    a.create_time,
    a.expire_time,
    now() as etl_time
from (
    -- 发放
    select
        dt,
        product_id,
        concat(id, '_', op_type) as id,
        op_type,
        user_id,
        gift_num as amount,
        null as book_id,
        send_time as create_time,
        expire_time
    from dwd.dwd_grant_user_giftlog
    where gift_num > 0 and dt = '${bf_1_dt}'
    union all
    -- 消耗
    select
        dt,
        product_id,
        concat(auto_id, '_', 3) as id,
        3 as op_type,
        user_id,
        amount,
        book_id,
        createtime,
        null as expire_time
    from dwd.dwd_consume_user_consume
    where types in(2, 3) and amount > 0 and dt = '${bf_1_dt}'
) a
left join dim.dim_shuangwen_book_read_consume_info b on a.book_id = b.book_id
left join dim.DIM_ProductType c on b.site_id2 = c.book_langid
union all
-- 海剧
select
    a.dt,
    a.product_id,
    a.id,
    a.op_type,
    a.user_id,
    a.amount,
    a.book_id,
    b.series_name,
    b.series_code,
    b.language,
    b.publish_edat,
    b.last_epis,
    a.create_time,
    a.expire_time,
    now() as etl_time
from (
    -- 发放
    select
        dt,
        6833 as product_id,
        concat(id, '_', 1) as id,
        1 as op_type,
        AccountId as user_id,
        Value as amount,
        null as book_id,
        Createtime as create_time,
        ExpireTime as expire_time
    from ads.ads_short_video_bonus_view
    where Value > 0 and dt = '${bf_1_dt}'
    union all
    -- 消耗
    select
        dt,
        6833 as product_id,
        concat(id, '_', 1) as id,
        3 as op_type,
        account_id as user_id,
        gain_bonus as amount,
        b.series_id,
        create_time,
        null as expire_time
    from dwd.dwd_consume_short_video_consume_view a
    left join dim.dim_short_video_epis_view b
    on a.epis_id = b.epis_id
    where consume_type = 1 and gain_bonus > 0 and dt = '${bf_1_dt}'
) a
left join dim.dim_short_video_series_view b on a.book_id = b.series_id;
