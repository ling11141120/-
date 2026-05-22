----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_wide_public_unt_measure
-- workflow_version : 1
-- create_user      : admin
-- task_name        : chapter_consume_unt
-- task_version     : 1
-- update_time      : 2023-09-18 15:15:03
-- sql_path         : \starrocks\tbl_dws_wide_public_unt_measure\chapter_consume_unt
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_wide_public_unt_measure(dt,md5_key,mea_key,dim_info,core,product_id,dim_1,dim_2,dim_3,dim_4,dim_5,dim_6,dim_7,dim_8,dim_9,dim_10,dim_11,dim_12,mea_val,etl_time)
select dt,
       md5(concat_ws('-','chapter_consume_unt',
         if(corever is not null,cast(corever as string),'NON'),
         if(product_id is not null,cast(product_id as string),'NON'),
         if(current_language is not null,cast(current_language as string),'NON'),
	     if(current_language2 is not null,cast(current_language2 as string),'NON'),
	     if(appver is not null,cast(appver as string),'NON'),
	     if(mt is not null,cast(mt as string),'NON'),
	     if(ver is not null,cast(ver as string),'NON'),
	     if(reg_country is not null,cast(reg_country as string),'NON'),
	     if(appver is not null,cast(appver as string),'NON'),
	     if(sex is not null,cast(sex as string),'NON'),
         if(site_id is not null,cast(site_id as string),'NON'),
         if(book_id is not null,cast(book_id as string),'NON'),
         if(chapter_id is not null,cast(chapter_id as string),'NON'),
         if(types is not null,cast(types as string),'NON')
           )) as md5_key,
       'chapter_consume_unt' as mea_key,
       'core-product_id-current_language-current_language2-appver-mt-ver-reg_country-appver-sex-site_id-book_id-chapter_id-types' as dim_info,
       if(corever is not null,cast(corever as string),'NON') as core,
       if(product_id is not null,cast(product_id as string),'NON') product_id,
       if(current_language is not null,cast(current_language as string),'NON') as dim_1,
	   if(current_language2 is not null,cast(current_language2 as string),'NON') as dim_2,
	   if(appver is not null,cast(appver as string),'NON') as dim_3,
	   if(mt is not null,cast(mt as string),'NON') as dim_4,
	   if(ver is not null,cast(ver as string),'NON') as dim_5,
	   if(reg_country is not null,cast(reg_country as string),'NON') as dim_6,
	   if(appver is not null,cast(appver as string),'NON') as dim_7,
	   if(sex is not null,cast(sex as string),'NON') as dim_8,
       if(site_id is not null,cast(site_id as string),'NON') as dim_9,
       if(book_id is not null,cast(book_id as string),'NON') as dim_10,
       if(chapter_id is not null,cast(chapter_id as string),'NON') as dim_11,
       if(types is not null,cast(types as string),'NON') as dim_12,
       bitmap_union(user_id) as mea_val,
       now() as etl_time
from dws.dws_consume_book_chapter_ed
where dt='${bf_1_dt}'
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_wide_public_unt_measure
-- workflow_version : 1
-- create_user      : admin
-- task_name        : wide_dau
-- task_version     : 1
-- update_time      : 2023-09-18 15:15:03
-- sql_path         : \starrocks\tbl_dws_wide_public_unt_measure\wide_dau
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_wide_public_unt_measure(dt,md5_key,mea_key,dim_info,core,product_id,dim_1,dim_2,dim_3,dim_4,dim_5,dim_6,dim_7,dim_8,mea_val,etl_time)
select dt,
       md5(concat_ws('-','wide_dau',
         if(corever is not null,cast(corever as string),'NON'),
         if(product_id is not null,cast(product_id as string),'NON'),
         if(current_language is not null,cast(current_language as string),'NON'),
	     if(current_language2 is not null,cast(current_language2 as string),'NON'),
	     if(appver is not null,cast(appver as string),'NON'),
	     if(mt is not null,cast(mt as string),'NON'),
	     if(ver is not null,cast(ver as string),'NON'),
	     if(reg_country is not null,cast(reg_country as string),'NON'),
	     if(appver is not null,cast(appver as string),'NON'),
	     if(sex is not null,cast(sex as string),'NON')
           )) as md5_key,
       'wide_dau' as mea_key,
       'core-product_id-current_language-current_language2-appver-mt-ver-reg_country-appver-sex' as dim_info,
       if(corever is not null,cast(corever as string),'NON') as core,
       if(product_id is not null,cast(product_id as string),'NON') product_id,
       if(current_language is not null,cast(current_language as string),'NON') as dim_1,
	   if(current_language2 is not null,cast(current_language2 as string),'NON') as dim_2,
	   if(appver is not null,cast(appver as string),'NON') as dim_3,
	   if(mt is not null,cast(mt as string),'NON') as dim_4,
	   if(ver is not null,cast(ver as string),'NON') as dim_5,
	   if(reg_country is not null,cast(reg_country as string),'NON') as dim_6,
	   if(appver is not null,cast(appver as string),'NON') as dim_7,
	   if(sex is not null,cast(sex as string),'NON') as dim_8,
       bitmap_union(to_bitmap(user_id)) as mea_val,
       now() as etl_time
from dws.dws_user_wide_active_ed
where dt='${bf_1_dt}'
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14;
