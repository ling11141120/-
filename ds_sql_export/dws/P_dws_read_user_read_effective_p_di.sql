----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_read_user_read_effective_p_di
-- workflow_version : 4
-- create_user      : yanxh
-- task_name        : dws_read_user_read_effective_p_di
-- task_version     : 4
-- update_time      : 2024-06-12 16:26:49
-- sql_path         : \starrocks\tbl_dws_read_user_read_effective_p_di\dws_read_user_read_effective_p_di
----------------------------------------------------------------
-- 前置SQL语句
delete from   dws.dws_read_user_read_effective_p_di where dt>='${bf_7_dt}'  and dt<'${dt}';

-- SQL语句
insert into dws.dws_read_user_read_effective_p_di
select a.dt,a.product_id,a.user_id,a.book_id,a.chapter_id,a.serial_number,a.corever,b.mt,a.current_language,b.current_language2 ,b.create_time as reg_tm,  b.reg_country,if(c.`level` is null ,2,c.`level` ) as country_level,b.appver,b.sex,
a.send_id,
a.page_turning ,
a.is_first_read_book,a.first_read_source_id,a.first_read_source_name,a.first_read_source_page_id,a.first_read_source_page_name,
a.read_source_id,a.read_source_name,a.read_source_page_id,a.read_source_page_name,
a.read_tps,
sum(a.read_times) as read_times , -- 阅读时长 单位：秒
min(a.event_tm) fst_read_tm, -- 当天是首次阅读时间
max(a.event_tm) lst_read_tm, -- 当天末次阅读时间
now()  as etl_tm
from
(
-- 开始阅读章节数据---------------------------
select dt,app_product_id as product_id,login_id as user_id,app_lang_id as current_language,app_core_ver as corever,
send_id,
book_id,chapter_id,read_chapter_sort as serial_number,page_turning ,
is_first_read_book,first_read_source_id,first_read_source_name,first_read_source_page_id,first_read_source_page_name,
read_source_id,read_source_name,read_source_page_id,read_source_page_name,0 as read_times,event_tm,1 as read_tps -- 阅读类型 1:开始阅读章节数据
from
 dwd.dwd_sensors_production_startreadingchapter_view
 where dt>='${bf_7_dt}' and dt<'${dt}'  and login_id is not null  and     cast(login_id as bigint) >0
 union all
 -- 结束阅读章节数据---------------------------
 select dt,app_product_id as product_id,login_id as user_id,app_lang_id as current_language,app_core_ver as corever,
send_id,
book_id,chapter_id,read_chapter_sort as serial_number,page_turning ,
null as is_first_read_book,null as first_read_source_id,null as first_read_source_name,null as first_read_source_page_id,null as first_read_source_page_name,
null as read_source_id, null as read_source_name,null as read_source_page_id, null as read_source_page_name,
reading_duration as read_times,event_tm,2 as read_tps -- 阅读类型 2:结束阅读章节数据
 from
 dwd.dwd_sensors_production_endreadingchapter_view
 where  dt>='${bf_7_dt}'  and dt<'${dt}'   and login_id is not null  and     cast(login_id as bigint) >0
) a
left join
dim.dim_user_account_info_view b
on a.product_id=b.product_id  and a.user_id =b.id
 left join
 dim.dim_countrylevel c
 on b.product_id =c.product_id  and b.reg_country =c.short_name
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27;
