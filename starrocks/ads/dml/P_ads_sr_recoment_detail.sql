----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_recoment_detail
-- workflow_version : 6
-- create_user      : chenmo
-- task_name        : ads_sr_recoment_detail
-- task_version     : 4
-- update_time      : 2025-04-16 14:13:19
-- sql_path         : \starrocks\tbl_ads_sr_recoment_detail\ads_sr_recoment_detail
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sr_recoment_detail
select
    productid as product_id,
    id as id,
    bookid as book_id,
    Language as language,
    title as title,
    recomment_order as recomment_order,
    update_time as update_time,
    publish_time as publish_time,
    positionid as position_id,
    IsDelete as is_delete,
    row_update_time as row_update_time,
    SyncLanguage as sync_language,
    now() as etl_time
from ods.ods_tidb_readernovel_tidb_xx_recoment_detail
group by 1,2,3,4,5,6,7,8,9,10,11,12;
