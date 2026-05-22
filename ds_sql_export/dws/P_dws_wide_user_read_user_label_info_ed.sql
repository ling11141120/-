----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_wide_user_read_user_label_info_ed
-- workflow_version : 10
-- create_user      : yanxh
-- task_name        : dws_wide_user_read_user_label_info_ed
-- task_version     : 4
-- update_time      : 2024-11-30 19:47:21
-- sql_path         : \starrocks\tbl_dws_wide_user_read_user_label_info_ed\dws_wide_user_read_user_label_info_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from  dws.dws_wide_user_read_user_label_info_ed where dt>='${bf_1_dt}' and dt<'${dt}';

-- SQL语句
insert into dws.dws_wide_user_read_user_label_info_ed
with us as (
    -- 活跃用户 和 有发放阅币礼券的未活跃用户------------
    select dt,product_id,user_id,corever,reg_time,1 as us_tps  from dws.dws_user_wide_active_ed
    where dt>='${bf_1_dt}' and dt<'${dt}' and product_id  not in (7777,8888,0) and user_id >0  group by 1,2,3,4,5,6
    union all
    -- ------筛选出每天发放阅币礼券的未在活跃表里的用户---------------------
     select dt,product_id ,user_id ,corever,null as reg_time , 2 as us_tps from
    (
    -- ------发放阅币的用户-------------
     select
         t.dt,t.product_id,t.user_id,u.corever
     from (
         select dt,product_id,user_id   from dwd.dwd_grant_readernovel_getmoneylog_view
         where dt>='${bf_1_dt}' and dt<'${dt}' and product_id  not in (7777,8888,0)   and user_id >0  and  charge_type  not in (5,100)
     ) t
     left join dim.dim_user_all_info u on t.product_id = u.product_id and t.user_id = u.user_id
    group by 1,2,3,4
     union all
    -- ---------发放礼券的用户---------
      select dt,product_id,user_id,coalesce(CAST((substring(appid, 4, 3)) AS INT), -99) AS core from dwd.dwd_grant_user_giftlog
     where dt>='${bf_1_dt}' and dt<'${dt}'  and product_id  not in (7777,8888,0)  and user_id >0   and gift_type =0  group by 1,2,3,4
     ) b
      where concat(product_id,user_id) not in
      (select distinct  concat(product_id,user_id) from dws.dws_user_wide_active_ed  where dt>='${bf_1_dt}' and dt<'${dt}'   and product_id  not in (7777,8888,0)  )
      group by 1,2,3,4,5,6
)
  -- 验证数据
  --     select us_tps,count(distinct concat(product_id,user_id))  from us group by 1 order by 1

  ,
  svip as (
  -- ----------------svip的用户-------------------------------
 select productid as product_id , UserId as user_id  ,max(dt) as dt,max(VipExpireTime) as VipExpireTime  from  dwd.dwd_trade_user_payorder dtup
 where dt>=DATE_SUB('${bf_1_dt}',interval 60 day) and dt<'${dt}'   and testflag=0 and ShopItem  =810  and ItemCount not in (7,20,60)  group by 1,2  order by user_id,dt
 )

,  user_tps as
(
  select us.dt,us.product_id,us.user_id ,us.corever,
        case when us.us_tps=1 and us.dt=date(us.reg_time) then 1 -- 新用户
             when us.us_tps=1 and us.dt=ins.install_date and ins.install_date>date(us.reg_time) then 2 -- rmt 用户
             when us.us_tps=2 then 4 -- 无登录行为用户
                else 3 end as user_tps   -- 老用户
  from us
  left join
  (select dt as install_date,product_id,user_id from dwd.dwd_user_install_info_ed_view  where dt>='${bf_1_dt}' and dt<'${dt}' and   product_id  not in (7777,8888,0) and isdelete !=1  group by 1,2,3) ins
  on us.dt=ins.install_date and us.product_id =ins.product_id and us.user_id =ins.user_id

)
  -- 验证数据 各用户类型加起来是为总数据------------------
 --  select user_tps,count(distinct concat(product_id,user_id))  from  user_tps group by 1
 --  select user_tps,count(1)  from  user_tps group by 1
 -- 数据验证  select user_tps,user_attribute,count(1) ,count(distinct concat(product_id,user_id)) from (  ) x group by 1,2  order by 1 ,2

select user_tps.dt,user_tps.product_id,user_tps.user_id,coalesce(user_tps.corever, -99) as corever,user_tps.user_tps,
        case when  user_tps.dt>=svip.dt and user_tps.dt<=date(VipExpireTime)   then 1
             when   c.is_negative_user  =1 then 2
             else 3 end as  user_attribute,now() as etl_tm
  from user_tps
 left join
 svip
 on  user_tps.product_id =svip.product_id and user_tps.user_id =svip.user_id
  left join
 dim.dim_user_other_info_view  c
 on user_tps.product_id =c.product_id and user_tps.user_id =c.id;
