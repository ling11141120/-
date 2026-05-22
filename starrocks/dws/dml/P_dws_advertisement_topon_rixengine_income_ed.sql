----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_advertisement_topon_rixengine_income_ed
-- workflow_version : 3
-- create_user      : yanxh
-- task_name        : dws_advertisement_topon_rixengine_income_ed
-- task_version     : 3
-- update_time      : 2023-12-01 18:10:23
-- sql_path         : \starrocks\tbl_dws_advertisement_topon_rixengine_income_ed\dws_advertisement_topon_rixengine_income_ed
----------------------------------------------------------------
-- SQL语句
delete from dws.dws_advertisement_topon_rixengine_income_ed where dt>='${bf_4_dt}';

-- SQL语句
insert into dws.dws_advertisement_topon_rixengine_income_ed
    select    date as dt,
         product_id,
     core  as corever,
     mt,
     ad_format, -- 广告类型
     firm_name,  --  广告来源
     placement_name,  -- 广告位置
    sum(revenue) as ad_amount, -- 广告收入
 -- sum(revenue)/sum(impression)*1000 as ecpm,
    sum(request) as  request, -- 请求数
    sum(matched_requests) as matched_requests , -- 匹配数
    sum(impression) impression , -- 展示次数
 -- 展现次数/匹配请求数*100%,
    sum(click) as click, -- 点击数
    now() as etl_time
    from (
select
    rp.date,
    rp.ad_format, -- 广告类型
    firm.Name as Firm_Name,  --  广告来源
    place.Name as Placement_Name,  -- 广告位置
    app.product_id,
    app.core,
    app.mt,
     rp.revenue , -- 广告收入
     rp.request   , -- 请求数
    case when firm.Firm_Id =0 then rp.Response   else   rp.request*rp.fill_rate end  as matched_requests ,-- 匹配数 ：topon广告来源：匹配数=请求数*匹配率    rixengine 广告来源直接取response
    impression , -- 展示次数
   click-- 点击数
from dwd.dwd_advertisement_toponfullreport_view  rp
left join dim.dim_toponappinfo_view app on rp.App_Id = app.App_Id or  rp.App_Id= app.Package_Name
left join dim.dim_toponfirminfo_view firm on rp.Network_Firm_Id = firm.Firm_Id
left join dim.dim_toponplacementinfo_view place on rp.App_Id = place.App_Id and rp.Placement_Id = place.Placement_Id
where rp.date>='${bf_4_dt}'
) a

group by 1,2,3,4,5,6,7
;
