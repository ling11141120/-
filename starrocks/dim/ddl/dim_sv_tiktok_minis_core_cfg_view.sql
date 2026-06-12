create or replace view dim.dim_sv_tiktok_minis_core_cfg_view (
     id                          comment "主键"
    ,core                        comment "core数值"
    ,core_name                   comment "core展示名称"
    ,minis_name                  comment "小程序名称"
    ,account                     comment "TikTok开发者账号标识"
    ,sort                        comment "排序值"
    ,disabled                    comment "是否禁用"
    ,requires_charge_plan        comment "是否需要价值面板"
    ,access_token_client_key     comment "TikTok OAuth client_key"
    ,access_token_client_secret  comment "TikTok OAuth client_secret"
    ,metric_profile              comment "行为口径"
    ,roi_std_cfg_projects        comment "ROI标准配置适用项目"
    ,remark                      comment "备注"
    ,create_user                 comment "创建人"
    ,create_time                 comment "创建时间"
    ,update_user                 comment "更新人"
    ,update_time                 comment "更新时间"
    ,sr_createtime               comment "StarRocks数据注入时间"
    ,sr_updatetime               comment "StarRocks数据更新时间"
)
comment "TT小程序Core配置清洗视图"
as
select
     a1.id                         as id                          -- 主键
    ,a1.core                       as core                        -- core数值
    ,a1.corename                   as core_name                   -- core展示名称
    ,a1.minisname                  as minis_name                  -- 小程序名称
    ,a1.account                    as account                     -- TikTok开发者账号标识
    ,a1.sort                       as sort                        -- 排序值
    ,a1.disabled                   as disabled                    -- 是否禁用
    ,a1.requireschargeplan         as requires_charge_plan        -- 是否需要价值面板
    ,a1.accesstokenclientkey       as access_token_client_key     -- TikTok OAuth client_key
    ,a1.accesstokenclientsecret    as access_token_client_secret  -- TikTok OAuth client_secret
    ,a1.metricprofile              as metric_profile              -- 行为口径
    ,a1.roistdcfgprojects          as roi_std_cfg_projects        -- ROI标准配置适用项目
    ,a1.remark                     as remark                      -- 备注
    ,a1.createuser                 as create_user                 -- 创建人
    ,a1.createtime                 as create_time                 -- 创建时间
    ,a1.updateuser                 as update_user                 -- 更新人
    ,a1.updatetime                 as update_time                 -- 更新时间
    ,a1.sr_createtime              as sr_createtime               -- StarRocks数据注入时间
    ,a1.sr_updatetime              as sr_updatetime               -- StarRocks数据更新时间
  from ods.ods_tidb_sharpengine_ads_global_tiktokminiscorecfg    as a1
;
