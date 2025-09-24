----------------------------------------------------------------
-- 程序功能： 产能人才资源库
-- 程序名： P_ads_mobotrans_capacity_author_resource
-- 目标表： ads.ads_mobotrans_capacity_author_resource
-- 负责人： xjc
-- 开发日期：2025-09-24
-- 版本号： v0.0.0
----------------------------------------------------------------



insert into ads.ads_mobotrans_capacity_author_resource
with oa as (
    select productid
          ,ToLanguage
          ,AccountId
          ,PenName
          ,RealName
          ,Occupation
          ,case when AuthorType = 0 then 0
                else 1
           end    as work_type
          ,Country
          ,Phone
          ,QQ
          ,EMail
          ,Remarks
          ,Status
      from ods.ods_tidb_shuangwen_xx_objectauthor
     where (case when productid = 3366 then ToLanguage in (322,436,445)
                 when productid = 3388 then ToLanguage in (375,419,418)
                 when productid = 3322 then ToLanguage not in (322,436,375,419,418)
            end
           )
       and AddTime < '${dt}'
       and AuthorType != 3
)
select  '${dt}'                                        as dt
        ,a.ToLanguage                                  as site_id
        ,a.AccountId                                   as author_id
        ,if(a.RoleType is not null, a.RoleType, 99)    as role_type
        ,a.PenName                                     as pen_name
        ,a.RealName                                    as real_name
        ,a.Occupation                                  as occupation
        ,a.work_type                                   as work_type
        ,a.Country                                     as country
        ,a.Phone                                       as phone
        ,a.QQ                                          as qq
        ,a.EMail                                       as e_mail
        ,a.avg_score                                   as avg_score
        ,b.delay_rate                                  as delay_rate
        ,a.low_score_rate                              as low_score_rate
        ,c.alter_err_rate                              as alter_err_rate
        ,d.font_length_7d                              as font_length_7d
        ,d.avg_font_length_30d                         as avg_font_length_30d
        ,d.font_length_curmonth                        as font_length_curmonth
        ,d.latest_remuneration                         as latest_remuneration
        ,d.median_num                                  as median_num
        ,a.FirstAudit                                  as first_audit
        ,case when a.status in (2, 3) then 1
              when a.status not in (2, 3) and date(d.latest_remuneration) < date_sub('${dt}', interval 90 day) then 2
              else 3
         end                     as work_status
        ,a.Remarks               as remarks
        ,now()                   as etl_time
from (select a.productid         as productid
            ,a.ToLanguage        as ToLanguage
            ,a.AccountId         as AccountId
            ,a.RoleType          as RoleType
            ,a.PenName           as PenName
            ,a.RealName          as RealName
            ,a.Occupation        as Occupation
            ,a.work_type         as work_type
            ,c.avg_score         as avg_score
            ,c.low_score_rate    as low_score_rate
            ,d.FirstAudit        as FirstAudit
            ,a.Country           as Country
            ,a.Phone             as Phone
            ,a.QQ                as QQ
            ,a.EMail             as EMail
            ,a.status            as status
            ,a.Remarks           as Remarks
        from (select oa.productid     as productid
                    ,oa.ToLanguage    as ToLanguage
                    ,oa.AccountId     as AccountId
                    ,b.RoleType       as RoleType
                    ,oa.PenName       as PenName
                    ,oa.RealName      as RealName
                    ,oa.Occupation    as Occupation
                    ,oa.work_type     as work_type
                    ,oa.Country       as Country
                    ,oa.Phone         as Phone
                    ,oa.QQ            as QQ
                    ,oa.EMail         as EMail
                    ,oa.status        as status
                    ,oa.Remarks       as Remarks
            from oa
            left join (select AuthorId
                             ,ToLanguage
                             ,RoleType
                         from ods.ods_tidb_shuangwen_xx_authortorole
                        where Status = 1
                        group by 1, 2, 3
                      ) b
                           on oa.ToLanguage = b.ToLanguage
                          and oa.AccountId = b.AuthorId
             ) a
            left join (select SiteId
                             ,AuthorId
                             ,RoleType
                             ,low_ct/ct    as low_score_rate
                             ,avg(sore)    as avg_score
                         from (select SiteId
                                     ,AuthorId
                                     ,RoleType
                                     ,Sore
                                     ,row_number() over(partition by SiteId, AuthorId, RoleType order by ModifyTime desc)    as rn
                                     ,sum(if(sore < 3, 1, 0)) over(partition by SiteId, AuthorId, RoleType)                  as low_ct
                                     ,count(1) over(partition by SiteId, AuthorId, RoleType)                                 as ct
                                 from ods.ods_tidb_shuangwen_xx_qualityfeedback
                                where FeedBackType not in (0, 10)
                                  and CreateTime < '${dt}'
                               ) a
                        where a.rn <= 10
                        group by SiteId, AuthorId, RoleType, low_ct/ct
                      ) c
              on a.ToLanguage = c.SiteId
             and a.AccountId = c.AuthorId
             and a.RoleType = c.RoleType
            left join ods.ods_tidb_shuangwen_en_objectauthortotal d
              on a.ToLanguage = d.ToLanguage
             and a.AccountId = d.AuthorId
     ) a
