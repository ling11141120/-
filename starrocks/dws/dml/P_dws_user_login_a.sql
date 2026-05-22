----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_user_login_a
-- workflow_version : 6
-- create_user      : yanxh
-- task_name        : tbl_dws_user_login_a
-- task_version     : 6
-- update_time      : 2023-12-05 15:22:20
-- sql_path         : \starrocks\tbl_dws_user_login_a\tbl_dws_user_login_a
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_user_login_a
       select    '${bf_1_dt}' as dt,
            u.product_id,
            u.user_id,
           u.first_login_time,
          u.last_login_time,
          u.new_login_time,
          u.first_login_ip,
          u.last_login_ip,
       u.new_login_ip,
       DATEDIFF(date(u.new_login_time) ,date(acc.create_time)) as remain_day,
       u.login_days,
       u.login_times,
       now() etl_times
       from (
    select
           IFNULL(x.product_id,y.product_id) product_id,
		    IFNULL(x.user_id,y.user_id) user_id,
            (case when x.first_login_time is not null and y.first_login_time is null then x.first_login_time   else y.first_login_time end) first_login_time,

            (case when  x.last_login_time is null and x.user_id is not null then y.new_login_time
                  when  x.last_login_time is null and y.last_login_time is not null then y.last_login_time    else x.last_login_time end) last_login_time,

            (case when x.new_login_time is null and y.new_login_time is not null then y.new_login_time   else x.new_login_time end) new_login_time,
            (case when x.first_login_ip is not null and y.first_login_ip is null then x.first_login_ip   else y.first_login_ip end) first_login_ip,

            (case when  x.last_login_ip is null and x.user_id is not null then y.last_login_ip
                  when  x.last_login_ip is null and y.last_login_ip is not null then y.last_login_ip   else x.last_login_ip end) last_login_ip,

            (case when x.new_login_ip is null and y.new_login_ip is not null then y.new_login_ip   else x.new_login_ip end) new_login_ip,
             ifnull(y.login_days,0)+ifnull(x.login_days,0) as  login_days ,
               ifnull(y.login_times,0)+ ifnull(x.login_times,0) as  login_times
    from (
    select   dt,
            product_id,user_id,
           first_login_time,
          last_login_time,
          new_login_time,
          first_login_ip,
          last_login_ip,
       new_login_ip,
       login_days,
       login_times
       from
dws.dws_user_login_a where dt='${bf_2_dt}'
and  product_id in  (3311,3333,3371,3399,3501,3511,7757,8858)
    ) y
full join
(
   with p0 as
    (
    select  a.productid product_id,
            a.userid    user_id,
            count(distinct a.dt) as login_days,
            count(1) as login_times
   from  dwd.dwd_user_appstartlog a
   where a.dt='${bf_1_dt}'
   and  productid in  (3311,3333,3371,3399,3501,3511,7757,8858)
   -- and a.userid in (138683467,134110124,134385152,135294493)
   group by 1,2

    ) ,
    p1 as
    (
    select
          product_id,user_id,
          max(case when  rank_asc=1 then createtime end) as first_login_time,
          max(case when  rank_desc=2 then createtime end ) as last_login_time,
          max(case when  rank_desc=1 then createtime end) as new_login_time,
          max(case when  rank_asc=1 then ip end) as first_login_ip,
          max(case when  rank_desc=2 then ip end) as last_login_ip,
          max(case when  rank_desc=1 then ip end) as new_login_ip

    from
    (
    SELECT productid product_id,
           userid    user_id,
           createtime,
           ip,
           ROW_NUMBER()over(partition by productid,userid order by  createtime ) rank_asc,
           ROW_NUMBER()over(partition by productid,userid order by  createtime  desc ) rank_desc
    from dwd.dwd_user_appstartlog
    where dt='${bf_1_dt}'
       and  productid in  (3311,3333,3371,3399,3501,3511,7757,8858)
     -- and userid in (138683467,134110124,134385152,135294493)
    ) a where rank_asc=1 or rank_desc in (1,2)
    group by 1,2  )

    select
    p0.product_id  ,
    p0.user_id   ,
    p1.first_login_time  ,
    p1.last_login_time  ,
    p1.new_login_time   ,
    p1.first_login_ip   ,
    p1.last_login_ip  ,
    p1.new_login_ip  ,
    p0.login_days  ,
    p0.login_times
    from p0 inner join
    p1 on p0.product_id =p1.product_id and  p0.user_id =p1.user_id
  )  x
    on y.product_id=x.product_id and y.user_id=x.user_id
 ) u  left join
    (select product_id,id,create_time from dim.dim_user_account_info_view  ) acc
    on u.product_id=acc.product_id  and u.user_id =acc.id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_user_login_a
