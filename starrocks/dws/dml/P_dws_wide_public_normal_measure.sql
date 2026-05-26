----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_wide_public_normal_measure
-- workflow_version : 15
-- create_user      : admin
-- task_name        : Dau
-- task_version     : 4
-- update_time      : 2023-10-26 14:20:13
-- sql_path         : \starrocks\tbl_dws_wide_public_normal_measure\Dau
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_wide_public_normal_measure (dt,md5_key,mea_key,dim_info,core,product_id,dim_1,dim_2,dim_3,dim_4,dim_5,dim_6,mea_val,etl_time)
SELECT  dt ,
        md5(CONCAT_WS('-',dt,'Dau',
        if(corever is not null,cast(corever as string),'NON'),
        if(productid is not null,cast(productid as string),'NON'),
        if(currentlanguage is not null,cast(currentlanguage as string),'NON'),
        if(currentlanguage2 is not null,cast(currentlanguage2 as string),'NON'),
        if(appver is not null,cast(appver as string),'NON'),
        if(mt is not null,cast(mt as string),'NON'),
        if(ver is not null,cast(ver as string),'NON'),
		if(regcountry is not null,cast(regcountry as string),'NON')
        )) as md5_key,
        'Dau' as mea_key,
        'core-product_id-current_language-current_language2-appver-mt-ver-reg_country' as dim_info,
        if(corever is not null,cast(corever as string),'NON') as core,
		if(productid is not null,cast(productid as string),'NON') as product_id,
		if(currentlanguage is not null,cast(currentlanguage as string),'NON') as dim_1,
		if(currentlanguage2 is not null,cast(currentlanguage2 as string),'NON') as dim_2,
		if(appver is not null,cast(appver as string),'NON') as dim_3,
		if(mt is not null,cast(mt as string),'NON') as dim_4,
		if(ver is not null,cast(ver as string),'NON') as dim_5,
		if(regcountry is not null,cast(regcountry as string),'NON') as dim_6,
		count(distinct userid  ) as mea_val,
		now() as etl_time
FROM
dws.dws_user_login_ed
where
dt='${bf_1_dt}'
group by 1,2,3,4,5,6,7,8,9,10,11,12
;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_wide_public_normal_measure
-- workflow_version : 15
-- create_user      : admin
-- task_name        : ad_toufang_amt
-- task_version     : 4
-- update_time      : 2023-10-27 14:36:21
-- sql_path         : \starrocks\tbl_dws_wide_public_normal_measure\ad_toufang_amt
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_wide_public_normal_measure where mea_key = 'ad_toufang_amt';

-- SQL语句
insert into dws.dws_wide_public_normal_measure (dt,md5_key,mea_key,dim_info,core,product_id,dim_1,dim_2,dim_3,mea_val,etl_time)
select 	dt,
		md5(CONCAT_WS('-',dt,'ad_toufang_amt',if(corever is not null,cast(corever as string),'NON'),if(product_id is not null,cast(product_id as string) ,'NON'),
		if(type is not null,cast(type as string),'NON'),if(current_language2 is not null,cast(current_language2 as string),'NON'),
		if(mt is not null,cast(mt as string),'NON'))),
		'ad_toufang_amt' as mea_key,
		'core-product_id-type-current_language2-mt' as dim_info,
		if(corever is not null,cast(corever as string),'NON'),
		if(product_id is not null,cast(product_id as string) ,'NON'),
		if(type is not null,cast(type as string),'NON'),
		if(current_language2 is not null,cast(current_language2 as string),'NON'),
		if(mt is not null,cast(mt as string),'NON'),
		spend,
		now() as etl_time
from 	dws.dws_advertisement_toufang_ed ;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_wide_public_normal_measure
-- workflow_version : 15
-- create_user      : admin
-- task_name        : consume_book_amount_cnt
-- task_version     : 4
-- update_time      : 2023-10-27 14:08:38
-- sql_path         : \starrocks\tbl_dws_wide_public_normal_measure\consume_book_amount_cnt
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_wide_public_normal_measure (dt,md5_key,mea_key,dim_info,core,product_id,dim_1,dim_2,dim_3,dim_4,dim_5,dim_6,dim_7,mea_val,etl_time)
SELECT  dt ,
        md5(CONCAT_WS('-',dt,'consume_book_amount_cnt',
        if(corever is not null,cast(corever as string),'NON'),
        if(product_id is not null,cast(product_id as string),'NON'),
        if(book_id is not null,cast(book_id as string),'NON'),
        if(types is not null,cast(types as string),'NON'),
        if(site_id is not null,cast(site_id as string),'NON'),
        if(mt is not null,cast(mt as string),'NON'),
        if(current_language is not null,cast(current_language as string),'NON'),
        if(current_language2 is not null,cast(current_language2 as string),'NON'),
		if(reg_country is not null,cast(reg_country as string),'NON')
         )) as md5_key,
        'consume_book_amount_cnt' as mea_key, -- ----------
        'core-product_id-book_id-types-site_id-mt-current_language-current_language2-reg_country' as dim_info,
        if(corever is not null,cast(corever as string),'NON') as core,
		if(product_id is not null,cast(product_id as string),'NON') as product_id,
		if(book_id is not null,cast(book_id as string),'NON') as dim_1,
		if(types is not null,cast(types as string),'NON') as dim_2,
		if(site_id is not null,cast(site_id as string),'NON') as dim_3,
		if(mt is not null,cast(mt as string),'NON') as dim_4,
		if(current_language is not null,cast(current_language as string),'NON') as dim_5,
		if(current_language2 is not null,cast(current_language2 as string),'NON') as dim_6,
		if(reg_country is not null,cast(reg_country as string),'NON') as dim_7,
		sum(amount) as mea_val,
		now() as etl_time
