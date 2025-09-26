----------------------------------------------------------------
-- 程序功能： bi-短篇书籍分析报表
-- 程序名： P_ads_bi_ss_book_anal_rpt.sql
-- 目标表： ads.ads_bi_ss_book_anal_rpt
-- 负责人： qhr/wx
-- 开发日期： 2023-09-24
-- 版本号： v0.0.0
----------------------------------------------------------------

insert into ads.ads_bi_ss_book_anal_rpt (
     dt                 -- 日期
    ,product_id         -- product_id
    ,book_id            -- 书籍id
    ,lang_cd            -- 语言编码
    ,lang_name          -- 语言名称
    ,book_cd            -- 书籍代号
    ,book_name          -- 书籍名称
    ,book_stat_cd       -- 书籍状态编码
    ,book_stat_name     -- 书籍状态名称
    ,pub_dt             -- 上架日期
    ,bgn_trl_dt         -- 开始翻译日期
    ,cmp_trl_dt         -- 完成翻译日期
    ,trl_days           -- 翻译天数
    ,trl_prg            -- 翻译进度
    ,trl_emp            -- 译员id
    ,trl_emp_name       -- 译员名称
    ,mc_trl_wc          -- 机翻字数
    ,qa_wc              -- 质检字数
    ,pub_wc             -- 发布字数
    ,ttl_chap_num       -- 总章节数
    ,pub_chap           -- 发布章节
    ,mat_is_cmp         -- 物料是否齐全
    ,ast_cmp_dt         -- 素材完成日期
    ,rev_sc_dt          -- 审核抽查日期
    ,zhtw_sig_ctr_dt    -- 繁体签约日期
    ,ph2_test_bgn_dt    -- 第二阶段测试开始日期
    ,ph1_test_bgn_dt    -- 第一阶段测试开始日期
    ,trl_cost_mon       -- 本月翻译成本
    ,amt_mon            -- 本月收入
    ,amt_30d            -- 近30天收入
    ,amt_7d             -- 近7天收入
)
-- 短篇书籍维度信息
with ss_book_dim_info as (
    select a1.productid               as product_id
          ,a1.BookID                  as book_id
          ,a2.BookLanguage            as lang_cd
          ,a3.cd_val_desc             as lang_name
          ,a2.bookno                  as book_cd
          ,a1.BookName                as book_name
          ,a1.Status                  as book_stat_cd    -- fix: 枚举值只有1，应该不是这个
          ,null                       as book_stat_name
          ,a4.build_time              as pub_dt
          ,a4.normal_chapter_num_f    as pub_chap
          ,a5.Status                  as mat_is_cmp
      from ods.ods_book_novel_book_m                        as a1
      left join ods.ods_tidb_sharpengine_bi_if_books        as a2
        on a1.productid = a2.productid
       and a1.bookid = a2.bookid
      left join dim.dim_pub_code_mapping_dict               as a3
        on a2.BookLanguage = a3.cd_val
       and a3.app_plat = 'pub'
       and a3.cd_col = 'lang_cd'
      left join dim.dim_shuangwen_book_read_consume_info    as a4
        on a1.productid = a4.product_id
       and a1.bookid = a4.book_id
       and a4.sexy2 < 4
      left join ods.ods_edit_book                           as a5
        on a1.productid = a5.productid
       and a1.bookid = (a5.BookId*1000+a5.SiteId)
     where a1.StoryType = 1
       and coalesce(a2.booknoseries, '-99') in ('PD', 'AD', 'JD')
)
-- 书籍章节翻译信息
, book_chap_trl_info as (
    select a1.productid
          ,a1.BookCode
          ,a4.cd_val                                                                         as lang_cd
          ,min(a2.CompleteTime)                                                              as bgn_trl_dt
          ,max(a2.CompleteTime)                                                              as cmp_trl_dt
          ,datediff(max(a2.CompleteTime), min(a2.CompleteTime))                              as trl_days
          ,concat(sum(case when a2.IsComplete = 2 then 1 else 0 end ), '/', count(a2.Id))    as trl_prg
          ,group_concat(distinct a2.InterpreterId)                                           as trl_emp
          ,group_concat(distinct a2.InterpreterName)                                         as trl_emp_name
          ,sum(a2.RobotLength)                                                               as mc_trl_wc
          ,sum(a2.RobotLength)                                                               as qa_wc
          ,sum(a2.ForeignLength)                                                             as pub_wc
          ,count(a2.Id)                                                                      as ttl_chap_num
      from ods.ods_tidb_shuangwen_en_objectbook            as a1
      left join ods.ods_tidb_shuangwen_xx_objectchapter    as a2
        on a1.id = a2.objectbookid
       and a1.productid = a2.productid
      left join dim.dim_pub_code_mapping_dict              as a3
        on a1.ToLanguage = a3.cd_val
       and a3.app_plat = 'pub'
       and a3.cd_col = 'book_lang_cd'
      left join dim.dim_pub_code_mapping_dict              as a4
        on a3.cd_val_desc = a4.cd_val_desc
       and a4.app_plat = 'pub'
       and a4.cd_col = 'lang_cd'
     group by 1, 2, 3
)
select a1.product_id
      ,a1.book_id
      ,a1.lang_cd
      ,a1.lang_name
      ,a1.book_cd
      ,a1.book_name
      ,a1.book_stat_cd
      ,a1.book_stat_name
      ,a1.pub_dt
      ,a1.pub_chap
      ,a1.mat_is_cmp
      ,a2.bgn_trl_dt
      ,a2.cmp_trl_dt
      ,a2.trl_days
      ,a2.trl_prg
      ,a2.trl_emp
      ,a2.trl_emp_name
      ,a2.mc_trl_wc
      ,a2.qa_wc
      ,a2.pub_wc
      ,a2.ttl_chap_num
  from ss_book_dim_info           as a1
  left join book_chap_trl_info    as a2
    on a1.product_id = a2.productid
   and a1.book_id = a2.BookCode
   and a1.lang_cd = a2.lang_cd
