----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_advertisement_qa_analysis
-- workflow_version : 15
-- create_user      : yanxh
-- task_name        : tbl_ads_report_advertisement_qa_analysis
-- task_version     : 15
-- update_time      : 2025-04-29 15:53:42
-- sql_path         : \starrocks\tbl_ads_report_advertisement_qa_analysis\tbl_ads_report_advertisement_qa_analysis
----------------------------------------------------------------
-- SQL语句
insert into  ads.ads_report_advertisement_qa_analysis
with crash as
         (
-- -------- crash ---------------------

             select date(date_add(x.dt,interval 1 day)) as dt ,x.product_id,x.core,x.crash_1d,x.crash_7d,y.crash_all,y.crash_today
from
    (
    select dt,product_id,core,crash_1d,crash_7d
    from (
    select date(start_time) as dt,product_id,core, crash_rate*100 as  crash_1d ,crash_rate7d_user_weighted*100 as crash_7d,ROW_NUMBER()over(partition by start_time,product_id,core order by VERSION_code desc  ) as ranks
    from dwd.dwd_qadata_gp_app_crash_rate_view
    where start_time>=date_sub('${bf_1_dt}',interval 1 day) and start_time<'${dt}' --  and product_id  in (3366,3388) and core=1
    ) a  where ranks=1
    ) x

    inner join (
    select date(start_time) as dt,product_id,core, crash_rate7d_user_weighted*100 as crash_all ,crash_rate*100 as  crash_today
    from dwd.dwd_qadata_gp_app_crash_rate_view
    where start_time>=date_sub('${bf_1_dt}',interval 1 day)  and start_time<'${dt}' and  VERSION_code=0 --  and product_id in (3366,3388)  and core=1 and
    ) y on x.dt=y.dt and x.product_id=y.product_id and x.core =y.core
    ),

    anr as (
-- -------- anr ---------------------
select  date(date_add(x.dt,interval 1 day)) as dt,x.product_id,x.core,x.anr_1d,x.anr_7d,y.anr_all,y.anr_today
from
    (
    select dt,product_id,core,anr_1d,anr_7d
    from (
    select date(start_time) as dt,product_id,core, anr_rate*100 as  anr_1d ,anr_rate7d_user_weighted*100 as anr_7d,ROW_NUMBER()over(partition by start_time,product_id,core order by VERSION_code desc  ) as ranks
    from dwd.dwd_qadata_gp_app_anr_rate_view
    where start_time>=date_sub('${bf_1_dt}',interval 1 day)  and start_time<'${dt}' --  and product_id  in (3366,3388) and core=1
    ) a  where ranks=1
    ) x
    inner join (
    select date(start_time) as dt,product_id,core,  anr_rate7d_user_weighted*100 as anr_all ,anr_rate*100 as  anr_today
    from dwd.dwd_qadata_gp_app_anr_rate_view
    where start_time>=date_sub('${bf_1_dt}',interval 1 day)  and start_time<'${dt}'  and  VERSION_code=0 -- and product_id in (3366,3388)  and core=1
    ) y on x.dt=y.dt and x.product_id=y.product_id and x.core =y.core

    ),

    device as (
-- --------------device_id------------------------------------

select    dt,product_id,corever,
    max(case when type ='realAdInit' then count_880 end) as  total_memory,
    max(case when type ='realAdInit' then count_not_880 end) as  device_num,
    max(case when type ='loadAd' then num end) as available_memory,
    max(case when type ='loadAd' then device_id end) as available_memory_device_id
from
    ( select dt,product_id,corever,type, count(distinct device_id) device_id,count(1) num,
    COUNT(DISTINCT CASE WHEN model in ( select model from dim.dim_advertisement_model_config_info_view  group by 1  ) THEN device_id END) as count_880,
    COUNT(DISTINCT CASE WHEN model not in ( select model from dim.dim_advertisement_model_config_info_view  group by 1  )
    THEN device_id END) as count_not_880
    from dwd.`dwd_sensors_production_adcontrol_view`
    where dt>='${bf_1_dt}'
     and dt<'${dt}'
     and event = 'AdControl'
     AND (type= 'realAdInit'
            OR (type = 'loadAd' AND rule <> '{"adStatus":0}')
            OR (type = 'loadAd' AND rule <> '{adStatus:0}')
         )
    group by 1,2,3 ,4
    ) a
group by 1,2,3
order by 1,2,3
    ) ,

    device_2 as (
-- --------------device_id------------------------------------

select dt,product_id,corever, count(distinct device_id) total_device_id

from dwd.dwd_hive_sensors_adcontrol_view
where dt>='${bf_1_dt}'
 and dt<'${dt}'
 and event = 'AdControl'
 AND (
      type= 'realAdInit'
     OR (type = 'loadAd' AND rule <> '{"adStatus":0}')
     OR (type = 'loadAd' AND rule <> '{adStatus:0}')
      )
group by 1,2,3
order by 1,2,3
    ) ,

    ads_user as
    (
select dt,product_id,core,count(distinct user_id) ads_user from dwd.dwd_read_readerlog_log_userwatchvideo3log_view
where dt>='${bf_1_dt}' and dt<'${dt}'
group by 1,2,3
    )

-- ------------dau -------------------

select a.dt,a.Product_id,a.corever,a.dau,ads_user.ads_user,
       b.crash_1d,b.crash_7d,b.crash_all,b.crash_today,
       b.anr_1d,b.anr_7d,b.anr_all,b.anr_today,
       device.total_memory,device.device_num,device.available_memory,device.available_memory_device_id,device_2.total_device_id,

       now() as etl_time

from (
         select dt,Productid as Product_id,corever ,count(distinct userid) dau
         from dws.dws_user_login_ed
         where dt>='${bf_1_dt}' and dt<'${dt}'
           and mt=4
           and corever in (1,2)
         group by 1,2,3
     ) a
         left join
     (
         select crash.dt,crash.Product_id,crash.core,
                crash.crash_1d,crash.crash_7d,crash.crash_all,crash.crash_today,
                anr.anr_1d,anr.anr_7d,anr.anr_all,anr.anr_today
         from crash
                  inner join
              anr
              on crash.dt=anr.dt and crash.Product_id=anr.product_id and crash.core=anr.core
     ) b

     on a.dt=b.dt and a.Product_id=b.product_id and a.corever=b.core
         left join
     device
     on a.dt=device.dt and a.Product_id=device.product_id and a.corever=device.corever
         left join
     device_2
     on a.dt=device_2.dt and a.Product_id=device_2.product_id and a.corever=device_2.corever
         left join
     ads_user
     on a.dt=ads_user.dt and a.Product_id=ads_user.product_id and a.corever=ads_user.core;