FROM
dws.dws_consume_user_consume_ed
where
dt='${bf_1_dt}'
group by 1,2,3,4,5,6,7,8,9,10,11,12 ,13
;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_wide_public_normal_measure
-- workflow_version : 15
-- create_user      : admin
-- task_name        : consume_book_chapter_cnt
-- task_version     : 4
-- update_time      : 2023-10-27 14:08:38
-- sql_path         : \starrocks\tbl_dws_wide_public_normal_measure\consume_book_chapter_cnt
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_wide_public_normal_measure (dt,md5_key,mea_key,dim_info,core,product_id,dim_1,dim_2,dim_3,dim_4,dim_5,dim_6,dim_7,mea_val,etl_time)
SELECT  dt ,
        md5(CONCAT_WS('-',dt,'consume_book_chapter_cnt',
        if(corever is not null,cast(corever as string),'NON'),
        if(product_id is not null,cast(product_id as string),'NON'),
        if(book_id is not null,cast(book_id as string),'NON'),
		if(types is not null,cast(types as string),'NON'),
        if(site_id is not null,cast(site_id as string),'NON'),
        if(mt is not null,cast(mt as string),'NON'),
        if(current_language is not null,cast(current_language as string),'NON'),
        if(current_language2 is not null,cast(current_language2 as string),'NON'),
		if(reg_country is not null,cast(reg_country as string),'NON')
         )) as md5_key,
        'consume_book_chapter_cnt' as mea_key, -- ----------
        'core-product_id-book_id-types-site_id-mt-current_language-current_language2-reg_country' as dim_info,
        if(corever is not null,cast(corever as string),'NON') as core,
		if(product_id is not null,cast(product_id as string),'NON') as product_id,
		if(book_id is not null,cast(book_id as string),'NON') as dim_1,
		if(types is not null,cast(types as string),'NON') as dim_2,
		if(site_id is not null,cast(site_id as string),'NON') as dim_3,
		if(mt is not null,cast(mt as string),'NON') as dim_4,
		if(current_language is not null,cast(current_language as string),'NON') as dim_5,
		if(current_language2 is not null,cast(current_language2 as string),'NON') as dim_6,
		if(reg_country is not null,cast(reg_country as string),'NON') as dim_7,
		sum(con_chapter_nums) as mea_val,
		now() as etl_time
FROM
dws.dws_consume_user_consume_ed
where
dt='${bf_1_dt}'
group by 1,2,3,4,5,6,7,8,9,10,11,12 ,13
;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_wide_public_normal_measure
-- workflow_version : 15
-- create_user      : admin
-- task_name        : consume_pay_type_amt
-- task_version     : 4
-- update_time      : 2023-10-26 18:32:56
-- sql_path         : \starrocks\tbl_dws_wide_public_normal_measure\consume_pay_type_amt
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_wide_public_normal_measure (dt,md5_key,mea_key,dim_info,core,product_id,dim_1,dim_2,dim_3,dim_4,dim_5,dim_6,dim_7,dim_8,dim_9,mea_val,etl_time)
select 	dt,
		md5(CONCAT_WS('-',dt,'consume_pay_type_amt',if(corever is not null,cast(corever as string),'NON'),if(product_id is not null,cast(product_id as string) ,'NON'),
		if(types is not null,cast(types as string),'NON'),if(pay_type is not null,cast(pay_type as string),'NON'),
		if(site_id is not null,cast(site_id as string),'NON'),if(mt is not null,cast(mt as string),'NON'),
		if(current_language is not null,cast(current_language as string),'NON'),if(current_language2 is not null,cast(current_language2 as string),'NON'),
		if(reg_country is not null,cast(reg_country as string),'NON'),if(app_id is not null,cast(app_id as string),'NON'),
		if(prod_id is not null,cast(prod_id as string),'NON')
		)),
		'consume_pay_type_amt' as mea_key,
		'core-product_id-types-pay_type-site_id-mt-current_language-current_language2-reg_country-app_id-prod_id' as dim_info,
		if(corever is not null,cast(corever as string),'NON') as core,
		if(product_id is not null,cast(product_id as string),'NON') as product_id,
		if(types is not null,cast(types as string),'NON') as dim_1,
		if(pay_type is not null,cast(pay_type as string),'NON') as dim_2,
		if(site_id is not null,cast(site_id as string),'NON') as dim_3,
		if(mt is not null,cast(mt as string),'NON') as dim_4,
		if(current_language is not null,cast(current_language as string),'NON') as dim_5,
		if(current_language2 is not null,cast(current_language2 as string),'NON') as dim_6,
		if(reg_country is not null,cast(reg_country as string),'NON') as dim_7,
		if(app_id is not null,cast(app_id as string),'NON') as dim_8,
		if(prod_id is not null,cast(prod_id as string),'NON') as dim_9,
		cast(if(sum(con_amount) is not null,cast(sum(con_amount) as string),'NON') as string) as mea_val,
		now() as etl_time
