----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_user_install_info_ed_est_mid
-- workflow_version : 4
-- create_user      : zhengtt
-- task_name        : dwd_user_install_info_ed_est_mid
-- task_version     : 4
-- update_time      : 2024-10-16 11:48:19
-- sql_path         : \starrocks\tbl_dwd_user_install_info_ed_est_mid\dwd_user_install_info_ed_est_mid
----------------------------------------------------------------
-- SQL语句
insert into dwd.dwd_user_install_info_ed_est_mid
select  date(hours_add(InstallDate,-13)) as dt,id,ProductId,UserId,BookId,Source,
        hours_add(CreateTime,-13) as create_time,hours_add(InstallDate,-13) as install_date,
        hours_add(NextAttributeTime,-13) as next_attribute_time,
        hours_add(RemarketingTime,-13) as remarketing_time,
        adid as ad_id,
        now() as etl_time
from ods.ods_sharpengine_ads_hk_bak_if_user_installreferrer
where date(hours_add(InstallDate,-13)) >= '${bf_3_dt}' and  ProductId != 6883 and IsDelete != 1
union all
select date(hours_add(InstallDate,-13)) as dt,id,ProductId,UserId,BookId,Source,
       hours_add(CreateTime,-13) as create_time,hours_add(InstallDate,-13) as install_date,
       hours_add(NextAttributeTime,-13) as next_attribute_time,
       hours_add(RemarketingTime,-13) as remarketing_time,
       adid as ad_id,
       now() as etl_time
from ods.ods_tidb_cdvideo_tidb_xcx_user_attribution
where date(hours_add(InstallDate,-13)) >= '${bf_3_dt}' and IsDelete != 1;
