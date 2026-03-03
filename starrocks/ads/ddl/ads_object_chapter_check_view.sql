create or replace view ads.ads_object_chapter_check_view (
     ProductId         comment "产品Id"
    ,Id                comment "Id"
    ,ChapterId         comment "章节Id"
    ,RoleType          comment "角色类型 1:质检, 2:一校, 3:二校"
    ,AuthorId          comment "译员Id"
    ,PenName           comment "译名"
    ,AuditAuthorId     comment "抽查人员Id"
    ,AuditPenName      comment "抽查人员译名"
    ,ObjectBookId      comment "项目图书Id"
    ,BookId            comment "书籍Id"
    ,ChapterName       comment "章节名"
    ,BookName          comment "书籍名称"
    ,Status            comment "状态 0:无法抽查、 1:未抽查、2:待审核、3:待修改、4:抽查完毕、5:抽查中"
    ,CreateTime        comment "创建时间"
    ,UpdateTime        comment "更新时间"
    ,ToLanguage        comment "语言"
    ,CompletionTime    comment "完成时间"
    ,DelStatus         comment "删除状态"
    ,Remark            comment "备注"
    ,FontLength        comment "字数"
    ,FirstPercent      comment "初始修改比例"
    ,ModifyPercent     comment "修改比例"
) 
comment "抽查列表"
as 
select
     a1.ProductId         as ProductId         -- 产品Id
    ,a1.Id                as Id                -- Id
    ,a1.ChapterId         as ChapterId         -- 章节Id
    ,a1.RoleType          as RoleType          -- 角色类型 1:质检, 2:一校, 3:二校
    ,a1.AuthorId          as AuthorId          -- 译员Id
    ,a1.PenName           as PenName           -- 译名
    ,a1.AuditAuthorId     as AuditAuthorId     -- 抽查人员Id
    ,a1.AuditPenName      as AuditPenName      -- 抽查人员译名
    ,a1.ObjectBookId      as ObjectBookId      -- 项目图书Id
    ,a1.BookId            as BookId            -- 书籍Id
    ,a1.ChapterName       as ChapterName       -- 章节名
    ,a1.BookName          as BookName          -- 书籍名称
    ,a1.Status            as Status            -- 状态 0:无法抽查、 1:未抽查、2:待审核、3:待修改、4:抽查完毕、5:抽查中
    ,a1.CreateTime        as CreateTime        -- 创建时间
    ,a1.UpdateTime        as UpdateTime        -- 更新时间
    ,a1.ToLanguage        as ToLanguage        -- 语言
    ,a1.CompletionTime    as CompletionTime    -- 完成时间
    ,a1.DelStatus         as DelStatus         -- 删除状态
    ,a1.Remark            as Remark            -- 备注
    ,a1.FontLength        as FontLength        -- 字数
    ,case when a1.FirstPercent is null and a1.RoleType = 1 then a2.MachinePercent
          when a1.FirstPercent is null and a1.RoleType = 2 then round((a2.ModifyLength / a2.ForeignLength) * 100, 2)
          when a1.FirstPercent is null and a1.RoleType = 3 then a2.ForeignPercent
          when a1.FirstPercent is not null then a1.FirstPercent
      end                 as FirstPercent      -- 初始修改比例
    ,case when a1.RoleType = 1 then a2.MachinePercent
          when a1.RoleType = 2 then round((a2.ModifyLength / a2.ForeignLength) * 100, 2)
          when a1.RoleType = 3 then a2.ForeignPercent
      end                 as ModifyPercent     -- 修改比例
  from ods.ods_shuangwen_tidb_xx_ObjectChapterCheck    as a1
  left join ods.ods_tidb_shuangwen_xx_objectchapter    as a2
    on a1.productid = a2.productid
   and a1.ChapterId = a2.Id
;