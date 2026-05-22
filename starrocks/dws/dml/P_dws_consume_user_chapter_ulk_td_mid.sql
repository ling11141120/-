----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_consume_user_consume_td_mid
-- workflow_version : 13
-- create_user      : yanxh
-- task_name        : tbl_dws_consume_user_chapter_ulk_td_mid
-- task_version     : 6
-- update_time      : 2024-10-16 12:02:29
-- sql_path         : \starrocks\tbl_dws_consume_user_consume_td_mid\tbl_dws_consume_user_chapter_ulk_td_mid
----------------------------------------------------------------
-- SQL语句
insert into  dws.dws_consume_user_chapter_ulk_td_mid
with t3 as (
select  t2.product_id ,
				t2.user_id ,
				t2.book_id ,
				t2.pay_type ,
				t2.chapter_ids ,
				t2.createtime ,
				t2.sup_ulk_sum ,
				t2.total_bat_ulk_money
			from (
				select 	t1.product_id ,
						t1.user_id ,
						t1.book_id ,
						t1.pay_type ,
						t1.chapter_ids ,
						t1.createtime ,
						sum(if(pay_type in (45,46,63),t1.amount,0)) over(partition by product_id,user_id) sup_ulk_sum,
						sum(if(pay_type in (1,18,29,31,62) and types = 1,t1.amount,0)) over (partition by product_id,user_id) total_bat_ulk_money
				from (
	    select  a1.product_id ,
                a1.user_id ,
                a1.book_id ,
				a1.chapter_ids ,
                a1.pay_type ,
                a1.dt ,
                sum(a1.amount) amount ,
                a1.createtime ,
                (length(a1.chapter_ids)-length(replace(a1.chapter_ids,',','')))+1 chapternum,
				 a1.types
        from  dwd.dwd_consume_user_consume_explode a1  where dt='${bf_1_dt}'
        and pay_type in  (1,18,29,31,45,46,63,62,91)  and types in (1,2,3)
        -- and  product_id in (3388)
        -- and user_id%2=1
        group by 1,2,3,4,5,6,8,9,10
				) t1  order by createtime
			)t2 group by 1,2,3,4,5,6,7,8   order by createtime
),
pt as (
    select  t2.product_id ,
                t2.user_id ,
                t2.chapternum start_sup_ulk_chp_cnt,
                t2.amount start_sup_ulk_chp_money ,
                createtime start_sup_ulk_chp_time
    from(
        select  t1.product_id ,
                t1.user_id ,
                t1.chapternum ,
                t1.amount,
                createtime,
                row_number() over(partition by t1.product_id,t1.user_id order by t1.createtime) rn
        from (
                 select  a1.product_id ,
                a1.user_id ,
                a1.book_id ,
				a1.chapter_ids ,
                a1.pay_type ,
                a1.dt ,
                sum(a1.amount) amount ,
                a1.createtime ,
                (length(a1.chapter_ids)-length(replace(a1.chapter_ids,',','')))+1 chapternum
                from     dwd.dwd_consume_user_consume_explode a1  where dt='${bf_1_dt}'  and types in (1,2,3) and pay_type in (45,46,63)
                -- and  product_id in (3388)
               -- and user_id%2=1
                group by 1,2,3,4,5,6,8,9
                ) t1
      ) t2  where rn = 1
),
ph as (
select    product_id,
             user_id,
              case start_bat_ulk_chp_cnt
                  when 10 then '10'
                  when 20 then '20'
                  when 30 then '30'
                  when 40 then '40'
                  when 50 then '50'
                  when 60 then '60'
                  when 70 then '70'
                  when 80 then '80'
                  when 90 then '90'
                  when 100 then '100'  end start_bat_ulk_gear,
        start_bat_ulk_chp_cnt,
		start_bat_ulk_money,
		start_bat_ulk_giftmoney,
        start_bat_ulk_time
from (
    select  t2.product_id ,
            t2.user_id ,
            t2.chapternum start_bat_ulk_chp_cnt,
			if(types = 1,amount,0) start_bat_ulk_money,
			if(types = 2,amount,0) start_bat_ulk_giftmoney,
            createtime start_bat_ulk_time
    from (
        select  t1.product_id ,
                t1.user_id ,
                t1.chapternum ,
				t1.amount ,
				t1.types ,
                createtime,
                row_number() over(partition by t1.product_id,t1.user_id order by t1.createtime,t1.types) rn
        from (
                 select  a1.product_id ,
                a1.user_id ,
                a1.book_id ,
				a1.chapter_ids ,
                a1.pay_type ,
                a1.dt ,
                sum(a1.amount) amount ,
                a1.createtime ,
                (length(a1.chapter_ids)-length(replace(a1.chapter_ids,',','')))+1 chapternum,
				 a1.types
        from  dwd.dwd_consume_user_consume_explode a1  where dt='${bf_1_dt}'
        and pay_type in (1,18,29,31,62)  and types in (1,2,3)
        group by 1,2,3,4,5,6,8,9,10
                ) t1
                ) t2
      where rn = 1) ph1
 )
 select '${bf_1_dt}' as dt,
        IFNULL(y2.product_id_b,y1.product_id) product_id,
		IFNULL(y2.user_id_b,y1.user_id) user_id,
		if(y2.total_bat_ulk_cnt_b > 0,y2.total_bat_ulk_cnt_b,0)+if(y1.total_bat_ulk_cnt > 0,y1.total_bat_ulk_cnt,0) total_bat_ulk_cnt,
		if(y2.total_fix_ulk_cnt_b > 0,y2.total_fix_ulk_cnt_b,0)+if(y1.total_fix_ulk_cnt > 0,y1.total_fix_ulk_cnt,0) total_fix_ulk_cnt,
		if(y2.sup_ulk_cnt_b > 0,y2.sup_ulk_cnt_b,0)+if(y1.sup_ulk_cnt > 0,y1.sup_ulk_cnt,0) sup_ulk_cnt,
		if(y2.sup_ulk_sum_b > 0,y2.sup_ulk_sum_b,0)+if(y1.sup_ulk_sum > 0,y1.sup_ulk_sum,0) sup_ulk_sum,
		if(y2.total_bat_ulk_money_b > 0,y2.total_bat_ulk_money_b,0)+if(y1.total_bat_ulk_money > 0,y1.total_bat_ulk_money,0) total_bat_ulk_money,
		IFNULL(y2.start_sup_ulk_chp_cnt_b,y1.start_sup_ulk_chp_cnt) start_sup_ulk_chp_cnt,
		IFNULL(y2.start_sup_ulk_chp_money_b,y1.start_sup_ulk_chp_money) start_sup_ulk_chp_money,
		IFNULL(y2.start_bat_ulk_gear_b,y1.start_bat_ulk_gear) start_bat_ulk_gear,
		IFNULL(y2.start_bat_ulk_chp_cnt_b,y1.start_bat_ulk_chp_cnt) start_bat_ulk_chp_cnt,
		IFNULL(y2.start_bat_ulk_money_b,y1.start_bat_ulk_money) start_bat_ulk_money,
		IFNULL(y2.start_bat_ulk_giftmoney_b,y1.start_bat_ulk_giftmoney) start_bat_ulk_giftmoney,
        IFNULL(y2.start_bat_ulk_time_b,y1.start_bat_ulk_time) start_bat_ulk_time,
		IFNULL(y2.start_sup_ulk_chp_time_b,y1.start_sup_ulk_chp_time) start_sup_ulk_chp_time,
        now() as etl_time
 from (
 select
        po.product_id,
        po.user_id,
        po.total_bat_ulk_cnt,
        po.total_fix_ulk_cnt,
        po.sup_ulk_cnt,
        po.sup_ulk_sum,
		po.total_bat_ulk_money,
		pt.start_sup_ulk_chp_cnt,
        pt.start_sup_ulk_chp_money,
        ph.start_bat_ulk_gear,
        ph.start_bat_ulk_chp_cnt,
		ph.start_bat_ulk_money,
		ph.start_bat_ulk_giftmoney ,
        ph.start_bat_ulk_time,
		pt.start_sup_ulk_chp_time
 from (  select product_id,
        user_id,
        total_bat_ulk_cnt,
        total_fix_ulk_cnt,
        sup_ulk_cnt,
        sup_ulk_sum,
		total_bat_ulk_money from (
	select 	t3.product_id ,
			t3.user_id ,
			sum(if(pay_type in (1,18,29,31,62),1,0)) over(partition by product_id,user_id) total_bat_ulk_cnt,
			sum(if(pay_type = 91,1,0)) over(partition by product_id,user_id) total_fix_ulk_cnt,
			sum(if(pay_type in (45,46,63),1,0)) over(partition by product_id,user_id) sup_ulk_cnt,
			t3.sup_ulk_sum ,
			t3.total_bat_ulk_money
	from t3 ) t4
group by  1,2,3,4,5,6,7
) po
 left  join  pt
 on po.product_id =pt.product_id and po.user_id =pt.user_id
 left join ph   on po.product_id =ph.product_id and po.user_id =ph.user_id
 ) y1
 full join
 (select    product_id product_id_b,
            user_id user_id_b,
            total_bat_ulk_cnt total_bat_ulk_cnt_b,
            total_fix_ulk_cnt total_fix_ulk_cnt_b,
            sup_ulk_cnt sup_ulk_cnt_b,
            sup_ulk_sum sup_ulk_sum_b,
		    total_bat_ulk_money total_bat_ulk_money_b,
		    start_sup_ulk_chp_cnt start_sup_ulk_chp_cnt_b,
            start_sup_ulk_chp_money start_sup_ulk_chp_money_b,
            start_bat_ulk_gear start_bat_ulk_gear_b,
            start_bat_ulk_chp_cnt start_bat_ulk_chp_cnt_b,
		    start_bat_ulk_money start_bat_ulk_money_b,
		    start_bat_ulk_giftmoney start_bat_ulk_giftmoney_b,
            start_bat_ulk_time start_bat_ulk_time_b,
		    start_sup_ulk_chp_time start_sup_ulk_chp_time_b
 from dws.dws_consume_user_chapter_ulk_td_mid  where  dt='${bf_2_dt}' ) y2
on y1.product_id=y2.product_id_b
and  y1.user_id=y2.user_id_b;