-- workflow_version : 6
-- create_user      : yanxh
-- task_name        : tbl_dws_user_login_a_3322
-- task_version     : 6
-- update_time      : 2023-12-05 15:22:20
-- sql_path         : \starrocks\tbl_dws_user_login_a\tbl_dws_user_login_a_3322
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_user_login_a
       select    '${bf_1_dt}' as dt,
            u.product_id,
            u.user_id,
           u.first_login_time,
          u.last_login_time,
          u.new_login_time,
          u.first_login_ip,
          u.last_login_ip,
       u.new_login_ip,
       DATEDIFF(date(u.new_login_time) ,date(acc.create_time)) as remain_day,
       u.login_days,
       u.login_times,
       now() etl_times
       from (
    select
           IFNULL(x.product_id,y.product_id) product_id,
		    IFNULL(x.user_id,y.user_id) user_id,
            (case when x.first_login_time is not null and y.first_login_time is null then x.first_login_time   else y.first_login_time end) first_login_time,

            (case when  x.last_login_time is null and x.user_id is not null then y.new_login_time
                  when  x.last_login_time is null and y.last_login_time is not null then y.last_login_time    else x.last_login_time end) last_login_time,

            (case when x.new_login_time is null and y.new_login_time is not null then y.new_login_time   else x.new_login_time end) new_login_time,
            (case when x.first_login_ip is not null and y.first_login_ip is null then x.first_login_ip   else y.first_login_ip end) first_login_ip,

            (case when  x.last_login_ip is null and x.user_id is not null then y.last_login_ip
                  when  x.last_login_ip is null and y.last_login_ip is not null then y.last_login_ip   else x.last_login_ip end) last_login_ip,

            (case when x.new_login_ip is null and y.new_login_ip is not null then y.new_login_ip   else x.new_login_ip end) new_login_ip,
             ifnull(y.login_days,0)+ifnull(x.login_days,0) as  login_days ,
               ifnull(y.login_times,0)+ ifnull(x.login_times,0) as  login_times
    from (
    select   dt,
            product_id,user_id,
           first_login_time,
          last_login_time,
          new_login_time,
          first_login_ip,
          last_login_ip,
       new_login_ip,
       login_days,
       login_times
       from
dws.dws_user_login_a where dt='${bf_2_dt}'
and  product_id in  (3322)
    ) y
full join
(
   with p0 as
    (
    select  a.productid product_id,
            a.userid    user_id,
            count(distinct a.dt) as login_days,
            count(1) as login_times
   from  dwd.dwd_user_appstartlog a
   where a.dt='${bf_1_dt}'
   and  productid in  (3322)
   -- and a.userid in (138683467,134110124,134385152,135294493)
   group by 1,2

    ) ,
    p1 as
    (
    select
          product_id,user_id,
          max(case when  rank_asc=1 then createtime end) as first_login_time,
          max(case when  rank_desc=2 then createtime end ) as last_login_time,
          max(case when  rank_desc=1 then createtime end) as new_login_time,
          max(case when  rank_asc=1 then ip end) as first_login_ip,
          max(case when  rank_desc=2 then ip end) as last_login_ip,
          max(case when  rank_desc=1 then ip end) as new_login_ip

    from
    (
    SELECT productid product_id,
           userid    user_id,
           createtime,
           ip,
           ROW_NUMBER()over(partition by productid,userid order by  createtime ) rank_asc,
           ROW_NUMBER()over(partition by productid,userid order by  createtime  desc ) rank_desc
    from dwd.dwd_user_appstartlog
    where dt='${bf_1_dt}'
       and  productid in  (3322)
     -- and userid in (138683467,134110124,134385152,135294493)
    ) a where rank_asc=1 or rank_desc in (1,2)
    group by 1,2  )

    select
    p0.product_id  ,
    p0.user_id   ,
    p1.first_login_time  ,
    p1.last_login_time  ,
    p1.new_login_time   ,
    p1.first_login_ip   ,
    p1.last_login_ip  ,
    p1.new_login_ip  ,
    p0.login_days  ,
    p0.login_times
    from p0 inner join
    p1 on p0.product_id =p1.product_id and  p0.user_id =p1.user_id
  )  x
    on y.product_id=x.product_id and y.user_id=x.user_id
 ) u  left join
    (select product_id,id,create_time from dim.dim_user_account_info_view  ) acc
    on u.product_id=acc.product_id  and u.user_id =acc.id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_user_login_a