from dws.dws_consume_user_pay_type_detail_consume_ed where dt = '${bf_1_dt}'
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_wide_public_normal_measure
-- workflow_version : 15
-- create_user      : admin
-- task_name        : consume_pay_type_count
-- task_version     : 4
-- update_time      : 2023-10-26 18:32:56
-- sql_path         : \starrocks\tbl_dws_wide_public_normal_measure\consume_pay_type_count
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_wide_public_normal_measure (dt,md5_key,mea_key,dim_info,core,product_id,dim_1,dim_2,dim_3,dim_4,dim_5,dim_6,dim_7,dim_8,dim_9,mea_val,etl_time)
select 	dt,
		md5(CONCAT_WS('-',dt,'consume_pay_type_count',if(corever is not null,cast(corever as string),'NON'),if(product_id is not null,cast(product_id as string) ,'NON'),
		if(types is not null,cast(types as string),'NON'),if(pay_type is not null,cast(pay_type as string),'NON'),
		if(site_id is not null,cast(site_id as string),'NON'),if(mt is not null,cast(mt as string),'NON'),
		if(current_language is not null,cast(current_language as string),'NON'),if(current_language2 is not null,cast(current_language2 as string),'NON'),
		if(reg_country is not null,cast(reg_country as string),'NON'),if(app_id is not null,cast(app_id as string),'NON'),
		if(prod_id is not null,cast(prod_id as string),'NON')
		)),
		'consume_pay_type_count' as mea_key,
		'core-product_id-types-pay_type-site_id-mt-current_language-current_language2-reg_country-app_id-prod_id' as dim_info,
		if(corever is not null,cast(corever as string),'NON') as core,
		if(product_id is not null,cast(product_id as string),'NON') as product_id,
		if(types is not null,cast(types as string),'NON') as dim_1,
		if(pay_type is not null,cast(pay_type as string),'NON') as dim_2,
		if(site_id is not null,cast(site_id as string),'NON') as dim_3,
		if(mt is not null,cast(mt as string),'NON') as dim_4,
		if(current_language is not null,cast(current_language as string),'NON') as dim_5,
		if(current_language2 is not null,cast(current_language2 as string),'NON') as dim_6,
		if(reg_country is not null,cast(reg_country as string),'NON') as dim_7,
		if(app_id is not null,cast(app_id as string),'NON') as dim_8,
		if(prod_id is not null,cast(prod_id as string),'NON') as dim_9,
		cast(if(sum(con_count) is not null,cast(sum(con_count) as string),'NON') as string) as mea_val,
		now() as etl_time
