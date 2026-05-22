----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_wide_short_video_ed
-- workflow_version : 3
-- create_user      : zhengtt
-- task_name        : tbl_ads_wide_short_video_ed
-- task_version     : 3
-- update_time      : 2026-05-04 19:57:02
-- sql_path         : \starrocks\tbl_ads_wide_short_video_ed\tbl_ads_wide_short_video_ed
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_wide_short_video_ed
select  a.dt,a.product_id,a.user_id,b.sex,b.create_tm as reg_tm,mt,mt2,corever,corever2,
        b.app_ver,b.ver,b.current_language,b.current_language2,b.reg_country,c.Source as lst_source_chl,
        if(b.email is not null,1,0) as is_bound_email,
        a.consume_amt,a.consume_cnt,a.consume_epis_bitmap,a.consume_money_amt,a.consume_money_cnt,
        a.consume_money_epis_bitmap,a.consume_cert_amt,a.consume_cert_cnt,a.consume_cert_epis_bitmap,
        a.pay_amt,a.received_amt,a.refund_amt,a.refund_real_amt,a.pay_cnt,a.refund_cnt,a.max_pay_amt,a.min_pay_amt,
        a.login_cnt,a.watch_epis_bitmap,a.epis_watch_cnt,a.is_like_cnt,a.is_like_epis_bitmap,
        now() as etl_time
from
(   select  coalesce(a.dt,b.dt,c.dt) as dt,
            coalesce(a.product_id,b.product_id,c.product_id) as product_id,
            coalesce(a.user_id,b.user_id,c.user_id) as user_id,
            a.consume_amt,a.consume_cnt,a.consume_epis_bitmap,a.consume_money_amt,a.consume_money_cnt,
            a.consume_money_epis_bitmap,a.consume_cert_amt,a.consume_cert_cnt,a.consume_cert_epis_bitmap,
            b.pay_amt,b.received_amt,b.refund_amt,b.refund_real_amt,b.pay_cnt,b.refund_cnt,b.max_pay_amt,b.min_pay_amt,
            c.login_cnt,c.watch_epis_bitmap,c.epis_watch_cnt,c.is_like_cnt,c.is_like_epis_bitmap
    from dws.dws_consume_short_video_consume_stat_ed a
    full join dws.dws_trade_short_video_payorder_ed b
        on a.dt = b.dt and a.product_id = b.product_id and a.user_id = b.user_id
    full join dws.dws_video_user_interaction_short_video_login_like_watch_ed c
        on coalesce(a.dt,b.dt) = c.dt and coalesce(a.product_id,b.product_id) = c.product_id and coalesce(a.user_id,b.user_id) = c.user_id
    where coalesce(a.dt,b.dt,c.dt) = '${bf_1_dt}'
    ) a
left join dim.dim_short_video_account_device_info b
    on a.user_id = b.user_id
left join
(   select User_Id,Source,
           row_number() over (partition by User_Id order by Create_Time desc) as rn
    from dwd.dwd_user_install_info_ed_view
    where Product_Id = 6833 and IsDelete != 1
    ) c
    on a.user_id = c.User_Id;
