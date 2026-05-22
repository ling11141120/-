----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_flow_operation_oosition_exposure_ed
-- workflow_version : 9
-- create_user      : yanxh
-- task_name        : dws_flow_operation_oosition_exposure_ed
-- task_version     : 8
-- update_time      : 2024-04-24 16:07:38
-- sql_path         : \starrocks\tbl_dws_flow_operation_oosition_exposure_ed\dws_flow_operation_oosition_exposure_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_flow_operation_oosition_exposure_ed where dt>='${bf_3_dt}';

-- SQL语句
insert into   dws.dws_flow_operation_oosition_exposure_ed
  select a.dt,a.app_product_id as product_id,a.identity_login_id as user_id,a.app_lang_id as current_language,
case when  (b.current_language2=0 or b.current_language2 is null or b.current_language2='')  and b.product_id =3311 then 6
  when  (b.current_language2=0 or b.current_language2 is null or b.current_language2='')  and b.product_id =3322 then 5
  when (b.current_language2=0 or b.current_language2 is null or b.current_language2='')  and b.product_id =3333 then 2
  when (b.current_language2=0 or b.current_language2 is null or b.current_language2='')  and b.product_id =3366 then 3
  when (b.current_language2=0 or b.current_language2 is null or b.current_language2='')  and b.product_id =3371 then 7
  when (b.current_language2=0 or b.current_language2 is null or b.current_language2='')  and b.product_id =3388 then 4
  when (b.current_language2=0 or b.current_language2 is null or b.current_language2='')  and b.product_id =3399 then 9
  when (b.current_language2=0 or b.current_language2 is null or b.current_language2='')  and b.product_id =3501 then 11
  when (b.current_language2=0 or b.current_language2 is null or b.current_language2='')  and b.product_id =3511 then 12
  when (b.current_language2=0 or b.current_language2 is null or b.current_language2='')  and b.product_id in (7757,8858) then 1
  else b.current_language2  end as current_language2,  -- 早期注册用户不存在注册语言字段，默认写死对应产品的注册语言（投放语言）
  b.reg_country,
  if(c.`level` is null ,2,c.`level` ) as country_level,
  if(a.app_core_ver is null or a.app_core_ver='',1,a.app_core_ver) as corever,-- 默认core1
 if(a.mt is null or a.mt='',0,a.mt) as  mt ,-- 空的null值归为其他
  a.page_name,a.page_id,a.element_name,a.element_id,a.activity_id,a.parent_group_id,a.group_id,a.send_id,countdown as count_down,
  event_strategy_id,start_type, count(1) as cnt,now() as etl_tm
 from dwd.dwd_sensors_production_operationpositionexposure_view a
 inner join
 dim.dim_user_account_info_view b
 on a.identity_login_id =b.id  and a.app_product_id =b.product_id  -- inner join  关联过滤掉不存在的用户id
 left join
 dim.dim_countrylevel c
 on b.product_id =c.product_id  and b.reg_country =c.short_name
 where a.dt>='${bf_3_dt}' and a.dt<'${dt}'
and (identity_login_id is  null or  CAST(identity_login_id AS BIGINT) >0 )
 group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20;
