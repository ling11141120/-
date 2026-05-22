----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_srsv_ads_koc_attribution_result_data
-- workflow_version : 77
-- create_user      : yanxh
-- task_name        : ads_srsv_ads_koc_attribution_result_data
-- task_version     : 50
-- update_time      : 2025-09-20 13:52:08
-- sql_path         : \starrocks\tbl_ads_srsv_ads_koc_attribution_result_data\ads_srsv_ads_koc_attribution_result_data
----------------------------------------------------------------
-- SQL语句
------===============2024-12-04  兼容同用户一天多归因逻辑 =============================
------===============2024-12-05  订单表改用ods视图 =============================
------===============2024-12-10  20241210开始归因数据改用不匹配书籍逻辑 =============================
------===============2024-12-13  20241214号开始书籍id不能为空 =============================
------===============2025-01-02  20250102号开始书籍id能为空 =============================
------===============2025-02-05 新增new_dev_unt、active_dev_unt字段 =============================
------===============2025-02-05 新增new_koc_amt、active_koc_amt、new_koc_amt_after、active_koc_amt_after字段 =============================
------===============2025-03-06  20250306号订单延迟1小时统计 =============================
------===============2025-03-19  20250319号新增订单号字段 =============================
------===============2025-04-10  20250410号新增14天归因收入 =============================
------===============2025-08-01  新增广告收入 =============================
insert into ads.ads_srsv_ads_koc_attribution_result_data(
     dt
    ,product_id
    ,adid
    ,project_tp
    ,book_id
    ,mt
    ,core
    ,source_chl
    ,chl
    ,current_language
    ,koc_code
    ,dev_unt
    ,new_dev_unt
    ,active_dev_unt
    ,order_num
    ,koc_amt
    ,new_koc_amt
    ,active_koc_amt
    ,koc_amt_after
    ,new_koc_amt_after
    ,active_koc_amt_after
    ,koc_amt_14d
    ,koc_amt_after_14d
    ,ad_amt
    ,etl_tm
)
with attribution_user as(
	select  a.product_id,a.dt,a.ad_id,a.user_id,if(minutes_diff(d.create_time,b.create_time)<1440,1,0) as is_new_user,
	a.begin_time,a.end_time,a.resource_id,a.create_time,
	a.koc_text,c.InstitutionId as institution_id,c.StarId as star_id,a.end_time_14d
	from (
		 select product_id,user_id,dt,ad_id,begin_time,end_time,resource_id,koc_text,create_time,
				case when diff_time=10080 and end_time1<=end_time2 then end_time1
					when diff_time=10080 and end_time1>end_time2 then end_time2
					else end_time end end_time_14d
		 from (
			 select
				product_id,user_id,date(begin_time) as dt,ad_id,begin_time,end_time,resource_id,koc_text,min(create_time) as create_time,minutes_diff(end_time,begin_time) as diff_time,datediff(end_time,begin_time),
				lead(begin_time,1,'2099-01-01 00:00:00') over (partition by product_id,user_id order by begin_time,end_time) as end_time1,date_add(begin_time,interval 14 day) end_time2
					from dwd.dwd_srsv_advertisement_koc_attribution_record_view
					where begin_time>='${bf_30_dt}'
			 group by 1,2,3,4,5,6,7,8
		) a
	) a
	left join (
		select product_id,id as user_id,create_time
		from dim.dim_user_account_info_view
		where dt>'${bf_30_dt}'
	  union all
		select product_id,user_id,create_time
		from dim.dim_short_video_user_accountinfo
		where dt>'${bf_30_dt}'
	) b on a.product_id = b.product_id and a.user_id = b.user_id
	left join ods.ods_tidb_koc_codeinfo c on a.koc_text = c.KocCode
	left join (
		select product_id,user_id,ad_id,date(begin_time) as dt,min(create_time) as create_time
		from dwd.dwd_srsv_advertisement_koc_attribution_record_view
		where begin_time>='${bf_30_dt}'
		group by 1,2,3,4
	) d on a.dt=d.dt and a.product_id = d.product_id and a.user_id = d.user_id and a.ad_id=d.ad_id
),
active_user as (
	select
		a.product_id,a.dt,a.ad_id,
		count(distinct a.user_id) as dev_unt,
		count(distinct if(is_new_user=1,a.user_id,null)) as new_dev_unt,
		count(distinct if(is_new_user=0,a.user_id,null)) as active_dev_unt
	from attribution_user a
	group by 1,2,3
)

