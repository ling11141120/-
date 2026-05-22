----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_video_short_video_consume_production
-- workflow_version : 9
-- create_user      : chenmo
-- task_name        : dwd_video_short_video_consume_production
-- task_version     : 9
-- update_time      : 2024-12-30 11:02:00
-- sql_path         : \starrocks\tbl_dwd_video_short_video_consume_production\dwd_video_short_video_consume_production
----------------------------------------------------------------
-- 前置SQL语句
delete from dwd.dwd_video_short_video_consume_production where dt = '${bf_1_dt}';

-- SQL语句
-- 版权方
insert into dwd.dwd_video_short_video_consume_production
-- 获取用户数据,渠道
with test_user as (
    select
        user_id
    from dwd.dwd_trade_short_video_payorder
    where test_flag = 1
    group by user_id
),
-- 获取海剧dt-1 消费明细
sv_consume as (
    select
       t1.dt,
       t1.id,
       0 as `type`,
       c.series_id,
       t1.epis_id,
       t1.epis_num,
       t1.account_id,
       t1.core,
       t1.consume_type,
       t1.consume_value,
       t1.create_time,
       now() as etl_time
    from(
        select
            a.dt,
            a.id,
            ifnull(a.epis_id,b.EpisId) as epis_id,
            ifnull(a.epis_num,b.EpisNum) as epis_num,
            a.account_id,
            c.core,
            a.consume_type,
            round(a.consume_value/count(1) over (partition by a.dt,a.Id,a.consume_type),6) as consume_value,
            a.create_time
        from dwd.dwd_consume_short_video_consume_view a
        left join (
            select b1.id,b1.AccountId,b1.SeriesId,b1.EpisId,b1.EpisNum,b2.epis_ids,b1.BillId
            from ods.ods_tidb_short_video_series_unlock b1
            left join (-- 批量解锁章节
                select BillId,array_join(array_agg(EpisId),',') as epis_ids
                from ods.ods_tidb_short_video_series_unlock
                where CreateTime>=date_sub('${bf_1_dt}',interval 2 day)
                group by BillId
                )b2 on b1.BillId=b2.BillId
            where CreateTime>=date_sub('${bf_1_dt}',interval 2 day )
            )b on a.Id=b.BillId
        left join test_user t on a.account_id=t.user_id
        left join (
            select
                user_id,
                core,
                update_time as start_time,
                lead(update_time,1,'2099-12-31') over(partition by user_id order by update_time) as end_time
            from dim.dim_user_corever
        ) c on a.account_id=c.user_id and a.create_time >= c.start_time and a.create_time < c.end_time
        where a.dt = '${bf_1_dt}' and ifnull(a.epis_id,b.EpisId) != 0 and t.user_id is null
    ) t1
    left join dim.dim_short_video_epis_view c on t1.epis_id=c.epis_id
    where c.series_id is not null
)
select
    dt,
    a.id,
    a.`type`,
    a.series_id,
    a.epis_num,
    a.account_id,
    a.consume_type,
    a.consume_value,
    a.create_time,
    now() as etl_time
from sv_consume a
where a.dt >= '2024-10-01' and core = 1
union all
select
    a.dt,
    a.id,
    a.`type`,
    a.series_id,
    a.epis_num,
    a.account_id,
    a.consume_type,
    a.consume_value,
    a.create_time,
    now() as etl_time
from sv_consume a
where a.dt < '2024-10-01';
