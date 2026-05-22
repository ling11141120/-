----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_trade_short_video_user_shop_num_da
-- workflow_version : 7
-- create_user      : chenmo
-- task_name        : dws_trade_short_video_user_shop_num_da
-- task_version     : 6
-- update_time      : 2026-02-26 15:00:38
-- sql_path         : \starrocks\tbl_dws_trade_short_video_user_shop_num_da\dws_trade_short_video_user_shop_num_da
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_trade_short_video_user_shop_num_da where dt = '${bf_1_dt}';

-- SQL语句
insert into dws.dws_trade_short_video_user_shop_num_da
with pay_order as (
    select
        product_id, user_id, shop_item,
        SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(ExtInfo,'|',-1),'com.changdu.mobovideo.',-1),'com.changdu.moboshort.',-1),'com.changjian.moboshortcj.',-1),'third.',-1) as item_id,
        1 as shop_num,
        create_time as first_time,
        create_time
    from dwd.dwd_trade_short_video_payorder
    where dt = '${bf_1_dt}'
      and shop_item in (840,810,860)
      and status = 0
    union all
    select
        product_id, user_id, shop_item,
        item_id,
        shop_num,
        first_time,
        create_time
    from dws.dws_trade_short_video_user_shop_num_da
    where dt = '${bf_2_dt}'
)
select
    '${bf_1_dt}' as dt,
    product_id, user_id, shop_item, item_id,
    sum(shop_num) as shop_num,
    sum(shop_num)-1 as autoRenew_times,
    min(first_time) as first_time,
    max(create_time) as create_time,
    now() as etl_time
from pay_order
group by product_id, user_id, shop_item, item_id;
