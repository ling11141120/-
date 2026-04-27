insert into ads.ads_srsv_biedou_iaa_group_user
with iaa as (
    -- IAA人群包
    select
        ifnull(b.id, a.id) as id,
        ifnull(b.group_name, a.group_name) as group_name
    from (
        select
            id,
            group_name
        from ods.ods_beidou_hk_cdp_user_portrait_group_info_at
        where is_delete = 0 and parent_group_id = 0 and lower(group_name) like '%iaa%'
    ) a
    left join ods.ods_beidou_hk_cdp_user_portrait_group_info_at b
    on a.id = b.parent_group_id
)
select
    date(date_add(dt, interval generate_series day)) as dt,
    CrowdId,
    SubCrowdId,
    UserId,
    now() as etl_time
from (
    select
        dt,
        CrowdId,
        SubCrowdId,
        UserId,
        days_diff(date(next_create_time), dt) as days_diff
    from (
        select
            dt,
            CrowdId,
            SubCrowdId,
            UserId,
            CreateTime,
            -- 获取入包对应的出包时间
            lead(CreateTime, 1, '${af_1_dt}') over (partition by SubCrowdId, UserId order by CreateTime, Id) as next_create_time,
            Operation
        from (
            select
                dt,
                Id,
                CrowdId,
                SubCrowdId,
                UserId,
                CreateTime,
                Operation,
                -- 1、用来判断该用户在人群包下是否一进一出，不是则剔除脏数据（剔除第二条）
                -- 2、用来判断第一条是否是入包，不是则剔除
                lag(Operation, 1, 2) over (partition by SubCrowdId, UserId order by CreateTime, Id) as last_operation
            from ads.crowd_log
            where Operation in(1, 2) and dt >= date_sub('${bf_1_dt}', interval 1 month) and dt <= '${bf_1_dt}' and SubCrowdId in(select id from iaa)
        ) a where Operation != last_operation
    ) a where Operation = 1 and hours_diff(next_create_time, CreateTime) > 1
) a
cross join generate_series(0, a.days_diff, 1)
where date_add(dt, interval generate_series day) <= '${bf_1_dt}';
