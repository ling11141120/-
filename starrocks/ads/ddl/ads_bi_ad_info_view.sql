----------------------------------------------------------------
-- 程序功能： 广告信息视图
-- 程序名： ads_bi_ad_info_view
-- 目标表： ads.ads_bi_ad_info_view
-- 负责人： roger
-- 开发日期：2025/11/12
-- 版本号： v1.0
----------------------------------------------------------------

CREATE OR REPLACE VIEW ads.ads_bi_ad_info_view (
    ad_id     COMMENT "广告id",
    prd_id    COMMENT "产品id",
    prd_name  COMMENT "产品名称",
    opt_eid   COMMENT "优化师工号",
    src_chl   COMMENT "来源渠道",
    ad_group_id   COMMENT "广告组id",
    ad_group_name COMMENT "广告组名称"
)
AS
SELECT
    a1.ad_id            AS ad_id,         -- 广告id
    a1.product_id       AS prd_id,        -- 产品id
    a2.cd_val_desc      AS prd_name,      -- 产品名称
    a1.ad_optimizer_uid AS opt_eid,       -- 优化师工号
    a1.source_chl       AS src_chl,       -- 来源渠道
    a1.ad_set_id        AS ad_group_id,   -- 广告组id
    a1.ad_setname       AS ad_group_name  -- 广告组名称
FROM dwd.dwd_advertisement_adext_view AS a1
LEFT JOIN dim.dim_pub_code_mapping_dict AS a2
    ON a1.product_id = a2.cd_val
   AND a2.app_plat = "pub"
   AND a2.cd_col = "product_id"
WHERE a1.ad_id IS NOT NULL
;

