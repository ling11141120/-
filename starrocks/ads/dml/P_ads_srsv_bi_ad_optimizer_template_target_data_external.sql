----------------------------------------------------------------
-- 程序功能： 模板维度基建上限
-- 程序名： P_ads_srsv_bi_ad_optimizer_template_target_data_external
-- 目标表： ads.ads_srsv_bi_ad_optimizer_template_target_data_external
-- 负责人： 050239
-- 开发日期：2026-05-26
----------------------------------------------------------------

insert into ads.ads_srsv_bi_ad_optimizer_template_target_data_external
select dt
     , book_id
     , template_id
     , source2
     , project_code
     , core
     , ''                 as ad_optimizer_uid
     , product
     , days
     , weekdays
     , book_code
     , languageid
     , current_language2
     , ''                 as ad_optimizer_group
     , ''                 as nick_name
     , template_name
     , adset_num
     , spend
     , d0_amt
     , std_amt
     , reg_num
     , reg_num_all
     , reg_num_new
     , new_amt_rate
     , old_spend
     , old_d0_amt
     , old_std_amt
     , days_book
     , regnum_new_7d
     , regnum_all_7d
     , spend_10d
     , adset_num_10d
     , days_10d
     , d0_amt_10d
     , std_amt_10d
     , d0_amt_all
     , std_amt_all
     , d0_amt_pow
     , std_amt_pow
     , d0_amt_pow_old
     , std_amt_pow_old
     , d0_amt_af
     , std_amt_af
     , code_stage
     , code_lv
     , test_status
     , begin_date
     , end_date
     , ''                 as frt_nickname
     , ''                 as nick_name_max
     , off_begindate
     , off_enddate
     , lang
     , lang_rate
     , group_spend
     , sunday_rate
     , friday_rate
     , base_rate
     , new_std
     , old_std
     , log_num
     , log_num_median
     , exp_a
     , new_r0_rate
     , non_compliance_exp
     , spend_exp
     , weekdays_p
     , newamt_rate
     , R0_new
     , R0_old
     , R0_bf1
     , old_R0_bf1
     , growth_base
     , growth_exp
     , spend_rate
     , growth_rate
     , adsetnum_1
     , adsetnum_2
     , has_plan
     , adsetnum_plan
     , etl_tm
  from ads.ads_srsv_bi_ad_optimizer_template_target_data
;
