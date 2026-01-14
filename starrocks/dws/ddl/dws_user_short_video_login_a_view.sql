create or replace view dws.dws_user_short_video_login_a_view (
     dt               comment "分区日期"
    ,product_id       comment "product_id"
    ,user_id          comment "用户id"
    ,login_days_td    comment "累计登录天数"
    ,new_login_tm     comment "最新登录时间"
)
comment "用户域-用户登录累计指标"
as
select acc.dt               as dt
     , 6833                 as product_id
     , acc.user_id          as user_id
     , acc.login_days_td    as login_days_td
     , stat.new_login_tm    as new_login_tm
  from dws.dws_user_sv_accumulate_idx_his_15df     as acc
  left join dws.dws_user_sv_status_idx_his_15df    as stat
    on acc.dt = stat.dt
   and acc.user_id = stat.user_id
;