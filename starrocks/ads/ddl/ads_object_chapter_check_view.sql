----------------------------------------------------------------
-- 目标表： ads.ads_object_chapter_check_view
-- 功能：
-- 负责人： xjc
-- 开发日期：	2025-06-04
----------------------------------------------------------------



CREATE OR REPLACE VIEW ads_object_chapter_check_view (
     ProductId
    ,Id
    ,ChapterId
    ,RoleType
    ,AuthorId
    ,PenName
    ,AuditAuthorId
    ,AuditPenName
    ,ObjectBookId
    ,BookId
    ,ChapterName
    ,BookName
    ,Status
    ,CreateTime
    ,UpdateTime
    ,ToLanguage
    ,CompletionTime
    ,DelStatus
    ,Remark
    ,FontLength
    ,FirstPercent                                      comment "第一次修改比例"
    ,ModifyPercent                                     comment "修改比例"
)
as
select   ods.a.ProductId
        ,ods.a.Id
        ,ods.a.ChapterId
        ,ods.a.RoleType
        ,ods.a.AuthorId
        ,ods.a.PenName
        ,ods.a.AuditAuthorId
        ,ods.a.AuditPenName
        ,ods.a.ObjectBookId
        ,ods.a.BookId
        ,ods.a.ChapterName
        ,ods.a.BookName
        ,ods.a.Status
        ,ods.a.CreateTime
        ,ods.a.UpdateTime
        ,ods.a.ToLanguage
        ,ods.a.CompletionTime
        ,ods.a.DelStatus
        ,ods.a.Remark
        ,ods.a.FontLength
        ,case when ((ods.a.FirstPercent is null) and (ods.a.RoleType = 1)) then ods.b.MachinePercent
              when ((ods.a.FirstPercent is null) and (ods.a.RoleType = 2)) then (round((ods.b.ModifyLength
                                                                                            / ods.b.ForeignLength)
                                                                                            * 100, 2))
              when ((ods.a.FirstPercent is null) and (ods.a.RoleType = 3)) then ods.b.ForeignPercent
              when (ods.a.FirstPercent is not null) then ods.a.FirstPercent
          end                                          as FirstPercent
        ,case when (ods.a.RoleType = 1) then ods.b.MachinePercent
              when (ods.a.RoleType = 2) then (round((ods.b.ModifyLength / ods.b.ForeignLength) * 100, 2))
              when (ods.a.RoleType = 3) then ods.b.ForeignPercent
          end                                          as ModifyPercent
  from ods.ods_shuangwen_tidb_xx_ObjectChapterCheck    as a
  left join ods.ods_tidb_shuangwen_xx_objectchapter    as b
         on (ods.a.productid = ods.b.productid)
        and (ods.a.ChapterId = ods.b.Id)
;