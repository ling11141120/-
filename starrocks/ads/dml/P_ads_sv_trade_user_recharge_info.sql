----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_trade_user_recharge_info
-- workflow_version : 1
-- create_user      : linq
-- task_name        : ads_sv_trade_user_recharge_info
-- task_version     : 1
-- update_time      : 2024-03-29 10:37:52
-- sql_path         : \starrocks\tbl_ads_sv_trade_user_recharge_info\ads_sv_trade_user_recharge_info
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sv_trade_user_recharge_info
select a.user_id,a.current_language,a.corever,a.last_login_time,from_unixtime(ifnull(a.expire_time,0)/1000) as expire_time,
       a.bind_email,b.last_recharge_tm,now() as etl_time
from dim.dim_short_video_user_accountinfo a
left join(
    select product_id, user_id, last_recharge_tm
    from dws.dws_trade_short_video_subscribe_payorder_a
    where dt = '${bf_1_dt}'
)b on a.product_id=b.product_id and a.user_id=b.user_id
where create_time<'${dt}';
