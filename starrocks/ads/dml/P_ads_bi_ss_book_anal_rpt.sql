----------------------------------------------------------------
-- 程序功能： bi-短篇书籍分析报表
-- 程序名： P_ads_bi_ss_book_anal_rpt.sql
-- 目标表： ads.ads_bi_ss_book_anal_rpt
-- 负责人： qhr/wx
-- 开发日期： 2025-10-17
-- 版本号： v0.1.0
----------------------------------------------------------------

insert into ads.ads_bi_ss_book_anal_rpt (
     dt                 -- 日期
    ,product_id         -- product_id
    ,book_id            -- 书籍id
    ,lang_cd            -- 语言编码
    ,lang_name          -- 语言名称
    ,book_cd            -- 书籍代号
    ,book_name          -- 书籍名称
    ,book_stat          -- 书籍状态
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
    select '${bf_1_dt}'               as dt
          ,a1.productid               as product_id
          ,a1.BookID                  as book_id
          ,a2.lang_cd                 as lang_cd
          ,a2.lang_name               as lang_name
          ,a2.bookno                  as book_cd
          ,a1.BookName                as book_name
          ,case when a7.book_st = 0 then '未上架'
                when a7.book_st = 1 then '停更'
                when a7.book_st = 3 then '机翻'
                when a7.book_st = 4 then '质检'
                when a7.book_st = 5 then '精修'
                when a7.book_st = 2 then case when a7.chapter_st = 3 then '精修完本'
                                              when a7.to_language = 322 and a7.chapter_st=2 then '质检完本'
                                              else '机翻完本'
                                          end
                else '机翻完本'
            end                       as book_stat
          ,a3.build_time              as pub_dt
          ,a3.normal_chapter_num_f    as pub_chap
          ,case when a4.BookName is not null and a4.CoverSrc is not null then '是'
                else '否'
            end                       as mat_is_cmp
          ,a8.ast_cmp_dt              as ast_cmp_dt
          ,a5.SignTime                as zhtw_sig_ctr_dt
          ,a6.ph2_test_bgn_dt         as ph2_test_bgn_dt
          ,a6.ph1_test_bgn_dt         as ph1_test_bgn_dt
          ,a9.ttl_chap_len            as pub_wc
          ,a9.ttl_chap_sum            as mc_trl_wc
      from ods.ods_book_novel_book_m                                           as a1
      left join (select b1.productid
                       ,b1.bookid
                       ,b1.bookno
                       ,b1.booknoseries
                       ,b1.BookLanguage
                       ,b2.cd_val         as lang_cd
                       ,b2.cd_val_desc    as lang_name
                   from ods.ods_tidb_sharpengine_bi_if_books                   as b1
                   left join dim.dim_pub_code_mapping_dict                     as b2
                     on b1.BookLanguage = b2.p_cd_val
                    and b2.app_plat = 'pub'
                    and b2.cd_col = 'book_lang_cd'
                )                                                              as a2
        on a1.bookid = a2.bookid
       and a1.Language = a2.BookLanguage
      left join dim.dim_shuangwen_book_read_consume_info                       as a3    ---去掉了productid的关联条件
        on a1.bookid = a3.book_id
       and a3.sexy2 < 4
      left join ods.ods_edit_book                                              as a4    ---去掉了productid的关联条件
        on a1.bookid = (a4.BookId*1000+a4.SiteId)
      left join ods.ods_mysql_zhangzhong_xzz_Book                              as a5
        on a5.StoryType = 1
       and a2.bookno = a5.BookCode
      left join (select b3.PutProductId
                       ,b3.CodeId
                       ,min(case when b3.CodeStage = 2 and b3.PlanRound = 1 then b3.BeginDate
                                 else null
                             end
                           )              as ph2_test_bgn_dt
                       ,min(case when b3.CodeStage = 1 and b3.PlanRound = 1 then b3.BeginDate
                                 else null
                             end
                           )              as ph1_test_bgn_dt
                  from ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan    as b3
                 where b3.ProjectCode = 1
                   and b3.IsDel = 0
                   and coalesce(b3.SourceChl, '') <> ''
                 group by 1, 2
                )                                                              as a6
        on a1.productid = a6.PutProductId
       and a1.bookid = a6.CodeId
      left join dwd.dwd_edit_book_languagebooktotal_da                         as a7
        on a7.dt = '${bf_1_dt}'
       and a1.productid = a7.product_id
       and a1.bookid = a7.to_book_id
      left join (select b4.Code
                       ,b4.CurrentLanguage
                       ,min(b4.BmCompeleteTime)    as ast_cmp_dt
                   from ods.ods_tidb_sharpengine_ads_asset_prod_MaterialUploadLog  as b4
                  where b4.TgtType=1
                  group by 1, 2
                )                                                              as a8
        on a2.bookno=a8.Code
       and a2.BookLanguage=a8.CurrentLanguage
      left join  (select productid
                        ,bookid
                        ,sum(case when IsSuccess = 1 then FontLength
                                  else null
                              end
                            )                      as ttl_chap_len
                        ,sum(FontLength)    as ttl_chap_sum
                    from ods.ods_tidb_shuangwen_xx_chapter
                    group by 1, 2
                 )                                                             as a9
        on a4.productid = a9.productid
       and a4.bookid = a9.bookid
     where a1.StoryType = 1
       and coalesce(a2.booknoseries, '-99') in ('PD', 'AD', 'JD', 'ZD')
)
-- 书籍章节翻译信息
, book_chap_trl_info as (
    select a1.productid
          ,a1.BookCode
          ,a1.ToLanguage                                                                            as lang_cd
          ,min(a2.CompleteTime)                                                                     as bgn_trl_dt
          ,max(case when a2.ChapterNumber = (select max(b1.ChapterNumber)
                                               from ods.ods_tidb_shuangwen_xx_objectchapter           as b1
                                              where a1.productid = b1.productid
                                                and a1.id = b1.objectbookid
                                            )
                    then a2.CompleteTime 
                end
              )                                                                                     as cmp_trl_dt
          ,datediff(max(case when a2.ChapterNumber = (select max(b1.ChapterNumber)
                                                        from ods.ods_tidb_shuangwen_xx_objectchapter  as b1
                                                       where a1.productid = b1.productid
                                                         and a1.id = b1.objectbookid
                                                     ) 
                             then a2.CompleteTime 
                         end
                       ) , min(a2.CompleteTime))                                                    as trl_days
          ,concat(sum(case when a2.IsComplete = 2 then 1 else 0 end ), '/', count(a2.Id))           as trl_prg
          ,max(case when a3.RoleType = 1 then a2.InterpreterId else 0 end)                          as trl_emp
          ,max(case when a3.RoleType = 1 then a2.InterpreterName else 'Robot' end)                  as trl_emp_name
          ,sum(a2.ForeignLength)                                                                    as qa_wc
          ,count(a2.Id)                                                                             as ttl_chap_num
          ,min(case when a3.RoleType=12 then a3.CreateTime else null end )                          as rev_sc_dt
          ,sum(case when a3.dt >= date_format('${bf_1_dt}', '%Y-%m-01') and a3.dt <='${bf_1_dt}' and a3.CurrencyType=1 then a3.TotalPrice
                    when a3.dt >= date_format('${bf_1_dt}', '%Y-%m-01') and a3.dt <='${bf_1_dt}' and a3.CurrencyType=2 then a3.TotalPrice*6.5
                    else 0
                end
              )                                                                              as trl_cost_mon
      from ods.ods_tidb_shuangwen_en_objectbook                 as a1
      left join ods.ods_tidb_shuangwen_xx_objectchapter         as a2
        on a1.productid = a2.productid
       and a1.id = a2.objectbookid
     left join (select productid
                      ,objectbookid
                      ,max(ChapterNumber)        as max_chapter_number
                 from ods.ods_tidb_shuangwen_xx_objectchapter
                group by 1, 2
               )                                                as b1
            on a1.productid = b1.productid
           and a1.id = b1.objectbookid
      left join ods.ods_tidb_shuangwen_en_translateremuneration as a3
        on a1.SwBookId = a3.BookId
       and a1.ToLanguage = a3.ToLanguage
       and a2.Id = a3.ObjectChapterId
     group by 1, 2, 3
)
--书籍本月、近30天、近7天收入信息
, book_income_info as (
    select product_id
          ,book_id
          ,sum(case when dt >= date_format('${bf_1_dt}', '%Y-%m-01') and dt <='${bf_1_dt}' then (amount / 100)*6.5
                    else 0
                end
              )    as amt_mon
          ,sum(case when dt >= date_sub('${bf_1_dt}',interval 29 day) and dt <= '${bf_1_dt}' then (amount / 100)*6.5
                    else 0
                end
              )    as amt_30d
          ,sum(case when dt >= date_sub('${bf_1_dt}',interval 6 day) and dt <= '${bf_1_dt}' then (amount / 100)*6.5
                    else 0
                end
              )    as amt_7d
      from dws.dws_consume_user_consume_ed
     where types = 1
       and dt >= date_sub('${bf_1_dt}',interval 29 day)
       and dt <= '${bf_1_dt}'
     group by 1,2
)
select a1.dt                 -- 日期
      ,a1.product_id         -- product_id
      ,a1.book_id            -- 书籍id
      ,a1.lang_cd            -- 语言编码
      ,a1.lang_name          -- 语言名称
      ,a1.book_cd            -- 书籍代号
      ,a1.book_name          -- 书籍名称
      ,a1.book_stat          -- 书籍状态
      ,a1.pub_dt             -- 上架日期
      ,a2.bgn_trl_dt         -- 开始翻译日期
      ,a2.cmp_trl_dt         -- 完成翻译日期
      ,a2.trl_days           -- 翻译天数
      ,a2.trl_prg            -- 翻译进度
      ,a2.trl_emp            -- 译员id
      ,a2.trl_emp_name       -- 译员名称
      ,a1.mc_trl_wc          -- 机翻字数
      ,a2.qa_wc              -- 质检字数
      ,a1.pub_wc             -- 发布字数
      ,a2.ttl_chap_num       -- 总章节数
      ,a1.pub_chap           -- 发布章节
      ,a1.mat_is_cmp         -- 物料是否齐全
      ,a1.ast_cmp_dt         -- 素材完成日期
      ,a2.rev_sc_dt          -- 审核抽查日期
      ,a1.zhtw_sig_ctr_dt    -- 繁体签约日期
      ,a1.ph2_test_bgn_dt    -- 第二阶段测试开始日期
      ,a1.ph1_test_bgn_dt    -- 第一阶段测试开始日期
      ,a2.trl_cost_mon       -- 本月翻译成本
      ,a3.amt_mon            -- 本月收入
      ,a3.amt_30d            -- 近30天收入
      ,a3.amt_7d             -- 近7天收入
  from ss_book_dim_info           as a1
  left join book_chap_trl_info    as a2
    on a1.book_cd = a2.BookCode
   and a1.lang_cd = a2.lang_cd
  left join book_income_info      as a3
    on a1.product_id = a3.product_id
   and a1.book_id = a3.book_id