from dws.dws_consume_user_pay_type_detail_consume_ed where dt = '${bf_1_dt}'
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_wide_public_normal_measure
-- workflow_version : 15
-- create_user      : admin
-- task_name        : grant_award_expire_money_amount_cnt
-- task_version     : 3
-- update_time      : 2023-10-19 14:41:10
-- sql_path         : \starrocks\tbl_dws_wide_public_normal_measure\grant_award_expire_money_amount_cnt
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_wide_public_normal_measure (dt,md5_key,mea_key,dim_info,core,product_id,dim_1,dim_2,dim_3,dim_4,dim_5,dim_6,dim_7,mea_val,etl_time)
SELECT  dt ,
        md5(CONCAT_WS('-',dt,'grant_award_expire_money_amount_cnt',
        if(corever is not null,cast(corever as string),'NON'),
        if(product_id is not null,cast(product_id as string),'NON'),
        if(current_language is not null,cast(current_language as string),'NON'),
        if(current_language2 is not null,cast(current_language2 as string),'NON'),
        if(appver is not null,cast(appver as string),'NON'),
        if(mt is not null,cast(mt as string),'NON'),
        if(ver is not null,cast(ver as string),'NON'),
		if(reg_country is not null,cast(reg_country as string),'NON'),
		if(sex is not null,cast(sex as string),'NON')
        )) as md5_key,
        'grant_award_expire_money_amount_cnt' as mea_key, -- -------
        'core-product_id-current_language-current_language2-appver-mt-ver-reg_country-sex' as dim_info,
        if(corever is not null,cast(corever as string),'NON') as core,
		if(product_id is not null,cast(product_id as string),'NON') as product_id,
		if(current_language is not null,cast(current_language as string),'NON') as dim_1,
		if(current_language2 is not null,cast(current_language2 as string),'NON') as dim_2,
		if(appver is not null,cast(appver as string),'NON') as dim_3,
		if(mt is not null,cast(mt as string),'NON') as dim_4,
		if(ver is not null,cast(ver as string),'NON') as dim_5,
		if(reg_country is not null,cast(reg_country as string),'NON') as dim_6,
		if(sex is not null,cast(sex as string),'NON') as dim_7,
		sum(if(gift_type =1 ,amount,0)) as mea_val,
		now() as etl_time
FROM
dws.dws_grant_user_giftlog_ed
where
dt='${bf_1_dt}'
and op_type=2
group by 1,2,3,4,5,6,7,8,9,10,11,12 ,13;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_wide_public_normal_measure
-- workflow_version : 15
-- create_user      : admin
-- task_name        : grant_award_money_amount_cnt
-- task_version     : 3
-- update_time      : 2023-10-19 14:41:10
-- sql_path         : \starrocks\tbl_dws_wide_public_normal_measure\grant_award_money_amount_cnt
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_wide_public_normal_measure (dt,md5_key,mea_key,dim_info,core,product_id,dim_1,dim_2,dim_3,dim_4,dim_5,dim_6,dim_7,mea_val,etl_time)
SELECT  dt ,
        md5(CONCAT_WS('-',dt,'grant_award_money_amount_cnt',
        if(corever is not null,cast(corever as string),'NON'),
        if(product_id is not null,cast(product_id as string),'NON'),
        if(current_language is not null,cast(current_language as string),'NON'),
        if(current_language2 is not null,cast(current_language2 as string),'NON'),
        if(appver is not null,cast(appver as string),'NON'),
        if(mt is not null,cast(mt as string),'NON'),
        if(ver is not null,cast(ver as string),'NON'),
		if(reg_country is not null,cast(reg_country as string),'NON'),
		if(sex is not null,cast(sex as string),'NON')
        )) as md5_key,
        'grant_award_money_amount_cnt' as mea_key, -- -------
        'core-product_id-current_language-current_language2-appver-mt-ver-reg_country-sex' as dim_info,
        if(corever is not null,cast(corever as string),'NON') as core,
		if(product_id is not null,cast(product_id as string),'NON') as product_id,
		if(current_language is not null,cast(current_language as string),'NON') as dim_1,
		if(current_language2 is not null,cast(current_language2 as string),'NON') as dim_2,
		if(appver is not null,cast(appver as string),'NON') as dim_3,
		if(mt is not null,cast(mt as string),'NON') as dim_4,
		if(ver is not null,cast(ver as string),'NON') as dim_5,
		if(reg_country is not null,cast(reg_country as string),'NON') as dim_6,
		if(sex is not null,cast(sex as string),'NON') as dim_7,
		sum(if(gift_type =1 ,amount,0)) as mea_val,
		now() as etl_time
