----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_offline_label
-- workflow_version : 72
-- create_user      : zhengtt
-- task_name        : ads_offline_label_user_device_info
-- task_version     : 2
-- update_time      : 2024-10-16 11:25:04
-- sql_path         : \starrocks\tbl_ads_offline_label\ads_offline_label_user_device_info
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_offline_label_user_device_info
select  dt,Productid,UserId,
        if(IMEI = '-99',null,IMEI) as IMEI,
        if(IMSI = '-99',null,IMSI) as IMSI,
        DeviceGUID,
        if(MAC = '-99',null,MAC) as MAC,
        Device,null as manufacturer,null as price_level,
        SW,SH,null as os_type,null as os_verison,AppId,now() as etl_time
from
(   select  dt,Productid,UserId,IMEI,IMSI,DeviceGUID,MAC,Device,SW,SH,AppId,
            row_number() over(partition by Productid,UserId order by CreateTime desc) as rn
    from dwd.dwd_user_appstartlog
    where dt = '${bf_1_dt}' and UserId != 0
    ) a
where rn = 1;
