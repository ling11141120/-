----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_promotion_activity‌_book_consume_ranking_di
-- workflow_version : 18
-- create_user      : hufengju
-- task_name        : ads_sr_promotion_activity‌_book_consume_ranking_di
-- task_version     : 9
-- update_time      : 2025-08-08 18:21:46
-- sql_path         : \starrocks\tbl_ads_sr_promotion_activity‌_book_consume_ranking_di\ads_sr_promotion_activity‌_book_consume_ranking_di
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.`ads_sr_promotion_activity_book_consume_ranking_di` where dt='${dt}';

-- SQL语句
insert into ads.`ads_sr_promotion_activity_book_consume_ranking_di`
select
  '${dt}' as dt,
  a.site_id,
  a.book_id,
  rn,
  a.languageid as languageid,
  a.amount,
  now() as etl_time
from (
	  select
		right(a.book_id,3) as site_id,a.book_id,a.languageid,a.amount,
		row_number() over(partition by languageid order by a.amount desc ) as rn
	  from
	  (
		  select a.book_id,b.languageid,sum(a.amount) as amount
		  from dwd.dwd_consume_user_consume_explode a
		  left join (select book_id,min(languageid) as languageid from dim.dim_shuangwen_book_read_consume_info where languageid is not null group by 1) b on a.book_id=b.book_id
		   where a.dt>=date(date_sub('${dt}',interval 14 day)) and a.book_id>0
		  group by 1,2
	  ) a
	  inner join ads.`ads_sr_promotion_activity_toufang_book_di` b on a.book_id=b.book_id and b.type=2 and b.dt='${dt}'
) a
where rn<=30
;
