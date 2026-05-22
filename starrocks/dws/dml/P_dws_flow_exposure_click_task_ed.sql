----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_flow_exposure_click_task_ed
-- workflow_version : 6
-- create_user      : zhugl
-- task_name        : tbl_dws_flow_exposure_click_task_ed
-- task_version     : 6
-- update_time      : 2023-12-15 16:35:49
-- sql_path         : \starrocks\tbl_dws_flow_exposure_click_task_ed\tbl_dws_flow_exposure_click_task_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_flow_exposure_click_task_ed where dt='${bf_1_dt}' ;

-- SQL语句
insert into  dws.dws_flow_exposure_click_task_ed (dt,user_id,product_id,user_type,task_name,corever,mt,app_ver,event,task_exp_cnt,task_clk_cnt,click_get_user,wacthuser,points_user_id)
with expo as (
select  identity_userID as userid,app_product_id,CDExposureValue,
cast(parse_json(parse_json(CDExposureValue)->'$.position')as string ) position_id,
cast(parse_json(parse_json(CDExposureValue)->'$.serial') as string )serial,
cast(parse_json(parse_json(CDExposureValue)->'$.modulid')as string ) modulid,
appid,event,
case when substr(appid,-2,1) = '0' then  substr(appid,-1,1)
else substr(appid,-2,2) end as  countrycode    FROM  dwd.dwd_sensors_cdexposure_view  where identity_userID is not  null and  app_product_id   is not   null  and dt='${bf_1_dt}'
and cast ( parse_json(parse_json(CDExposureValue)->'$.position')as string) in ('90120000','90100301','90100400','90100401','90100302')
UNION  ALL
select  identity_userID as userid,app_product_id,CDClickPath,
cast(parse_json(parse_json(CDClickPath)->'$.position')as string ) position_id,
cast(parse_json(parse_json(CDClickPath)->'$.serial')as string ) serial,
cast(parse_json(parse_json(CDClickPath)->'$.modulid')as string ) modulid,
appid,event,
case when substr(appid,-2,1) = '0' then  substr(appid,-1,1)
else substr(appid,-2,2) end as  countrycode  FROM  dwd.dwd_sensors_cdclick_view  where   identity_userID is not  null and  app_product_id   is not   null  and dt='${bf_1_dt}'
and cast( parse_json(parse_json(CDClickPath)->'$.position') as string) in ('90120000','90100301','90100400','90100401','90100302')
),
watchlog as (
select  identity_userID as userid,app_product_id,
ARRAY_DISTINCT(ARRAY_AGG(cast(parse_json(parse_json(CDClickPath)->'$.position')as string ))) position_cf
  FROM  dwd.dwd_sensors_cdclick_view  where  app_product_id   is not   null  and dt='${bf_1_dt}'
and cast( parse_json(parse_json(CDClickPath)->'$.position') as string) in ('90120000','90100301','90100400','90100401','90100302')
group by 1,2
),
country_info as (
 select user_Id ,product_id ,
ARRAY_DISTINCT(ARRAY_AGG(regexp_extract(position, '([0-9]+)',1))) position_arr   from dwd.dwd_read_readerlog_log_userwatchvideo3log_view where dt='${bf_1_dt}'
and  regexp_extract(position, '([0-9]+)',1) is not  null and regexp_extract(position, '([0-9]+)',1) !=''
group  by 1,2 )
-- renwu
select
'${bf_1_dt}' dt,
a.userid as user_id,
a.app_product_id as product_id,
case when u.ads_type !='' and u.ads_quality =0 then '1'
when u.is_has_charge =0 and u.is_negative_user =1 then '2'
when u.is_has_charge=1 and u.is_negative_user = 1 then '3'
else '4' end  as user_type,
case
when position_id ='90120000' and  cast(concat(countrycode,serial)as string ) in ('415' ,'482' ,'2150038' ,'2150039' ,'315' ,'391' ,'515' ,'581' ,'615' ,'675' ,'715' ,'790070' ,'915' ,'9120039' ,'9150040' ,'111' ,'11120039' ,'11120019' ,'121' ,'12150033' ,'12150013') then '阅读'
when position_id ='90120000' and  cast(concat(countrycode,serial)as string ) in ('464','2150028','376','566','661','790055','11120024','12150018') then '定向阅读'
when position_id ='90120000' and  cast(concat(countrycode,serial)as string ) in ('466','467','43001410000','442','485','466','467' ,'2150030','2150029','2150044','260019','23001410000' ,'343','377','378','343','390','31000910002' ,'544','567','568','580','53001410000' ,'662','663','678','63001410000' ,'790056','790057','790069','73001410000' ,'930040','990042','9120041','990035','9150043','93001410000' ,'11120025','11120026','11120038' ,'12150019','12150020') then '玩游戏'
when position_id ='90120000' and  cast(concat(countrycode,serial)as string ) in ('426','212','326','526','626','726','926','11120043','11120043','1290001') then '充值'
when position_id ='90120000' and  cast(concat(countrycode,serial)as string ) in ('423' ,'29' ,'323' ,'523' ,'623' ,'723' ,'923' ,'1130003' ,'1230005') then '购买章节'
when position_id ='90120000' and  cast(concat(countrycode,serial)as string ) in ('421','27','321','350','721','11120005','12120003') then '打赏书籍'
when position_id ='90120000' and  cast(concat(countrycode,serial)as string ) in ('470','2150035','383','573','668','790062','11120031','12150025') then '浏览商城'
when position_id ='90120000' and  cast(concat(countrycode,serial)as string ) in ('469','422' ,'2150036','28' ,'384','322' ,'522','574' ,'669','622' ,'790063','722' ,'922','9120038' ,'1130002','11120032' ,'12150026','1260002') then '评论'
when position_id ='90120000' and  cast(concat(countrycode,serial)as string ) in ('468' ,'2150037' ,'385' ,'312' ,'575' ,'670' ,'790064' ,'11120033' ,'12150027') then '点赞'
when position_id ='90120000' and  cast(concat(countrycode,serial)as string ) in ('433' ,'217' ,'320','333','320','333' ,'632' ,'733' ,'933' ,'11120006' ,'1260005') then '分享'
when position_id ='90120000' and  cast(concat(countrycode,serial)as string ) in ('427','431','441' ,'216' ,'327','331','341','342','345' ,'533' ,'633' ,'731' ,'931' ,'11120003' ,'12120002') then '绑定邮箱'
when position_id ='90120000' and  cast(concat(countrycode,serial)as string ) in ('334') then '第三方账号绑定'
when position_id ='90120000' and  cast(concat(countrycode,serial)as string ) in ('328','428') then '填写个人信息'
when position_id ='90100301'  then '吃饭'
when position_id in('90100400','90100401') then  '宝箱'
else '未知' end as task_name,
u.corever,
u.mt,
u.app_ver,
event,
count( case when event = 'CDExposure' then a.userid end) as task_exp_cnt,
count( case when event = 'CDClick' then a.userid end) as task_clk_cnt,
-- count(distinct case when event = 'CDExposure' then a.userid end) as task_exp_usercnt,
-- count(distinct case when event = 'CDClick' then a.userid end) as task_clk_usercnt,
case when event = 'CDClick' and (case  when position_id ='90120000' then a.modulid
when position_id in ('90100301','90100401') and event = 'CDClick' then '2' else null end) = '2' then  a.userid end as click_get_user,
case when position_id ='90120000' and array_contains(position_arr,'3') and concat(countrycode,serial) in ('415' ,'482' ,'2150038' ,'2150039' ,'315' ,'391' ,'515' ,'581' ,'615' ,'675' ,'715' ,'790070' ,'915' ,'9120039' ,'9150040' ,'111' ,'11120039' ,'11120019' ,'121' ,'12150033' ,'12150013') then country_info.user_id
when position_id ='90120000' and array_contains(position_arr,'34') and concat(countrycode,serial) in ('464','2150028','376','566','661','790055','11120024','12150018') then country_info.user_id
when position_id ='90120000' and (array_contains(position_arr,'15') or array_contains(position_arr,'24') or array_contains(position_arr,'25') )and concat(countrycode,serial) in ('466','467','43001410000','442','485','466','467' ,'2150030','2150029','2150044','260019','23001410000' ,'343','377','378','343','390','31000910002' ,'544','567','568','580','53001410000' ,'662','663','678','63001410000' ,'790056','790057','790069','73001410000' ,'930040','990042','9120041','990035','9150043','93001410000' ,'11120025','11120026','11120038' ,'12150019','12150020') then country_info.user_id
when position_id ='90120000' and array_contains(position_arr,'4') and concat(countrycode,serial) in ('426','212','326','526','626','726','926','11120043','11120043','1290001') then country_info.user_id
when position_id ='90120000' and array_contains(position_arr,'14') and concat(countrycode,serial) in ('423' ,'29' ,'323' ,'523' ,'623' ,'723' ,'923' ,'1130003' ,'1230005') then country_info.user_id
when position_id ='90120000' and array_contains(position_arr,'13') and concat(countrycode,serial) in ('421','27','321','350','721','11120005','12120003') then country_info.user_id
when position_id ='90120000' and array_contains(position_arr,'32') and concat(countrycode,serial) in ('470','2150035','383','573','668','790062','11120031','12150025') then country_info.user_id
when position_id ='90120000' and array_contains(position_arr,'2') and concat(countrycode,serial) in ('469','422' ,'2150036','28' ,'384','322' ,'522','574' ,'669','622' ,'790063','722' ,'922','9120038' ,'1130002','11120032' ,'12150026','1260002') then country_info.user_id
when position_id ='90120000' and array_contains(position_arr,'31') and concat(countrycode,serial) in ('468' ,'2150037' ,'385' ,'312' ,'575' ,'670' ,'790064' ,'11120033' ,'12150027') then country_info.user_id
when position_id ='90120000' and array_contains(position_arr,'1') and concat(countrycode,serial) in ('433' ,'217' ,'320','333','320','333' ,'632' ,'733' ,'933' ,'11120006' ,'1260005') then country_info.user_id
when position_id ='90120000' and array_contains(position_arr,'20') and concat(countrycode,serial) in ('427','431','441' ,'216' ,'327','331','341','342','345' ,'533' ,'633' ,'731' ,'931' ,'11120003' ,'12120002') then country_info.user_id
when position_id ='90120000' and array_contains(position_arr,'22') and concat(countrycode,serial) in ('334') then country_info.user_id
when position_id ='90120000' and array_contains(position_arr,'21') and concat(countrycode,serial) in ('328','428') then country_info.user_id
when position_id ='90100301' and array_contains(position_cf,'90100302')  then a.userid
when position_id in('90100400') then  null
when position_id ='90100401' and array_contains(position_arr,'33')  then country_info.user_id
 end as wacthuser,
 points.user_id points_user_id