left join (select a.productid                                                                  as productid
                 ,a.ForeignProofreadingId                                                      as authorid
                 ,2                                                                            as roletype
                 ,if(b.foreign_dalay_cnt is not null, b.foreign_dalay_cnt, 0)/a.foreign_cnt    as delay_rate
             from (select productid
                         ,ForeignProofreadingId
                         ,count(distinct ChapterId)    as foreign_cnt
                     from (select productid
                                 ,ObjectBookId
                                 ,ChapterId
                                 ,ForeignProofreadingId
                                 ,row_number() over(partition by productid, ObjectBookId, ChapterId order by Id desc)    as rn
                             from ods.ods_tidb_shuangwen_xx_objectchapter
                            where ForeignProofreadingId != 0
                              and date(Cretatime) < '${dt}'
                          ) a
                    where a.rn = 1
                    group by productid, ForeignProofreadingId
                  ) a
             left join (select productid
                              ,PersonnelId
                              ,count(distinct ChapterId)    as foreign_dalay_cnt
                          from ods.ods_tidb_shuangwen_xx_delaystatistics
                         where StatisticsType in (2, 6)
                           and PersonnelId != 0
                           and date(CreateTime) < '${dt}'
                         group by productid, PersonnelId
                       ) b
                            on a.productid = b.productid
                           and a.ForeignProofreadingId = b.PersonnelId
            union all
           select a.productid                                                                              as productid
                 ,a.InterpreterId                                                                          as authorid
                 ,1                                                                                        as roletype
                 ,if(b.Interpreter_dalay_cnt is not null, b.Interpreter_dalay_cnt, 0)/a.Interpreter_cnt    as delay_rate
             from (select productid
                         ,InterpreterId
                         ,count(distinct ChapterId)    as Interpreter_cnt
                     from (select productid
                                 ,ObjectBookId
                                 ,ChapterId
                                 ,InterpreterId
                                 ,row_number() over(partition by productid, ObjectBookId, ChapterId order by Id desc)    as rn
                             from ods.ods_tidb_shuangwen_xx_objectchapter
                            where InterpreterId != 0
                              and date(Cretatime) < '${dt}'
                         ) a
                          where a.rn = 1
                          group by productid, InterpreterId
                  ) a
             left join (select productid
                              ,PersonnelId
                              ,count(distinct ChapterId)     as Interpreter_dalay_cnt
                          from ods.ods_tidb_shuangwen_xx_delaystatistics
                         where StatisticsType in (1, 5, 7)
                           and PersonnelId != 0
                           and date(CreateTime) < '${dt}'
                         group by productid, PersonnelId
                       ) b
               on a.productid = b.productid
              and a.InterpreterId = b.PersonnelId
          ) b
  on a.productid = b.productid
 and a.AccountId = b.authorid
 and a.RoleType = b.roletype
