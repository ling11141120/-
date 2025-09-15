----------------------------------------------------------------
-- 程序功能： 海阅海剧koc用户回收数据结果日志表
-- 程序名： P_ads_srsv_ads_koc_attribution_result_data_log
-- 目标表： ads.ads_srsv_ads_koc_attribution_result_data_log
-- 负责人： qhr
-- 开发日期： 2025-09-11
-- 版本号： v0.0.0
----------------------------------------------------------------

insert into ads.ads_srsv_ads_koc_attribution_result_data_log
select dt
      ,product_id
      ,adid
      ,project_tp
      ,book_id
      ,mt
      ,core
      ,source_chl
      ,chl
      ,current_language
      ,koc_code
      ,dev_unt
      ,koc_amt
      ,koc_amt_after
      ,order_num
      ,koc_amt_14d
      ,koc_amt_after_14d
      ,ad_amt
      ,etl_tm
      ,date_format(now(), '%Y%m%d%H%i%s')    as batch_no
      ,now()                                 as create_time
      ,curdate()                             as create_dt
  from ads.ads_srsv_ads_koc_attribution_result_data
 where dt>='${bf_20_dt}'
   and (    dev_unt>0
         or koc_amt>0
         or koc_amt_after>0
         or koc_amt_14d>0
         or ad_amt>0
       )
;