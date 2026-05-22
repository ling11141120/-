----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_read_consume_user_consume_p_hi
-- workflow_version : 2
-- create_user      : xixg
-- task_name        : dws_read_consume_user_consume_p_hi
-- task_version     : 2
-- update_time      : 2024-05-25 18:47:11
-- sql_path         : \starrocks\tbl_dws_read_consume_user_consume_p_hi\dws_read_consume_user_consume_p_hi
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_read_consume_user_consume_p_hi
with t1 as (
    select DATE_FORMAT (createtime, '%Y-%m-%d %H') AS dt_hour, product_id, types, user_id,
           (case
                when  product_id in(3311,3322,3333,3366,3371,3388,3501,3511,3399) and book_id % 1000 in(322,375,409,410,418,419,414,433,435,436,445,412,413,415,447,448) then book_id % 1000
                when  product_id in (7757,8858,7777,8888) then 777
                else 333 end ) as site_id,
           book_id,substr(chapter_ids,2,length(chapter_ids) - 2) as chapter_ids,Chapter_id,pay_type,
           sum(amount) as con_amount,count(1) as con_chp_cnt,sum(consume_cnt) as con_book_cnt,min(createtime) as fst_time,max(createtime) as lst_time
    from dwd.dwd_consume_user_consume_explode where dt>='${bf_1_dt}' and dt<='${dt}' and (types in(1,2,3) or (types=4 and isFirst=1))
    group by 1,2,3,4,5,6,7,8,9
)
select t1.dt_hour,md5(concat_ws('_',t1.dt_hour, t1.product_id,t1.user_id,t1.types,t1.pay_type,t1.site_id,t1.book_id,t1.chapter_ids,t1.Chapter_id)) as md5_key,
       t1.product_id,t1.user_id,t1.types,t1.pay_type,t1.site_id,t1.book_id,t1.chapter_ids,t1.Chapter_id,
       acc.corever,acc.mt ,acc.ver ,acc.current_language as currentlanguage,
       (case when acc.product_id = 3311 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  6
             when acc.product_id = 3322 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  5
             when acc.product_id = 3333 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  2
             when acc.product_id = 3366 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  3
             when acc.product_id = 3371 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  7
             when acc.product_id = 3388 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  4
             when acc.product_id = 3501 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  11
             when acc.product_id = 3511 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  12
             when acc.product_id = 3399 and (acc.Current_Language2 is null or acc.Current_Language2 = 0) then  9
             else acc.Current_Language2 end ) as  CurrentLanguage2,
       acc.Create_Time as reg_date,datediff(t1.dt_hour,acc.Create_Time) as reg_days,acc.reg_country as reg_country,acc.appver,acc.sex,other.is_negative_user,other.ads_type,other.ads_quality,acc.app_id as app_id,
       con_amount,con_chp_cnt,con_book_cnt,fst_time,lst_time,now() as etl_time
from t1 left join dim.dim_user_account_info_view acc on t1.product_id=acc.product_id and t1.user_id=acc.Id
        left join dim.dim_user_other_info_view other on t1.product_id=other.product_id and t1.user_id=other.Id;