left join (select productid
                 ,InterpreterId                                                        as authorid
                 ,1                                                                    as roletype
                 ,sum(if(MachinePercent/100 >= 0.8, 1, 0))/count(distinct ChapterId)   as alter_err_rate
             from (select productid
                         ,ObjectBookId
                         ,ChapterId
                         ,InterpreterId
                         ,MachinePercent
                         ,row_number() over(partition by productid, ObjectBookId, ChapterId order by Id desc)    as rn
             from ods.ods_tidb_shuangwen_xx_objectchapter
            where InterpreterId != 0
              and date(Cretatime) < '${dt}'
                  ) a
            where a.rn = 1
            group by productid, InterpreterId
            union all
           select  productid
                  ,ForeignProofreadingId                                                 as authorid
                  ,2                                                                     as roletype
                  ,sum(if(foreign_alter_rate >= 0.8, 1, 0))/count(distinct ChapterId)    as alter_err_rate
             from (select productid
                         ,ObjectBookId
                         ,ChapterId
                         ,ForeignProofreadingId
                         ,ModifyLength/ForeignLength                                                             as foreign_alter_rate
                         ,row_number() over(partition by productid, ObjectBookId, ChapterId order by Id desc)    as rn
                     from ods.ods_tidb_shuangwen_xx_objectchapter
                    where ForeignProofreadingId != 0
                      and date(Cretatime) < '${dt}'
                  ) a
            where a.rn = 1
            group by productid, ForeignProofreadingId
            union all
           select productid
                 ,ProofreadingId                                                        as authorid
                 ,3                                                                     as roletype
                 ,sum(if(ForeignPercent/100 >= 0.8, 1, 0))/count(distinct ChapterId)    as alter_err_rate
             from (select productid
                         ,ObjectBookId
                         ,ChapterId
                         ,ProofreadingId
                         ,ForeignPercent
                         ,row_number() over(partition by productid, ObjectBookId, ChapterId order by Id desc)    as rn
                     from ods.ods_tidb_shuangwen_xx_objectchapter
                    where ProofreadingId != 0
                      and date(Cretatime) < '${dt}'
                 ) a
            where a.rn = 1
            group by productid, ProofreadingId
          ) c
  on a.productid = c.productid
 and a.AccountId = c.authorid
 and a.RoleType = c.roletype
left join (select to_language
                 ,author_id
                 ,role_type
                 ,latest_remuneration
                 ,percentile_approx_raw(percentile_union(percentile_hash(font_length_dt)), 0.5)                as median_num
                 ,sum(if(dt >= date_sub('${dt}', interval 7 day), font_length_dt, 0))                          as font_length_7d
                 ,sum(if(dt >= date_sub('${dt}', interval 30 day), font_length_dt, 0))/30                      as avg_font_length_30d
                 ,sum(if(date_format(dt, '%Y-%m') = date_format('${bf_1_dt}', '%Y-%m'), font_length_dt, 0))    as font_length_curmonth
             from (select dt
                         ,to_language
                         ,author_id
                         ,role_type
                         ,latest_remuneration
                         ,sum(font_length)    as font_length_dt
                     from (select dt
                                 ,to_language
                                 ,author_id
                                 ,role_type
                                 ,font_length
                                 ,max(remuneration_time) over(partition by to_language, author_id, role_type)    as latest_remuneration
                             from dwd.dwd_content_translate_remuneration
                            where remuneration_type = 1
                              and book_id > 0
                          ) t
                    where dt < '${dt}'
                      and dt >= date_sub('${dt}', interval 90 day)
                    group by 1, 2, 3, 4, 5
                  ) a
            group by 1, 2, 3, 4
          ) d

  on a.ToLanguage = d.to_language
 and a.AccountId = d.author_id
 and a.RoleType = d.role_type
;