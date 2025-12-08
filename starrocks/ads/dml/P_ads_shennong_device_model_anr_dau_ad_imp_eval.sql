----------------------------------------------------------------
-- 程序功能： 神农-机型ANR日活广告影响评估
-- 程序名： P_ads_shennong_device_model_anr_dau_ad_imp_eval
-- 目标表： ads.ads_shennong_device_model_anr_dau_ad_imp_eval
-- 负责人： roger
-- 开发日期：2025/12/8
-- 版本号： v1.0
----------------------------------------------------------------

set cbo_cte_reuse = true -- 开启CTE复用
;

-- 近3日数据重刷
insert into ads.ads_shennong_device_model_anr_dau_ad_imp_eval
with all_product_dev_tmp as (
    select a1.dt
         , a1.core
         , a1.dev_mdl
         , a1.product_id
         , a1.biz_type_cd
         , a1.biz_type_name
      from dim.dim_device_device_model_info_df    as a1
     where a1.dt >= '${bf_3_dt}'
       and a1.dt <= '${bf_1_dt}'
)
, mdl_anr_tmp as (
    -- 广告降权
    select a1.dt                  as dt
         , 1                      as dem_type
         , 'ADs'                  as dem_type_name
         , a2.p_cd_val            as biz_type_cd
         , a1.product_id          as product_id
         , a1.Core                as core
         , a1.manufacturer        as mfr
         , a1.device_model        as dev_mdl
         , date(a1.anr_time)      as anr_ocr_dt
         , date(a1.start_time)    as anr_fch_dt
         , a1.device_guid         as dev_guid
         , a1.anr_count           as imp_num
         , a1.session_count       as sess_num
         , a1.anr_rate            as imp_pct
         , a1.anr_global_rate     as hist_anr_usr_rat
      from dwd.dwd_device_gp_app_anr_di     as a1
      join dim.dim_pub_code_mapping_dict    as a2
        on a2.app_plat = 'beidou'
       and a2.cd_col = 'product_id'
       and a2.p_cd_val is not null
       and a1.product_id = a2.cd_val
     where a1.dt >= '${bf_3_dt}' and a1.dt <= '${bf_1_dt}'
       and a1.product_id <> 6883
       and a1.anr_type = 'ADs'
     union all
      -- PUSH降权
    select a3.dt                                          as dt
         , 2                                              as dem_type
         , 'PUSH'                                         as dem_type_name
         , a4.p_cd_val                                    as biz_type_cd
         , a3.product_id                                  as product_id
         , a3.Core                                        as core
         , substring_index(a3.device_name, ' ', 1)        as mfr
         , substring_index(a3.device_name, ' ', -1)       as dev_mdl
         , date(a3.anr_time)                              as anr_ocr_dt
         , date(a3.start_time)                            as anr_fch_dt
         , a3.device_guid                                 as dev_guid
         , a3.anr_count                                   as imp_num
         , null                                           as sess_num
         , a3.anr_rate                                    as imp_pct
         , a3.anr_global_rate                             as hist_anr_usr_rat
      from dwd.dwd_device_gp_app_anr_di                   as a3
      join dim.dim_pub_code_mapping_dict                  as a4
        on a4.app_plat = 'beidou'
       and a4.cd_col = 'product_id'
       and a4.p_cd_val is not null
       and a3.product_id = a4.cd_val
     where a3.dt >= '${bf_3_dt}' and a3.dt <= '${bf_1_dt}'
       and a3.anr_type = 'PUSH'
)
, mdl_dau_ad_uv_tmp as (
    select dt
         , biz_type_cd
         , product_id
         , core
         , dev_mdl
         , biz_type_name
         , svr_dau
         , ad_uv
         , ad_ttl_amt
         , ad_rpc
         , web_ad_amt
         , web_ad_rpc
         , med_sdk_ad_amt
         , med_sdk_ad_rpc
         , clk_uv
         , push_act_clk_uv
         , tp_rev
         , push_af_1h_tp_rev
      from dws.dws_device_model_analyze_di
     where dt >= '${bf_3_dt}'
       and dt <= '${bf_1_dt}'
)

select a1.dt
      ,1              as dem_type
      ,a1.biz_type_cd
      ,a1.product_id
      ,a1.core
      ,a1.dev_mdl
      ,'ADs'          as dem_type_name
      ,a1.biz_type_name
      ,a4.cd_val_desc as prd_name
      ,a2.mfr
      ,a2.anr_ocr_dt
      ,a2.anr_fch_dt
      ,a2.dev_guid
      ,a2.imp_num
      ,a2.sess_num
      ,a2.imp_pct
      ,a2.hist_anr_usr_rat
      ,a3.svr_dau
      ,a3.ad_uv
      ,a3.ad_ttl_amt
      ,a3.ad_rpc
      ,a3.web_ad_amt
      ,a3.web_ad_rpc
      ,a3.med_sdk_ad_amt
      ,a3.med_sdk_ad_rpc
      ,a3.clk_uv
      ,a3.push_act_clk_uv
      ,a3.tp_rev
      ,a3.push_af_1h_tp_rev
      ,now()          as etl_tm
  from all_product_dev_tmp                   as a1
  left join mdl_anr_tmp                      as a2
    on a1.product_id = a2.product_id
   and a1.core = a2.core
   and a1.dev_mdl = a2.dev_mdl
   and a2.dem_type = 1
   and a1.dt = a2.dt
  left join mdl_dau_ad_uv_tmp                as a3
    on a1.product_id = a3.product_id
   and a1.core = a3.core
   and a1.dev_mdl = a3.dev_mdl
   and a1.dt = a3.dt
  left join dim.dim_pub_code_mapping_dict    as a4
    on a4.app_plat = 'pub'
   and a4.cd_col = 'product_id'
   and a1.product_id = a4.cd_val
 union all
select a5.dt
      , 2              as dem_type
      , a5.biz_type_cd
      , a5.product_id
      , a5.core
      , a5.dev_mdl
      , 'PUSH'         as dem_type_name
      , a5.biz_type_name
      , a8.cd_val_desc as prd_name
      , a6.mfr
      , a6.anr_ocr_dt
      , a6.anr_fch_dt
      , a6.dev_guid
      , a6.imp_num
      , a6.sess_num
      , a6.imp_pct
      , a6.hist_anr_usr_rat
      , a7.svr_dau
      , a7.ad_uv
      , a7.ad_ttl_amt
      , a7.ad_rpc
      , a7.web_ad_amt
      , a7.web_ad_rpc
      , a7.med_sdk_ad_amt
      , a7.med_sdk_ad_rpc
      , a7.clk_uv
      , a7.push_act_clk_uv
      , a7.tp_rev
      , a7.push_af_1h_tp_rev
      , now()          as etl_tm
  from all_product_dev_tmp                   as a5
  left join mdl_anr_tmp                      as a6
    on a5.product_id = a6.product_id
   and a5.core = a6.core
   and a5.dev_mdl = a6.dev_mdl
   and a6.dem_type = 2
   and a5.dt = a6.dt
  left join mdl_dau_ad_uv_tmp                as a7
    on a5.product_id = a7.product_id
   and a5.core = a7.core
   and a5.dev_mdl = a7.dev_mdl
   and a5.dt = a7.dt
  left join dim.dim_pub_code_mapping_dict    as a8
    on a8.app_plat = 'pub'
   and a8.cd_col = 'product_id'
   and a5.product_id = a8.cd_val
;
