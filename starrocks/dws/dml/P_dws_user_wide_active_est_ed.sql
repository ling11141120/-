----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_user_wide_active_est_ed
-- workflow_version : 3
-- create_user      : hufengju
-- task_name        : dws_user_wide_active_est_ed
-- task_version     : 3
-- update_time      : 2026-01-12 10:49:39
-- sql_path         : \starrocks\tbl_dws_user_wide_active_est_ed\dws_user_wide_active_est_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_user_wide_active_est_ed where dt>='${bf_1_dt}' and dt<='${dt}';

-- SQL语句
-- ----------------------昨天的脚本---------------------------------
insert into dws.dws_user_wide_active_est_ed
select b.dt,b.Productid as product_id, b.UserId as user_id, acc.corever, acc.mt, acc.ver, acc.current_language as current_language,
       acc.currentlanguage2 as currentlanguage2, acc.reg_country, acc.level,
       acc.appver, acc.create_time, datediff(b.dt,acc.create_time) as reg_days, acc.sex,
	   if(c.user_id is not null ,1,0) as is_pay,
       if(d.user_id is not null ,1,0) as is_pay_current,
	   now() as etl_time
from (
         select dt,Productid, UserId
         from (  -- ---登录 交易 消耗 阅读事件 当作用户活跃主表----------------------
                  select date(date_add(CreateTime,interval -13 hour)) as dt,Productid, UserId from dwd.dwd_user_appstartlog where date(date_add(CreateTime,interval -13 hour)) = '${bf_1_dt}' and UserId !=0    --CreateTime
                  union all
                  select date(date_add(CreateTime,interval -13 hour)) as dt,Productid, UserId from dwd.dwd_trade_user_payorder  where date(date_add(CreateTime,interval -13 hour)) = '${bf_1_dt}' and UserId !=0   --CreateTime
                  union all
                  select date(date_add(createtime,interval -13 hour)) as dt,product_id, user_id from dwd.dwd_consume_user_consume where date(date_add(createtime,interval -13 hour)) = '${bf_1_dt}' and user_id !=0   --createtime
                  union all
                  select date(date_add(create_time,interval -13 hour)) as dt,Product_id, User_Id from dwd.dwd_read_user_chapter_view where date(date_add(create_time,interval -13 hour)) = '${bf_1_dt}' and user_id !=0   --create_time
              ) a
         group by 1,2,3
     ) b
left join (
    select a.product_id,a.id,if(a.corever is null or a.CoreVer=0,1,a.CoreVer) as corever,a.mt,a.ver,a.current_language ,
           case when (a.current_language2  is null or a.current_language2=0)and a.product_id=3311 then 6
                when (a.current_language2  is null or a.current_language2=0)and a.product_id=3322 then 5
                when (a.current_language2  is null or a.current_language2=0)and a.product_id=3333 then 2
                when (a.current_language2  is null or a.current_language2=0)and a.product_id=3366 then 3
                when (a.current_language2  is null or a.current_language2=0)and a.product_id=3371 then 7
                when (a.current_language2  is null or a.current_language2=0)and a.product_id=3388 then 4
                when (a.current_language2  is null or a.current_language2=0)and a.product_id=3501 then 11
                when (a.current_language2  is null or a.current_language2=0)and a.product_id=3511 then 12
                else a.current_language2  end  as currentlanguage2,
           a.reg_country,b.level,a.appver ,hours_sub(a.create_time, 13) as create_time  ,a.sex
    from dim.dim_user_account_info_view a
	     -- --------------获取国家等级---------------------------------
        left join dim.dim_countrylevel b on a.product_id=b.product_id and a.reg_country=b.short_name
    ) acc on b.Productid=acc.product_id and b.UserId=acc.Id
	 left join
 --  历史是否付费----------------------
 (select   ProductId as product_id ,userid as user_id  from dwd.dwd_trade_user_payorder  where  date(date_add(CreateTime,interval -13 hour)) <'${bf_1_dt}'  group by 1,2 ) c
 on b.Productid =c.product_id and b.UserId =c.user_id
  left join
 --  当天是否付费----------------------
 (select   dt,ProductId as product_id ,userid as user_id  from dwd.dwd_trade_user_payorder  where date(date_add(CreateTime,interval -13 hour)) = '${bf_1_dt}'  group by 1,2,3)  d
 on b.dt=d.dt and b.Productid =d.product_id and b.UserId =d.user_id
 ;