-- workflow_version : 6
-- create_user      : yanxh
-- task_name        : tbl_dws_user_login_a_3366
-- task_version     : 6
-- update_time      : 2023-12-05 15:22:20
-- sql_path         : \starrocks\tbl_dws_user_login_a\tbl_dws_user_login_a_3366
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_user_login_a
       select    '${bf_1_dt}' as dt,
            u.product_id,
            u.user_id,
           u.first_login_time,
          u.last_login_time,
          u.new_login_time,
          u.first_login_ip,
          u.last_login_ip,
       u.new_login_ip,
       DATEDIFF(date(u.new_login_time) ,date(acc.create_time)) as remain_day,
       u.login_days,
       u.login_times,
       now() etl_times
       from (
    select
           IFNULL(x.product_id,y.product_id) product_id,
		    IFNULL(x.user_id,y.user_id) user_id,
            (case when x.first_login_time is not null and y.first_login_time is null then x.first_login_time   else y.first_login_time end) first_login_time,

            (case when  x.last_login_time is null and x.user_id is not null then y.new_login_time
                  when  x.last_login_time is null and y.last_login_time is not null then y.last_login_time    else x.last_login_time end) last_login_time,

            (case when x.new_login_time is null and y.new_login_time is not null then y.new_login_time   else x.new_login_time end) new_login_time,
            (case when x.first_login_ip is not null and y.first_login_ip is null then x.first_login_ip   else y.first_login_ip end) first_login_ip,

            (case when  x.last_login_ip is null and x.user_id is not null then y.last_login_ip
                  when  x.last_login_ip is null and y.last_login_ip is not null then y.last_login_ip   else x.last_login_ip end) last_login_ip,

            (case when x.new_login_ip is null and y.new_login_ip is not null then y.new_login_ip   else x.new_login_ip end) new_login_ip,
             ifnull(y.login_days,0)+ifnull(x.login_days,0) as  login_days ,
               ifnull(y.login_times,0)+ ifnull(x.login_times,0) as  login_times
    from (
    select   dt,
            product_id,user_id,
           first_login_time,
          last_login_time,
          new_login_time,
          first_login_ip,
          last_login_ip,
       new_login_ip,
       login_days,
       login_times
       from
dws.dws_user_login_a where dt='${bf_2_dt}'
and  product_id in  (3366)
    ) y
full join
(
   with p0 as
    (
    select  a.productid product_id,
            a.userid    user_id,
            count(distinct a.dt) as login_days,
            count(1) as login_times
   from  dwd.dwd_user_appstartlog a
   where a.dt='${bf_1_dt}'
   and  productid in  (3366)
   -- and a.userid in (138683467,134110124,134385152,135294493)
   group by 1,2

    ) ,
    p1 as
    (
    select
          product_id,user_id,
          max(case when  rank_asc=1 then createtime end) as first_login_time,
          max(case when  rank_desc=2 then createtime end ) as last_login_time,
          max(case when  rank_desc=1 then createtime end) as new_login_time,
          max(case when  rank_asc=1 then ip end) as first_login_ip,
          max(case when  rank_desc=2 then ip end) as last_login_ip,
          max(case when  rank_desc=1 then ip end) as new_login_ip

    from
    (
    SELECT productid product_id,
           userid    user_id,
           createtime,
           ip,
           ROW_NUMBER()over(partition by productid,userid order by  createtime ) rank_asc,
           ROW_NUMBER()over(partition by productid,userid order by  createtime  desc ) rank_desc
    from dwd.dwd_user_appstartlog
    where dt='${bf_1_dt}'
       and  productid in  (3366)
     -- and userid in (138683467,134110124,134385152,135294493)
    ) a where rank_asc=1 or rank_desc in (1,2)
    group by 1,2  )

    select
    p0.product_id  ,
    p0.user_id   ,
    p1.first_login_time  ,
    p1.last_login_time  ,
    p1.new_login_time   ,
    p1.first_login_ip   ,
    p1.last_login_ip  ,
    p1.new_login_ip  ,
    p0.login_days  ,
    p0.login_times
    from p0 inner join
    p1 on p0.product_id =p1.product_id and  p0.user_id =p1.user_id
  )  x
    on y.product_id=x.product_id and y.user_id=x.user_id
 ) u  left join
    (select product_id,id,create_time from dim.dim_user_account_info_view  ) acc
    on u.product_id=acc.product_id  and u.user_id =acc.id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_user_login_a
