----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_original_user_book_consume_ed
-- workflow_version : 47
-- create_user      : yanxh
-- task_name        : ads_bi_original_book_consume_user_eq
-- task_version     : 6
-- update_time      : 2024-01-04 19:23:44
-- sql_path         : \starrocks\tbl_ads_bi_original_user_book_consume_ed\ads_bi_original_book_consume_user_eq
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_bi_original_book_consume_user_eq
select   a.years,
        2 as  qtypes,
      case when a.dt in (1,2,3) then 1
             when a.dt in (4,5,6) then 2
              when a.dt in (7,8,9) then 3
               when a.dt in (10,11,12) then 4 end as dt,
      a.site_id,
       a.book_id,
       a.user_id,
    count(1) counts,now() as etl_time
from
ads.ads_bi_original_book_consume_user_em a
where
 (a.years=year(date_sub(curdate(),interval 3 month)) and  quarter(concat_ws('-',years,dt,'01')) =quarter(date_sub(curdate(),interval 3 month)) )
or (a.years=year(curdate()) and   quarter(concat_ws('-',years,dt,'01'))= quarter(curdate())  )
and a.qtypes= 1
group by 1,2,3,4,5,6  ;
