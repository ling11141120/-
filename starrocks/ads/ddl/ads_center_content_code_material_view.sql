----------------------------------------------------------------
-- 目标表： ads.ads_center_content_code_material_view
-- 来源表： ods.ods_tidb_readernovel_tidb_tag_center_content_code_material
-- 开发人： lwb
-- 开发日期： 2026-04-16
----------------------------------------------------------------

CREATE VIEW ads.ads_center_content_code_material_view (
     dt               COMMENT "日期，create_time"
    ,id               COMMENT "主键"
    ,applytype        COMMENT "应用类型 1push"
    ,bookno           COMMENT "代号"
    ,sort             COMMENT "序号"
    ,status           COMMENT "是否应用"
    ,createtime       COMMENT "创建时间"
    ,updatetime       COMMENT "更新时间"
)
AS
SELECT dt
      ,id
      ,applytype
      ,bookno
      ,sort
      ,status
      ,createtime
      ,updatetime
  FROM ods.ods_tidb_readernovel_tidb_tag_center_content_code_material
  ;