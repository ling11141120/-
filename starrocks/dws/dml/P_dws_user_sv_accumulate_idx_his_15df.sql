----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_user_sv_accumulate_idx_his_15df
-- workflow_version : 4
-- create_user      : qhr
-- task_name        : P_dws_user_sv_accumulate_idx_his_15df
-- task_version     : 4
-- update_time      : 2026-02-05 14:19:05
-- sql_path         : \starrocks\tbl_dws_user_sv_accumulate_idx_his_15df\P_dws_user_sv_accumulate_idx_his_15df
----------------------------------------------------------------
-- SQL语句
----------------------------------------------------------------
-- 程序功能： 用户域-海剧用户累计指标历史-近15天全量
-- 程序名： P_dws_user_sv_accumulate_idx_his_15df
-- 目标表： dws.dws_user_sv_accumulate_idx_his_15df
-- 负责人： qhr
-- 开发日期： 2025-12-25
----------------------------------------------------------------

insert into dws.dws_user_sv_accumulate_idx_his_15df
select '${bf_1_dt}'    as dt
     , user_id
     , login_days_td
     , login_cnt_td
     , consume_amt_td
     , consume_cnt_td
     , consume_money_amt_td
     , consume_money_cnt_td
     , consume_cert_amt_td
     , consume_cert_cnt_td
     , watch_days_td
     , watch_tv_td
     , watch_cnt_td
     , watch_series_td
     , like_cnt_td
     , like_series_td
     , like_epis_td
     , total_subscribe_amt
     , total_subscribe_cnt
     , total_recharge_amt
     , total_recharge_cnt
     , recharge_avg
     , total_subscribe_refund_cnt
     , total_refund_amt
     , total_refund_cnt
     , mul_subscribe_item
     , has_subscribe
     , idx_ddl
     , sign_card_total_price
     , vip_total_price
     , svip_total_price
  from dws.dws_user_sv_accumulate_idx_di
;
