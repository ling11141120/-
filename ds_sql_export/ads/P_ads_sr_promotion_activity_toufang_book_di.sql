----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_promotion_activity_toufang‌_book_di
-- workflow_version : 15
-- create_user      : hufengju
-- task_name        : ads_sr_promotion_activity_toufang‌_book_di
-- task_version     : 8
-- update_time      : 2025-08-11 19:15:48
-- sql_path         : \starrocks\tbl_ads_sr_promotion_activity_toufang‌_book_di\ads_sr_promotion_activity_toufang‌_book_di
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.`ads_sr_promotion_activity_toufang_book_di` where dt='${dt}';

-- SQL语句
insert into ads.`ads_sr_promotion_activity_toufang_book_di`
with book_cost as (
  select
	b.book_id,
	if(max(a.max_date)>=date(date_sub('${dt}',interval 7 day)),b.book_id,null) as cost_7day,
	if(max(a.max_date)<date(date_sub('${dt}',interval 7 day)),b.book_id,null) as cost_6month
  from (
    select AdId as ad_id,max(CreateTime) as max_date,sum(CostAmount) as cost_amount
    from ods.ods_tidb_sharpengine_ads_global_FbAdRoiInstallReferrerTimeZone_di a
    where ProductId not in (6833,6883)
    and CreateTime >=date(date_sub('${dt}',interval 1 year))
	and CostAmount>0
    group by 1
  ) a
  left join ads.ads_advertisement_adext_view b on a.ad_id=b.ad_id  and b.product_id  not in (6833,6883)
  group by 1
)
select
	'${dt}' as dt,
	if(cost_7day is not null,1,2) as type,
	book_id,
	now() as etl_time
from book_cost
where cast(book_id as int)>0;
