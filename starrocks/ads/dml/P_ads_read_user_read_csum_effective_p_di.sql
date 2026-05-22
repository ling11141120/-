----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_alg_book_feature_di
-- workflow_version : 5
-- create_user      : yanxh
-- task_name        : ads_read_user_read_csum_effective_p_di
-- task_version     : 4
-- update_time      : 2025-03-26 23:02:22
-- sql_path         : \starrocks\tbl_ads_sr_alg_book_feature_di\ads_read_user_read_csum_effective_p_di
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_read_user_read_csum_effective_p_di
with r as
(
select
    x1.dt dt,
    x1.book_id book_id,
    x1.user_id user_id,
    count(distinct x1.chapter_id) start_read_chpts,
    count(distinct x2.chapter_id) end_read_chpts
from(
    select
        dt,
         user_id,
        book_id,
        chapter_id
    from dws.dws_read_user_read_effective_p_di
    where dt>='${bf_7_dt}'  and  dt<'${dt}'
    and read_tps=1
    and user_id is not null
    and book_id is not null
    and cast(user_id as bigint)  >0
    group by 1,2,3,4
)x1
left join(
    select
        dt,
        user_id,
        book_id,
        chapter_id
    from dws.dws_read_user_read_effective_p_di
    where dt>='${bf_7_dt}'  and  dt<'${dt}'
    and read_tps=2
    and user_id is not null
    and book_id is not null
    and cast(user_id as bigint)  >0
    group by 1,2,3,4
)x2 on x1.dt=x2.dt and x1.user_id=x2.user_id and x1.book_id=x2.book_id and x1.chapter_id=x2.chapter_id
group by 1,2,3
 )

select  r.dt, r.book_id, r.user_id,r.start_read_chpts,r.end_read_chpts,csum.csum_cnt, csum.csum_amt
from  r
 left join
 (  -- --------消耗数额 阅币、礼券、赠送币合计 解锁章节数---------------
  select dt, user_id, book_id, sum(cast(con_chp_amount as int)) as csum_amt, count(distinct chapter_id) as csum_cnt
from dwm.dwm_consume_user_consume_mild_ed
where dt>='${bf_7_dt}'  and  dt<'${dt}' and types in(1,2,3) and length(chapter_id)>0 and book_id>0
group by 1,2,3
 ) csum
 on r.book_id=csum.book_id and r.user_id=csum.user_id and r.dt=csum.dt;
