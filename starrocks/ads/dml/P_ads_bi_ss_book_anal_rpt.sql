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
    ,book_zh_name       -- 书籍中文名称
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
-- 短篇书籍基本信息
with ss_book_basic_info as (
    select a1.productid       as product_id
          ,a1.BookID          as book_id
          ,a2.BookLanguage    as lang_cd
          ,a3.cd_val_desc     as lang_name
          ,a2.bookno          as book_cd
          ,a1.BookName        as book_zh_name    -- fix: 不是中文名
          ,a1.Status          as book_stat_cd    -- fix: 枚举值只有1，应该不是这个
          ,null               as book_stat_name
          ,a4.build_time      as pub_dt
      from ods.ods_book_novel_book_m                    as a1
      left join ods.ods_tidb_sharpengine_bi_if_books    as a2
        on a1.productid = a2.productid
       and a1.bookid = a2.bookid
      left join dim.dim_pub_code_mapping_dict           as a3
        on a2.BookLanguage = a3.cd_val
       and a3.app_plat = 'pub'
       and a3.cd_col = 'lang_cd'
      left join dim.dim_shuangwen_book_read_consume_info    as a4
        on a1.productid = a4.product_id
       and a1.bookid = a4.book_id
       and a4.sexy2 < 4
     where a1.StoryType = 1
       and coalesce(a2.booknoseries, '-99') in ('PD', 'AD', 'JD')
)