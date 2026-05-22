----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_advertisement_ad_cost_amt_ed
-- workflow_version : 10
-- create_user      : yanxh
-- task_name        : dwm_advertisement_ad_cost_amt_ed
-- task_version     : 10
-- update_time      : 2024-03-27 16:05:46
-- sql_path         : \starrocks\tbl_dwm_advertisement_ad_cost_amt_ed\dwm_advertisement_ad_cost_amt_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from dwm.dwm_advertisement_ad_cost_amt_ed where dt>='${bf_7_dt}';

-- SQL语句
insert into  dwm.dwm_advertisement_ad_cost_amt_ed
   -- -------------投放费用宽表 包含营销和再营销  东八区的脚本----------------------------
select dt,product_id,ad_id,fb_account_id,source_chl,ads_type,ads_quality,ad_name,product_name,
       ad_campname,ad_camp_id,ad_set_id,ad_setname as ad_set_name,
       if(book_id=105373755,10537375,book_id) as book_id,book_name,book_channel,book_nature,
       ad_optimizer_uid,ads_optimizer_group,
       corever,mt,current_language2,
       is_remarketing,
       cost_amt ,
       install_unt,
       click_cnt,
       impression_cnt ,
     now() as etl_tm
from (

select   date(DATE_ADD(a.date_start,INTERVAL 13 Hour)) as dt,a.product_id, a.ad_id,b.fb_account as fb_account_id,b.source_chl,b.ads_type,b.ads_quality,b.ad_name,c.product_name,
        b.ad_campname,b.ad_camp_id,b.ad_set_id,b.ad_setname,b.book_id,b.book_name,
        b.book_channel,b.book_nature,b.ad_optimizer_uid,
        d.ads_optimizer_group,
        b.core as corever,b.mt,b.current_language2,
        c.fb_account_type  as  is_remarketing,  -- 判断是否再营销 1 再营销 0 非再营销
        sum(a.spend) as cost_amt,
        sum(a.installs) as install_unt,
        sum(a.clicks) as click_cnt,
        sum(a.impressions) as impression_cnt
from  dwd.dwd_advertisement_fbad_dailyinsight_byesthour_view a
left join dwd.dwd_advertisement_adext_view b
    on a.ad_id = b.ad_id -- and a.product_id = b.product_id
left join dim.dim_ad_account c
    on  b.fb_account = c.account
left join
  (  select dt, optimizer_group_type, ads_optimizer_group, ads_optimizer from dim.dim_optimizergroups  where dt ='${bf_1_dt}'  and optimizer_group_type = 0) d
  on b.ad_optimizer_uid = d.ads_optimizer
where a.date_start  >= DATE_ADD(DATE_ADD('${bf_1_dt}',INTERVAL -13 Hour),INTERVAL -6 DAY)
     -- and  a.date_start < DATE_ADD(DATE_ADD('2024-12-01',INTERVAL -13 Hour),INTERVAL 10 DAY)
and a.product_id in (3311,3322,3333,3366,3371,3388,3399,3501,3511)
and a.spend >0
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21 ,22,23

 union all
select  date(DATE_ADD(a.date_start,INTERVAL 13 Hour)) as dt,a.product_id, a.ad_id,b.fb_account as fb_account_id,b.source_chl,b.ads_type,b.ads_quality,b.ad_name,c.product_name,
        b.ad_campname,b.ad_camp_id,b.ad_set_id,b.ad_setname,b.book_id,b.book_name,
        b.book_channel,b.book_nature,b.ad_optimizer_uid,
        0  as ads_optimizer_group,-- d.ads_optimizer_group,
        a.core,a.mt,a.current_language2,
		a.is_remarketing ,
        sum(a.spend) as cost_amt,
        sum(a.installs) as install_unt,
        sum(a.clicks) as click_cnt,
        sum(a.impressions) as impression_cnt
from  dwd.dwd_advertisement_ltv_dailyinsight_byhour_view a
left join dwd.dwd_advertisement_adext_view b
    on a.ad_id = b.ad_id
left join dim.dim_ad_account c
    on  b.fb_account = c.account
 left join
  (  select dt, optimizer_group_type, ads_optimizer_group, ads_optimizer from dim.dim_optimizergroups  where dt = '${bf_1_dt}'  and optimizer_group_type = 0) d
   on b.ad_optimizer_uid = d.ads_optimizer
where a.date_start  >= DATE_ADD(DATE_ADD('${bf_1_dt}',INTERVAL -13 Hour),INTERVAL -6 DAY)
     -- and   a.date_start < DATE_ADD(DATE_ADD('2024-12-01',INTERVAL -13 Hour),INTERVAL 10 DAY)
and a.product_id in (3311,3322,3333,3366,3371,3388,3399,3501,3511)
and a.spend >0
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21 ,22,23
) a  ;
