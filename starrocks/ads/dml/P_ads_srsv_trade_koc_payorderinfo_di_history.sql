----------------------------------------------------------------
-- 程序功能： KOC订单信息-历史
-- 程序名： P_ads_srsv_trade_koc_payorderinfo_di_history
-- 目标表： ads.ads_srsv_trade_koc_payorderinfo_di
-- 负责人： qhr
-- 开发日期： 2025-09-08
----------------------------------------------------------------

--------------调度：KOC充值订单信息清洗------------------
-----------------20241104 新增字段core、current_language-----------------------------------
------===============2024-12-10  20241210开始归因数据改用不匹配书籍逻辑 =============================
------===============2024-12-13  20241214号开始书籍id不能为空 =============================
------===============2025-01-02  20250102号开始书籍id能为空 =============================
------===============2025-03-06  20250306号订单延迟1小时统计 =============================
insert into ads.ads_srsv_trade_koc_payorderinfo_di
select
      c.order_id as ref_order_id,
	  c.status as status,
	  date(c.create_time) as dt ,
      a.KocCode as code  ,
      c.book_id as story_id,
      d.book_name as story_name,
      c.item_count as amount,
	  c.base_amount,
      a.project_type as project_type, -- 1:海阅 2：海剧
      a.institution_user_id as institution_user_id,
      a.star_user_id as star_user_id,
      c.create_time as create_time,
      now() as etl_tm,
	  cast(SUBSTRING_INDEX(SUBSTRING_INDEX(b.ad_id, 'Core=', -1),'|',1) as int ) as core,
	  ifnull(d.languageid,cast(SUBSTRING_INDEX(SUBSTRING_INDEX(b.ad_id, 'CurrentLanguage2=', -1),'|',1) as int )) as current_language
from
(
	-- 海阅的充值订单---
	select ProductId as product_id ,UserId as user_id,OrderId as order_id,0 as status,1 as project_type,
	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(packageid,'|',1), 'Ps_Half_', -1),'Ps_Shop_half_',-1), '_', 1), '_', -1) as int ) as book_id,
	CreateTime as create_time,
	sum(ItemCount)  as item_count,
	sum(BaseAmount)/100 as base_amount
	from dwd.dwd_sr_user_koc_payorder_view
	where dt>='${bf_30_dt}' and dt<='${dt}'
	and CreateTime<date_sub(now(),interval 1 hour)
	and (PackageId like  '%Ps_Half%' or PackageId like  '%Ps_Shop_half%')
	group by 1 ,2 ,3 ,4 ,5,6,7

	union all
	-- 海剧的充值订单---
	select product_id ,user_id ,order_id,status,2 as project_type,
	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(package_id, 'Ps_Half_', -1), '_', 1), '_', -1) as int ) as book_id,
	create_time ,
	sum(item_count) as item_count ,
	sum(base_amount)/100 as base_amount
	from  dwd.dwd_trade_short_video_payorder_view
	where dt >= '${bf_30_dt}' and dt<='${dt}'
	and create_time<date_sub(now(),interval 1 hour)
	and product_id = 6833
	and  package_id like  '%Ps_Half%'
	and test_flag = 0
	and status =0 -- 正常订单
	group by 1 ,2 ,3 ,4 ,5,6,7
) c
inner join  ------订单关联归因表，确认归属koc的订单
dwd.dwd_srsv_advertisement_koc_attribution_record_view b
	on b.product_id=c.product_id and b.user_id= c.user_id and b.resource_id=c.book_id
     and c.create_time>=b.begin_time
     and c.create_time<b.end_time
left join    ----------------关联口令和达人信息表，获取口令和达人等信息
(
	select a.KocCode,a.ProjectType as project_type,c.UserId as institution_user_id,a.DataId,b.userid as star_user_id
	from ods.ods_tidb_koc_codeinfo a
	left join ods.ods_tidb_koc_starinfo b on a.InstitutionId = b.InstitutionId and a.StarId = b.Id
	left join ods.ods_koc_institutioninfo c on a.InstitutionId = c.id
) a
	on a.KocCode = b.koc_text and a.DataId = b.resource_id
