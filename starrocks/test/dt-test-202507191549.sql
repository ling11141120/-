-- --------------阅读的 2222----------------------------
  insert into test.ads_bi_read_adv_income_report_advdata_test
with amt as 
(	SELECT
	  dt,
	  product_id,
	  ads_nmae,
	  ad_unit,
	  mt,
	  corever,
	  sum(ad_requests) AS ad_requests,
	  sum(matched_requests) AS matched_requests,
	  sum(impressions) AS impressions,
	  sum(clicks) AS clicks,
	  sum(ad_amount) AS ad_amount
	FROM dws.dws_advertisement_admob_income_ed
	WHERE 
	dt>=  '{bf_4_dt}'
	and product_id  not in (6833)
	and time_types = 1
	GROUP BY 1,2,3,4,5,6),


	
-- -----------先关联开启状态的广告单元id配置数据------------------------------
	amt_1 as (
select   amt.dt,
  amt.product_id,
  amt.mt,
  amt.corever,
  amt.ads_nmae,
  b.ad_show_type,
  b.ad_position as position_id ,
  1  as tps,
  sum(amt.ad_amount) AS ad_amt,
  sum(amt.ad_requests) AS ad_request_cnt,
  sum(amt.matched_requests) AS matched_request_cnt,
  sum(amt.impressions) AS impression_cnt,
  sum(amt.clicks) AS click_cnt 
from amt 
inner join 
(-- ----------海外阅读的广告单元id配置表--------------------------------
 select product_id, unit_adid,ad_show_type,min(ad_position) ad_position from dim.dim_app_adplatform_unit_id_info where ad_plat_form=1 and status =1   group by 1,2 ,3) b 
 on amt.product_id=b.product_id and amt.ad_unit=b.unit_adid 
 group by 1,2,3,4,5,6,7,8
  ) ,
  
  	amt_2 as (
select   amt.dt,
  amt.product_id,
  amt.mt,
  amt.corever,
  amt.ads_nmae,
  b.ad_show_type,
  b.ad_position as position_id ,
  1  as tps,
  sum(amt.ad_amount) AS ad_amt,
  sum(amt.ad_requests) AS ad_request_cnt,
  sum(amt.matched_requests) AS matched_request_cnt,
  sum(amt.impressions) AS impression_cnt,
  sum(amt.clicks) AS click_cnt 
from amt 
inner join 
(-- ----------海外阅读的广告单元id配置表--------------------------------
 select product_id, unit_adid,ad_show_type,min(ad_position) ad_position from dim.dim_app_adplatform_unit_id_info where ad_plat_form=1 and status =0   group by 1,2 ,3) b 
 on amt.product_id=b.product_id and amt.ad_unit=b.unit_adid 
 where concat(amt.ad_unit,amt.product_id) not in (select  distinct concat(unit_adid,product_id) from  dim.dim_app_adplatform_unit_id_info where ad_plat_form=1 and status =1) 
 group by 1,2,3,4,5,6,7,8,9,10
  )  
  
select   dt, product_id, mt, corever, ads_nmae, ad_show_type, position_id , tps,  ad_amt, ad_request_cnt, matched_request_cnt,impression_cnt,click_cnt,now() as etl_tm  from amt_1
  union all 
 select   dt, product_id, mt, corever, ads_nmae, ad_show_type, position_id , tps,  ad_amt, ad_request_cnt, matched_request_cnt,impression_cnt,click_cnt,now() as etl_tm  from amt_2
