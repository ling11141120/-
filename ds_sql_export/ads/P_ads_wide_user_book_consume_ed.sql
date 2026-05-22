----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_wide_user_book_consume_ed
-- workflow_version : 6
-- create_user      : yanxh
-- task_name        : ads_wide_user_book_consume_ed
-- task_version     : 6
-- update_time      : 2025-05-29 15:59:08
-- sql_path         : \starrocks\tbl_ads_wide_user_book_consume_ed\ads_wide_user_book_consume_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from  ads.ads_wide_user_book_consume_ed where   dt= '${bf_1_dt}';

-- SQL语句
insert into ads.ads_wide_user_book_consume_ed
select a.dt,
       md5(concat_ws('_',a.dt, a.product_id,a.user_id,a.types,a.pay_type,a.site_id,a.book_id,a.Chapter_id,user_type)) as md5_key,
       a.product_id,a.user_id,a.types as tp,a.pay_type,a.site_id,
       a.book_id,a.chapter_id,a.corever,a.mt,a.ver,
       a.current_language,a.current_language2,
       a.reg_date,a.reg_days,a.reg_country,a.appver,a.sex,
       a.is_negative_user,a.ads_type,a.ads_quality,
       CASE WHEN c.`level` is null THEN 2 ELSE c.`level` END as country_level,
       ifnull(b.user_type,-1),b.user_period,b.user_value,b.source,
       sum(con_chp_amount) con_chp_amt,
       sum(con_chp_cnt) con_chp_cnt,
       sum(con_book_cnt) con_book_cnt,
       min(fst_time) fst_tm,
       max(lst_time) lst_tm,
       now() as etl_tm
from  dwm.dwm_consume_user_consume_mild_ed a
          left join
      dws.dws_user_wide_tag_info_ed b
      on a.dt =b.dt and a.product_id =b.product_id and a.user_id=b.user_id  and b.dt>= '${bf_1_dt}' and  b.dt<'${dt}'
          left join
      dim.dim_countrylevel c
      on a.product_id =c.product_id  and a.reg_country =c.short_name
where  a.dt>= '${bf_1_dt}' and  a.dt<'${dt}'
  and a.pay_type !=1103
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27  ;