left join  ------------关联海阅、海剧维表，获取书名/剧名
(
	select 1 as project_type,book_id,book_name,languageid
	from dim.dim_shuangwen_book_read_consume_info
	group by product_id,book_id,book_name,languageid

	union all
	select 2 as project_type,series_id as book_id,series_name as book_name,language as languageid
	from dim.dim_short_video_series_view
	group by series_id,series_name,language
) d on c.project_type=d.project_type and c.book_id = d.book_id
where date(c.create_time)>='${bf_3_dt}'  and date(c.create_time)<'2024-12-11'

union all
------===============2024-12-10  20241210开始归因数据改用不匹配书籍逻辑 =============================
------===============2025-01-02  20250102号开始书籍id能为空 =============================
select
      c.order_id as ref_order_id,
	  c.status as status,
	  date(c.create_time) as dt ,
      ifnull(b.koc_text,0) as code  ,
      ifnull(c.book_id,0) as story_id,
      d.book_name as story_name,
      c.item_count as amount,
	  c.base_amount,
      a.project_type as project_type, -- 1:海阅 2：海剧
      a.institution_user_id as institution_user_id,
      a.star_user_id as star_user_id,
      c.create_time as create_time,
      now() as etl_tm,
	  cast(SUBSTRING_INDEX(SUBSTRING_INDEX(b.ad_id, 'Core=', -1),'|',1) as int ) as core,
	  ifnull(d.languageid,cast(SUBSTRING_INDEX(SUBSTRING_INDEX(b.ad_id, 'CurrentLanguage2=', -1),'|',1) as int )) as current_language
from
(
	-- 海阅的充值订单---
	select ProductId as product_id ,UserId as user_id,OrderId as order_id,0 as status,1 as project_type,
	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(packageid,'|',1), 'Ps_Half_', -1),'Ps_Shop_half_',-1), '_', 1), '_', -1) as int ) as book_id,
	CreateTime as create_time,
	sum(ItemCount)  as item_count,
	sum(BaseAmount)/100 as base_amount
	from dwd.dwd_sr_user_koc_payorder_view
	where dt>='${bf_30_dt}' and dt<='${dt}'
	and CreateTime<date_sub(now(),interval 1 hour)
	--and (PackageId like  '%Ps_Half%' or PackageId like  '%Ps_Shop_half%')
	group by 1 ,2 ,3 ,4 ,5,6,7

	union all
	-- 海剧的充值订单---
	select product_id ,user_id ,order_id,status,2 as project_type,
	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(package_id, 'Ps_Half_', -1), '_', 1), '_', -1) as int ) as book_id,
	create_time ,
	sum(item_count) as item_count ,
	sum(base_amount)/100 as base_amount
	from  dwd.dwd_trade_short_video_payorder_view
	where dt >= '${bf_30_dt}' and dt<='${dt}'
	and create_time<date_sub(now(),interval 1 hour)
	and product_id = 6833
	--and  package_id like  '%Ps_Half%'
	and test_flag = 0
	and status =0 -- 正常订单
	group by 1 ,2 ,3 ,4 ,5,6,7
) c
inner join  ------订单关联归因表，确认归属koc的订单
dwd.dwd_srsv_advertisement_koc_attribution_record_view b
	on if(b.product_id=6833,2,1) =c.project_type and b.user_id= c.user_id --and b.resource_id=c.book_id
     and c.create_time>=b.begin_time
     and c.create_time<b.end_time
left join    ----------------关联口令和达人信息表，获取口令和达人等信息
(
	select a.KocCode,a.ProjectType as project_type,c.UserId as institution_user_id,a.DataId,b.userid as star_user_id
	from ods.ods_tidb_koc_codeinfo a
	left join ods.ods_tidb_koc_starinfo b on a.InstitutionId = b.InstitutionId and a.StarId = b.Id
	left join ods.ods_koc_institutioninfo c on a.InstitutionId = c.id
) a
	on a.KocCode = b.koc_text and a.DataId = b.resource_id
left join  ------------关联海阅、海剧维表，获取书名/剧名
(
	select 1 as project_type,book_id,book_name,languageid
	from dim.dim_shuangwen_book_read_consume_info
	group by product_id,book_id,book_name,languageid

	union all
	select 2 as project_type,series_id as book_id,series_name as book_name,language as languageid
	from dim.dim_short_video_series_view
	group by series_id,series_name,language
) d on c.project_type=d.project_type and c.book_id = d.book_id
where date(c.create_time)>='${bf_3_dt}'  and ((date(c.create_time)>='2024-12-11'  and date(c.create_time)<'2024-12-14' ) or c.create_time>='2025-01-02')
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

