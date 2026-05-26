----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ads_srsv_user_value_analysis
-- workflow_version : 4
-- create_user      : chenmo
-- task_name        : P_ads_srsv_user_value_analysis
-- task_version     : 1
-- update_time      : 2026-05-21 20:03:14
-- sql_path         : \starrocks\sch_ads_srsv_user_value_analysis\P_ads_srsv_user_value_analysis
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_srsv_user_value_analysis
select
    a.dt
   ,a.product_id
   ,a.user_id
   ,a.user_period
   ,ifnull(b.ad_type, 3) as ad_type
   ,a.corever
   ,a.mt
   ,a.current_language2
   ,a.reg_country
   ,b.ecpm
   ,b.create_time
   ,a.ad_amt
   ,a.d7_ad_amt
   ,a.amt
   ,a.d7_amt
   ,e.group_id_list
   ,now() as etl_time
from (
    select
        a.dt
       ,a.product_id
       ,a.user_id
       ,a.user_period
       ,a.corever
       ,a.mt
       ,a.current_language2
       ,a.reg_country
       ,a.ad_amt
       ,a.d7_ad_amt
       ,b.amt
       ,sum(c.d7_amt) as d7_amt
    from (
        select
            a.dt
           ,a.product_id
           ,a.user_id
           ,a.user_period
           ,a.corever
           ,a.mt
           ,a.current_language2
           ,a.reg_country
           ,b.ad_amt
           ,sum(c.d7_ad_amt) as d7_ad_amt
        from (
            select
                dt
               ,product_id
               ,user_id
               ,user_period
               ,corever
               ,mt
               ,current_language2
               ,reg_country
            from dws.dws_srsv_wide_user_type_info_di
            where dt >= date_sub('${bf_1_dt}', interval 7 day)
        ) a
        left join (
            select
                dt
               ,date_add(dt, interval 7 day) as lag_dt
               ,product_id
               ,user_id
               ,sum(amt) as ad_amt
            from dws.dws_advertisement_user_position_amt_ed
            where dt >= date_sub('${bf_1_dt}', interval 7 day)
            group by dt, product_id, user_id
        ) b on a.product_id = b.product_id and a.user_id = b.user_id and a.dt = b.dt
        left join (
            select
                dt
               ,product_id
               ,user_id
               ,sum(amt) as d7_ad_amt
            from dws.dws_advertisement_user_position_amt_ed
            where dt >= date_sub('${bf_1_dt}', interval 7 day)
            group by dt, product_id, user_id
        ) c on a.product_id = c.product_id and a.user_id = c.user_id
            and a.dt <= c.dt and date_add(a.dt, interval 7 day) > c.dt
        group by a.dt, a.product_id, a.user_id, a.user_period, a.corever, a.mt,
                 a.current_language2, a.reg_country, b.ad_amt
    ) a
    left join (
        select
            date(coo_notify_time) as dt
           ,date_add(date(coo_notify_time), interval 7 day) as lag_dt
           ,product_id
           ,user_id
           ,sum(base_amount/100) as amt
        from dwd.dwd_srsv_trade_hk_sync_payorder_di_view
        where date(coo_notify_time) >= date_sub('${bf_1_dt}', interval 7 day)
        group by date(coo_notify_time), product_id, user_id
    ) b on a.dt = b.dt and a.product_id = b.product_id and a.user_id = b.user_id
    left join (
        select
            date(coo_notify_time) as dt
           ,product_id
           ,user_id
           ,sum(base_amount/100) as d7_amt
        from dwd.dwd_srsv_trade_hk_sync_payorder_di_view
        where date(coo_notify_time) >= date_sub('${bf_1_dt}', interval 7 day)
        group by date(coo_notify_time), product_id, user_id
    ) c on a.product_id = c.product_id and a.user_id = c.user_id
        and a.dt <= c.dt and date_add(a.dt, interval 7 day) > c.dt
    group by a.dt, a.product_id, a.user_id, a.user_period, a.corever, a.mt,
             a.current_language2, a.reg_country, a.ad_amt, a.d7_ad_amt, b.amt
) a
left join (
    --  sr_new_ecpm
    select
        a.product_id
       ,a.id as user_id
       ,3 as ad_type
       ,b.lst_preload_ecpm as ecpm
       ,b.fst_preload_time as create_time
    from (
        select
            product_id
           ,id
        from dim.dim_user_account_info_view
    ) a
    left join (
        select
            product_id
           ,user_id
           ,lst_preload_ecpm
           ,fst_preload_time
        from dws.dws_srsv_user_first_preload_info_df
        where ad_type = 3
    ) b on a.product_id = b.product_id and a.id = b.user_id

    union all

    --  sv_new_ecpm
    select
        a.product_id
       ,a.user_id
       ,b.ad_type
       ,b.lst_preload_ecpm as ecpm
       ,b.fst_preload_time as create_time
    from (
        select
            product_id
           ,user_id
        from dim.dim_short_video_user_accountinfo
    ) a
    left join (
        select
            product_id
           ,user_id
           ,ad_type
           ,lst_preload_ecpm
           ,fst_preload_time
        from dws.dws_srsv_user_first_preload_info_df
    ) b on a.product_id = b.product_id and a.user_id = b.user_id
) b on a.product_id = b.product_id and a.user_id = b.user_id
left join (
    select
        dt
       ,ProductId
       ,UserId
       ,group_concat(distinct CrowdId) as group_id_list
    from ads.crowd_log
    where dt >= date_sub('${bf_1_dt}', interval 7 day)
    group by dt, ProductId, UserId

    union all

    select
        dt
       ,ProductId
       ,UserId
       ,group_concat(distinct CrowdId) as group_id_list
    from ads.ads_sr_beidou_group_crowd_log
    where dt >= date_sub('${bf_1_dt}', interval 7 day)
    group by dt, ProductId, UserId
) e on a.dt = e.dt and a.product_id = e.ProductId and a.user_id = e.UserId
;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_srsv_user_value_analysis
-- workflow_version : 10
-- create_user      : chenmo
-- task_name        : ads_srsv_user_value_analysis
-- task_version     : 10
-- update_time      : 2025-10-23 10:48:09
-- sql_path         : \starrocks\tbl_ads_srsv_user_value_analysis\ads_srsv_user_value_analysis
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_srsv_user_value_analysis
with sr_new_ecpm as (
    select
        a.product_id,
        a.id as user_id,
        3 as ad_type,
        max_by(get_json_string(b.s0,'$.valueMicros') * 1000, 1/b.create_time) as ecpm,
        min(b.create_time) as create_time
    from (
        select
            product_id,
            id
        from dim.dim_user_account_info_view
    ) a
    left join (
        select
            product_id,
            user_id,
            s0,
            create_time
        from ads.ads_user_commonactionlog_view
        where Action = 'FirstPreloadEvent'
    ) b on a.product_id = b.product_id and a.id = b.user_id
    group by 1, 2, 3
),
sv_new_ecpm as (
    select
        a.product_id,
        a.user_id,
        b.ad_type,
        max_by(b.value_micros * 1000, 1/b.create_time) as ecpm,
        min(b.create_time) as create_time
    from (
        select
            product_id,
            user_id
        from dim.dim_short_video_user_accountinfo
    ) a
    left join (
        select
            account_id,
            ad_type,
            value_micros,
            create_time
        from ads.ads_sv_advertise_ad_preload_revenue_di_view
    ) b on a.user_id = b.account_id
    group by 1, 2, 3
)
select
    a.dt,
    a.product_id,
    a.user_id,
    a.user_period,
    ifnull(b.ad_type, 3) as ad_type,
    a.corever,
    a.mt,
    a.current_language2,
    a.reg_country,
    b.ecpm,
    b.create_time,
    a.ad_amt,
    a.d7_ad_amt,
    a.amt,
    a.d7_amt,
    e.group_id_list,
    now() as etl_time
