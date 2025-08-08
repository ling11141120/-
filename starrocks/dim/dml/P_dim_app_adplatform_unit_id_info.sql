INSERT OVERWRITE dim.dim_app_adplatform_unit_id_info
SELECT UNNEST AS unit_adid
      ,id
      ,attribute
      ,core
      ,mt
      ,applang_id
      ,product_id
      ,ad_show_type
      ,ad_position
      ,ad_plat_form
      ,scene_id
      ,jgroup_ids
      ,exclude_jgroup_ids
      ,minver
      ,maxver
      ,is_shield_author
      ,sort
      ,status
      ,create_tm
      ,update_tm
      ,NOW() AS etl_tm
  FROM (SELECT SPLIT(adids, '|') AS unit_adid
              ,id
              ,attribute
              ,core
              ,mt
              ,applangid AS applang_id
              ,b.productid AS product_id
              ,adshowtype AS ad_show_type
              ,adposition AS ad_position
              ,adplatform AS ad_plat_form
              ,sceneid AS scene_id
              ,jgroupids AS jgroup_ids
              ,excludejgroupids AS exclude_jgroup_ids
              ,minver
              ,maxver
              ,isshieldauthor AS is_shield_author
              ,sort
              ,status
              ,createtime AS create_tm
              ,updatetime AS update_tm
          FROM ods.ods_tidb_readernovel_tidb_tag_center_ads_ids a
          LEFT JOIN (SELECT productid
                           ,langid
                       FROM dim.DIM_ProductType
                      WHERE langid NOT IN (14, 15)
                    ) b
            ON a.applangid = b.langid
       ) x
  ,UNNEST(unit_adid)

UNION ALL
-- ---------------游戏配置数据来源于simple后台的配置-------------------------------------
SELECT UnitID
      ,0 AS id
      ,0 AS attribute
      ,0 AS CoreVer
      ,0 AS mt
      ,0 AS applang_id
      ,product_id
      ,AdShowType
      ,MIN(`Position`) AS ad_position
      ,1 AS ad_plat_form
      ,0 AS scene_id
      ,0 AS jgroup_ids
      ,0 AS exclude_jgroup_ids
      ,0 AS minver
      ,0 AS maxver
      ,0 AS is_shield_author
      ,0 AS sort
      ,1 AS status
      ,NOW() AS create_tm
      ,NOW() AS update_tm
      ,NOW() AS etl_tm
  FROM ods.ods_tidb_readernovel_tidb_admobconfig
 WHERE `Position` IN (36, 39, 40)
   AND UnitID NOT IN (SELECT unit_adid
                        FROM dim.dim_app_adplatform_unit_id_info
                     )
 GROUP BY 1, 2, 3, 4, 5, 6, 7, 8
;