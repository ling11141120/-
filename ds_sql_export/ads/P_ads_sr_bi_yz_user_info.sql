----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_bi_yz_user_info
-- workflow_version : 14
-- create_user      : yanxh
-- task_name        : ads_sr_bi_yz_user_info
-- task_version     : 14
-- update_time      : 2025-07-30 18:36:33
-- sql_path         : \starrocks\tbl_ads_sr_bi_yz_user_info\ads_sr_bi_yz_user_info
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sr_bi_yz_user_info
  with ac_user as (
  select a.dt,a.product_id,a.user_id,a.create_time,a.reg_country,a.chl2,a.unique_cdreader_id,
      row_number()over(partition by a.dt,a.product_id,a.user_id order by b.createtime) as asc_rank ,
      b.createtime as login_tm,c.create_time as watch_time

  from(
  -- 主表数据源 --注册初始渠道值带预装的  chl2 like '%yz%'
 select dt, product_id ,id as user_id,create_time,reg_country,chl2 ,unique_cdreader_id
 from  dim.dim_user_account_info_view
 where  --  create_time >='2024-06-20' -- 20号开始才有这个预装的数据 测试数据
          dt>= date_sub('${bf_1_dt}',interval 29 day)  and
        ( chl2 like '%yz%'or chl2 like '%YZ%')
 )  a
 left join
 ( -- --------启动登录记录当天至未来29天内----------------------
 select  dt,app_product_id as productid,identity_login_id as userid ,event_tm as createtime ,device_id
 from dwd.dwd_sensors_production_appstart_view
 where
 -- dt>='2024-06-20' and
  dt>='${bf_1_dt}'
 -- and dt<=  date_add('2024-06-20',interval 29 day)
 and dt<=  date_add('${bf_1_dt}',interval 29 day)
 ) b
 on a.product_id=b.productid and a.unique_cdreader_id=b.device_id
 -- and b.createtime>=a.create_time           -- 启动时间会存在早于注册时间，启动的时候，用户的user_id还没生成，所以要用设备id匹配
 and b.dt<= date_add(a.dt,interval 29 day) -- 活跃时间在注册时间30天内
     left join (
        select
            min(dt) as dt,user_id, min(create_time) as create_time
        from dwd.dwd_read_user_chapter_view
        where dt >= '${bf_1_dt}' and dt <= date_add('${bf_1_dt}',interval 29 day)
        group by user_id
  ) c on a.user_id = c.user_id and c.dt= a.dt

 )

 select dt,product_id,user_id,create_time,reg_country,chl2,unique_cdreader_id,login_tm,watch_time,now() as etl_tm
 from ac_user
 where asc_rank=2
 and  unique_cdreader_id not in
 (select device_guid  from  ads.ads_sr_bi_yz_user_info group by 1 );
