----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_flow_app_client_biz_ed
-- workflow_version : 9
-- create_user      : zhugl
-- task_name        : tbl_dws_flow_app_client_biz_ed
-- task_version     : 9
-- update_time      : 2025-06-18 18:16:51
-- sql_path         : \starrocks\tbl_dws_flow_app_client_biz_ed\tbl_dws_flow_app_client_biz_ed
----------------------------------------------------------------
-- 前置SQL语句
DELETE  FROM  dws.dws_flow_app_client_biz_ed where dt ='${bf_1_dt}';

-- SQL语句
insert into dws.dws_flow_app_client_biz_ed
select
    dt,
    app_id,
    case
        when app_channel is not null and array_length(split(app_channel,'_'))=4 then   split(app_channel,'_')[2]
        when appchannel is not null  and array_length(split(appchannel,'_'))=4 then   split(appchannel,'_')[2]
        when  ifnull(app_core_ver,appcorever) is not  null then concat('core',ifnull(app_core_ver,appcorever))
        else ''
        end as core,
    upper (case
        when app_channel is not null and array_length(split(app_channel,'_'))=4  then   split(app_channel,'_')[3]
        when appchannel is not null  and array_length(split(appchannel,'_'))=4  then   split(appchannel,'_')[3]
        when lib  is  not  null then lib
        else ''
        end) as mt,
    -- ifnull(app_product_id,'') app_product_id,
        case
        when app_channel is not null and array_length(split(app_channel,'_'))=4  then   split(app_channel,'_')[1]
        when appchannel is not null  and array_length(split(appchannel,'_'))=4  then   split(appchannel,'_')[1]
        else '' end  as product_id,
    ifnull(app_version,-99) as app_version,
    if(biz_type is null,'-99',biz_type) as biz_type,
    coalesce(biz_book_id,biz_book_id2,'-99') as biz_book_id,
    if(biz_chapter_id is null,'-99',biz_chapter_id) as biz_chapter_id,
    count(1) cnt ,
    NOW()
from dwd.dwd_flow_apperror_log_cdappclientbiz_view  a
where dt >='${bf_1_dt}' and lib !='js' and (app_id ='com.changdu.mobovideo'
or (array_length(split(app_channel,'_'))=4 or array_length(split(appchannel,'_'))=4) ) and length(coalesce(biz_book_id,biz_book_id2,'-99')) <= 30
-- and app_id='com.changdu.ereader3.th' AND  biz_type ='PayBizError' AND  app_version ='5.7.2' and dt='2024-01-22'
group by 1,2,3,4,5,6,7,8,9;
