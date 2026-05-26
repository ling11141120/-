----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_consume_user_pay_type_detail_consume_ed
-- workflow_version : 3
-- create_user      : zhengtt
-- task_name        : tbl_dws_consume_user_pay_type_detail_consume_ed
-- task_version     : 3
-- update_time      : 2023-10-26 18:28:36
-- sql_path         : \starrocks\tbl_dws_consume_user_pay_type_detail_consume_ed\tbl_dws_consume_user_pay_type_detail_consume_ed
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_consume_user_pay_type_detail_consume_ed
select dt,
       product_id,
       user_id,
       book_id,
       types,
       pay_type ,
       site_id,
         corever,mt,ver ,current_language,current_language2,reg_date,reg_days,reg_country,appver,sex,app_id,0 as prod_id,
       array_join(array_distinct(array_concat(split(array_join(array_agg(if(Chapter_Ids='',null,Chapter_Ids)),','),','))),',') as chapter_ids,
	   round(sum(con_chp_amount)) as con_amount,
	   round(sum(con_book_cnt)) as con_count,
       now() as etl_time
from dwm.dwm_consume_user_consume_mild_ed
where dt='${bf_1_dt}'
      and pay_type <> 1103
group by 1,2,3,4,5,6,7  ,8,9,10,11,12,13,14,15,16,17,18,19
union all
	select 	   dt ,product_id,user_id,book_id,
					types ,pay_type ,
					site_id,
                    corever,mt,ver ,current_language,current_language2,reg_date,reg_days,reg_country,appver,sex,app_id, prod_id,
					array_join(array_distinct(array_concat(split(array_join(array_agg(if(Chapter_Ids='',null,Chapter_Ids)),','),','))),',') as chapter_ids,
					round(con_amount) as con_amount ,
					count(1) as con_count,
                    now() as etl_time
			from
			(
			select 	dt ,product_id,user_id ,book_id ,types,pay_type ,chapter_ids ,con_amount,
			        site_id,
                   corever,mt,ver ,current_language,current_language2,reg_date,reg_days,reg_country,appver,sex,app_id, prod_id
				from
				(	select 	dt ,product_id  ,user_id  ,book_id  ,5 as types,pay_type,
				site_id,
                corever,mt,ver ,current_language,current_language2,reg_date,reg_days,reg_country,appver,sex,app_id,0 as prod_id,
				chapter_ids,
				sum(con_chp_amount) over(partition by dt,product_id,user_id,book_id,pay_type) as con_amount
					from dwm.dwm_consume_user_consume_mild_ed
					where dt = '${bf_1_dt}'
					and  pay_type <> 1103

				)a
				group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21
			)a
			group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,21;
