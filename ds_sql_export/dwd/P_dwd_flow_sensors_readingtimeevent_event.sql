----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sensors_exposure_bulu
-- workflow_version : 1
-- create_user      : admin
-- task_name        : dwd_flow_sensors_readingtimeevent_event_1
-- task_version     : 1
-- update_time      : 2023-10-18 13:34:11
-- sql_path         : \starrocks\sensors_exposure_bulu\dwd_flow_sensors_readingtimeevent_event_1
----------------------------------------------------------------
-- SQL语句
INSERT  INTO  dwd.dwd_flow_sensors_readingtimeevent_event
select dt,id,ind,track_id,rid,event_tm,userid,mt,corever,prodid,appver,event,createtime,bookid,chapterid,readtime,productid,now()
FROM (select dt,id,track_id,rid,event_tm,userid,mt,corever,prodid,appver,event,createtime,productid,
unnest ,
get_json_string(unnest,'$.bookid') as bookid,
get_json_string(unnest,'$.chapterid') as chapterid,
get_json_string(unnest,'$.time') as readtime,
ROW_NUMBER() over(partition by id )as ind from
(select dt,id,track_id,rid,event_tm,
userid,mt,corever,prodid,appver,event,
createtime,detail,productid,etl_tm,
cast(detail as array<string>) jsons
from  ods.ods_flow_sensors_readingtimeevent_event  where dt='${bf_1_dt}' and event_tm<=concat('${bf_1_dt}',' 12:00:00')
) a,
unnest(jsons)unnest
)a;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sensors_exposure_bulu
-- workflow_version : 1
-- create_user      : admin
-- task_name        : dwd_flow_sensors_readingtimeevent_event_2
-- task_version     : 1
-- update_time      : 2023-10-18 13:34:11
-- sql_path         : \starrocks\sensors_exposure_bulu\dwd_flow_sensors_readingtimeevent_event_2
----------------------------------------------------------------
-- SQL语句
INSERT  INTO  dwd.dwd_flow_sensors_readingtimeevent_event
select dt,id,ind,track_id,rid,event_tm,userid,mt,corever,prodid,appver,event,createtime,bookid,chapterid,readtime,productid,now()
FROM (select dt,id,track_id,rid,event_tm,userid,mt,corever,prodid,appver,event,createtime,productid,
unnest ,
get_json_string(unnest,'$.bookid') as bookid,
get_json_string(unnest,'$.chapterid') as chapterid,
get_json_string(unnest,'$.time') as readtime,
ROW_NUMBER() over(partition by id )as ind from
(select dt,id,track_id,rid,event_tm,
userid,mt,corever,prodid,appver,event,
createtime,detail,productid,etl_tm,
cast(detail as array<string>) jsons
from  ods.ods_flow_sensors_readingtimeevent_event  where dt='${bf_1_dt}' and event_tm>concat('${bf_1_dt}',' 12:00:00')
) a,
unnest(jsons)unnest
)a;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_flow_sensors_readingtimeevent_event
-- workflow_version : 8
-- create_user      : zhugl
-- task_name        : dwd_flow_sensors_readingtimeevent_event
-- task_version     : 4
-- update_time      : 2025-03-27 20:08:06
-- sql_path         : \starrocks\tbl_dwd_flow_sensors_readingtimeevent_event\dwd_flow_sensors_readingtimeevent_event
----------------------------------------------------------------
-- SQL语句
INSERT  INTO  dwd.dwd_flow_sensors_readingtimeevent_event
select dt,id,ind,track_id,rid,event_tm,userid,mt,corever,prodid,appver,event,createtime,bookid,chapterid,readtime,productid,now()
FROM (select dt,id,track_id,rid,event_tm,userid,mt,corever,prodid,appver,event,createtime,productid,
unnest ,
get_json_string(unnest,'$.bookid') as bookid,
get_json_string(unnest,'$.chapterid') as chapterid,
get_json_string(unnest,'$.time') as readtime,
ROW_NUMBER() over(partition by id )as ind from
(select dt,id,track_id,rid,event_tm,
userid,mt,corever,prodid,appver,event,
createtime,detail,productid,etl_tm,
split(regexp_replace(regexp_replace(detail,'\\[|\\]',''),'},{','},,{'),',,') jsons
from  ods.ods_flow_sensors_readingtimeevent_event  where dt='${bf_1_dt}'
) a,
unnest(jsons)unnest
)a;
