----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_user_first_read_book_est_ed
-- workflow_version : 18
-- create_user      : yanxh
-- task_name        : dws_user_first_read_book_est_ed_1d
-- task_version     : 14
-- update_time      : 2025-11-10 17:56:52
-- sql_path         : \starrocks\tbl_dws_user_first_read_book_est_ed\dws_user_first_read_book_est_ed_1d
----------------------------------------------------------------
-- 前置SQL语句
delete from  dws.dws_user_first_read_book_est_ed where dt='${bf_1_dt}';

-- SQL语句
insert into dws.dws_user_first_read_book_est_ed
 with ins as (
    select product_id,user_id,install_date,source,next_attribute_time,book_id
         from  -- ----------归因表------------------
         (   select product_id,user_id,install_date,next_attribute_time,source,book_id,
                   row_number() over (partition by product_id,user_id,date(install_date) order by (case when source in ('fbs2s','facebook','tt','appleadservice','sem','adwords') then 3  when source = 'officialsite' then 2 else 1 end) desc, install_date) as rn
            from dwd.dwd_user_install_info_ed_est_mid
            where dt>='2023-12-01' and    dt<='${bf_1_dt}' and  product_id not in  (6833,6883,-1)  -- 缩小查询分区范围
            ) a
         where rn = 1
         )

 select a.dt,a.product_id,a.user_id,a.book_id,a.fst_read_tm,a.h12_time,a.h24_time,a.d3_time,a.d7_time,a.d30_time,
        b.mt,if(b.corever=0 or b.corever is null,1,b.corever) as corever,
       case  when  a.dt=date(b.reg_time) then 1  else 2 end as user_tp,
         case  when  a.dt=date(b.reg_time) then 1
               when  a.dt=date(ins.install_date) then 2
               else 3 end as source_user_tp,
  if(a.fst_read_tm >= date_sub(ins.install_date, interval 30 second) and a.fst_read_tm <= ins.next_attribute_time and a.book_id =ins.book_id,ins.source,null) as source ,
  now() as etl_tm
 from -- 西五区首次阅读表---
 dws.dws_user_first_read_book_est_temp a
 left join  -- ------关联账户表--------------------
 ( select id,hours_add(create_time,-13) as reg_time,product_id,mt,corever from  dim.dim_user_account_info_view  ) b
 on a.product_id=b.product_id  and a.user_id =b.id

  left join
  ins
 on  a.product_id =ins.product_id and a.user_id=ins.user_id
  where a.dt='${bf_1_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_user_first_read_book_est_ed
-- workflow_version : 18
-- create_user      : yanxh
-- task_name        : dws_user_first_read_book_est_ed_2d
-- task_version     : 15
-- update_time      : 2025-11-10 18:16:18
-- sql_path         : \starrocks\tbl_dws_user_first_read_book_est_ed\dws_user_first_read_book_est_ed_2d
----------------------------------------------------------------
-- 前置SQL语句
delete from  dws.dws_user_first_read_book_est_ed where dt='${bf_2_dt}';

-- SQL语句
insert into dws.dws_user_first_read_book_est_ed
 with ins as (
    select product_id,user_id,install_date,source,next_attribute_time,book_id
         from  -- ----------归因表------------------
         (   select product_id,user_id,install_date,next_attribute_time,source,book_id,
                   row_number() over (partition by product_id,user_id,date(install_date) order by (case when source in ('fbs2s','facebook','tt','appleadservice','sem','adwords') then 3  when source = 'officialsite' then 2 else 1 end) desc, install_date) as rn
            from dwd.dwd_user_install_info_ed_est_mid
            where dt>='2023-12-01' and    dt<='${bf_2_dt}' and  product_id not in  (6833,6883,-1)  -- 缩小查询分区范围
            ) a
         where rn = 1
         )

 select a.dt,a.product_id,a.user_id,a.book_id,a.fst_read_tm,a.h12_time,a.h24_time,a.d3_time,a.d7_time,a.d30_time,
        b.mt,if(b.corever=0 or b.corever is null,1,b.corever) as corever,
       case  when  a.dt=date(b.reg_time) then 1  else 2 end as user_tp,
         case  when  a.dt=date(b.reg_time) then 1
               when  a.dt=date(ins.install_date) then 2
               else 3 end as source_user_tp,
  if(a.fst_read_tm >= date_sub(ins.install_date, interval 30 second) and a.fst_read_tm <= ins.next_attribute_time and a.book_id =ins.book_id,ins.source,null) as source ,
  now() as etl_tm
 from -- 西五区首次阅读表---
 dws.dws_user_first_read_book_est_temp a
 left join  -- ------关联账户表--------------------
 ( select id,hours_add(create_time,-13) as reg_time,product_id,mt,corever from  dim.dim_user_account_info_view  ) b
 on a.product_id=b.product_id  and a.user_id =b.id

  left join
  ins
 on  a.product_id =ins.product_id and a.user_id=ins.user_id
  where a.dt='${bf_2_dt}';