FROM
dws.dws_grant_user_giftlog_ed
where
dt='${bf_1_dt}'
and op_type=1
group by 1,2,3,4,5,6,7,8,9,10,11,12 ,13
;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_wide_public_normal_measure
-- workflow_version : 15
-- create_user      : admin
-- task_name        : grant_gift_expire_money_amount_cnt
-- task_version     : 3
-- update_time      : 2023-10-19 14:41:10
-- sql_path         : \starrocks\tbl_dws_wide_public_normal_measure\grant_gift_expire_money_amount_cnt
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_wide_public_normal_measure (dt,md5_key,mea_key,dim_info,core,product_id,dim_1,dim_2,dim_3,dim_4,dim_5,dim_6,dim_7,mea_val,etl_time)
SELECT  dt ,
        md5(CONCAT_WS('-',dt,'grant_gift_expire_money_amount_cnt',
        if(corever is not null,cast(corever as string),'NON'),
        if(product_id is not null,cast(product_id as string),'NON'),
        if(current_language is not null,cast(current_language as string),'NON'),
        if(current_language2 is not null,cast(current_language2 as string),'NON'),
        if(appver is not null,cast(appver as string),'NON'),
        if(mt is not null,cast(mt as string),'NON'),
        if(ver is not null,cast(ver as string),'NON'),
		if(reg_country is not null,cast(reg_country as string),'NON'),
		if(sex is not null,cast(sex as string),'NON')
        )) as md5_key,
        'grant_gift_expire_money_amount_cnt' as mea_key, -- ------
        'core-product_id-current_language-current_language2-appver-mt-ver-reg_country-sex' as dim_info,
        if(corever is not null,cast(corever as string),'NON') as core,
		if(product_id is not null,cast(product_id as string),'NON') as product_id,
		if(current_language is not null,cast(current_language as string),'NON') as dim_1,
		if(current_language2 is not null,cast(current_language2 as string),'NON') as dim_2,
		if(appver is not null,cast(appver as string),'NON') as dim_3,
		if(mt is not null,cast(mt as string),'NON') as dim_4,
		if(ver is not null,cast(ver as string),'NON') as dim_5,
		if(reg_country is not null,cast(reg_country as string),'NON') as dim_6,
		if(sex is not null,cast(sex as string),'NON') as dim_7,
		sum(if(gift_type =0 ,amount,0)) as mea_val,
		now() as etl_time
FROM
dws.dws_grant_user_giftlog_ed
where
dt='${bf_1_dt}'
and op_type=2
group by 1,2,3,4,5,6,7,8,9,10,11,12 ,13
;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_wide_public_normal_measure
-- workflow_version : 15
-- create_user      : admin
-- task_name        : grant_gift_money_amount_cnt
-- task_version     : 3
-- update_time      : 2023-10-19 14:41:10
-- sql_path         : \starrocks\tbl_dws_wide_public_normal_measure\grant_gift_money_amount_cnt
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_wide_public_normal_measure (dt,md5_key,mea_key,dim_info,core,product_id,dim_1,dim_2,dim_3,dim_4,dim_5,dim_6,dim_7,mea_val,etl_time)
SELECT  dt ,
        md5(CONCAT_WS('-',dt,'grant_gift_money_amount_cnt',
        if(corever is not null,cast(corever as string),'NON'),
        if(product_id is not null,cast(product_id as string),'NON'),
        if(current_language is not null,cast(current_language as string),'NON'),
        if(current_language2 is not null,cast(current_language2 as string),'NON'),
        if(appver is not null,cast(appver as string),'NON'),
        if(mt is not null,cast(mt as string),'NON'),
        if(ver is not null,cast(ver as string),'NON'),
		if(reg_country is not null,cast(reg_country as string),'NON'),
		if(sex is not null,cast(sex as string),'NON')
        )) as md5_key,
        'grant_gift_money_amount_cnt' as mea_key, -- ------
        'core-product_id-current_language-current_language2-appver-mt-ver-reg_country-sex' as dim_info,
        if(corever is not null,cast(corever as string),'NON') as core,
		if(product_id is not null,cast(product_id as string),'NON') as product_id,
		if(current_language is not null,cast(current_language as string),'NON') as dim_1,
		if(current_language2 is not null,cast(current_language2 as string),'NON') as dim_2,
		if(appver is not null,cast(appver as string),'NON') as dim_3,
		if(mt is not null,cast(mt as string),'NON') as dim_4,
		if(ver is not null,cast(ver as string),'NON') as dim_5,
		if(reg_country is not null,cast(reg_country as string),'NON') as dim_6,
		if(sex is not null,cast(sex as string),'NON') as dim_7,
		sum(if(gift_type =0 ,amount,0)) as mea_val,
		now() as etl_time
