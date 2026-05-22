----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_user_mail_binding_ed
-- workflow_version : 11
-- create_user      : linq
-- task_name        : dws_user_mail_binding_yesterday
-- task_version     : 8
-- update_time      : 2024-02-09 01:11:07
-- sql_path         : \starrocks\tbl_dws_user_mail_binding_ed\dws_user_mail_binding_yesterday
----------------------------------------------------------------
-- SQL语句
insert into  dws.dws_user_mail_binding_ed
select '${bf_1_dt}' as dt,
       bing.product_id,
       if(acc.CoreVer is null ,1,acc.corever),
       if(acc.mt is null ,0,acc.mt),
       if(date(acc.create_time) = '${bf_1_dt}', 1, 0)         as user_type,
       count(distinct bing.id)                                       as total_cnt,
       count(distinct if(is_facebook_bind_email = 1, bing.id, null)) as fb_bandding_cnt,
       count(distinct if(a.position = 'kefu', a.user_id, null))      as kefu_guidance_cnt,
       count(distinct if(a.position='kefu' and bing.is_facebook_bind_email=1,a.user_id,null)) as kefu_guidance_fb_cnt,
       now() as etl_time
from(
    select product_id, id, is_facebook_bind_email, face_book_bind_email_time, email_bound_time
    from dim.dim_user_other_info_view
    where (date(face_book_bind_email_time) = '${bf_1_dt}') or (date(email_bound_time) = '${bf_1_dt}')
    ) bing
left join (
         select product_id, Id, CoreVer, mt, create_time from dim.dim_user_account_info_view
    )acc on bing.product_id=acc.product_id and bing.id=acc.Id
left join (
    select product_id, user_id,core,mt,position, createtime,date(createtime) as dt
         from dwd.dwd_user_userbindemailpositionlog_view
         where date(createtime) = '${bf_1_dt}'
    )a on bing.product_id=a.product_id and bing.id=a.user_id
group by 1,2,3,4,5;
