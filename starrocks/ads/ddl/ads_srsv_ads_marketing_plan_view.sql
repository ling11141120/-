create or replace view ads.ads_srsv_ads_marketing_plan_view (
     id                   comment "主键ID"
    ,project_code         comment "项目类型 1=海阅|2=海剧"
    ,code_id              comment "代号 ProjectCode 为 1=书籍 ID|ProjectCode 为 2=短剧 ID"
    ,code                 comment "代号 ProjectCode 为 1=书籍代号|ProjectCode 为 2=短剧代号"
    ,put_product_id       comment "投放语言"
    ,current_language     comment "投放语言"
    ,source_chl           comment "媒体"
    ,plan_round           comment "计划次数 1|2|3"
    ,date_span            comment "日期跨度 7|14"
    ,begin_date           comment "开始日期"
    ,end_date             comment "结束日期"
    ,plan_remark          comment "计划说明"
    ,plan_status          comment "计划结果状态 0=无结果|1=跑出|2=未跑出"
    ,plan_docs_url        comment "星河链接地址"
    ,create_time          comment "创建时间"
    ,creator              comment "创建人"
    ,creator_uid          comment "创建人账号 ID"
    ,update_time          comment "更新时间"
    ,updater              comment "更新人"
    ,updater_uid          comment "更新人账号 ID"
    ,is_del               comment "是否删除 0=否|1=是"
    ,asset_num            comment "首批素材数量"
    ,budget               comment "投放预发"
    ,plan_status_remark   comment "计划状态变更说明"
    ,test_status          comment "测试状态 0=未开始|1=测试中|2=已结束"
    ,spend                comment "花费"
    ,amount               comment "收入"
    ,d0_amount            comment "Day0 花费"
    ,day0_first_pay_num   comment "Day0 付费人数"
    ,reg_num              comment "注册人数"
    ,is_init              comment "是否初始数据 初始数据会跑一次 ROI"
    ,begin_length         comment "开始总字数"
    ,begin_publish_length comment "开始发布字数"
    ,begin_is_full        comment "开始是否完本 0=否|1=是"
    ,end_length           comment "结束总字数"
    ,end_publish_length   comment "结束发布字数"
    ,end_is_full          comment "结束是否完本 0=否|1=是"
    ,code_stage           comment "代号阶段 海阅最大 3 阶 海剧最大 2 阶 国剧就 1 阶"
    ,d0_std_amount        comment "Day0 标准收入"
    ,d7_std_amount        comment "Day0 标准收入"
    ,code_lv              comment "最高阶段投放等级 A|S|SS"
    ,sr_createtime        comment "sr 入库时间"
    ,sr_updatetime        comment "sr 更新时间"
)
comment "市场测推表"
as
select Id                    as id
     , ProjectCode           as project_code
     , CodeId                as code_id
     , Code                  as code
     , PutProductId          as put_product_id
     , CurrentLanguage       as current_language
     , SourceChl             as source_chl
     , PlanRound             as plan_round
     , DateSpan              as date_span
     , BeginDate             as begin_date
     , EndDate               as end_date
     , PlanRemark            as plan_remark
     , PlanStatus            as plan_status
     , PlanDocsUrl           as plan_docs_url
     , CreateTime            as create_time
     , Creator               as creator
     , CreatorUid            as creator_uid
     , UpdateTime            as update_time
     , Updater               as updater
     , UpdaterUid            as updater_uid
     , IsDel                 as is_del
     , AssetNum              as asset_num
     , Budget                as budget
     , PlanStatusRemark      as plan_status_remark
     , TestStatus            as test_status
     , Spend                 as spend
     , Amount                as amount
     , D0Amount              as d0_amount
     , Day0FirstPayNum       as day0_first_pay_num
     , RegNum                as reg_num
     , IsInit                as is_init
     , BeginLength           as begin_length
     , BeginPublishLength    as begin_publish_length
     , BeginIsFull           as begin_is_full
     , EndLength             as end_length
     , EndPublishLength      as end_publish_length
     , EndIsFull             as end_is_full
     , CodeStage             as code_stage
     , D0StdAmount           as d0_std_amount
     , D7StdAmount           as d7_std_amount
     , CodeLv                as code_lv
     , sr_createtime
     , sr_updatetime
  from ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan
;