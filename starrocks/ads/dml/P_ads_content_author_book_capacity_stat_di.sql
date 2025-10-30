----------------------------------------------------------------
-- 程序功能：内容域--译员书籍语言--按天统计字数
-- 程序名： P_ads_content_author_book_capacity_stat_di
-- 目标表： ads.ads_content_author_book_capacity_stat_di
-- 负责人： xjc
-- 开发日期：
-- 版本号： v0.1.0
----------------------------------------------------------------

insert into ads.ads_content_author_book_capacity_stat_di
-- 短剧翻译（取字数）
with sd_trl as (
    select concat(substring(cast(a.BillDate as varchar),1,4)
                  ,'-'
                  ,substring(cast(a.BillDate as varchar),5,2)
                  ,'-01'
                 )                                            as dt
          ,a.AuthorId                                         as author_id
          ,a.SourceBookId                                     as book_id
          ,a.ToLanguage                                       as language_id
          ,a.SourceBookName                                   as book_name
          ,max(1)                                             as type_id
          ,max(a.PenName)                                     as pen_name
          ,max(ifnull(a.RealName,a.PenName))                  as real_name
          ,sum(a.FontLength)                                  as capacity_value
      from ods.ods_tidb_shuangwen_en_translateremuneration    as a
     where a.RoleType = 1    -- 过滤译员
       and a.BookType = 3    -- 过滤短剧
       and a.SourceBookName not like '%素材%'            -- 过滤书籍名称不包含素材
       and a.SourceBookName not like '%短剧剧名&简介%'    -- 过滤书籍名称不包含短剧剧名&简介
       and a.SourceBookName is not  null
       and a.SourceBookName != ''
     group by 1,2,3,4,5
)
-- 短剧审核抽查&初译审核（取字数）
,sd_trl_check as (
    select concat(substring(cast(a.BillDate as varchar),1,4)
                  ,'-'
                  ,substring(cast(a.BillDate as varchar),5,2)
                  ,'-01'
                 )                                            as dt
          ,a.AuthorId                                         as author_id
          ,a.SourceBookId                                     as book_id
          ,a.ToLanguage                                       as language_id
          ,a.SourceBookName                                   as book_name
          ,max(2)                                             as type_id
          ,max(case when a.PenName='王靖怡-意语(766935)' then '王靖怡(766935)'
                    else a.PenName
                end
              )                                               as pen_name
          ,max(ifnull(a.RealName,a.PenName))                  as real_name
          ,sum(a.FontLength)                                  as capacity_value
      from ods.ods_tidb_shuangwen_en_translateremuneration    as a
     where a.RoleType in (6,12)    -- 质检抽查与初译审核
       and a.BookType = 3          -- 过滤短剧
       and a.SourceBookName is not null
       and a.SourceBookName != ''
     group by 1,2,3,4,5
)
-- 测试稿审核（取数据条数）
,test_draft_check as (
    select concat(substring(cast(a.BillDate as varchar),1,4)
                  ,'-'
                  ,substring(cast(a.BillDate as varchar),5,2)
                  ,'-01'
                 )                                          as dt
          ,a.AuthorId                                       as author_id
          ,a.SourceBookId                                   as book_id
          ,a.ToLanguage                                     as language_id
          ,a.SourceBookName                                 as book_name
          ,max(3)                                           as type_id
          ,max(case when a.PenName='王靖怡-意语(766935)' then '王靖怡(766935)'
                    else a.PenName
                end
              )                                             as pen_name
          ,max(ifnull(a.RealName,a.PenName))                as real_name
          ,count(1)                                         as capacity_value
      from ods.ods_tidb_shuangwen_en_translateremuneration  as a
     where a.RoleType in(8,9)    -- 国内测试稿审核，国外测试稿审核
     group by 1,2,3,4,5
)
-- 素材翻译（取字数）
,material_trl as (
    select concat(substring(cast(a.BillDate as varchar),1,4)
                  ,'-'
                  ,substring(cast(a.BillDate as varchar),5,2)
                  ,'-01'
                 )                                            as dt
          ,a.AuthorId                                         as author_id
          ,a.SourceBookId                                     as book_id
          ,a.ToLanguage                                       as language_id
          ,a.SourceBookName                                   as book_name
          ,max(4)                                             as type_id
          ,max(a.PenName)                                     as pen_name
          ,max(ifnull(a.RealName,a.PenName))                  as real_name
          ,sum(a.FontLength)                                  as capacity_value
      from ods.ods_tidb_shuangwen_en_translateremuneration    as a
     where a.RoleType = 1    -- 过滤译员
       and a.BookType = 3    -- 过滤短剧
       and (    a.SourceBookName like '%素材%'            -- 过滤书籍名称包含素材
             or a.SourceBookName like '%短剧剧名&简介%'    -- 过滤书籍名称包含素材
           )
       and a.SourceBookName is not null
       and a.SourceBookName != ''
     group by 1,2,3,4,5
)
-- 词条翻译（取完成字数）
,entry_trl_01 as (
    select cast(date(a.ComplteTime) as varchar)                    as dt
          ,a.InterpreterId                                         as author_id
          ,0                                                       as book_id
          ,a.FLanguage                                             as language_id
          ,max(5)                                                  as type_id
          ,max(concat(a.InterpreterName,'(',a.Interpreter,')'))    as pen_name
          ,max(a.InterpreterName)                                  as real_name
          ,max(null)                                               as book_name
          ,sum(a.NumberWord)                                       as capacity_value
      from ods.ods_mysql_AppTranslationDB_TranslationTask_da       as a
     where a.TaskStatus = 1    -- 翻译状态已完成
       and a.ComplteTime is not null
       and a.InterpreterId is not null
       and a.InterpreterName is not null
     group by 1,2,3,4
)
,entry_trl_02 as (
    select a.dt
          ,a.author_id
          ,a.book_id
          ,a.language_id
          ,a.type_id
          ,ifnull(b.PenName,a.real_name)      as pen_name
          ,ifnull(b.real_name,a.real_name)    as real_name
          ,a.book_name
          ,a.capacity_value
      from entry_trl_01                       as a
      left join (select PenName
                       ,max(RealName)         as real_name
                   from ods.ods_tidb_shuangwen_xx_objectauthor
                  group by PenName
                )                             as b
        on a.real_name = split(b.PenName,'(')[1]
)
,dic_num as (
    select a.CreateTime                                   as dt
          ,a.AuthorId                                     as author_id
          ,a.bookId                                       as book_id
          ,a.ToLanguage                                   as language_id
          ,6                                              as type_id
          ,b.PenName                                      as pen_name
          ,b.RealName                                     as real_name
          ,c.BookName                                     as book_name
          ,a.FontLength                                   as capacity_value
      from ods.ods_edit_book_RemunerationDetail           as a
      join ods.ods_tidb_shuangwen_en_objectbook           as c
        on  a.productid = c.productid
       and a.bookId = c.SwBookId
       and a.ToLanguage = c.ToLanguage
       and c.Status = 1
       and c.ObjectBookType = 1    -- 短剧项目
      left join ods.ods_tidb_shuangwen_xx_objectauthor    as b
        on a.productid = b.productid
       and a.AuthorId = b.AccountId
       and a.ToLanguage = b.ToLanguage
     where RoleType = 18    -- 词典创建
)
-- 将前面计算结果union all在一起
,union_all_result as(
    select md5(concat_ws('_',date(dt)
                        ,author_id
                        ,book_name
                        ,language_id
                        ,type_id
                        ,book_id
                        )
              )        as md5_key
          ,date(dt)    as dt
          ,author_id
          ,book_id
          ,language_id
          ,type_id
          ,case when pen_name='王靖怡-意语(766935)' then '王靖怡(766935)'
                when pen_name='陈佳慧' then '陈佳慧(540469)'
                else pen_name
            end        as pen_name
          ,real_name
          ,book_name
          ,capacity_value
          ,now()       as etl_time
      from sd_trl
     union all
    select md5(concat_ws('_',date(dt)
                        ,author_id
                        ,book_name
                        ,language_id
                        ,type_id
                        ,book_id
                        )
              )        as md5_key
          ,date(dt)
          ,author_id
          ,book_id
          ,language_id
          ,type_id
          ,case when pen_name='王靖怡-意语(766935)' then '王靖怡(766935)'
                when pen_name='陈佳慧' then '陈佳慧(540469)'
                else pen_name
            end        as pen_name
          ,real_name
          ,book_name
          ,capacity_value
          ,now()
      from sd_trl_check
     union all
    select md5(concat_ws('_',date(dt)
                        ,author_id
                        ,book_name
                        ,language_id
                        ,type_id
                        ,book_id
                        )
              )        as md5_key
          ,date(dt)
          ,author_id
          ,book_id
          ,language_id
          ,type_id
          ,case when pen_name='王靖怡-意语(766935)' then '王靖怡(766935)'
                when pen_name='陈佳慧' then '陈佳慧(540469)'
                else pen_name
            end        as pen_name
          ,real_name
          ,book_name
          ,capacity_value
          ,now()
      from test_draft_check
     union all
    select md5(concat_ws('_',date(dt)
                        ,author_id
                        ,book_name
                        ,language_id
                        ,type_id
                        ,book_id
                        )
              )        as md5_key
          ,date(dt)
          ,author_id
          ,book_id
          ,language_id
          ,type_id
          ,case when pen_name='王靖怡-意语(766935)' then '王靖怡(766935)'
                when pen_name='陈佳慧' then '陈佳慧(540469)'
                else pen_name
            end        as pen_name
          ,real_name
          ,book_name
          ,capacity_value
          ,now()
      from material_trl
     union all
    select md5(concat_ws('_',date(dt)
                        ,author_id
                        ,book_name
                        ,language_id
                        ,type_id
                        ,book_id
                        )
              )        as md5_key
          ,date(dt)
          ,author_id
          ,book_id
          ,language_id
          ,type_id
          ,case when pen_name='王靖怡-意语(766935)' then '王靖怡(766935)'
                when pen_name='陈佳慧' then '陈佳慧(540469)'
                else pen_name
            end        as pen_name
          ,real_name
          ,book_name
          ,capacity_value
          ,now()
      from entry_trl_02
     union all
    select md5(concat_ws('_',date(dt)
                        ,author_id
                        ,book_name
                        ,language_id
                        ,type_id
                        ,book_id
                        )
              )        as md5_key
          ,date(dt)
          ,author_id
          ,book_id
          ,language_id
          ,type_id
          ,case when pen_name='王靖怡-意语(766935)' then '王靖怡(766935)'
                when pen_name='陈佳慧' then '陈佳慧(540469)'
                else pen_name
            end        as pen_name
          ,real_name
          ,book_name
          ,capacity_value
          ,now()
      from dic_num
)
select a.md5_key                             as md5_key                 -- md5_key唯一值
      ,a.dt                                  as dt                      -- 日期
      ,a.author_id                           as author_id               -- 译员Id
      ,a.book_id                             as book_id                 -- 书籍Id
      ,a.language_id                         as language_id             -- 目标语言
      ,b.cd_val_desc                         as language_name           -- 目标语言名称
      ,a.type_id                             as type_id                 -- 类型: 1 短剧翻译、2 短剧审核抽查&初译审核、3 测试稿审核、4 素材翻译、5 词条翻译、6 词典字数
      ,a.pen_name                            as pen_name                -- 译名
      ,a.real_name                           as real_name               -- 姓名
      ,a.book_name                           as book_name               -- 书名
      ,a.capacity_value                      as capacity_value          -- 产能
      ,a.etl_time                            as etl_time                -- 数据生成时间
  from union_all_result                      as a
  left join dim.dim_pub_code_mapping_dict    as b
    on a.language_id = b.cd_val
   and b.app_plat='pub'
   and b.cd_col_desc='书籍语言编号'
;