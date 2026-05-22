----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_read_action_info
-- workflow_version : 8
-- create_user      : yanxh
-- task_name        : ads_report_read_action_info
-- task_version     : 8
-- update_time      : 2024-01-24 14:29:04
-- sql_path         : \starrocks\tbl_ads_report_read_action_info\ads_report_read_action_info
----------------------------------------------------------------
-- SQL语句
delete  from ads.ads_report_read_action_info where dt>='${bf_1_dt}' ;

-- SQL语句
insert into ads.ads_report_read_action_info
with  action_1029 as
          (
              select dt,productid, action, f3, bookid, imei, mt, corever, createtime, regdate, regnum, userid ,f8,current_language2 from
                  (
                      select  dt, productid,action,f3,(case when f3=14 then f5 else f4 end) as bookid,s4 as imei,mt,substring(appid,6,1) as corever,createtime,userid,regdate,regnum,row_number() over(partition by productid ,userid order by createtime) as rank_1, f8,current_language2
                      from (
                               select a.dt,a.product_id as productid, a.action,a.f3,a.f5 ,a.f4 ,a.s4 ,a.mt,a.appid,a.create_time as createtime,a.user_id as userid,a.f8,b.create_time as regdate,datediff(date(a.create_time),date(b.create_time)) as regnum,a.f6,b.current_language2
                               from dwd.dwd_readerlog_commonactionlog_view a
                                        left join
                                    dim.dim_user_account_info_view b
                                    on a.user_id=b.id  and a.product_id=b.product_id
                               where a.dt >=date_sub('${dt}',interval 1 day) and a.dt<'${dt}' and a.product_id in (3311,3322,3333,3366,3371,3388,3501,3511) and a.action in (1029)  and a.f3<>11   and a.user_id >0 and a.f6= 1

                               union all

                               select a.dt,a.product_id as productid, a.action,a.f3,a.f5 ,a.f4 ,a.s4 ,a.mt,a.appid,a.create_time as createtime,b.id as userid,a.f8,b.create_time as regdate,datediff(date(a.create_time),date(b.create_time)) as regnum,a.f6,b.current_language2
                               from dwd.dwd_readerlog_commonactionlog_view a
                                        left join
                                    (
                                        select x.product_id, x.id,x.device_guid,x.create_time,x.current_language2   from  dim.dim_user_account_info_view x
                                                                                                                          inner join
                                                                                                                      (select  product_id,device_guid,min(create_time) createtime from dim.dim_user_account_info_view
                                                                                                                       where create_time>=date_sub('${dt}',interval 1 day) and create_time<'${dt}' group by 1,2 ) y
                                                                                                                      on x.device_guid=y.device_guid and x.create_time =y.createtime and x.product_id=y.product_id
                                        where x.create_time>=date_sub('${dt}',interval 1 day) and x.create_time<'${dt}'
                                    ) b
                                    on a.s4=b.device_guid  and a.product_id=b.product_id
                               where a.dt >=date_sub('${dt}',interval 1 day) and a.dt<'${dt}' and a.product_id in (3311,3322,3333,3366,3371,3388,3501,3511) and a.action in (1029)  and a.f3<>11  and a.f6= 1  and (a.user_id is null or a.user_id='' or a.user_id=0)

                           ) s
                  ) x where  rank_1=1
          ),
      action_1202 as
          (
              select dt, productid,userid,max(f1) as isfirst from
                  (
                      select  product_id as productid,user_id as userid,dt ,f1 from dwd.dwd_readerlog_commonactionlog_view  a
                      where a.dt >=date_sub('${dt}',interval 1 day) and a.dt<'${dt}'  and a.product_id in (3311,3322,3333,3366,3371,3388,3501,3511) and a.action in (1202)  and  a.user_id  >0

                      union all
                      select a.product_id as productid, b.id as userid,dt,a.f1
                      from dwd.dwd_readerlog_commonactionlog_view  a
                               left join
                           (
                               select x.product_id, x.id,x.device_guid,x.create_time,x.current_language2   from  dim.dim_user_account_info_view x
                                                                                                                 inner join
                                                                                                             (select  product_id,device_guid,min(create_time) createtime from dim.dim_user_account_info_view
                                                                                                              where create_time>=date_sub('${dt}',interval 1 day) and create_time<'${dt}' group by 1,2 ) y
                                                                                                             on x.device_guid=y.device_guid and x.create_time =y.createtime and x.product_id=y.product_id
                               where x.create_time>=date_sub('${dt}',interval 1 day) and x.create_time<'${dt}'
                           ) b
                           on a.s4=b.device_guid  and a.product_id=b.product_id
                      where a.dt >=date_sub('${dt}',interval 1 day) and a.dt<'${dt}'  and a.product_id in (3311,3322,3333,3366,3371,3388,3501,3511) and a.action in (1202)  and (a.user_id is null or a.user_id=''or a.user_id=0 )
                  ) a group by 1,2 ,3
          ) ,

      read_info as (
          select  a.product_id,a.userid ,a.bookid,a.createtime from dwd.dwd_read_log_readreportedlog_view   a
          where a.dt >=date_sub('${dt}',interval 1 day)  and a.CreateTime <date_add('${dt}',interval 3 hour) and a.product_id in (3311,3322,3333,3366,3371,3388,3501,3511) and userid >0
          union all
          select   a.product_id, b.id as userid,a.bookid,a.createtime from dwd.dwd_read_log_readreportedlog_view  a
                                                                               inner join dim.dim_user_account_info_view   b
                                                                                          on a.deviceguid=b.device_guid and a.product_id =b.product_id
          where a.dt >=date_sub('${dt}',interval 1 day)  and a.CreateTime<date_add('${dt}',interval 3 hour) and a.product_id in (3311,3322,3333,3366,3371,3388,3501,3511) and (a.userid is null or a.userid='' or a.userid=0)
      )

