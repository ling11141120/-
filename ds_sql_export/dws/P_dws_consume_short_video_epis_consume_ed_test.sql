----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_consume_short_video_epis_consume_ed_test
-- workflow_version : 1
-- create_user      : chenmo
-- task_name        : dws_consume_short_video_epis_consume_ed_test
-- task_version     : 1
-- update_time      : 2024-10-17 19:30:58
-- sql_path         : \starrocks\tbl_dws_consume_short_video_epis_consume_ed_test\dws_consume_short_video_epis_consume_ed_test
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_consume_short_video_epis_consume_ed_test where dt='${bf_1_dt}';

-- SQL语句
-- 两套逻辑：一套取消费明细，一套取充值明细

-- 新 -消费：观看币
insert into dws.dws_consume_short_video_epis_consume_ed_test
-- 获取海剧dt-1 koc归因周期内的数据
with sv_koc as (
    select
        user_id,
        begin_time,
        koc_text,
        end_time,
        resource_id
    from dwd.dwd_srsv_advertisement_koc_attribution_record_view
    where product_id = 6833
),
-- 获取用户数据，渠道为1
sv_account as (
    select
        user_id
    from dim.dim_short_video_user_accountinfo
    where product_id = 6833 and corever = 1
),
-- 获取版权方收入统计模式
sv_story as (
    select
        story_id,
        divide_type
    from dim.dim_sr_cp_story_view
    where product_type = 1 and story_type = 2
),
-- 获取海剧dt-1 消费明细
sv_user_series_consume as (
    select
        a.id,
        b.series_id,
        a.epis_num,
        a.account_id,
        a.consume_type,
        a.consume_value,
        a.create_time
    from dwd.dwd_consume_short_video_consume_view a
    left join dim.dim_short_video_epis_view b on a.epis_id = b.epis_id
    join sv_account c on a.account_id = c.user_id
    left join sv_story d on b.series_id = d.story_id
    where a.dt = '${bf_1_dt}'
        and a.epis_id != 0
        and b.series_id is not null
        and coalesce(d.divide_type, 0) = 0
),
-- KOC机构合作信息-短剧
koc_institutioncfg as (
    select
        InstitutionId,
        SplitRatio/100 as split_ratio
    from ods.ods_tidb_koc_institutioncfg_da
    where ProjectType = 2
),
-- 根据剧名、用户和koc归因周期剔除koc分成
sv_consume as (
    select
        a.id,
        a.series_id,
        a.epis_num,
        a.account_id,
        a.consume_type,
        a.consume_value * (1 - coalesce(d.split_ratio, 0)) as consume_value
    from sv_user_series_consume a
        -- 订单关联归因表，确认归属koc的订单
        left join sv_koc b
            on a.account_id = b.user_id
            and a.series_id = b.resource_id
            and a.create_time >= b.begin_time and a.create_time <= b.end_time
        left join ods.ods_tidb_koc_codeinfo c
            on c.KocCode = b.koc_text
        left join koc_institutioncfg d
            on c.InstitutionId = d.InstitutionId
)
select
    '${bf_1_dt}' as dt,
    a.series_id,
    a.epis_num,
    bitmap_union(to_bitmap(a.account_id)) as consume_user_bitmap,
    sum(a.consume_value) as consume_amt,
    count(distinct a.id) as consume_cnt,
    bitmap_union(to_bitmap(if(a.consume_type = 0, a.account_id, null))) as consume_money_user_bitmap,
    sum(if(a.consume_type = 0, a.consume_value, 0)) as consume_money_amt,
    sum(if(a.consume_type = 0, 1, 0)) as consume_money_cnt,
    bitmap_union(to_bitmap(if(a.consume_type = 1, a.account_id, null))) as consume_cert_user_bitmap,
    sum(if(a.consume_type = 1, a.consume_value, 0)) as consume_cert_amt,
    sum(if(a.consume_type = 1, 1, 0)) as consume_cert_cnt,
    now() as etl_time
from sv_consume a
group by a.series_id, a.epis_num;

-- SQL语句
-- 新 -充值：观看币
insert into dws.dws_consume_short_video_epis_consume_ed_test
-- 获取海剧dt-1 koc归因周期内的数据
with sv_koc as (
    select
        user_id,
        begin_time,
        koc_text,
        end_time,
        resource_id
    from dwd.dwd_srsv_advertisement_koc_attribution_record_view
    where product_id = 6833
),
-- 获取用户数据，渠道为1
sv_account as (
    select
        user_id
    from dim.dim_short_video_user_accountinfo
    where product_id = 6833 and corever = 1
),
-- 获取版权方收入统计模式
sv_story as (
    select
        story_id,
        divide_type
    from dim.dim_sr_cp_story_view
    where product_type = 1 and story_type = 2
        and divide_type = 2
),
-- 获取海剧dt-1 充值明细
sv_production as (
    select
        id,
        login_id,
        substring_index(send_id, '_', -1) as series_id,
        real_recharge,
        event_tm
    from ods_log.ods_sensors_cd_video_production_ordersuccess
    where dt = '${bf_1_dt}' and product_id = 6833 and send_id is not null
),
-- 关联
sv_user_series_consume as (
    select
        a.id,
        a.series_id,
        0 as epis_num,
        a.login_id as account_id,
        0 as consume_type,
        real_recharge*100 as consume_value,
        event_tm as create_time
    from sv_production a
        join sv_account c on a.login_id = c.user_id
        join sv_story d on a.series_id = d.story_id
),
-- KOC机构合作信息-短剧
koc_institutioncfg as (
    select
        InstitutionId,
        SplitRatio/100 as split_ratio
    from ods.ods_tidb_koc_institutioncfg_da
    where ProjectType = 2
),
-- 根据剧名、用户和koc归因周期剔除koc分成
sv_consume as (
    select
        a.id,
        a.series_id,
        a.epis_num,
        a.account_id,
        a.consume_type,
        a.consume_value * (1 - coalesce(d.split_ratio, 0)) as consume_value
    from sv_user_series_consume a
    -- 订单关联归因表，确认归属koc的订单
    left join sv_koc b
        on a.account_id = b.user_id
        and a.series_id = b.resource_id
        and a.create_time >= b.begin_time and a.create_time <= b.end_time
    left join ods.ods_tidb_koc_codeinfo c
        on c.KocCode = b.koc_text
    left join koc_institutioncfg d
        on c.InstitutionId = d.InstitutionId
)
select
    '2024-10-12' as dt,
    a.series_id,
    a.epis_num,
    bitmap_union(to_bitmap(a.account_id)) as consume_user_bitmap,
    sum(a.consume_value) as consume_amt,
    count(distinct a.id) as consume_cnt,
    bitmap_union(to_bitmap(if(a.consume_type = 0, a.account_id, null))) as consume_money_user_bitmap,
    sum(if(a.consume_type = 0, a.consume_value, 0)) as consume_money_amt,
    sum(if(a.consume_type = 0, 1, 0)) as consume_money_cnt,
    bitmap_union(to_bitmap(if(a.consume_type = 1, a.account_id, null))) as consume_cert_user_bitmap,
    sum(if(a.consume_type = 1, a.consume_value, 0)) as consume_cert_amt,
    sum(if(a.consume_type = 1, 1, 0)) as consume_cert_cnt,
    now() as etl_time
from sv_consume a
group by a.series_id, a.epis_num;
