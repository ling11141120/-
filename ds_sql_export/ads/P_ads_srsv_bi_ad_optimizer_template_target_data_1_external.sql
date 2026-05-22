----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_srsv_bi_ad_optimizer_template_target_data_1
-- workflow_version : 37
-- create_user      : qhr
-- task_name        : P_ads_srsv_bi_ad_optimizer_template_target_data_1_external
-- task_version     : 30
-- update_time      : 2026-03-27 17:33:46
-- sql_path         : \starrocks\tbl_ads_srsv_bi_ad_optimizer_template_target_data_1\P_ads_srsv_bi_ad_optimizer_template_target_data_1_external
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_srsv_bi_ad_optimizer_template_target_data_1_external
select dt
     , book_id
     , template_id
     , source2
     , project_code
     , core
     , product
     , days
     , weekdays
     , book_code
     , languageid
     , current_language2
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
     , opt_eid
     , opt_name
     , auto_ce_type_cd
     , auto_ce_type_name
     , is_fst_infra
     , init_infra_num
     , is_new_group_ce
     , spend1
     , d0_amt1
     , std_amt1
     , d0_amt_pow1
     , std_amt_pow1
     , etl_tm
from ads.ads_srsv_bi_ad_optimizer_template_target_data_1
;
