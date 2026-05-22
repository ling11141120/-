----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_book_url_cost_info_di
-- workflow_version : 4
-- create_user      : hufengju
-- task_name        : ads_sr_book_url_cost_info_di
-- task_version     : 4
-- update_time      : 2025-02-18 14:40:05
-- sql_path         : \starrocks\tbl_ads_sr_book_url_cost_info_di\ads_sr_book_url_cost_info_di
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.`ads_sr_book_url_cost_info_di` where dt>='${bf_1_dt}';

-- SQL语句
insert into ads.`ads_sr_book_url_cost_info_di`
select
	a.est as dt,
	md5(concat(est,product_id,source,pageid,ad_id,file_name,book_id)) as md5_key,
	a.product_id,source,pageid,a.ad_id ,a.file_name as url,book_id,cost_amount,reg_num,view_num,now() as etl_tm
from (
	select a.est,c.product_id,source,pageid,a.ad_id ,a.file_name,book_id,
		reg_num,reg_total,reg_num/reg_total as rega_ratio,  -- 激活及激活占比
		view_num,view_total,view_num/view_total as view_ratio, -- 点击及点击占比
		c.cost_amount as cost_total,
		-- 优先激活后点击 花费*占比
		-- if(reg_total is not null,reg_num/reg_total*cost_amount,view_num/view_total*cost_amount) as cost_amount   -- 优先激活后点击 花费*占比
		case when reg_total is not null then reg_num/reg_total*cost_amount
			when view_total is not null then view_num/view_total*cost_amount
			end as  cost_amount
	from ( -- 分url 激活、点击数
		select est,product_id,source,ad_id ,coalesce(abtest_pageid,pageid) as pageid,file_name,book_id,ifnull(sum(reg_total),0) reg_num,ifnull(sum(view_total),0) view_num
		from ads.ads_sr_read_abtest_pageid_summery_di
		where est>='${bf_1_dt}'
		and product_id<>683
		and book_id>0 and file_name is not null
		group by 1,2,3,4,5,6,7
	) a left join
	(  -- 总adidurl 激活、点击数
		select est,product_id,ad_id ,sum(reg_total) reg_total,sum(view_total) view_total
		from ads.ads_sr_read_abtest_pageid_summery_di
		where est>='${bf_1_dt}'
		group by 1,2,3
	) b  on a.ad_id=b.ad_id and a.product_id=b.product_id and a.est=b.est
	left join
	( -- adid 花费
		select dt,ad_id,left(product_id,3) as product_id1,product_id,sum(cost_amount) as cost_amount
		from ads.ads_advertisement_fbadroiinstallreferrer_view
		where dt>='${bf_1_dt}'
		group by 1,2,3,4
	) c on a.ad_id=c.ad_id and a.est=c.dt and a.product_id=c.product_id1
) a
where a.cost_amount>0
;
