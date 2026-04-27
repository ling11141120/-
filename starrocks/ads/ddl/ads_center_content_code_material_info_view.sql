----------------------------------------------------------------
-- 目标表： ads.ads_center_content_code_material_info_view
-- 来源表： ods.ods_tidb_readernovel_tidb_tag_center_content_code_material_info
-- 开发人： lwb
-- 开发日期： 2026-04-16
----------------------------------------------------------------

CREATE VIEW ads.ads_center_content_code_material_info_view (
     dt               COMMENT "日期，create_time"
    ,id               COMMENT "主键"
    ,contenttype      COMMENT "内容类型（0标题，1内容）"
    ,content          COMMENT "内容"
    ,materialid       COMMENT "内容素材Id"
    ,translateid      COMMENT "翻译Id"
    ,langid           COMMENT "语言"
    ,createtime       COMMENT "创建时间"
    ,updatetime       COMMENT "更新时间"
)
AS
SELECT dt
      ,id
      ,contenttype
      ,content
      ,materialid
      ,translateid
      ,langid
      ,createtime
      ,updatetime
  FROM ods.ods_tidb_readernovel_tidb_tag_center_content_code_material_info
  ;