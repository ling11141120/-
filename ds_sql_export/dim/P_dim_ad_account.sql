----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dim_ad_account
-- workflow_version : 3
-- create_user      : admin
-- task_name        : dim_ad_account
-- task_version     : 3
-- update_time      : 2024-06-05 10:58:22
-- sql_path         : \starrocks\tbl_dim_ad_account\dim_ad_account
----------------------------------------------------------------
-- SQL语句
insert overwrite dim.dim_ad_account
select  Id,1 as types,Account,Secret,PageId,AppId,AppUrl,CreatTime,ProductId,ProductName,Mt,
        Token,InsId,Status,AutoFillAd,UpdateStatus,Chl,Core,FbAdRuleId,AdAutoActive,
        StatusChangeTime,FbAccountType,RowVersion,SpendCap,AmountSpent,PutProductId,
        CurrentLanguage2,AccountAdType,ExchangeRate,null as TimeZone,AccountChangeToRemarketingTime,
        LastInsightInfo,IsProductPutAccount,LastPutTime,FbAdNetworkType,ThirdPayDatasetId,
        null as timezone_offset,null as source_chl,null as ad_platform_id,AccountTz as account_tz,
        now() as etl_time
from ods.ods_tidb_sharpengine_ads_global_FbAccount
union all
select  Id,2 as types,Account,Secret,PageId,AppId,AppUrl,CreateTime,ProductId,ProductName,Mt,
        Token,InsId,Status,AutoFillAd,UpdateStatus,Chl,Core,FbAdRuleId,AdAutoActive,
        StatusChangeTime,FbAccountType,RowVersion,SpendCap,AmountSpent,PutProductId,
        CurrentLanguage2,AccountAdType,ExchangeRate,null as TimeZone,AccountChangeToRemarketingTime,
        LastInsightInfo,null as is_product_put_account,null as last_put_time,null as fb_ad_network_type,
        null as third_pay_data_set_id,TimeZoneOffset,null as source_chl,null as ad_platform_id,AccountTz,
        now() as etl_time
from ods.ods_tidb_sharpengine_ads_global_TiktokAdsAccount
union all
select  Id,3 as types,Account,Secret,PageId,AppId,AppUrl,CreateTime,ProductId,ProductName,Mt,
        Token,InsId,Status,AutoFillAd,UpdateStatus,Chl,Core,FbAdRuleId,AdAutoActive,
        StatusChangeTime,FbAccountType,RowVersion,SpendCap,AmountSpent,PutProductId,
        CurrentLanguage2,AccountAdType,ExchangeRate,null as TimeZone,AccountChangeToRemarketingTime,
        LastInsightInfo,null as is_product_put_account,null as last_put_time,null as fb_ad_network_type,
        null as third_pay_data_set_id,null as timezone_offset,SourceChl,AdPlatformId,AccountTz,
        now() as etl_time
from ods.ods_tidb_sharpengine_ads_global_ThirdAdAccount
union all
select  Id,4 as types,Account,Secret,PageId,AppId,AppUrl,CreatTime,ProductId,ProductName,Mt,
        Token,InsId,Status,AutoFillAd,UpdateStatus,Chl,Core,FbAdRuleId,AdAutoActive,
        StatusChangeTime,FbAccountType,RowVersion,SpendCap,AmountSpent,PutProductId,
        CurrentLanguage2,AccountAdType,ExchangeRate,TimeZone,AccountChangeToRemarketingTime,
        LastInsightInfo,null as is_product_put_account,null as last_put_time,null as fb_ad_network_type,
        null as third_pay_data_set_id,null as timezone_offset,null as SourceChl,null as AdPlatformId,AccountTz,
        now() as etl_time
from ods.ods_tidb_sharpengine_ads_global_adsaccount;
