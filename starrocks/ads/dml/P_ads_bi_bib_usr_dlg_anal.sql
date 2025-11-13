----------------------------------------------------------------
-- 程序功能： BI-圣经用户对话分析
-- 程序名： P_ads_bi_bib_usr_dlg_anal
-- 目标表： ads.ads_bi_bib_usr_dlg_anal
-- 负责人： xjc
-- 开发日期： 2025-11-13
-- 版本号： v0.0.0
----------------------------------------------------------------

insert into ads.ads_bi_bib_usr_dlg_anal
select date(a1.CreateTime)                           as dt           -- 数据日期
      ,a1.UserId                                     as usr_id       -- 用户Id
      ,datediff(a1.CreateTime,a2.create_time)        as ust          -- 用户活跃时长
      ,count(1)                                      as dlg_num_d    -- 当日对话次数
      ,current_timestamp()                           as etl_time     -- 数据清洗时间
  from ods.ods_tidb_hallow_log_log_chatlog           as a1
  left join dim.dim_hallow_user_account_info_view    as a2
    on a1.UserId = a2.id
 where substr(a1.CreateTime,1,10) >= '${bf_1_dt}'
 group by 1, 2, 3
;