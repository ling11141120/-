----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_bi_yz_user_info
-- workflow_version : 12
-- create_user      : yanxh
-- task_name        : ads_sv_bi_yz_user_info
-- task_version     : 12
-- update_time      : 2025-07-30 18:34:58
-- sql_path         : \starrocks\tbl_ads_sv_bi_yz_user_info\ads_sv_bi_yz_user_info
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sv_bi_yz_user_info
   with ac_user as (
  select a.dt,a.product_id,a.user_id,a.create_time,a.reg_country,a.chl2,a.unique_cdreader_id as device_guid,
        row_number()over(partition by a.dt,a.product_id,a.unique_cdreader_id order by b.create_time) as asc_rank ,
      b.create_time as login_tm, c.create_time as watch_time
  from(
   -- 主表数据源 --注册初始渠道值带预装的  chl2 like '%yz%'
 select dt, product_id , user_id,create_time,reg_country,chl2,unique_cdreader_id   -- 唯一设备id
 from  dim.dim_short_video_user_accountinfo
 where
   --  create_time >='2024-07-10'   and  -- 7-20号开始才有这个预装的数据
dt>= date_sub('${bf_1_dt}',interval 29 day)  and
 (chl2 like '%yz%' or chl2 like '%YZ%')
  )  a
 left join
 ( -- --------启动登录记录当天至未来29天内----------------------
 select  dt,product_id,identity_login_id as user_id ,event_tm as create_time ,device_id
 from dwd.dwd_sensors_cd_video_appstart_view
 where
  --  dt>='2024-07-10' and
  dt>='${bf_1_dt}'
 -- and dt<=  date_add('2024-06-20',interval 29 day)
 and dt<=  date_add('${bf_1_dt}',interval 29 day)
 ) b
 on a.product_id=b.product_id and a.unique_cdreader_id=b.device_id
 -- and b.create_time>=a.create_time           -- 启动时间大于等于注册时间
 and b.dt<= date_add(a.dt,interval 29 day) -- 活跃时间在注册时间30天内
left join ( -- --------观看记录当天至未来29天内----------------------
        select
            min(dt) as dt,account_id as user_id, min(create_time) as create_time
        from dwd.dwd_video_short_video_epis_history
        where dt >= '${bf_1_dt}' and dt <= date_add('${bf_1_dt}',interval 29 day)
        group by account_id
    ) c on a.user_id = c.user_id
    -- and b.create_time>=a.create_time           -- 启动时间大于等于注册时间
    and c.dt = a.dt -- 活跃时间在注册时间30天内
 )

  select dt,product_id,user_id,create_time,reg_country,chl2,device_guid,login_tm,watch_time,now() as etl_tm
 from ac_user
  where  asc_rank=2
 and  device_guid not in
 (select device_guid  from  ads.ads_sv_bi_yz_user_info group by 1 );