-- SQL语句
-- ----------------------当天的脚本---------------------------------
insert into dws.dws_user_wide_active_est_ed
select b.dt,b.Productid as product_id, b.UserId as user_id, acc.corever, acc.mt, acc.ver, acc.current_language as current_language,
       acc.currentlanguage2 as currentlanguage2, acc.reg_country, acc.level,
       acc.appver, acc.create_time, datediff(b.dt,acc.create_time) as reg_days, acc.sex,
	   if(c.user_id is not null ,1,0) as is_pay,
       if(d.user_id is not null ,1,0) as is_pay_current,
	   now() as etl_time
from (
         select dt,Productid, UserId
         from (  -- ---登录 交易 消耗 阅读事件 当作用户活跃主表----------------------
                  select date(date_add(CreateTime,interval -13 hour)) as dt,Productid, UserId from dwd.dwd_user_appstartlog where date(date_add(CreateTime,interval -13 hour)) = '${dt}' and UserId !=0    --CreateTime
                  union all
                  select date(date_add(CreateTime,interval -13 hour)) as dt,Productid, UserId from dwd.dwd_trade_user_payorder  where date(date_add(CreateTime,interval -13 hour)) = '${dt}' and UserId !=0   --CreateTime
                  union all
                  select date(date_add(createtime,interval -13 hour)) as dt,product_id, user_id from dwd.dwd_consume_user_consume where date(date_add(createtime,interval -13 hour)) = '${dt}' and user_id !=0   --createtime
                  union all
                  select date(date_add(create_time,interval -13 hour)) as dt,Product_id, User_Id from dwd.dwd_read_user_chapter_view where date(date_add(create_time,interval -13 hour)) = '${dt}' and user_id !=0   --create_time
              ) a
         group by 1,2,3
     ) b
left join (
    select a.product_id,a.id,if(a.corever is null or a.CoreVer=0,1,a.CoreVer) as corever,a.mt,a.ver,a.current_language ,
           case when (a.current_language2  is null or a.current_language2=0)and a.product_id=3311 then 6
                when (a.current_language2  is null or a.current_language2=0)and a.product_id=3322 then 5
                when (a.current_language2  is null or a.current_language2=0)and a.product_id=3333 then 2
                when (a.current_language2  is null or a.current_language2=0)and a.product_id=3366 then 3
                when (a.current_language2  is null or a.current_language2=0)and a.product_id=3371 then 7
                when (a.current_language2  is null or a.current_language2=0)and a.product_id=3388 then 4
                when (a.current_language2  is null or a.current_language2=0)and a.product_id=3501 then 11
                when (a.current_language2  is null or a.current_language2=0)and a.product_id=3511 then 12
                else a.current_language2  end  as currentlanguage2,
           a.reg_country,b.level,a.appver ,hours_sub(a.create_time, 13) as create_time  ,a.sex
    from dim.dim_user_account_info_view a
	     -- --------------获取国家等级---------------------------------
        left join dim.dim_countrylevel b on a.product_id=b.product_id and a.reg_country=b.short_name
    ) acc on b.Productid=acc.product_id and b.UserId=acc.Id
	 left join
 --  历史是否付费----------------------
 (select   ProductId as product_id ,userid as user_id  from dwd.dwd_trade_user_payorder  where  date(date_add(CreateTime,interval -13 hour)) <'${dt}'  group by 1,2 ) c
 on b.Productid =c.product_id and b.UserId =c.user_id
  left join
 --  当天是否付费----------------------
 (select   dt,ProductId as product_id ,userid as user_id  from dwd.dwd_trade_user_payorder  where date(date_add(CreateTime,interval -13 hour)) = '${dt}'  group by 1,2,3)  d
 on b.dt=d.dt and b.Productid =d.product_id and b.UserId =d.user_id
 ;
