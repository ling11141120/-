----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_advertisement_admob_income_ed
-- workflow_version : 7
-- create_user      : yanxh
-- task_name        : dws_advertisement_admob_income_ed
-- task_version     : 6
-- update_time      : 2024-10-16 15:47:52
-- sql_path         : \starrocks\tbl_dws_advertisement_admob_income_ed\dws_advertisement_admob_income_ed
----------------------------------------------------------------
-- SQL语句
delete from  dws.dws_advertisement_admob_income_ed  where dt>=   '${bf_4_dt}';

-- SQL语句
insert into  dws.dws_advertisement_admob_income_ed

select         a.dt, a.product_id,a.account,a.ads_nmae,a.ad_unit,a.mt,case when a.core in (0,1) then 1 else a.core end as corever ,
                a.time_types,
      		     sum(a.ad_requests) ad_requests,
             sum(a.matched_requests) matched_requests,
             sum(a.impressions) impressions,
             sum(a.clicks) clicks,
             sum(a.ad_amount)  as ad_amount,
             now() as etl_time,
              a.appver
from (
select  a.dt, c.product_id,a.account,a.name as ads_nmae,a.ad_unit,c.mt,c.core,a.appver,
             a.time_types,
		     sum(a.ad_requests) ad_requests,
             sum(a.matched_requests) matched_requests,
             sum(a.impressions) impressions,
             sum(a.clicks) clicks,
             sum(a.ad_amount)  as ad_amount
		from
	  dwd.dwd_advertisement_admob_income a
inner JOIN  dim.dim_admobapp_view c ON a.App = c.appid
where a.dt>='${bf_4_dt}'

   --  and a.time_types =1
	-- and c.mt in (1,4) and c.product_id in (3366,3311,3322,3333,3371,3388,3399,3511,3501,7777,8888)
	group by 1,2,3,4,5,6,7,8,9

union all
  -- -----------------从2024年7月1号起不再用这个表里的数据---------------------------
      select   a.dt, c.product_id,account,name as ads_nmae, 0 as ad_unit,c.mt,c.core,a.country as appver,
         1 as time_types,
         0 as  ad_requests,
         0 as  matched_requests,
         0 as  impressions,
         0 as  clicks,
         sum(EstRevenue)  as ad_amount

     from  dwd.dwd_advertisement_Mintegral_income_view a
 inner join
(select Mt,Core,	Product_Id,case when Plat_form = 'IOS' then concat('id', AppStore_Id) else AppStore_Id end As Package  from   dim.dim_admobapp_view)  c
  on a.App_Package = c.Package
	where a.dt>='${bf_4_dt}'
            and a.dt<'2024-07-01'
   --  and a.time_types =1
	-- and c.mt in (1,4) and c.product_id in (3366,3311,3322,3333,3371,3388,3399,3511,3501,7777,8888)
	group by 1,2,3,4,5,6,7,8,9
) a
		group by 1,2,3,4,5,6,7,8,15 ;
