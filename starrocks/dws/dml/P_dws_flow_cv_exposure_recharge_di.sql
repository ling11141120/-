----------------------------------------------------------------
-- 程序功能： 国剧充值档位曝光充值转化数据处理，融合优化师、充值模板等维度
-- 程序名： P_dws_flow_cv_exposure_recharge_di
-- 目标表： dws.dws_flow_cv_exposure_recharge_di
-- 负责人： yanxh
-- 开发日期：2026-06-08
----------------------------------------------------------------

-- 前置SQL语句
delete from dws.dws_flow_cv_exposure_recharge_di where dt='${bf_1_dt}';

-- SQL语句
insert into dws.dws_flow_cv_exposure_recharge_di
with exp_user as (
    select ex.dt
         , ex.cz_template_id
         , ex.cz_template_name
         , ex.app_id
         , ex.real_recharge
         , ex.login_id                   as user_id
         , ex.shortplay_id
         , b.tv_name
         , if(d.tps is null , 1 , d.tps) as recharge_tps
         , ex.event_tm
      from ods_log.ods_sensors_cd_video_production_rechargeexposure as ex
      left join dim.dim_cn_a_tv_view as b
        on ex.shortplay_id = b.tv_id
      left join dim.dim_video_cn_accountinfo_view as c
        on ex.login_id = c.video_user_id
      -- 通过表C的机构id 关联来区别充值来源
      left join (select distinct ref_id
                      , 2               as tps
                   from dim.dim_ads_role_users_view
                  where role_json like '%middleman%'
                    and  operation_type = 2
                  union all
                 select ref_id
                      , 3      as tps
                   from dim.dim_ads_role_users_view
                  where type = 2
                  union all
                 select ref_id
                      , 4      as tps
                   from dim.dim_ads_role_users_view
                  where type = 3
                ) as d
        on c.middle_man_id = d.ref_id
     where ex.dt = '${bf_1_dt}'
       and ex.product_id = 6883
       and ex.cz_template_id is not null
       and ex.cz_template_id != ''
)
, ads as (
    select exp_user.dt
         , ad.ads_optimizer
         , exp_user.cz_template_id
         , exp_user.cz_template_name
         , exp_user.app_id
         , exp_user.real_recharge
         , exp_user.user_id
         , exp_user.shortplay_id
         , exp_user.tv_name
         , exp_user.recharge_tps
         , exp_user.event_tm
      from exp_user
      --获取近30天内最新一条数据的优化师名字字段
      left join (select user_id
                      , ads_optimizer
                   from (select a.Unique_CdReaderId as user_id
                              , a.ad_id
                              , b.ads_optimizer
                              , max(a.dt)           as dt
                           from dwd.dwd_user_install_info_ed_view     as a
                           left join dwd.dwd_advertisement_adext_view as b
                             on a.ad_id = b.ad_id
                          where a.dt >= date_sub('${bf_1_dt}', interval 30  day)
                            and a.Product_Id = 6883
                            and a.ad_id is not null
                          group by 1, 2, 3
                        ) as v
                ) as ad
        on exp_user.user_id = ad.user_id
)
, re as (
    select dt
         , cz_template_id
         , cz_template_name
         , app_id
         , real_recharge
         , ads_optimizer
         , user_id
         , event_tm
      from (select ads.dt
                 , ads.user_id
                 , ads.app_id
                 , ads.cz_template_id
                 , ads.cz_template_name
                 , ads.real_recharge
                 , ads.ads_optimizer
                 , ads.event_tm
                 , b.create_time
                 , timeDIFF(b.create_time, ads.event_tm ) as time_diff
                 , row_number()over (partition by ads.dt, ads.user_id , ads.app_id, ads.cz_template_id, ads.cz_template_name, ads.real_recharge, ads.ads_optimizer
                                         order by timeDIFF(b.create_time, ads.event_tm )
                                    )                     as rk
              from ads
              join (select a.dt
                         , a.video_user_id as user_id
                         , b.template_id
                         , a.amount / 100  as recharge_amt
                         , a.create_time
                      from dwd.dwd_trade_video_cn_payorder_view                             as a
                      -- 获取用户的充值模板id （通过充值选项id来关联获取）
                      left join ods.ods_tidb_cdvideo_tidb_xcx_sync_recharge_template_option as b
                        on a.option_snap_shot_id = b.option_snapshot_id
                     where a.dt = '${bf_1_dt}'
                       and  a.coo_order_status = 1
                       and a.test_flag = 0
                   ) as b
                on ads.dt = b.dt
               and ads.user_id = b.user_id
               and ads.cz_template_id = b.template_id
               and ads.real_recharge = b.recharge_amt
               and b.create_time >= ads.event_tm
           ) as x
     where rk = 1
)
select ads.dt
     , ads.ads_optimizer
     , ads.cz_template_id
     , ads.cz_template_name
     , if(ads.app_id = 'tt04bb72069b87c57401', '抖音', '微信') as product_tps
     , ads.real_recharge
     , ads.user_id                                         as exp_user
     , re.user_id                                          as recharge_user
     , ads.shortplay_id
     , ads.tv_name
     , ads.recharge_tps
     , now()                                               as etl_tm
  from ads
  left join re
    on ads.dt = re.dt
   and  ads.cz_template_id = re.cz_template_id
   and ads.cz_template_name = re.cz_template_name
   and ads.app_id = re.app_id
   and ads.real_recharge = re.real_recharge
   and ads.user_id = re.user_id
   and  ads.event_tm = re.event_tm
;