select a.dt,a.productid as product_id,a.action as actions ,a.userid as user_id,
       a.f3,a.bookid as book_id,a.imei,a.mt,a.corever,a.createtime as create_time,a.regdate as reg_date,
       a.regnum as reg_num,a.first_bookid,a.first_userid,a.counts,a.f8,action_1202.isfirst as is_first,c.last_source  as source_name,now() as etl_time
from (

         select dt,productid,action,userid,f3,bookid,imei,mt,corever,createtime,regdate,regnum,first_bookid,first_userid,counts,f8,Current_Language2 from (
                                                                                                                                                             select   action_1029.dt,action_1029.productid,action_1029.action,action_1029.userid,action_1029.f3,action_1029.bookid,action_1029.imei,action_1029.mt,action_1029.corever,
                                                                                                                                                                      action_1029.createtime,action_1029.regdate,action_1029.regnum,
                                                                                                                                                                      read_info.bookid as first_bookid,
                                                                                                                                                                      read_info.userid as first_userid,
                                                                                                                                                                      0 as counts,
                                                                                                                                                                      action_1029.f8,
                                                                                                                                                                      action_1029.Current_Language2,
                                                                                                                                                                      row_number() over(partition by action_1029.productid,action_1029.userid,action_1029.bookid order by read_info.createtime) as ranks
                                                                                                                                                             from
                                                                                                                                                                 action_1029
                                                                                                                                                                     left join
                                                                                                                                                                 read_info
                                                                                                                                                                 on action_1029.bookid=read_info.bookid and action_1029.userid=read_info.userid and action_1029.createtime<=read_info.createtime and action_1029.productid=read_info.product_id

                                                                                                                                                             where  action_1029.dt>=date_sub('${dt}',interval 1 day)    and  action_1029.dt<'${dt}'  and action_1029.bookid !=0
                                                                                                                                                         ) y   where ranks=1
     ) a
         left join
     action_1202
     on  a.userid =action_1202.userid and a.dt=action_1202.dt and a.productid= action_1202.productid
         left join
     (select product_id,user_id,mt,corever,lang2,last_source from  dws.dws_user_market_channel_info_detail_td where dt='{bf_1_dt}')c
     on a.productid =c.product_id and a.userid=c.user_id and a.mt=c.mt and a.corever=c.corever and a.Current_Language2=c.lang2  and c.product_id in (3311,3322,3333,3366,3371,3388,3501,3511)

;