------===============2024-12-10  20241210开始归因数据改用不匹配书籍逻辑 =============================
------===============2025-01-02  20250102号开始书籍id能为空 =============================
------===============2025-02-05 新增new_dev_unt、active_dev_unt字段 =============================
------===============2025-04-10  20250410号新增14天归因收入 =============================
select * from (
	select a.dt ,
		  a.product_id,
		  a.ad_id,
		  if(max(a.product_id)=6833,2,1) as project_tp, -- 1:海阅 2：海剧
		  max(a.resource_id) as book_id,
		  max(a.mt) as mt,
		  max(a.core) as core,
		  'koc' as source_chl,
		  max(a.chl) as chl,
		  max(a.current_language) as current_language ,
		  max(a.koc_text) as koc_code,
		  ifnull(max(b.dev_unt),0) as dev_unt,   ---人数按归因创建时间统计
		  ifnull(max(b.new_dev_unt),0) as new_dev_unt,
		  ifnull(max(b.active_dev_unt),0) as active_dev_unt,
		  count(order_id) as order_num,
		  sum(item_count) as koc_amt,
		  sum(new_koc_amt) as new_koc_amt,
		  sum(active_koc_amt) as active_koc_amt,
		  sum(base_amount) as koc_amt_after,
		  sum(new_koc_amt_after) as new_koc_amt_after,
		  sum(active_koc_amt_after) as active_koc_amt_after,
		  sum(item_count_14d) as koc_amt_14d,
		  sum(base_amount_14d) as koc_amt_after_14d,
		  sum(ad_amt) as ad_amt,
		  now() as etl_tm
	from (
		select a.dt,a.product_id,a.ad_id,a.resource_id,a.user_id,a.mt,a.core,a.chl,a.current_language,a.koc_text,a.user_dt,
			case when b.create_time<a.end_time then b.item_count else 0 end as item_count,
			case when b.create_time<a.end_time and a.is_new_user=1 then b.item_count else 0 end as new_koc_amt,
			case when b.create_time<a.end_time and a.is_new_user=0 then b.item_count else 0 end as active_koc_amt,
			case when b.create_time<a.end_time then b.base_amount else 0 end as base_amount,
			case when b.create_time<a.end_time and a.is_new_user=1 then b.base_amount else 0 end as new_koc_amt_after,
			case when b.create_time<a.end_time and a.is_new_user=0 then b.base_amount else 0 end as active_koc_amt_after,
			case when b.create_time<a.end_time_14d then b.item_count else 0 end as item_count_14d,
			case when b.create_time<a.end_time_14d then b.base_amount else 0 end as base_amount_14d,
			case when b.create_time<a.end_time then b.order_id else null end as order_id,
			0 as ad_amt,
			0 as ad_amt_14d
		from (
					select
						b.datestr as dt ,
						a.product_id,
						a.user_id,
						a.resource_id,
						a.begin_time,
						a.end_time,
						a.end_time_14d,
						a.ad_id,
						cast(SUBSTRING_INDEX(SUBSTRING_INDEX(a.ad_id, 'Mt=', -1),'|',1) as int ) as mt,
						cast(SUBSTRING_INDEX(SUBSTRING_INDEX(a.ad_id, 'Chl2=', -1),'|',1) as string ) as chl,
						ifnull(c.languageid,cast(SUBSTRING_INDEX(SUBSTRING_INDEX(a.ad_id, 'CurrentLanguage2=', -1),'|',1) as int )) as current_language,
						cast(SUBSTRING_INDEX(SUBSTRING_INDEX(a.ad_id, 'Core=', -1),'|',1) as int ) as core,
						a.koc_text,
						date(a.create_time) as user_dt,
						a.is_new_user
					from  attribution_user a
					left join dim.dim_date b on b.datestr >='${bf_30_dt}' and b.datestr <= '${dt}'
					left join (
						select 6833 as product_id,series_id as book_id, language as languageid
						from dim.dim_short_video_series_view
					union all
						select product_id,book_id,languageid
						from  dim.dim_shuangwen_book_read_consume_info
					) c on a.product_id = c.product_id and a.resource_id = c.book_id
			) a
			left join
			(
				select
					dt,ProductId as product_id ,UserId as user_id,
					cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(packageid,'|',1), 'Ps_Half_', -1),'Ps_Shop_half_',-1), '_', 1), '_', -1) as int ) as book_id,
					CreateTime as create_time,
					OrderId as order_id,
					sum(ItemCount) item_count,
					sum(BaseAmount)/100 as base_amount
					from dwd.dwd_sr_user_koc_payorder_view
					where dt>='${bf_30_dt}' and dt<='${dt}'
					and CreateTime<date_sub(now(),interval 1 hour)
					--and (PackageId like  '%Ps_Half%' or PackageId like  '%Ps_Shop_half%')
					group by 1 ,2 ,3 ,4 ,5,6
				union all
				-- 海剧的充值订单---
				select
					dt,product_id ,user_id ,
					cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(package_id, 'Ps_Half_', -1), '_', 1), '_', -1) as int ) as book_id,
					create_time ,
					order_id,
					sum(item_count) as item_count ,
					sum(base_amount)/100 as base_amount
				from  dwd.dwd_trade_short_video_payorder_view
				where dt >= '${bf_30_dt}' and dt<='${dt}'
				and create_time<date_sub(now(),interval 1 hour)
				and product_id = 6833
				--and  package_id like  '%Ps_Half%'
				and test_flag = 0
				and status =0 -- 正常订单
				group by 1 ,2 ,3 ,4,5,6
			) b on a.dt=b.dt and if(a.product_id=6833,2,1) = if(b.product_id=6833,2,1)  and a.user_id= b.user_id and b.create_time>=a.begin_time    and b.create_time<a.end_time_14d
			where a.begin_time>='${bf_30_dt}'
			group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22

			union all

		select a.dt,a.product_id,a.ad_id,a.resource_id,a.user_id,a.mt,a.core,a.chl,a.current_language,a.koc_text,a.user_dt,
			0 as item_count,
			0 as new_koc_amt,
			0 as active_koc_amt,
			0 as base_amount,
			0 as new_koc_amt_after,
			0 as active_koc_amt_after,
			0 as item_count_14d,
			0 as base_amount_14d,
			null as order_id,
			case when c.create_tm<a.end_time then c.ad_amt else 0 end as ad_amt,
			case when c.create_tm<a.end_time_14d then c.ad_amt else 0 end as ad_amt_14d
		from (
					select
						b.datestr as dt ,
						a.product_id,
						a.user_id,
						a.resource_id,
						a.begin_time,
						a.end_time,
						a.end_time_14d,
						a.ad_id,
						cast(SUBSTRING_INDEX(SUBSTRING_INDEX(a.ad_id, 'Mt=', -1),'|',1) as int ) as mt,
						cast(SUBSTRING_INDEX(SUBSTRING_INDEX(a.ad_id, 'Chl2=', -1),'|',1) as string ) as chl,
						ifnull(c.languageid,cast(SUBSTRING_INDEX(SUBSTRING_INDEX(a.ad_id, 'CurrentLanguage2=', -1),'|',1) as int )) as current_language,
						cast(SUBSTRING_INDEX(SUBSTRING_INDEX(a.ad_id, 'Core=', -1),'|',1) as int ) as core,
						a.koc_text,
						date(a.create_time) as user_dt,
						a.is_new_user
					from  attribution_user a
					left join dim.dim_date b on b.datestr >='${bf_30_dt}' and b.datestr <= '${dt}'
					left join (
						select 6833 as product_id,series_id as book_id, language as languageid
						from dim.dim_short_video_series_view
					union all
						select product_id,book_id,languageid
						from  dim.dim_shuangwen_book_read_consume_info
					) c on a.product_id = c.product_id and a.resource_id = c.book_id
			) a
			left join (
				select
				  dt,
				  create_tm,
				  product_id,
				  if(product_id =6833,2,1) as product_type,
				  user_id,
				  ad_position_amt as ad_amt
				from dwd.dwd_advertisement_user_position_amt_p_di
				where dt >= '${bf_30_dt}' and dt<='${dt}'  and dt>='2025-08-01'
			) c on a.dt=c.dt and if(a.product_id=6833,2,1) = c.product_type  and a.user_id= c.user_id and c.create_tm>=a.begin_time    and c.create_tm<a.end_time_14d
			where a.begin_time>='${bf_30_dt}'
			group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22
	 ) a
	 left join active_user b on a.dt=b.dt and a.product_id =b.product_id and a.ad_id=b.ad_id
	 group by 1,2,3
) a
where 1=1
and a.dt >= '${bf_3_dt}' and ((a.dt>='2024-12-11' and a.dt<'2024-12-14') or a.dt>='2025-01-02')
and core in (1,15)
;
