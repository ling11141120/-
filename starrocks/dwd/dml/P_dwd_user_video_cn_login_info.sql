insert into dwd.dwd_user_video_cn_login_info
select 	date(create_time) as dt,Id,log_id,log_type,login_type,user_id,ip,os,
          platform,state,create_time,now() as etl_time
from ods.ods_tidb_cdvideo_tidb_xcx_login
where state = 1 and date(create_time) >= '${bf_1_dt}';