----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_book_income_expand_di
-- workflow_version : 18
-- create_user      : linq
-- task_name        : ads_sr_book_income_expand_di
-- task_version     : 5
-- update_time      : 2024-10-16 11:54:57
-- sql_path         : \starrocks\tbl_ads_sr_book_income_expand_di\ads_sr_book_income_expand_di
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_sr_book_income_expand_di where dt>=date_sub('${dt}',interval 60 day) and dt<='${dt}';

-- SQL语句
insert into ads.ads_sr_book_income_expand_di
with a as (
    select dt,product_id,book_type,book_id,lang_id,author_id,book_name,book_code,is_put,put_down_level,author_name,author_type
    from ads.ads_sr_book_income_expand_di_mid
    left join (
        select datestr as dt from dim.dim_date where datestr>=date_sub('${dt}',interval 60 day ) and datestr<='${dt}'
    ) t1 on 1=1 -- 为了同时跑多天的数据
)
select a.dt,md5(concat_ws('_',a.dt,a.product_id,a.book_type,a.book_id,a.lang_id)) as md5_key,
       a.product_id,a.book_type as income_type,a.book_id,a.lang_id,a.author_id,a.book_name,a.author_name,
       b.AuthorSale,now() as etl_time
from a
left join (
    select date(StaticDate) as dt, bookid, Language,AuthorSale
    from ods.ods_tidb_shuangwen_authorbookdaily
    where date(StaticDate) >= date_sub('${dt}', interval 60 day) and date(StaticDate)<='${dt}'
    )b on a.dt=b.dt and a.book_id=b.BookId and a.lang_id=b.Language;