-- workflow_version : 6
-- create_user      : yanxh
-- task_name        : tbl_dws_user_login_a_3388
-- task_version     : 6
-- update_time      : 2023-12-05 15:22:20
-- sql_path         : \starrocks\tbl_dws_user_login_a\tbl_dws_user_login_a_3388
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_user_login_a

       select    '${bf_1_dt}' as dt,
            u.product_id,
            u.user_id,
           u.first_login_time,
          u.last_login_time,
          u.new_login_time,
          u.first_login_ip,
          u.last_login_ip,
       u.new_login_ip,
       DATEDIFF(date(u.new_login_time) ,date(acc.create_time)) as remain_day,
       u.login_days,
       u.login_times,
       now() etl_times
       from (
    select
           IFNULL(x.product_id,y.product_id) product_id,
		    IFNULL(x.user_id,y.user_id) user_id,
            (case when x.first_login_time is not null and y.first_login_time is null then x.first_login_time   else y.first_login_time end) first_login_time,

            (case when  x.last_login_time is null and x.user_id is not null then y.new_login_time
                  when  x.last_login_time is null and y.last_login_time is not null then y.last_login_time    else x.last_login_time end) last_login_time,

            (case when x.new_login_time is null and y.new_login_time is not null then y.new_login_time   else x.new_login_time end) new_login_time,
            (case when x.first_login_ip is not null and y.first_login_ip is null then x.first_login_ip   else y.first_login_ip end) first_login_ip,

            (case when  x.last_login_ip is null and x.user_id is not null then y.last_login_ip
                  when  x.last_login_ip is null and y.last_login_ip is not null then y.last_login_ip   else x.last_login_ip end) last_login_ip,

            (case when x.new_login_ip is null and y.new_login_ip is not null then y.new_login_ip   else x.new_login_ip end) new_login_ip,
             ifnull(y.login_days,0)+ifnull(x.login_days,0) as  login_days ,
               ifnull(y.login_times,0)+ ifnull(x.login_times,0) as  login_times
    from (
    select   dt,
            product_id,user_id,
           first_login_time,
          last_login_time,
          new_login_time,
          first_login_ip,
          last_login_ip,
       new_login_ip,
       login_days,
       login_times
       from
dws.dws_user_login_a where dt='${bf_2_dt}'
and  product_id in  (3388)
    ) y
full join
(
   with p0 as
    (
    select  a.productid product_id,
            a.userid    user_id,
            count(distinct a.dt) as login_days,
            count(1) as login_times
   from  dwd.dwd_user_appstartlog a
   where a.dt='${bf_1_dt}'
   and  productid in  (3388)
   -- and a.userid in (138683467,134110124,134385152,135294493)
   group by 1,2

    ) ,
    p1 as
    (
    select
          product_id,user_id,
          max(case when  rank_asc=1 then createtime end) as first_login_time,
          max(case when  rank_desc=2 then createtime end ) as last_login_time,
          max(case when  rank_desc=1 then createtime end) as new_login_time,
          max(case when  rank_asc=1 then ip end) as first_login_ip,
          max(case when  rank_desc=2 then ip end) as last_login_ip,
          max(case when  rank_desc=1 then ip end) as new_login_ip

    from
    (
    SELECT productid product_id,
           userid    user_id,
           createtime,
           ip,
           ROW_NUMBER()over(partition by productid,userid order by  createtime ) rank_asc,
           ROW_NUMBER()over(partition by productid,userid order by  createtime  desc ) rank_desc
    from dwd.dwd_user_appstartlog
    where dt='${bf_1_dt}'
       and  productid in  (3388)
     -- and userid in (138683467,134110124,134385152,135294493)
    ) a where rank_asc=1 or rank_desc in (1,2)
    group by 1,2  )

    select
    p0.product_id  ,
    p0.user_id   ,
    p1.first_login_time  ,
    p1.last_login_time  ,
    p1.new_login_time   ,
    p1.first_login_ip   ,
    p1.last_login_ip  ,
    p1.new_login_ip  ,
    p0.login_days  ,
    p0.login_times
    from p0 inner join
    p1 on p0.product_id =p1.product_id and  p0.user_id =p1.user_id
  )  x
    on y.product_id=x.product_id and y.user_id=x.user_id
 ) u  left join
    (select product_id,id,create_time from dim.dim_user_account_info_view  ) acc
    on u.product_id=acc.product_id  and u.user_id =acc.id;
