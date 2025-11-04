create or replace view dim.dim_srsv_auto_spl_wo_plan_view (
     plan_id      comment "计划ID"
    ,prd_cd       comment "产品编码"
    ,prj_cd       comment "项目编码"
    ,prj_name     comment "项目名称"
    ,src_med      comment "来源媒体"
    ,lang_cd      comment "语言编码"
    ,lang_abbr    comment "语言缩写"
    ,lang_name    comment "语言名称"
    ,opt_eid      comment "优化师工号"
    ,opt_name     comment "优化师名称"
)
comment "海阅海剧优化师自动拆单计划"
as
with t1 as (
    select a1.Code        as opt_eid
          ,a3.NickName    as opt_name
      from ods.ods_tidb_sharpengine_ads_global_DIM_OptimizerGroupsNew            as a1
      join (select b1.Id
              from ods.ods_tidb_sharpengine_ads_global_DIM_OptimizerGroupsNew    as b1
             where b1.GroupType = 1
               and b1.ParentId = 0
               and b1.SubGroupType = 1
           )                                                                     as a2
        on a1.ParentId = a2.Id
      join ods.ods_tidb_SharpEngineDB_b_userinfo_tb                              as a3
        on a1.Code = a3.Account
     group by a1.Code, a3.NickName
)
select a1.PlanId                                    as plan_id
      ,a1.Code                                      as prd_cd
      ,a1.ProjectCode                               as prj_cd
      ,case when (a1.ProjectCode = 1) then '海阅'
            when (a1.ProjectCode = 2) then '海剧'
            else null 
        end                                         as prj_name
      ,a1.SourceChl                                 as src_med
      ,a1.CurrentLanguage                           as lang_cd
      ,a3.cd_val                                    as lang_abbr
      ,a3.cd_val_desc                               as lang_name
      ,a1.OptimizerUid                              as opt_eid
      ,coalesce(a2.opt_name, a1.OptimizerUid)       as opt_name
  from ods.ods_tidb_sharpengine_ads_global_NewbookRankOptimizerSchedule    as a1
  left join t1                                                             as a2
    on a1.OptimizerUid = a2.opt_eid
  left join dim.dim_pub_code_mapping_dict                                  as a3
    on a1.CurrentLanguage = a3.p_cd_val
   and a3.app_plat = 'pub'
   and a3.cd_col = 'lang_abbr'
 where a1.ProjectCode in (1, 2)
;