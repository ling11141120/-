----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_flow_operation_position_click_ed
-- workflow_version : 2
-- create_user      : yanxh
-- task_name        : dws_flow_operation_position_click_ed
-- task_version     : 2
-- update_time      : 2023-12-25 15:01:15
-- sql_path         : \starrocks\tbl_dws_flow_operation_position_click_ed\dws_flow_operation_position_click_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_flow_operation_position_click_ed   where dt>='${bf_3_dt}';

-- SQL语句
insert into   dws.dws_flow_operation_position_click_ed
  select a.dt,a.app_product_id as product_id,a.identity_login_id as user_id,a.app_lang_id as current_language,b.current_language2,
  b.reg_country,if(c.`level` is null ,2,c.`level` ) as country_level,a.app_core_ver as corever,split_part(a.app_channel, "_", 3) as mt ,
  a.page_name,a.page_id,a.element_name,a.element_id,a.element_type,a.activity_id,a.parent_group_id,a.group_id,a.send_id,a.countdown as count_down,
  a.event_strategy_id,a.element_content,a.start_type, count(1) as cnt,now() as etl_tm
 from dwd.dwd_sensors_production_operationpositionclick_view a
 left join
 dim.dim_user_account_info_view b
 on a.identity_login_id =b.id  and a.app_product_id =b.product_id
 left join
 dim.dim_countrylevel c
 on b.product_id =c.product_id  and b.reg_country =c.short_name
 where a.dt>='${bf_3_dt}' and a.dt<'${dt}'
and (identity_login_id is  null or  CAST(identity_login_id AS BIGINT) >0 )
 group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22

 ;
