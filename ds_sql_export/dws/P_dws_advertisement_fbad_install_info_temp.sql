----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : ads_advertisement_fbad_rd_cost_charge_info
-- workflow_version : 10
-- create_user      : yanxh
-- task_name        : dws_advertisement_fbad_install_info_temp
-- task_version     : 3
-- update_time      : 2024-11-26 20:53:59
-- sql_path         : \starrocks\ads_advertisement_fbad_rd_cost_charge_info\dws_advertisement_fbad_install_info_temp
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_advertisement_fbad_install_info_temp where dt >='${bf_7_dt}';

-- SQL语句
insert into dws.dws_advertisement_fbad_install_info_temp
select  date(install_date)  as dt, install_date,user_id,product_id,mt,Core,case when product_id not in (6883,6833) then 1 when product_id=6833 then 2 end as product_tp,ad_id,source,book_id,current_language2,country,now() as etl_tm
from (
select install_date,user_id,product_id,mt,Core,ad_id,source,book_id,current_language2,country
from (
select  hours_add(install_date,-13) as install_date -- 东八区需要转换成西五区
,user_id
,product_id
,mt
,Core
,ad_id
,source
,book_id
,country
,current_language2
,unique_cdreaderid
,is_reinstall
,case when source in ('fbs2s','facebook','tt','appleadservice','sem','adwords') then 3  when source = 'officialsite' then 2 else 1 end source_lev
,case when pre_attribute_source in ('fbs2s','facebook','tt','appleadservice','sem','adwords') then 3  when pre_attribute_source = 'officialsite' then 2 else 1 end pre_source_lev
,case when next_attribute_source in ('fbs2s','facebook','tt','appleadservice','sem','adwords') then 3  when next_attribute_source = 'officialsite' then 2 else 1 end next_source_lev
,pre_attribute_time
,next_attribute_time
,trace_id
,hours_add(c2rtime,-13)  c2rtime
from dwd.dwd_user_install_info_ed_view
where
install_date >=date_add('${bf_7_dt}',interval 13 hour)
-- and install_date < date_add('2024-01-15',interval 13 hour)
and product_id in (3311,3322,3333,3366,3371,3388,3399,3501,3511,6833)
and user_id <>-1  and source !='fixadinfo'
) a1
where
(   source_lev =3 and (pre_source_lev < source_lev  or (pre_source_lev = source_lev and days_diff(install_date,pre_attribute_time) >=1)))
 or (source_lev <3 and (source_lev > pre_source_lev or days_diff(install_date,pre_attribute_time) >=1) and ((next_source_lev > source_lev and days_diff(next_attribute_time,install_date)>=1)
 or next_source_lev <= source_lev))
)a
where source in('fbs2s','facebook');