FROM
dws.dws_grant_user_giftlog_ed
where
dt='${bf_1_dt}'
and op_type=1
group by 1,2,3,4,5,6,7,8,9,10,11,12 ,13
;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_wide_public_normal_measure
-- workflow_version : 15
-- create_user      : admin
-- task_name        : grant_money_amount_cnt
-- task_version     : 3
-- update_time      : 2023-10-19 14:41:10
-- sql_path         : \starrocks\tbl_dws_wide_public_normal_measure\grant_money_amount_cnt
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_wide_public_normal_measure (dt,md5_key,mea_key,dim_info,core,product_id,dim_1,dim_2,dim_3,dim_4,dim_5,dim_6,dim_7,mea_val,etl_time)
SELECT  dt ,
        md5(CONCAT_WS('-',dt,'grant_money_amount_cnt',
        if(corever is not null,cast(corever as string),'NON'),
        if(product_id is not null,cast(product_id as string),'NON'),
        if(current_language is not null,cast(current_language as string),'NON'),
        if(current_language2 is not null,cast(current_language2 as string),'NON'),
        if(appver is not null,cast(appver as string),'NON'),
        if(mt is not null,cast(mt as string),'NON'),
        if(ver is not null,cast(ver as string),'NON'),
		if(reg_country is not null,cast(reg_country as string),'NON'),
		if(sex is not null,cast(sex as string),'NON')
        )) as md5_key,
        'grant_money_amount_cnt' as mea_key, -- ------
        'core-product_id-current_language-current_language2-appver-mt-ver-reg_country-sex' as dim_info,
        if(corever is not null,cast(corever as string),'NON') as core,
		if(product_id is not null,cast(product_id as string),'NON') as product_id,
		if(current_language is not null,cast(current_language as string),'NON') as dim_1,
		if(current_language2 is not null,cast(current_language2 as string),'NON') as dim_2,
		if(appver is not null,cast(appver as string),'NON') as dim_3,
		if(mt is not null,cast(mt as string),'NON') as dim_4,
		if(ver is not null,cast(ver as string),'NON') as dim_5,
		if(reg_country is not null,cast(reg_country as string),'NON') as dim_6,
		if(sex is not null,cast(sex as string),'NON') as dim_7,
		sum(money_amount) as mea_val,
		now() as etl_time
FROM
dws.dws_grant_user_getmoneylog_ed
where
dt='${bf_1_dt}'
group by 1,2,3,4,5,6,7,8,9,10,11,12 ,13
;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_wide_public_normal_measure
-- workflow_version : 15
-- create_user      : admin
-- task_name        : read_book_chapter_cnt
-- task_version     : 4
-- update_time      : 2023-10-26 16:50:25
-- sql_path         : \starrocks\tbl_dws_wide_public_normal_measure\read_book_chapter_cnt
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_wide_public_normal_measure (dt,md5_key,mea_key,dim_info,core,product_id,dim_1,dim_2,dim_3,dim_4,dim_5,dim_6,mea_val,etl_time)
SELECT  dt ,
        md5(CONCAT_WS('-',dt,'read_book_chapter_cnt',
        if(corever is not null,cast(corever as string),'NON'),
        if(product_id is not null,cast(product_id as string),'NON'),
        if(book_id is not null,cast(book_id as string),'NON'),
        if(site_id is not null,cast(site_id as string),'NON'),
        if(mt is not null,cast(mt as string),'NON'),
        if(current_language is not null,cast(current_language as string),'NON'),
        if(current_language2 is not null,cast(current_language2 as string),'NON'),
		if(reg_country is not null,cast(reg_country as string),'NON')
         )) as md5_key,
        'read_book_chapter_cnt' as mea_key, -- ---------  -----------
        'core-product_id-book_id-site_id-mt-current_language-current_language2-reg_country' as dim_info,
        if(corever is not null,cast(corever as string),'NON') as core,
		if(product_id is not null,cast(product_id as string),'NON') as product_id,
		if(book_id is not null,cast(book_id as string),'NON') as dim_1,
		if(site_id is not null,cast(site_id as string),'NON') as dim_2,
		if(mt is not null,cast(mt as string),'NON') as dim_3,
		if(current_language is not null,cast(current_language as string),'NON') as dim_4,
		if(current_language2 is not null,cast(current_language2 as string),'NON') as dim_5,
		if(reg_country is not null,cast(reg_country as string),'NON') as dim_6,
		sum(read_chapter_num) as mea_val,
		now() as etl_time
FROM
dws.dws_read_user_readbook_ed
where
dt='${bf_1_dt}'
group by 1,2,3,4,5,6,7,8,9,10,11,12
;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_wide_public_normal_measure
-- workflow_version : 15
-- create_user      : admin
-- task_name        : read_book_user_cnt
-- task_version     : 4
-- update_time      : 2023-10-26 16:50:25
-- sql_path         : \starrocks\tbl_dws_wide_public_normal_measure\read_book_user_cnt
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_wide_public_normal_measure (dt,md5_key,mea_key,dim_info,core,product_id,dim_1,dim_2,dim_3,dim_4,dim_5,dim_6,mea_val,etl_time)
SELECT  dt ,
        md5(CONCAT_WS('-',dt,'read_book_user_cnt',
        if(corever is not null,cast(corever as string),'NON'),
        if(product_id is not null,cast(product_id as string),'NON'),
        if(book_id is not null,cast(book_id as string),'NON'),
        if(site_id is not null,cast(site_id as string),'NON'),
        if(mt is not null,cast(mt as string),'NON'),
        if(current_language is not null,cast(current_language as string),'NON'),
        if(current_language2 is not null,cast(current_language2 as string),'NON'),
		if(reg_country is not null,cast(reg_country as string),'NON')
         )) as md5_key,
        'read_book_user_cnt' as mea_key, -- ---------  ----------
        'core-product_id-book_id-site_id-mt-current_language-current_language2-reg_country' as dim_info,
        if(corever is not null,cast(corever as string),'NON') as core,
		if(product_id is not null,cast(product_id as string),'NON') as product_id,
		if(book_id is not null,cast(book_id as string),'NON') as dim_1,
		if(site_id is not null,cast(site_id as string),'NON') as dim_2,
		if(mt is not null,cast(mt as string),'NON') as dim_3,
		if(current_language is not null,cast(current_language as string),'NON') as dim_4,
		if(current_language2 is not null,cast(current_language2 as string),'NON') as dim_5,
		if(reg_country is not null,cast(reg_country as string),'NON') as dim_6,
		count(distinct user_id) as mea_val,
		now() as etl_time
