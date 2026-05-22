----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_short_video_third_and_mail
-- workflow_version : 3
-- create_user      : linq
-- task_name        : ads_bi_short_video_third_and_mail
-- task_version     : 3
-- update_time      : 2023-12-22 18:18:46
-- sql_path         : \starrocks\tbl_ads_bi_short_video_third_and_mail\ads_bi_short_video_third_and_mail
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_bi_short_video_third_and_mail
with active as (
    select dt,a.product_id,
           bitmap_union(to_bitmap(a.user_id)) as active_dau,
           bitmap_union(if(acc.third_party_id in(1,2,3) or acc.pass_word is not null,to_bitmap(a.user_id),to_bitmap(null))) as third_party_dau,
           bitmap_union(if(acc.email is not null or acc.bind_email is not null,to_bitmap(a.user_id),to_bitmap(null))) as mail_dau
    from dws.dws_user_short_video_wide_active_ed a
    left join (
        select product_id,user_id,email,bind_email,pass_word,third_party_id,create_time
        from dim.dim_short_video_user_accountinfo
        )acc on a.product_id=acc.product_id and a.user_id=acc.user_id
    where dt>='${bf_3_dt}' and dt<'${dt}' and a.product_id=6833
    group by 1,2
),newuser as (
    select dt,
           product_id,
           bitmap_union(to_bitmap(user_id)) as new_unt,
           bitmap_union(
               if(
                   (hours_diff(third_login_time,create_time)>=0 and hours_diff(third_login_time,create_time)<24) or
                   (hours_diff(create_password_time,create_time)>=0 and hours_diff(create_password_time,create_time)<24)
                  ,to_bitmap(user_id),to_bitmap(null))) as new_third_party_unt,
           bitmap_union(if(email is not null or bind_email is not null,to_bitmap(user_id),to_bitmap(null))) as new_mail_unt
    from dim.dim_short_video_user_accountinfo
    where date(create_time)>='${bf_3_dt}' and date(create_time)<'${dt}' and product_id=6833
    group by 1,2
)
select newuser.dt,newuser.product_id,active_dau,third_party_dau,mail_dau,new_unt,new_third_party_unt,new_mail_unt,now() as etl_time
from newuser left join active on newuser.dt=active.dt and newuser.product_id=active.product_id
order by 1;