union all
------===============2024-12-13  20241214号开始书籍id不能为空 =============================
select
      c.order_id as ref_order_id,
	  c.status as status,
	  date(c.create_time) as dt ,
      ifnull(b.koc_text,0) as code  ,
      ifnull(c.book_id,0) as story_id,
      d.book_name as story_name,
      c.item_count as amount,
	  c.base_amount,
      a.project_type as project_type, -- 1:海阅 2：海剧
      a.institution_user_id as institution_user_id,
      a.star_user_id as star_user_id,
      c.create_time as create_time,
      now() as etl_tm,
	  cast(SUBSTRING_INDEX(SUBSTRING_INDEX(b.ad_id, 'Core=', -1),'|',1) as int ) as core,
	  ifnull(d.languageid,cast(SUBSTRING_INDEX(SUBSTRING_INDEX(b.ad_id, 'CurrentLanguage2=', -1),'|',1) as int )) as current_language
from
(
	-- 海阅的充值订单---
	select ProductId as product_id ,UserId as user_id,OrderId as order_id,0 as status,1 as project_type,
	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(packageid,'|',1), 'Ps_Half_', -1),'Ps_Shop_half_',-1), '_', 1), '_', -1) as int ) as book_id,
	CreateTime as create_time,
	sum(ItemCount)  as item_count,
	sum(BaseAmount)/100 as base_amount
	from dwd.dwd_sr_user_koc_payorder_view
	where dt>='${bf_30_dt}' and dt<='${dt}'
	and CreateTime<date_sub(now(),interval 1 hour)
	and (PackageId like  '%Ps_Half%' or PackageId like  '%Ps_Shop_half%')
	group by 1 ,2 ,3 ,4 ,5,6,7

	union all
	-- 海剧的充值订单---
	select product_id ,user_id ,order_id,status,2 as project_type,
	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(package_id, 'Ps_Half_', -1), '_', 1), '_', -1) as int ) as book_id,
	create_time ,
	sum(item_count) as item_count ,
	sum(base_amount)/100 as base_amount
	from  dwd.dwd_trade_short_video_payorder_view
	where dt >= '${bf_30_dt}' and dt<='${dt}'
	and create_time<date_sub(now(),interval 1 hour)
	and product_id = 6833
	and  package_id like  '%Ps_Half%'
	and test_flag = 0
	and status =0 -- 正常订单
	group by 1 ,2 ,3 ,4 ,5,6,7
) c
inner join  ------订单关联归因表，确认归属koc的订单
dwd.dwd_srsv_advertisement_koc_attribution_record_view b
	on if(b.product_id=6833,2,1) =c.project_type and b.user_id= c.user_id --and b.resource_id=c.book_id
     and c.create_time>=b.begin_time
     and c.create_time<b.end_time
left join    ----------------关联口令和达人信息表，获取口令和达人等信息
(
	select a.KocCode,a.ProjectType as project_type,c.UserId as institution_user_id,a.DataId,b.userid as star_user_id
	from ods.ods_tidb_koc_codeinfo a
	left join ods.ods_tidb_koc_starinfo b on a.InstitutionId = b.InstitutionId and a.StarId = b.Id
	left join ods.ods_koc_institutioninfo c on a.InstitutionId = c.id
) a
	on a.KocCode = b.koc_text and a.DataId = b.resource_id
left join  ------------关联海阅、海剧维表，获取书名/剧名
(
	select 1 as project_type,book_id,book_name,languageid
	from dim.dim_shuangwen_book_read_consume_info
	group by product_id,book_id,book_name,languageid

	union all
	select 2 as project_type,series_id as book_id,series_name as book_name,language as languageid
	from dim.dim_short_video_series_view
	group by series_id,series_name,language
) d on c.project_type=d.project_type and c.book_id = d.book_id
where date(c.create_time)>='${bf_3_dt}'  and date(c.create_time)>='2024-12-14' and c.book_id>0 and c.create_time<'2025-01-02'
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
;