FROM
dws.dws_read_user_readbook_ed
where
dt>='${bf_1_dt}'
group by 1,2,3,4,5,6,7,8,9,10,11,12
;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_wide_public_normal_measure
-- workflow_version : 15
-- create_user      : admin
-- task_name        : read_times
-- task_version     : 6
-- update_time      : 2023-12-05 15:51:30
-- sql_path         : \starrocks\tbl_dws_wide_public_normal_measure\read_times
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_wide_public_normal_measure (dt,md5_key,mea_key,dim_info,core,product_id,dim_1,dim_2,dim_3,dim_4,dim_5,mea_val,etl_time)
select 	a.dt,
		md5(CONCAT_WS('-',a.dt,'read_times',if(b.corever is not null,cast(b.corever as string),'NON'),if(a.product_id is not null,cast(a.product_id as string) ,'NON'),
		if(a.site_id is not null,cast(a.site_id as string) ,'NON'),if(b.mt is not null,cast(b.mt as string) ,'NON'),if(b.current_language is not null,cast(b.current_language as string) ,'NON'),
		if(b.current_language2 is not null,cast(b.current_language2 as string) ,'NON'),if(b.app_id is not null,cast(b.app_id as string) ,'NON'))) as md5_key,
		'read_times' as mea_key,
		'core-product_id-site_id-mt-current_language-current_language2-appid' as dim_info,
		if(b.corever is not null,cast(b.corever as string),'NON') as core,
		if(a.product_id is not null,cast(a.product_id as string),'NON') as product_id,
		if(a.site_id is not null,cast(a.site_id as string) ,'NON') as site_id,
		if(b.mt is not null,cast(b.mt as string) ,'NON') as mt,
		if(b.current_language is not null,cast(b.current_language as string) ,'NON') as current_language,
		if(b.current_language2 is not null,cast(b.current_language2 as string) ,'NON') as current_language2,
		if(b.app_id is not null,cast(b.app_id as string) ,'NON') as appid,
		sum(read_times) as read_times,
		now() as etl_time
