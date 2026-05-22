----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_flow_exposure_au_ed
-- workflow_version : 5
-- create_user      : zhugl
-- task_name        : tbl_dws_flow_exposure_au_ed
-- task_version     : 5
-- update_time      : 2023-11-27 14:51:26
-- sql_path         : \starrocks\tbl_dws_flow_exposure_au_ed\tbl_dws_flow_exposure_au_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_flow_exposure_au_ed where dt='${bf_1_dt}';

-- SQL语句
insert into dws.dws_flow_exposure_au_ed(dt,product_id,user_id,corever,mt,app_ver,user_type,baoguang_user_id,user_cnt)
with expo as (
select  identity_userID as userid,app_product_id,CDExposureValue,
cast (parse_json(parse_json(CDExposureValue)->'$.position')as string ) position_id
FROM  dwd.dwd_sensors_cdexposure_view  where identity_userID is  not  null and   app_product_id   is not   null  and dt='${bf_1_dt}'
and cast ( parse_json(parse_json(CDExposureValue)->'$.position')as string) = '90100000'
),
 baoguang as (
select
'${bf_1_dt}' dt,
userid,
case when b.ads_type !='' and b.ads_quality =0 then '1'
when b.is_has_charge =0 and b.is_negative_user =1 then '2'
when b.is_has_charge=1 and b.is_negative_user = 1 then '3'
else '4' end  as user_type,
b.corever,
b.mt,
b.product_id,
b.app_ver,
count( a.userid) as user_cnt
from  expo as a
left join dim.dim_user_all_info b on a.userid = b.user_id  and a.app_product_id = b.product_id
group  by 1,2,3,4,5,6,7),
appstar as (
select
a.dt,a.product_id,
b.corever,b.mt,b.app_ver,
case when b.ads_type !='' and b.ads_quality =0 then '1'
when b.is_has_charge=0 and b.is_negative_user =1 then '2'
when b.is_has_charge=1 and b.is_negative_user = 1 then '3'
else '4' end  as user_type, -- usertype 1IAA 2纯白嫖 3付费白嫖 4非白嫖
 a.user_id
from (select
dt ,userid user_id,productid product_id,mt
from dwd.dwd_user_appstartlog where dt='${bf_1_dt}' and   UserId !=0   and mt in (1,4) and productid not  in(7777,8888)
group by 1,2,3,4 order by userid ) a
left  join dim.dim_user_all_info b on a.user_id = b.user_id and a.product_id = b.product_id
group by 1,2,3,4,5,6,7)
select
appstar.dt,appstar.product_id,appstar.user_id,appstar.corever,appstar.mt,appstar.app_ver,appstar.user_type,
baoguang.userid,baoguang.user_cnt
from appstar left join baoguang
on appstar.product_id =  baoguang.product_id and appstar.user_id  = baoguang.userid
where appstar.user_id is not null and  appstar.product_id is not null;
