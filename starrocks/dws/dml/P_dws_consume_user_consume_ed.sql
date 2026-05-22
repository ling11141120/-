----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_consume_user_consume_ed
-- workflow_version : 8
-- create_user      : yanxh
-- task_name        : dws_consume_user_consume_ed
-- task_version     : 8
-- update_time      : 2026-01-04 20:24:55
-- sql_path         : \starrocks\tbl_dws_consume_user_consume_ed\dws_consume_user_consume_ed
----------------------------------------------------------------
-- 前置SQL语句
delete  from  dws.dws_consume_user_consume_ed  where dt>= '${bf_1_dt}' and dt <= '${dt}';

-- SQL语句
insert into dws.dws_consume_user_consume_ed
select	a.dt  ,
	          		a.product_id  ,
              		a.user_id  ,
              		a.book_id  ,
              		a.types  ,
					a.site_id,
					 a.corever ,
					 a.mt,
					 a.ver ,
					 a.current_language,
					 a.current_language2,
					 a.reg_date,
					 a.reg_days,
					 a.reg_country as  regcountry,
					 a.appver,
		             a.sex as sex,
					 a.app_id ,
              		 count(distinct  if(chapter_id ='',null,chapter_id)) as con_chapter_nums,
					round(sum(a.con_chp_amount)) as amount,
					min(fst_time) as fst_tm,
					max(lst_time) as lst_tm,
                    now() as etl_time
                   from dwm.dwm_consume_user_consume_mild_ed  a
					where   a.dt >= '${bf_1_dt}'  and a.dt<='${dt}'  and a.book_id <> 0 and a.pay_type <> 1103
			group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17
			union all
	        select	a.dt  ,
	          		a.product_id  ,
              		a.user_id  ,
              		a.book_id  ,
              		 5 as types  ,
					a.site_id,
					 a.corever ,
					 a.mt,
					 a.ver ,
					 a.current_language,
					 a.current_language2,
					 a.reg_date,
					 a.reg_days,
					 a.reg_country as  regcountry,
					 a.appver,
		             a.sex as sex,
					 a.app_id ,
              		 count(distinct if(chapter_id ='',null,chapter_id)) as con_chapter_nums,
					round(sum(a.con_chp_amount)) as amount,
					min(fst_time) as fst_tm,
					max(lst_time) as lst_tm,
                    now() as etl_time
					from dwm.dwm_consume_user_consume_mild_ed a
					where   a.dt >= '${bf_1_dt}'  and a.dt<='${dt}' and a.book_id <> 0 and a.pay_type <> 1103
			group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17	;

-- SQL语句
commit;
