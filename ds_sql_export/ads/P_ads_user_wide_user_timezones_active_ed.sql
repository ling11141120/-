----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_user_wide_user_timezones_active_ed
-- workflow_version : 3
-- create_user      : chenmo
-- task_name        : ads_user_wide_user_timezones_active_ed
-- task_version     : 3
-- update_time      : 2025-02-05 16:42:28
-- sql_path         : \starrocks\tbl_ads_user_wide_user_timezones_active_ed\ads_user_wide_user_timezones_active_ed
----------------------------------------------------------------
-- SQL语句
-- ----------------------昨天的脚本---------------------------------
insert into ads.ads_user_wide_user_timezones_active_ed
select date(date_add(b.create_time, interval ifnull(utc_offset_hour, -5) hour)) as dt,
       b.Productid as product_id, b.UserId as user_id,
       date_add(b.create_time, interval ifnull(utc_offset_hour, -5) hour) as create_time,
       ifnull(utc_offset_hour, -5) as utc_offset,
       acc.corever, acc.mt, acc.ver, acc.current_language as current_language,
       acc.currentlanguage2 as currentlanguage2, acc.reg_country, acc.level,
       acc.appver, acc.create_time,
       datediff(date(date_add(b.create_time, interval ifnull(utc_offset_hour, -5) hour)),acc.create_time) as reg_days,
       acc.sex,
	   if(c.user_id is not null ,1,0) as is_pay,
       if(d.user_id is not null ,1,0) as is_pay_current,

	   now() as etl_time
from (
    select CONVERT_TZ(CreateTime, '+08:00', '+00:00') as create_time,Productid, UserId
    from (  -- ---登录 交易 消耗 阅读事件 当作用户活跃主表----------------------
             select CreateTime,Productid, UserId from dwd.dwd_user_appstartlog where dt = '${bf_1_dt}' and UserId !=0
             union all
             select CreateTime,Productid, UserId from dwd.dwd_trade_user_payorder  where dt = '${bf_1_dt}' and UserId !=0
             union all
             select createtime,product_id, user_id from dwd.dwd_consume_user_consume where dt = '${bf_1_dt}' and user_id !=0
             union all
             select create_time,Product_id, User_Id from dwd.dwd_read_user_chapter_view where dt = '${bf_1_dt}' and user_id !=0
    ) a where Productid = 3311 and UserId = 137780734
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
           a.reg_country,b.level,a.appver ,a.create_time ,a.sex,
           ut_coff_set/60/60 as utc_offset_hour
    from dim.dim_user_account_info_view a
	     -- --------------获取国家等级---------------------------------
        left join dim.dim_countrylevel b on a.product_id=b.product_id and a.reg_country=b.short_name
    ) acc on b.Productid=acc.product_id and b.UserId=acc.Id
	 left join
 --  历史是否付费----------------------
 (select   ProductId as product_id ,userid as user_id  from dwd.dwd_trade_user_payorder  where  dt <'${bf_1_dt}'  group by 1,2 ) c
 on b.Productid =c.product_id and b.UserId =c.user_id
  left join
 --  当天是否付费----------------------
 (select   dt,ProductId as product_id ,userid as user_id  from dwd.dwd_trade_user_payorder  where dt = '${bf_1_dt}'  group by 1,2,3)  d
 on b.Productid =d.product_id and b.UserId =d.user_id
 ;

-- SQL语句
-- ----------------------当天的脚本---------------------------------
insert into ads.ads_user_wide_user_timezones_active_ed
select date(date_add(b.create_time, interval ifnull(utc_offset_hour, -5) hour)) as dt,
       b.Productid as product_id, b.UserId as user_id,
       date_add(b.create_time, interval ifnull(utc_offset_hour, -5) hour) as create_time,
       ifnull(utc_offset_hour, -5) as utc_offset,
       acc.corever, acc.mt, acc.ver, acc.current_language as current_language,
       acc.currentlanguage2 as currentlanguage2, acc.reg_country, acc.level,
       acc.appver, acc.create_time,
       datediff(date(date_add(b.create_time, interval ifnull(utc_offset_hour, -5) hour)),acc.create_time) as reg_days,
       acc.sex,
	   if(c.user_id is not null ,1,0) as is_pay,
       if(d.user_id is not null ,1,0) as is_pay_current,

	   now() as etl_time
from (
    select CONVERT_TZ(CreateTime, '+08:00', '+00:00') as create_time,Productid, UserId
    from (  -- ---登录 交易 消耗 阅读事件 当作用户活跃主表----------------------
             select CreateTime,Productid, UserId from dwd.dwd_user_appstartlog where dt = '${dt}' and UserId !=0
             union all
             select CreateTime,Productid, UserId from dwd.dwd_trade_user_payorder  where dt = '${dt}' and UserId !=0
             union all
             select createtime,product_id, user_id from dwd.dwd_consume_user_consume where dt = '${dt}' and user_id !=0
             union all
             select create_time,Product_id, User_Id from dwd.dwd_read_user_chapter_view where dt = '${dt}' and user_id !=0
    ) a
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
           a.reg_country,b.level,a.appver ,a.create_time ,a.sex,
           ut_coff_set/60/60 as utc_offset_hour
    from dim.dim_user_account_info_view a
	     -- --------------获取国家等级---------------------------------
        left join dim.dim_countrylevel b on a.product_id=b.product_id and a.reg_country=b.short_name
    ) acc on b.Productid=acc.product_id and b.UserId=acc.Id
	 left join
 --  历史是否付费----------------------
 (select   ProductId as product_id ,userid as user_id  from dwd.dwd_trade_user_payorder  where  dt <'${dt}'  group by 1,2 ) c
 on b.Productid =c.product_id and b.UserId =c.user_id
  left join
 --  当天是否付费----------------------
 (select   dt,ProductId as product_id ,userid as user_id  from dwd.dwd_trade_user_payorder  where dt = '${dt}'  group by 1,2,3)  d
 on b.Productid =d.product_id and b.UserId =d.user_id
 ;
