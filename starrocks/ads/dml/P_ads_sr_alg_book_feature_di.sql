----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_alg_book_feature_di
-- workflow_version : 5
-- create_user      : yanxh
-- task_name        : ads_sr_alg_book_feature_di
-- task_version     : 4
-- update_time      : 2025-03-26 23:02:22
-- sql_path         : \starrocks\tbl_ads_sr_alg_book_feature_di\ads_sr_alg_book_feature_di
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sr_alg_book_feature_di
select
    '${bf_1_dt}' dt,
    b.book_id book_id,
    channel,
    new_cid,
    count(distinct CASE WHEN DATEDIFF(b.dt,x1.dt)=1 THEN x1.user_id ELSE null END) read_uv_1d,
    count(distinct CASE WHEN DATEDIFF(b.dt,x1.dt)=1 and x1.csum_total>0 THEN x1.user_id ELSE null END) csum_uv_1d,
    sum(CASE WHEN DATEDIFF(b.dt,x1.dt)=1 THEN x1.start_read_chpts ELSE 0 END) start_read_chpts_1d,
    sum(CASE WHEN DATEDIFF(b.dt,x1.dt)=1 THEN x1.end_read_chpts ELSE 0 END) end_read_chpts_1d,
    sum(CASE WHEN DATEDIFF(b.dt,x1.dt)=1 THEN IFNULL(x1.csum_num, 0) ELSE  0 END) csum_num_1d,
    sum(CASE WHEN DATEDIFF(b.dt,x1.dt)=1 THEN IFNULL(x1.csum_total, 0) ELSE 0 END) csum_total_1d,
    count(distinct CASE WHEN DATEDIFF(b.dt,x1.dt)<=3 THEN x1.user_id ELSE null END) read_uv_3d,
    count(distinct CASE WHEN DATEDIFF(b.dt,x1.dt)<=3 and x1.csum_total>0 THEN x1.user_id ELSE null END) csum_uv_3d,
    sum(CASE WHEN DATEDIFF(b.dt,x1.dt)<=3 THEN x1.start_read_chpts ELSE 0 END) start_read_chpts_3d,
    sum(CASE WHEN DATEDIFF(b.dt,x1.dt)<=3 THEN x1.end_read_chpts ELSE 0 END) end_read_chpts_3d,
    sum(CASE WHEN DATEDIFF(b.dt,x1.dt)<=3 THEN IFNULL(x1.csum_num, 0) ELSE 0 END) csum_num_3d,
    sum(CASE WHEN DATEDIFF(b.dt,x1.dt)<=3 THEN IFNULL(x1.csum_total, 0) ELSE 0 END) csum_total_3d,
    count(distinct CASE WHEN DATEDIFF(b.dt,x1.dt)<=7 THEN x1.user_id ELSE null END) read_uv_7d,
    count(distinct CASE WHEN DATEDIFF(b.dt,x1.dt)<=7 and x1.csum_total>0 THEN x1.user_id ELSE null END) csum_uv_7d,
    sum(CASE WHEN DATEDIFF(b.dt,x1.dt)<=7 THEN x1.start_read_chpts ELSE 0 END) start_read_chpts_7d,
    sum(CASE WHEN DATEDIFF(b.dt,x1.dt)<=7 THEN x1.end_read_chpts ELSE 0 END) end_read_chpts_7d,
    sum(CASE WHEN DATEDIFF(b.dt,x1.dt)<=7 THEN IFNULL(x1.csum_num, 0) ELSE 0 END) csum_num_7d,
    sum(CASE WHEN DATEDIFF(b.dt,x1.dt)<=7 THEN IFNULL(x1.csum_total, 0) ELSE 0 END) csum_total_7d,
    count(distinct CASE WHEN DATEDIFF(b.dt,x1.dt)<=30 THEN x1.user_id ELSE null END) read_uv_30d,
    count(distinct CASE WHEN DATEDIFF(b.dt,x1.dt)<=30 and x1.csum_total>0 THEN x1.user_id ELSE null END) csum_uv_30d,
    sum(CASE WHEN DATEDIFF(b.dt,x1.dt)<=30 THEN x1.start_read_chpts ELSE 0 END) start_read_chpts_30d,
    sum(CASE WHEN DATEDIFF(b.dt,x1.dt)<=30 THEN x1.end_read_chpts ELSE 0 END) end_read_chpts_30d,
    sum(CASE WHEN DATEDIFF(b.dt,x1.dt)<=30 THEN IFNULL(x1.csum_num, 0) ELSE 0 END) csum_num_30d,
    sum(CASE WHEN DATEDIFF(b.dt,x1.dt)<=30 THEN IFNULL(x1.csum_total, 0) ELSE 0 END) csum_total_30d,
    count(distinct x1.user_id) read_uv,
    count(distinct CASE WHEN x1.csum_total>0 THEN x1.user_id ELSE null END) csum_uv,
    sum(x1.start_read_chpts) start_read_chpts,
    sum(x1.end_read_chpts) end_read_chpts,
    sum(IFNULL(x1.csum_num, 0)) csum_num,
    sum(IFNULL(x1.csum_total, 0)) csum_total,
    now() as etl_tm

from(
        select
            '${bf_1_dt}' dt, book_id, max(channel) channel, max(new_cid) new_cid
        from dim.dim_shuangwen_book_read_consume_info
        group by book_id

    )b
        left join( -- ---------有效阅读消耗数据----------------------------
    select  dt,  user_id, book_id, start_read_chpts, end_read_chpts,csum_cnt as  csum_num, csum_amt as csum_total
    from   ads.ads_read_user_read_csum_effective_p_di
    where dt<'${bf_1_dt}'
    group by 1,2,3,4,5,6,7

)x1 on b.book_id=x1.book_id
group by b.dt, b.book_id, channel, new_cid;
