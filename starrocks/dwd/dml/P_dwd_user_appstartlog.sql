insert into dwd.dwd_user_appstartlog
select dt,Productid,AutoId,UserId,CreateTime,IP,MT,IMEI,IMSI,MAC,Ver,Chl,Device,SW,SH,DeviceGUID,AppId,now() as etl_time
from (
         select dt,Productid,Id as AutoId,UserId,CreateTime,IP,MT,
                if(IMEI is null or IMEI = '', -99, IMEI) as                                   IMEI,
                if(IMSI is null or IMSI = '', -99, IMSI) as                                   IMSI,
                if(MAC is null or MAC = '', -99, MAC)    as                                   MAC,
                Ver,Chl,Device,SW,SH,DeviceGUID,AppId,
                row_number() over (partition by Productid,UserId,CreateTime order by Id desc) rk
         from ods_log.ods_user_log_appstartlog
         where dt >= '${bf_1_dt}'
           and dt <= '${dt}'
     ) t1
where rk = 1
;