----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_alg_book_compile_info
-- workflow_version : 8
-- create_user      : yanxh
-- task_name        : tbl_alg_book_compile_info
-- task_version     : 2
-- update_time      : 2024-06-17 14:10:43
-- sql_path         : \starrocks\tbl_alg_book_compile_info\tbl_alg_book_compile_info
----------------------------------------------------------------
-- SQL语句
insert overwrite alg.alg_book_compile_info partition(p'${pname}')
select
 '${dt}' as dt ,
 a.book_id ,
 a.build_time
, a.public_fontlength
,a.new_cid
,a.site_id2
,a.channel
,a.price_per_thousand
,a.free_chapternum
,con_user_cons
,con_aduser_cons
,con_notaduser_cons
,con_user_cons_a
,con_user_cons_b
,con_user_cons_c
,con_aduser_cons_a
,con_aduser_cons_b
,con_aduser_cons_c
,con_notaduser_cons_a
,con_notaduser_cons_b
,con_notaduser_cons_c
,con_aduser_cons_01
,con_notaduser_cons_01
,con_aduser_cons_07
,con_notaduser_cons_07
,con_aduser_cons_15
,con_notaduser_cons_15
,con_chap_cons_01
,con_chap_cons_07
,con_chap_cons_15
,con_chap_cons
,con_ad_chap_cons_01
,con_ad_chap_cons_07
,con_ad_chap_cons_15
,con_ad_chap_cons
,con_notad_chap_cons_01
,con_notad_chap_cons_07
,con_notad_chap_cons_15
,con_notad_chap_cons
,sum_amount_01
,sum_amount_07
,sum_amount_15
,sum_amount
,sum_amount_ad_01
,sum_amount_ad_07
,sum_amount_ad_15
,sum_amount_ad
,sum_amount_notad_01
,sum_amount_notad_07
,sum_amount_notad_15
,sum_amount_notad
,con_user_charege
,con_user_charege_a
,con_user_charege_b
,con_aduser_charege
,con_notaduser_charege
,con_aduser_charege_a
,con_aduser_charege_b
,con_notaduser_charege_a
,con_notaduser_charege_b
,con_user_charege_a_01
,con_user_charege_b_01
,con_aduser_charege_01
,con_notaduser_charege_01
,con_aduser_charege_a_01
,con_aduser_charege_b_01
,con_notaduser_charege_a_01
,con_notaduser_charege_b_01
,con_user_charege_a_07
,con_user_charege_b_07
,con_aduser_charege_07
,con_notaduser_charege_07
,con_aduser_charege_a_07
,con_aduser_charege_b_07
,con_notaduser_charege_a_07
,con_notaduser_charege_b_07
,con_user_charege_a_15
,con_user_charege_b_15
,con_aduser_charege_15
,con_notaduser_charege_15
,con_aduser_charege_a_15
,con_aduser_charege_b_15
,con_notaduser_charege_a_15
,con_notaduser_charege_b_15
,con_itemcount
,con_itemcount_a
,con_itemcount_b
,con_itemcount_ad
,con_itemcount_notad
,con_itemcount_ad_a
,con_itemcount_ad_b
,con_itemcount_notad_a
,con_itemcount_notad_b
,con_itemcount_a_01
,con_itemcount_b_01
,con_itemcount_ad_01
,con_itemcount_notad_01
,con_itemcount_ad_a_01
,con_itemcount_ad_b_01
,con_itemcount_notad_a_01
,con_itemcount_notad_b_01
,con_itemcount_a_07
,con_itemcount_b_07
,con_itemcount_ad_07
,con_itemcount_notad_07
,con_itemcount_ad_a_07
,con_itemcount_ad_b_07
,con_itemcount_notad_a_07
,con_itemcount_notad_b_07
,con_itemcount_a_15
,con_itemcount_b_15
,con_itemcount_ad_15
,con_itemcount_notad_15
,con_itemcount_ad_a_15
,con_itemcount_ad_b_15
,con_itemcount_notad_a_15
,con_itemcount_notad_b_15
,sum_itemcount
,sum_itemcount_a
,sum_itemcount_b
,sum_itemcount_ad
,sum_itemcount_notad
,sum_itemcount_ad_a
,sum_itemcount_ad_b
,sum_itemcount_notad_a
,sum_itemcount_notad_b
,sum_itemcount_a_01
,sum_itemcount_b_01
,sum_itemcount_ad_01
,sum_itemcount_notad_01
,sum_itemcount_ad_a_01
,sum_itemcount_ad_b_01
,sum_itemcount_notad_a_01
,sum_itemcount_notad_b_01
,sum_itemcount_a_07
,sum_itemcount_b_07
,sum_itemcount_ad_07
,sum_itemcount_notad_07
,sum_itemcount_ad_a_07
,sum_itemcount_ad_b_07
,sum_itemcount_notad_a_07
,sum_itemcount_notad_b_07
,sum_itemcount_a_15
,sum_itemcount_b_15
,sum_itemcount_ad_15
,sum_itemcount_notad_15
,sum_itemcount_ad_a_15
,sum_itemcount_ad_b_15
,sum_itemcount_notad_a_15
,sum_itemcount_notad_b_15
,con_user_read
,con_aduser_read
,con_notaduser_read
,con_user_read_a
,con_user_read_b
,con_user_read_c
,con_aduser_read_a
,con_aduser_read_b
,con_aduser_read_c
,con_notaduser_read_a
,con_notaduser_read_b
,con_notaduser_read_c
,con_aduser_read_01
,con_notaduser_read_01
,con_aduser_read_07
,con_notaduser_read_07
,con_aduser_read_15
,con_notaduser_read_15
,con_read_chap_01
,con_read_chap_07
,con_read_chap_15
,con_read_chap
,con_adread_chap_01
,con_adread_chap_07
,con_adread_chap_15
,con_adread_chap
,con_notadread_chap_01
,con_notadread_chap_07
,con_notadread_chap_15
,con_notadread_chap
,now() as etl_time

from  (select book_id ,build_time
, public_fontlength
,new_cid
,site_id2
,channel
,price_per_thousand
,free_chapternum
 	 from dim.dim_shuangwen_book_read_consume_info  where  product_id <>8858   ) a
left join alg.alg_consume_book_consume_info  b
on a.book_id=b.book_id and b.dt='${bf_1_dt}'
left join alg.alg_trade_book_pay_info  c
on a.book_id=c.book_id and c.dt='${bf_1_dt}'
left join  alg.alg_read_book_info  d
on a.book_id=d.book_id  and d.dt='${bf_1_dt}';