from (
    select
        a.dt,
        a.product_id,
        a.user_id,
        a.user_period,
        a.corever,
        a.mt,
        a.current_language2,
        a.reg_country,
        a.ad_amt,
        a.d7_ad_amt,
        b.amt,
        sum(c.d7_amt) as d7_amt
    from (
        select
            a.dt,
            a.product_id,
            a.user_id,
            a.user_period,
            a.corever,
            a.mt,
            a.current_language2,
            a.reg_country,
            b.ad_amt,
            sum(c.d7_ad_amt) as d7_ad_amt
        from (
            select
                dt,
                product_id,
                user_id,
                user_period,
                corever,
                mt,
                current_language2,
                reg_country
            from dws.dws_srsv_wide_user_type_info_di
            where dt >= date_sub('${bf_1_dt}', interval 7 day)
        ) a
        left join (
            select
                dt,
                date_add(dt, interval 7 day) as lag_dt,
                product_id,
                user_id,
                sum(amt) as ad_amt
            from dws.dws_advertisement_user_position_amt_ed
            where dt >= date_sub('${bf_1_dt}', interval 7 day)
            group by dt, product_id, user_id
        ) b on a.product_id = b.product_id and a.user_id = b.user_id and a.dt = b.dt
        left join (
            select
                dt,
                product_id,
                user_id,
                sum(amt) as d7_ad_amt
            from dws.dws_advertisement_user_position_amt_ed
            where dt >= date_sub('${bf_1_dt}', interval 7 day)
            group by dt, product_id, user_id
        ) c on a.product_id = c.product_id and a.user_id = c.user_id and a.dt <= c.dt and date_add(a.dt, interval 7 day) > c.dt
        group by a.dt, a.product_id, a.user_id, a.user_period, a.corever, a.mt, a.current_language2, a.reg_country, b.ad_amt
    ) a
    left join (
        select
            date(coo_notify_time) as dt,
            date_add(date(coo_notify_time), interval 7 day) as lag_dt,
            product_id,
            user_id,
            sum(base_amount/100) as amt
        from dwd.dwd_srsv_trade_hk_sync_payorder_di_view
        where date(coo_notify_time) >= date_sub('${bf_1_dt}', interval 7 day)
        group by date(coo_notify_time), product_id, user_id
    ) b
    on a.dt = b.dt and a.product_id = b.product_id and a.user_id = b.user_id
    left join (
        select
            date(coo_notify_time) as dt,
            product_id,
            user_id,
            sum(base_amount/100) as d7_amt
        from dwd.dwd_srsv_trade_hk_sync_payorder_di_view
        where date(coo_notify_time) >= date_sub('${bf_1_dt}', interval 7 day)
        group by date(coo_notify_time), product_id, user_id
    ) c
    on a.product_id = c.product_id and a.user_id = c.user_id and a.dt <= c.dt and date_add(a.dt, interval 7 day) > c.dt
    group by a.dt, a.product_id, a.user_id, a.user_period, a.corever, a.mt, a.current_language2, a.reg_country, a.ad_amt, a.d7_ad_amt, b.amt
) a
left join (
    select
        product_id,
        user_id,
        ad_type,
        ecpm,
        create_time
    from sr_new_ecpm
    union all
    select
        product_id,
        user_id,
        ad_type,
        ecpm,
        create_time
    from sv_new_ecpm
) b on a.product_id = b.product_id and a.user_id = b.user_id
left join (
    select
        dt,
        ProductId,
        UserId,
        group_concat(distinct CrowdId) as group_id_list
    from ads.crowd_log
    where dt >= date_sub('${bf_1_dt}', interval 7 day)
    group by dt, ProductId, UserId
    union all
    select
        dt,
        ProductId,
        UserId,
        group_concat(distinct CrowdId) as group_id_list
    from ads.ads_sr_beidou_group_crowd_log
    where dt >= date_sub('${bf_1_dt}', interval 7 day)
    group by dt, ProductId, UserId
) e on a.dt = e.dt and a.product_id = e.ProductId and a.user_id = e.UserId;
