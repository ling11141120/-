----------------------------------------------------------------
-- 程序功能： BI-圣经用户对话分析
-- 程序名： P_ads_bi_bib_usr_dlg_anal
-- 目标表： ads.ads_bi_bib_usr_dlg_anal
-- 负责人： xjc
-- 开发日期： 2025-11-13
-- 版本号： v0.0.0
----------------------------------------------------------------

insert into ads.ads_bi_bib_usr_dlg_anal
select date(a.CreateTime)                            as dt             -- 数据日期
      ,a.UserId                                      as usr_id         -- 用户Id
      ,datediff(a.CreateTime,b.create_time)          as ust            -- 用户活跃时长
      ,count(1)                                      as dlg_num_d      -- 当日对话次数
      ,current_timestamp()                           as etl_time       -- 数据清洗时间
  from ods.ods_tidb_hallow_log_log_chatlog           as a
  left join dim.dim_hallow_user_account_info_view    as b
    on a.UserId=b.id
 where substr(a.CreateTime,1,10) >= '${bf_1_dt}'
 group by 1, 2, 3
;