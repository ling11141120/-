insert into ads.ads_content_author_book_capacity_stat_di
-- 短剧翻译（取字数）
with type1_tmp as (
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
     GROUP BY 1,2,3,4,5
)
-- 短剧审核抽查&初译审核（取字数）
, type2_tmp as (
    select concat(substring(cast(a.BillDate as varchar),1,4)
                  ,'-'
                  ,substring(cast(a.BillDate as varchar),5,2)
                  ,'-01'
                 )                                            as dt
          ,a.AuthorId                                         as author_id
          ,a.SourceBookId                                     as book_id
          ,a.ToLanguage                                       as language_id
          ,a.SourceBookName                                   as book_name
          ,MAX(2)                                             as type_id
          ,MAX(case when a.PenName='王靖怡-意语(766935)' then '王靖怡(766935)'
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
, type3_tmp as (
    select concat(substring(cast(a.BillDate as varchar),1,4)
                  ,'-'
                  ,substring(cast(a.BillDate as varchar),5,2)
                  ,'-01'
                 )                                          as dt
          ,a.AuthorId                                       as author_id
          ,a.SourceBookId                                   as book_id
          ,a.ToLanguage                                     as language_id
          ,a.SourceBookName                                 as book_name
          ,MAX(3)                                           as type_id
          ,MAX(case when a.PenName='王靖怡-意语(766935)' then '王靖怡(766935)'
                    else a.PenName
                end
              )                                             as pen_name
          ,max(ifnull(a.RealName,a.PenName))                as real_name
          ,count(1)                                         as capacity_value
      from ods.ods_tidb_shuangwen_en_translateremuneration    as a
     where a.RoleType in(8,9)    -- 国内测试稿审核，国外测试稿审核
     group by 1,2,3,4,5
)
-- 素材翻译（取字数）
, type4_tmp as (
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
, type5_tmp0 as (
    select cast(date(a.ComplteTime) as varchar)                    as dt
          ,a.InterpreterId                                         as author_id
          ,0                                                       as book_id
          ,a.FLanguage                                             as language_id
          ,max(5)                                                  as type_id
          ,max(concat(a.InterpreterName,'(',a.Interpreter,')'))    as pen_name
          ,max(a.InterpreterName)                                  as real_name
          ,max(null)                                               as book_name
          ,sum(a.NumberWord)                                       as capacity_value
      FROM ods.ods_mysql_AppTranslationDB_TranslationTask_da       as a
     WHERE a.TaskStatus = 1    -- 翻译状态已完成
       and a.ComplteTime is not null
       and a.InterpreterId is not null
       and a.InterpreterName is not null
     GROUP BY 1,2,3,4
)
, type5_tmp as (
    select a.dt
          ,a.author_id
          ,a.book_id
          ,a.language_id
          ,a.type_id
          ,ifnull(b.PenName,a.real_name)      as pen_name
          ,ifnull(b.real_name,a.real_name)    as real_name
          ,a.book_name
          ,a.capacity_value
      from type5_tmp0                         as a
      left join (select PenName
                       ,MAX(RealName)         as real_name 
                   from ods.ods_tidb_shuangwen_xx_objectauthor
                  group by PenName
                )                             as b
        on a.real_name = split(b.PenName,'(')[1]
)
, type6_tmp as (
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
select md5(concat_ws('_',date(dt)
                    ,author_id
                    ,book_name
                    ,language_id
                    ,type_id
                    ,book_id)
          )    as md5_key
      ,date(dt)
      ,author_id
      ,book_id
      ,language_id
      ,type_id
      ,case when pen_name='王靖怡-意语(766935)' then '王靖怡(766935)'
            when pen_name='陈佳慧' then '陈佳慧(540469)'
            else pen_name
        end    as pen_name
      ,real_name
      ,book_name
      ,capacity_value
      ,now()
  from type1_tmp
 union all
select md5(concat_ws('_',date(dt)
                    ,author_id
                    ,book_name
                    ,language_id
                    ,type_id
                    ,book_id)
          )    as md5_key
      ,date(dt)
      ,author_id
      ,book_id
      ,language_id
      ,type_id
      ,case when pen_name='王靖怡-意语(766935)' THEN '王靖怡(766935)'
            when pen_name='陈佳慧' THEN '陈佳慧(540469)'
            ELSE pen_name
        end    as pen_name
      ,real_name
      ,book_name
      ,capacity_value
      ,now()
  from type2_tmp
 union all
select md5(concat_ws('_',date(dt)
                    ,author_id
                    ,book_name
                    ,language_id
                    ,type_id
                    ,book_id)
          )    as md5_key
      ,date(dt)
      ,author_id
      ,book_id
      ,language_id
      ,type_id
      ,case when pen_name='王靖怡-意语(766935)' THEN '王靖怡(766935)'
            when pen_name='陈佳慧' THEN '陈佳慧(540469)'
            ELSE pen_name
        end    as pen_name
      ,real_name
      ,book_name
      ,capacity_value
      ,now()
 from type3_tmp
union all
select md5(concat_ws('_',date(dt)
                    ,author_id
                    ,book_name
                    ,language_id
                    ,type_id
                    ,book_id)
          )    as md5_key
      ,date(dt)
      ,author_id
      ,book_id
      ,language_id
      ,type_id
      ,case when pen_name='王靖怡-意语(766935)' THEN '王靖怡(766935)'
            when pen_name='陈佳慧' THEN '陈佳慧(540469)'
            ELSE pen_name
        end    as pen_name
      ,real_name
      ,book_name
      ,capacity_value
      ,now()
  from type4_tmp
 union all
select md5(concat_ws('_',date(dt)
                    ,author_id
                    ,book_name
                    ,language_id
                    ,type_id
                    ,book_id)
          )    as md5_key
      ,date(dt)
      ,author_id
      ,book_id
      ,language_id
      ,type_id
      ,case when pen_name='王靖怡-意语(766935)' THEN '王靖怡(766935)'
            when pen_name='陈佳慧' THEN '陈佳慧(540469)'
            ELSE pen_name
        end    as pen_name
      ,real_name
      ,book_name
      ,capacity_value
      ,now()
  from type5_tmp
 union all
select md5(concat_ws('_',date(dt)
                    ,author_id
                    ,book_name
                    ,language_id
                    ,type_id
                    ,book_id)
          )    as md5_key
      ,date(dt)
      ,author_id
      ,book_id
      ,language_id
      ,type_id
      ,case when pen_name='王靖怡-意语(766935)' THEN '王靖怡(766935)'
            when pen_name='陈佳慧' THEN '陈佳慧(540469)'
            ELSE pen_name
        end    as pen_name
      ,real_name
      ,book_name
      ,capacity_value
      ,now()
  from type6_tmp
