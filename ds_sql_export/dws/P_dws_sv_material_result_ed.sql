----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_material_grade_data_result
-- workflow_version : 30
-- create_user      : hufengju
-- task_name        : dws_sv_material_result_ed
-- task_version     : 4
-- update_time      : 2024-12-28 10:21:54
-- sql_path         : \starrocks\tbl_ads_sv_material_grade_data_result\dws_sv_material_result_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.`dws_sv_material_result_ed` where date_key>='${bf_1_dt}';

-- SQL语句
insert into dws.dws_sv_material_result_ed
-- 素材原始数据,筛选fbs2s和tt
select a.date_key
    ,b.material_id
    ,b.material_type
    ,a.source_chl
    ,b.language_name
    ,b.code
    ,b.materia_uid
    ,c.nick_name
    ,max(b.material_name) as material_name
    ,sum(spend) as spend
    ,sum(impressions) as impressions
    ,sum(clicks) as clicks
    ,sum(link_clicks) as link_clicks
    ,sum(installs) as installs
    ,sum(amount) as amount
    ,now() as etl_tm
from (
    -- 上传成功素材 及 属性
    select  material_id
            ,material_type
            ,language_name
            ,asset_guid
            ,code
            ,materia_uid
            ,max(material_name) as material_name
    from ads.ads_material_upload_log_view
    where upload_status=4   -- 上传成功
    group by 1,2,3,4,5,6
) b
join (
    select x.*
        ,e.source_chl
    from (
        select date_key
            ,product_id
            ,adid
            ,fb_account
            ,AssetGuid
            ,sum(spend) spend
            ,sum(impressions) impressions
            ,sum(clicks) clicks
            ,sum(link_clicks) link_clicks
            ,sum(installs) installs
            ,sum(amount) amount
        from ads.ads_advertisement_adassetltv_view
      where date_key>='${bf_1_dt}' and product_id=6833 and spend>0 and date_key<curdate() -- 剔除延迟展示和无花费数据
--        where date_key>days_add(curdate(),-360) and product_id=6833 and spend>0 and date_key<curdate() -- 剔除延迟展示和无花费数据
        group by 1,2,3,4,5
    ) x
    -- 获取投放媒体
    join ads.ads_advertisement_adext_view e on x.product_id=e.product_id and x.adid=e.ad_id and e.source_chl in ('tt','fbs2s')
) a  on a.AssetGuid=b.asset_guid
left join dim.dim_kpi_user_info_view c on b.materia_uid=c.account
group by 1,2,3,4,5,6,7,8;
