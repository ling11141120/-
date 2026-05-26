----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_user_viedo_cn_login_ed
-- workflow_version : 9
-- create_user      : zhengtt
-- task_name        : dws_user_viedo_cn_login_ed
-- task_version     : 9
-- update_time      : 2024-11-29 14:06:15
-- sql_path         : \starrocks\tbl_dws_user_viedo_cn_login_ed\dws_user_viedo_cn_login_ed
----------------------------------------------------------------
-- SQL语句
insert into  dws.dws_user_viedo_cn_login_ed  --  test.yxh --测试写入了5月份的数据
with tps_2 as (
  -- ----------------分销的活跃 ----------------------------
select a.dt,6883 as product_id, a.user_id,2 as types, c.corever2,
           c.current_language2, c.mt2, c.reg_country, date(c.create_time)  as reg_date,
           c.chl2,DATEDIFF(a.dt,date(c.create_time)) as reg_days,count(a.user_id) as  login_times,
           now() as etl_time
    from dwd.dwd_user_video_cn_login_info a
          inner join dim.dim_video_cn_accountinfo_view  c
                       on  a.user_id = c.account
      and c.middle_man_id  in
   -- ------------筛选分销的数据-------------------------
 ( select distinct  ref_id from  dim.dim_ads_role_users_view where  role_json like '%middleman%' and  operation_type= 2  )
 where
    a.dt >= '${bf_3_dt}' and  a.dt<='${dt}'
    and    a.state = 1
    group by 1,2,3,4,5,6,7,8,9,10,11
)
,
    tps_3  as
    (
    -- ----------------星图的活跃 特殊的时间段写死 5月9号到5月21号期间 appid='tt3f83493ea0be37f901' 的数据都是归为视趣小程序  ----------------------------
select a.dt,6883 as product_id, a.user_id ,3 as types, c.corever2,
           c.current_language2, c.mt2, c.reg_country, date(c.create_time)  as reg_date,
           c.chl2,DATEDIFF(a.dt,date(c.create_time)) as reg_days,count(a.user_id) as  login_times,
           now() as etl_time
    from dwd.dwd_user_video_cn_login_info a
     -- ----------筛选5月9号到-5月21号期间的星图用户------------------------
          inner join dim.dim_video_cn_accountinfo_view  c
                       on  a.user_id = c.account  and  c.create_time >= '2024-05-09' and  c.create_time<'2024-05-22' and c.appid='tt3f83493ea0be37f901'
 where
    a.dt >= '2024-05-09' and  a.dt<='2024-05-21'
    and    a.state = 1
    group by 1,2,3,4,5,6,7,8,9,10,11
  ) ,

  tps_34 as
  (-- ----------------5月22号后 星图推广和小程序推广的活跃 ----------------------------
select a.dt,6883 as product_id, a.user_id,if(b.types=2,3,4) as types, c.corever2,
           c.current_language2, c.mt2, c.reg_country, date(c.create_time)  as reg_date,
           c.chl2,DATEDIFF(a.dt,date(c.create_time)) as reg_days,count(a.user_id) as  login_times,
           now() as etl_time
    from dwd.dwd_user_video_cn_login_info a
          inner join dim.dim_video_cn_accountinfo_view  c
                       on  a.user_id = c.account
                   inner join
                    -- --------  5月22号之后的 星图推广和小程序推广-------------------
          (select    ref_id,type as types from  dim.dim_ads_role_users_view where  type in ( 2,3) ) b    -- 2:星图推广 3：小程序推广
          on c.middle_man_id =b.ref_id
 where
    a.dt >= '2024-05-22' and a.dt >= '${bf_3_dt}' and a.dt<='${dt}' and c.create_time >='2024-05-22'
    and    a.state = 1
    group by 1,2,3,4,5,6,7,8,9,10,11
    )
,

tps_1 as
(
    -- --------总的活跃 ----------------

    select  a.dt,a.product_id, a.user_id, a.corever2,b.user_id as b_user_id,
           a.current_language2, a.mt2,a.reg_country, a.reg_date,
           a.chl2,a.reg_days,a.login_times,
           now() as etl_time
    from (
  select a.dt,6883 as product_id, a.user_id, c.corever2,
           c.current_language2, c.mt2, c.reg_country, date(c.create_time)  as reg_date,
           c.chl2,DATEDIFF(a.dt,date(c.create_time)) as reg_days,count(a.user_id) as  login_times
    from dwd.dwd_user_video_cn_login_info a
          left  join dim.dim_video_cn_accountinfo_view  c
                       on  a.user_id = c.account
     where
    a.dt >= '${bf_3_dt}' and  a.dt<='${dt}'
    and    a.state = 1
    group by 1,2,3,4,5,6,7,8,9,10
    ) a
    left join
    (
select dt,user_id from  tps_2 group by 1,2  -- 分销的
union all
select dt,user_id from  tps_3 group by 1,2  -- 509-521 期间的星图用户
union all
select dt,user_id from  tps_34 group by 1,2  -- 522开始，星图小程序推广用户
    ) b
    on a.dt=b.dt and a.user_id=b.user_id
  )

      -- 自营
select  dt,product_id,user_id,1 as self_type,corever2 as core,current_language2,mt2,reg_country,
        reg_date,chl2,reg_days,login_times,
        now() as etl_time
from tps_1
where   b_user_id is null  -- 总的 筛选掉未关联到的用户就是自营的

union all
-- 分销
select  dt,product_id,user_id,2 as self_type,corever2 as core,current_language2,mt2,reg_country,
        reg_date,chl2,reg_days,login_times,
        now() as etl_time
from  tps_2
union all
-- --总活跃---
select  dt,product_id,user_id,0 as self_type,corever2 as core,current_language2,mt2,reg_country,
        reg_date,chl2,reg_days,sum(login_times) as login_times,
        now() as etl_time
from tps_1
group by 1,2,3,4,5,6,7,8,9,10,11
union all  -- --星图推广---
select  dt,product_id,user_id,4 as self_type,corever2 as core,current_language2,mt2,reg_country,
        reg_date,chl2,reg_days,login_times,
        now() as etl_time
from tps_3
union all  -- --星图及小程序推广---
select  dt,product_id,user_id,if(types=3,4,5)  as self_type,corever2 as core,current_language2,mt2,reg_country,
        reg_date,chl2,reg_days,login_times,
        now() as etl_time
from tps_34;
