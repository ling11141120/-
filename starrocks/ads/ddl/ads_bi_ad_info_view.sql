----------------------------------------------------------------
-- 目标表： ads.ads_bi_ad_info_view
-- 来源实例： <来源数据库实例>
-- 来源表： dwd.dwd_advertisement_adext_view
-- 来源负责： <来源表服务端/客户端负责人(允许多个)>
-- 采集工具： <采集工具：极光-定时批量 / SeaTunnel>
-- 开发人： roger
-- 开发日期：2025/11/13
----------------------------------------------------------------

create or replace view ads.ads_bi_ad_info_view (
     ad_id            comment "广告id"
    ,prd_id           comment "产品id"
    ,prd_name         comment "产品名称"
    ,opt_eid          comment "优化师工号"
    ,src_chl          comment "来源渠道"
    ,ad_group_id      comment "广告组id"
    ,ad_group_name    comment "广告组名称"
)
comment '广告信息视图'
as
select a1.ad_id               as ad_id            -- 广告id
      ,a1.product_id          as prd_id           -- 产品id
      ,a2.cd_val_desc         as prd_name         -- 产品名称
      ,a1.ad_optimizer_uid    as opt_eid          -- 优化师工号
      ,a1.source_chl          as src_chl          -- 来源渠道
      ,a1.ad_set_id           as ad_group_id      -- 广告组id
      ,a1.ad_setname          as ad_group_name    -- 广告组名称
  from dwd.dwd_advertisement_adext_view      as a1
  left join dim.dim_pub_code_mapping_dict    as a2
    on a1.product_id = a2.cd_val
   and a2.app_plat = "pub"
   and a2.cd_col = "product_id"
 where a1.ad_id is not null
;
