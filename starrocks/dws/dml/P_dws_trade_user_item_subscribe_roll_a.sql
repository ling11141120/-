----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_trade_user_item_subscribe_roll_a
-- workflow_version : 7
-- create_user      : lxz
-- task_name        : dws_trade_user_item_subscribe_roll_a
-- task_version     : 5
-- update_time      : 2025-01-18 14:38:38
-- sql_path         : \starrocks\tbl_dws_trade_user_item_subscribe_roll_a\dws_trade_user_item_subscribe_roll_a
----------------------------------------------------------------
-- SQL语句
--==============dws_trade_user_item_subscribe_roll_a=====================
insert into dws.dws_trade_user_item_subscribe_roll_a
with pay_order as (
    select
        ProductId as product_id, UserId as user_id, ShopItem as shop_item,
        SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX( SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(
		 SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX( SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(
		 SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(ExtInfo,'|',-1),'readerfr.',-1),'minireaderfr.',-1),
				'cdycnovelfr.',-1),'tcreader.',-1),'minireaderft.',-1),'minireaderen.',-1),'ereader.',-1),'readerpt.',-1),'novelpt.',-1) ,'spainreader.',-1),'noveltw.',-1),
				'novelen.',-1),'readerru.',-1),'minireaderes.',-1),'minireaderth.',-1),'readerid.',-1),'thai.',-1),
				'noveles.',-1),'novelru.',-1),'reader4.',-1),'novelth.',-1),'novelid.',-1),'readerja.',-1),'novelja.',-1)
				as item_id,
        1 as recharge_cnt
    from dwd.dwd_trade_user_payorder
    where dt = '${bf_1_dt}'
      and ShopItem in (800, 810, 830, 840, 850)
    union all
    select
        product_id, user_id, shop_item,
        item_id,
        recharge_cnt
    from dws.dws_trade_user_item_subscribe_roll_a
    where dt = '${bf_2_dt}'
)
select
    '${bf_1_dt}' as dt,
    product_id, pay_order.user_id, shop_item, item_id,
    sum(recharge_cnt) as recharge_cnt,
	min(b.first_subscribe_time) as first_subscribe_time,
    now() as etl_time
from pay_order
left join (
	select UserId as user_id,min(CreateTime) as first_subscribe_time
	from dwd.dwd_trade_user_payorder
	where ShopItem in (800, 810, 830, 840, 850)
	and dt<='${bf_1_dt}'
	group by UserId
) b on pay_order.user_id = b.user_id
where product_id is not null and pay_order.user_id is not null and shop_item is not null and item_id is not null
group by 1, 2, 3, 4,5;