from
(	select 	dt,product_id,user_id,
			(case 	when  product_id in(3311,3322,3333,3366,3371,3388,3501,3511,3399) and book_id % 1000 = 322 then 322
					when  product_id in(3311,3322,3333,3366,3371,3388,3501,3511,3399) and book_id % 1000 = 375 then 375
					when  product_id in(3311,3322,3333,3366,3371,3388,3501,3511,3399) and book_id % 1000 = 409 then 409
					when  product_id in(3311,3322,3333,3366,3371,3388,3501,3511,3399) and book_id % 1000 = 410 then 410
					when  product_id in(3311,3322,3333,3366,3371,3388,3501,3511,3399) and book_id % 1000 = 418 then 418
					when  product_id in(3311,3322,3333,3366,3371,3388,3501,3511,3399) and book_id % 1000 = 419 then 419
					when  product_id in(3311,3322,3333,3366,3371,3388,3501,3511,3399) and book_id % 1000 = 414 then 414
					when  product_id in(3311,3322,3333,3366,3371,3388,3501,3511,3399) and book_id % 1000 = 433 then 433
					when  product_id in(3311,3322,3333,3366,3371,3388,3501,3511,3399) and book_id % 1000 = 435 then 435
					when  product_id in(3311,3322,3333,3366,3371,3388,3501,3511,3399) and book_id % 1000 = 436 then 436
					when  product_id in(3311,3322,3333,3366,3371,3388,3501,3511,3399) and book_id % 1000 = 445 then 445
					when  product_id in(3311,3322,3333,3366,3371,3388,3501,3511,3399) and book_id % 1000 = 412 then 412
					when  product_id in(3311,3322,3333,3366,3371,3388,3501,3511,3399) and book_id % 1000 = 413 then 413
					when  product_id in(3311,3322,3333,3366,3371,3388,3501,3511,3399) and book_id % 1000 = 415 then 415
					when  product_id in(3311,3322,3333,3366,3371,3388,3501,3511,3399) and book_id % 1000 = 447 then 447
					when  product_id in(3311,3322,3333,3366,3371,3388,3501,3511,3399) and book_id % 1000 = 448 then 448
					when  product_id in (8858) then 885 when product_id in (7757) then 775
					else 	333 end ) as site_id,
			sum(read_times) as read_times
	from dws.dws_read_user_book_readtime_ed
	where dt = '${bf_1_dt}'
	group by 1,2,3,4
)a left join dim.dim_user_account_info_view b on a.product_id = b.product_id and a.user_id = b.id
group by 1,2,3,4,5,6,7,8,9,10,11;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_wide_public_normal_measure
-- workflow_version : 15
-- create_user      : admin
-- task_name        : translate_cost
-- task_version     : 5
-- update_time      : 2023-10-26 14:28:02
-- sql_path         : \starrocks\tbl_dws_wide_public_normal_measure\translate_cost
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_wide_public_normal_measure (dt,md5_key,mea_key,dim_info,dim_1,dim_2,mea_val,etl_time)
select 	s1.dt,
		md5(CONCAT_WS('-',s1.dt,'translate_cost',if(s1.book_id is not null,cast(s1.book_id as string),'NON'),if(s1.cost_types is not null,cast(s1.cost_types as string) ,'NON'))) as md5_key,
		'translate_cost' as mea_key,
		'book_id-cost_types' as dim_info,
		if(s1.book_id is not null,cast(s1.book_id as string),'NON'),
		if(s1.cost_types is not null,cast(s1.cost_types as string),'NON'),
		sum(total_price) as cost_amt,
		now() as etl_time
from(
	SELECT 	dt,book_id,
			1 as cost_types,
			if(currency_type = 1,total_price,total_price*6.5) as total_price
	FROM dwd.dwd_content_translate_remuneration
	where  book_id > 0 and remuneration_type = 1 and st != 3 and dt >= date_sub('${bf_1_dt}',INTERVAL 60 DAY) and dt <= '${bf_1_dt}'
)s1
group by 1,2,3,4,5,6
union all
select 	b.dt,
		md5(CONCAT_WS('-',b.dt,'translate_cost',if(a.book_id is not null,cast(a.book_id as string),'NON'),cast( 2 as string))) as md5_key,
		'translate_cost' as mea_key,
		'book_id-cost_types' as dim_info,
		if(a.book_id is not null,cast(a.book_id as string),'NON'),
		2 as cost_types,
		sum(b.authorsaleactual*a.rate)/100*6.5 as cost_amt,
		now() as etl_time
from dim.dim_shuangwen_book_channel_income_config a
inner join
(
	select 	dt as dt,book_id as book_id,
			sum(case when static_date <='2021-10-19' then (money_sale+award_reward+reward)/6.6/2
				when static_date >'2021-10-19'then (money_sale/6.6 + award_reward+reward)/2
				end) as authorsaleactual
	from dwd.dwd_content_book_daily_sale_view where dt = '${bf_1_dt}'
	group by 1,2
) b
on a.book_id = b.book_id
group by 1,2,3,4,5,6;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_wide_public_normal_measure
-- workflow_version : 15
-- create_user      : admin
-- task_name        : translate_font_length
-- task_version     : 3
-- update_time      : 2023-10-19 14:41:10
-- sql_path         : \starrocks\tbl_dws_wide_public_normal_measure\translate_font_length
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_wide_public_normal_measure (dt,md5_key,mea_key,dim_info,dim_1,dim_2,dim_3,mea_val,etl_time)
select 	dt,
		md5(CONCAT_WS('-',dt,'translate_font_length',if(author_id is not null,cast(author_id as string),'NON'),if(book_id is not null,cast(book_id as string) ,'NON'),if(role_type is not null,cast(role_type  as string),'NON'))) as md5_key,
		'translate_font_length' as mea_key,
		CONCAT_WS('-','author_id','book_id','role_type') as dim_info,
		if(author_id is not null,cast(author_id  as string),'NON') ,
		if(book_id is not null,cast(book_id  as string),'NON'),
		if(book_id is not null,cast(book_id  as string),'NON'),
		sum(font_length) as translate_font_length,now() as etl_time
from dwd.dwd_content_translate_remuneration
where remuneration_type = 1 and book_id > 0 and  dt = '${bf_1_dt}'
group by 1,2,3,4,5,6;
