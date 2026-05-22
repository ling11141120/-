----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_competitor_app_perf_download_ed
-- workflow_version : 2
-- create_user      : doupz
-- task_name        : dws_competitor_app_perf_download_ed
-- task_version     : 2
-- update_time      : 2024-02-06 14:53:07
-- sql_path         : \starrocks\tbl_dws_competitor_app_perf_download_ed\dws_competitor_app_perf_download_ed
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_competitor_app_perf_download_ed
select
    coalesce(download.dt, perf.dt) as dt,
    coalesce(download.country_code, perf.country_code) as country_code,
    coalesce(download.device_code, perf.device_code) as device_code,
    coalesce(download.product_id, perf.product_id) as product_id,
	coalesce(download.granularity, perf.granularity) as granularity,
	coalesce(download.end_date, perf.end_date) as end_date,
    download.est_organic_download,
    download.est_organic_featured_download,
    download.est_organic_search_download,
    download.est_paid_ads_download,
    download.est_paid_channel_download,
    download.est_paid_search_download,
    perf.est_download,
    perf.est_revenue,
    perf.est_cumulative_download,
    sum(est_cumulative_download) over(partition by coalesce(download.dt, perf.dt),coalesce(download.country_code, perf.country_code),coalesce(download.device_code, perf.device_code),product.company_id) company_est_cumulative_download,
    perf.est_cumulative_revenue,
    sum(est_cumulative_revenue) over(partition by coalesce(download.dt, perf.dt),coalesce(download.country_code, perf.country_code),coalesce(download.device_code, perf.device_code),product.company_id) company_est_cumulative_revenue,
    cast(perf.est_rpd as decimal(15, 6)) as est_rpd,
    perf.est_average_active_users,
    perf.est_total_active_days,
    perf.est_wifi_bytes,
    perf.est_usage_penetration,
    perf.est_average_session_per_user,
    perf.est_average_session_duration,
    perf.est_average_time_per_user,
    perf.est_total_time,
    perf.est_average_active_days,
    perf.est_percentage_active_days,
    perf.est_share_of_category_time,
    perf.est_install_base,
    perf.est_install_penetration,
    perf.est_open_rate,
    product.product_name,
    product.product_type,
    product.product_status,
    product.unified_product_name,
    product.unified_product_id,
    product.category_name,
    product.category_id,
    product.market_code,
    product.publisher_name,
    product.publisher_id,
    product.publisher_market,
    product.publisher_website,
    product.company_name,
    product.company_id,
    product.parent_company_name,
    product.parent_company_id,
    product.company_stock_symbol,
    product.company_website,
    product.company_is_public,
    current_timestamp() as etl_time
from
    dwd.dwd_competitor_data_ai_app_download_view as download
full join dwd.dwd_competitor_data_ai_app_perf_view as perf on download.dt = perf.dt
    and download.country_code = perf.country_code
    and download.device_code = perf.device_code
    and download.product_id = perf.product_id
inner join dim.dim_product as product on download.product_id = product.product_id or perf.product_id = product.product_id
where
    (download.dt >='${bf_3_dt}' and download.dt<='${bf_1_dt}')
    or
	(perf.dt >='${bf_3_dt}' and perf.dt<='${bf_1_dt}');

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_init_dws_competitor_app_perf_download_ed
-- workflow_version : 2
-- create_user      : doupz
-- task_name        : tbl_init_dws_competitor_app_perf_download_ed
-- task_version     : 2
-- update_time      : 2024-02-06 14:54:56
-- sql_path         : \starrocks\tbl_init_dws_competitor_app_perf_download_ed\tbl_init_dws_competitor_app_perf_download_ed
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_competitor_app_perf_download_ed
select
    coalesce(download.dt, perf.dt) as dt,
    coalesce(download.country_code, perf.country_code) as country_code,
    coalesce(download.device_code, perf.device_code) as device_code,
    coalesce(download.product_id, perf.product_id) as product_id,
    coalesce(download.granularity, perf.granularity) as granularity,
    coalesce(download.end_date, perf.end_date) as end_date,
    download.est_organic_download,
    download.est_organic_featured_download,
    download.est_organic_search_download,
    download.est_paid_ads_download,
    download.est_paid_channel_download,
    download.est_paid_search_download,
    perf.est_download,
    perf.est_revenue,
    perf.est_cumulative_download,
    sum(est_cumulative_download) over(partition by coalesce(download.dt, perf.dt),coalesce(download.country_code, perf.country_code),coalesce(download.device_code, perf.device_code),product.company_id) company_est_cumulative_download,
    perf.est_cumulative_revenue,
    sum(est_cumulative_revenue) over(partition by coalesce(download.dt, perf.dt),coalesce(download.country_code, perf.country_code),coalesce(download.device_code, perf.device_code),product.company_id) company_est_cumulative_revenue,
    cast(perf.est_rpd as decimal(15, 6)) as est_rpd,
    perf.est_average_active_users,
    perf.est_total_active_days,
    perf.est_wifi_bytes,
    perf.est_usage_penetration,
    perf.est_average_session_per_user,
    perf.est_average_session_duration,
    perf.est_average_time_per_user,
    perf.est_total_time,
    perf.est_average_active_days,
    perf.est_percentage_active_days,
    perf.est_share_of_category_time,
    perf.est_install_base,
    perf.est_install_penetration,
    perf.est_open_rate,
    product.product_name,
    product.product_type,
    product.product_status,
    product.unified_product_name,
    product.unified_product_id,
    product.category_name,
    product.category_id,
    product.market_code,
    product.publisher_name,
    product.publisher_id,
    product.publisher_market,
    product.publisher_website,
    product.company_name,
    product.company_id,
    product.parent_company_name,
    product.parent_company_id,
    product.company_stock_symbol,
    product.company_website,
    product.company_is_public,
    current_timestamp() as etl_time
from
    dwd.dwd_competitor_data_ai_app_download_view as download
        full join dwd.dwd_competitor_data_ai_app_perf_view as perf on download.dt = perf.dt
        and download.country_code = perf.country_code
        and download.device_code = perf.device_code
        and download.product_id = perf.product_id
        inner join dim.dim_product as product on download.product_id = product.product_id or perf.product_id = product.product_id
where
    (download.dt > '2023-08-01' and download.dt <= '2023-10-01')
   or
    (perf.dt > '2023-08-01' and perf.dt <= '2023-10-01');
