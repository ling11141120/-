----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_ad_material_blood_relationship_effect
-- workflow_version : 9
-- create_user      : chenmo
-- task_name        : ads_ad_material_blood_relationship_effect
-- task_version     : 9
-- update_time      : 2025-04-10 09:48:01
-- sql_path         : \starrocks\tbl_ads_ad_material_blood_relationship_effect\ads_ad_material_blood_relationship_effect
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_ad_material_blood_relationship_effect
select a.asset_guid as asset_guid,
       a.tgt_type as project_id,
       coalesce(UPPER(g.abbreviation),a.language_name) as current_language,
       a.source_chl_type as source_chl_type,
       c.book_id as book_id,
       a.material_id as meterial_id,
       d.asset_guid as fission_parent_id,
       if(a.material_name like '%复刻%',1,0) as is_replica,
       count(distinct(b.adset_id)) as ad_group_count,
       sum(b.spend) as ad_spend,
       sum(b.amount) as ad_revenue,
       sum(b.dev_num) as activation_count,
       sum(b.impressions) as impression_count,
       case when a.source_chl_type = 1 then sum(b.link_clicks)
            when a.source_chl_type = 2 then sum(b.clicks) end as link_click_count,
       now() as etl_time
from ads.ads_material_upload_log_view a
left join ads.ads_advertisement_adassetltv_view b on a.asset_guid = b.AssetGuid and b.date_key between DATE('${bf_1_dt}' - INTERVAL 360 DAY) and DATE('${bf_1_dt}' - INTERVAL 8 DAY)
left join ads.ads_advertisement_adext_view c on b.adid = c.ad_id and b.product_id = c.product_id
left join ads.ads_material_upload_log_view d on a.fission_parent_id = d.id
left join dim.dim_shuangwen_book_read_consume_info e on c.book_id = e.book_id and c.product_id not in (6833,6883)
left join dim.dim_sv_series_hi f on c.book_id = f.series_id and c.product_id = 6833
left join dim.DIM_ProductType g on if(c.product_id=6833,f.language,e.languageid) = g.langid and g.abbreviation != 'and2'
where a.upload_status=4 and a.asset_guid is not null and a.bm_compelete_time > DATE('${bf_1_dt}' - INTERVAL 450 DAY)
group by a.asset_guid,a.tgt_type,a.language_name,a.source_chl_type,c.book_id,a.material_id,d.asset_guid,a.material_name,a.source_chl_type,g.abbreviation;