from
expo as a
left  join country_info on a.userid = country_info.User_Id and a.app_product_id  =country_info.product_id
left join watchlog on a.userid = watchlog.userid and a.app_product_id  =watchlog.app_product_id
left  join dim.dim_user_all_info u on a.userid = u.user_id and a.app_product_id = u.product_id
left join (select * from dws.dws_flow_jifen_anditemjifen_give_consume_ed where dt ='${bf_1_dt}' and  task_name is not NULL) points  on a.userid = points.user_id and a.app_product_id  =points.product_id and case
when position_id ='90120000' and  cast(concat(countrycode,serial)as string ) in ('415' ,'482' ,'2150038' ,'2150039' ,'315' ,'391' ,'515' ,'581' ,'615' ,'675' ,'715' ,'790070' ,'915' ,'9120039' ,'9150040' ,'111' ,'11120039' ,'11120019' ,'121' ,'12150033' ,'12150013') then '阅读'
when position_id ='90120000' and  cast(concat(countrycode,serial)as string ) in ('464','2150028','376','566','661','790055','11120024','12150018') then '定向阅读'
when position_id ='90120000' and  cast(concat(countrycode,serial)as string ) in ('466','467','43001410000','442','485','466','467' ,'2150030','2150029','2150044','260019','23001410000' ,'343','377','378','343','390','31000910002' ,'544','567','568','580','53001410000' ,'662','663','678','63001410000' ,'790056','790057','790069','73001410000' ,'930040','990042','9120041','990035','9150043','93001410000' ,'11120025','11120026','11120038' ,'12150019','12150020') then '玩游戏'
when position_id ='90120000' and  cast(concat(countrycode,serial)as string ) in ('426','212','326','526','626','726','926','11120043','11120043','1290001') then '充值'
when position_id ='90120000' and  cast(concat(countrycode,serial)as string ) in ('423' ,'29' ,'323' ,'523' ,'623' ,'723' ,'923' ,'1130003' ,'1230005') then '购买章节'
when position_id ='90120000' and  cast(concat(countrycode,serial)as string ) in ('421','27','321','350','721','11120005','12120003') then '打赏书籍'
when position_id ='90120000' and  cast(concat(countrycode,serial)as string ) in ('470','2150035','383','573','668','790062','11120031','12150025') then '浏览商城'
when position_id ='90120000' and  cast(concat(countrycode,serial)as string ) in ('469','422' ,'2150036','28' ,'384','322' ,'522','574' ,'669','622' ,'790063','722' ,'922','9120038' ,'1130002','11120032' ,'12150026','1260002') then '评论'
when position_id ='90120000' and  cast(concat(countrycode,serial)as string ) in ('468' ,'2150037' ,'385' ,'312' ,'575' ,'670' ,'790064' ,'11120033' ,'12150027') then '点赞'
when position_id ='90120000' and  cast(concat(countrycode,serial)as string ) in ('433' ,'217' ,'320','333','320','333' ,'632' ,'733' ,'933' ,'11120006' ,'1260005') then '分享'
when position_id ='90120000' and  cast(concat(countrycode,serial)as string ) in ('427','431','441' ,'216' ,'327','331','341','342','345' ,'533' ,'633' ,'731' ,'931' ,'11120003' ,'12120002') then '绑定邮箱'
when position_id ='90120000' and  cast(concat(countrycode,serial)as string ) in ('334') then '第三方账号绑定'
when position_id ='90120000' and  cast(concat(countrycode,serial)as string ) in ('328','428') then '填写个人信息'
when position_id ='90100301'  then '吃饭'
when position_id in('90100400','90100401') then  '宝箱'
else '未知' end = points.task_name
GROUP by 1,2,3,4,5,6,7,8,9,12,13,14;
