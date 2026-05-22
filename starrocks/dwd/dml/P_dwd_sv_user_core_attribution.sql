----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_sv_user_core_attribution
-- workflow_version : 5
-- create_user      : chenmo
-- task_name        : dwd_sv_user_core_attribution
-- task_version     : 5
-- update_time      : 2026-01-28 01:35:50
-- sql_path         : \starrocks\tbl_dwd_sv_user_core_attribution\dwd_sv_user_core_attribution
----------------------------------------------------------------
-- SQL语句
insert into dwd.dwd_sv_user_core_attribution
with user_core_attr as (
    select
        a.user_id,
        b.core,
        a.test_flag,
        a.create_time as start_time,
        lead(a.create_time,1,'2099-12-31') over(partition by a.user_id order by a.create_time) as end_time
    from (
        select
            user_id,
            pay_config_id,
            get_json_string(custom_data,'$.goodsId') as goods_id,
            max(test_flag) as test_flag,
            min(create_time) as create_time
        from dwd.dwd_trade_short_video_payorder
        where !(pay_config_id = 0 and get_json_string(custom_data,'$.goodsId') is null)
        group by user_id,pay_config_id,get_json_string(custom_data,'$.goodsId')
    ) a
    left join dim.dim_short_video_goods_view b
    on a.pay_config_id = b.pay_config_id or a.goods_id = b.id
),
grouped_data as (
    SELECT
        user_id,
        core,
        test_flag,
        start_time,
        end_time,
        -- 使用 LAG 函数判断当前记录是否与上一条记录的状态相同
        IF(core = LAG(core) OVER (PARTITION BY user_id ORDER BY start_time), 0, 1) AS is_new_group
    FROM user_core_attr
),
group_numbers as (
    SELECT
        user_id,
        core,
        test_flag,
        start_time,
        end_time,
        -- 累加分组号，以给每个新分组分配唯一的组编号
        SUM(is_new_group) OVER (PARTITION BY user_id ORDER BY start_time) AS group_id
    FROM grouped_data
)
SELECT
    user_id,
    ifnull(core,-99) as core,
    max(test_flag) as test_flag,
    min(start_time) as start_time,
    max(end_time) as end_time,
    now() as etl_time
FROM group_numbers
GROUP BY user_id, ifnull(core,-99), group_id;
