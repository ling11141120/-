insert overwrite dim.dim_app_adplatform_unit_id_info
select UNNEST as unit_adid
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
      ,now() as etl_tm
  from (select split(adids, '|')   as unit_adid
              ,id
              ,attribute
              ,core
              ,mt
              ,applangid           as applang_id
              ,b.productid         as product_id
              ,adshowtype          as ad_show_type
              ,adposition          as ad_position
              ,adplatform          as ad_plat_form
              ,sceneid             as scene_id
              ,jgroupids           as jgroup_ids
              ,excludejgroupids    as exclude_jgroup_ids
              ,minver
              ,maxver
              ,isshieldauthor      as is_shield_author
              ,sort
              ,status
              ,createtime          as create_tm
              ,updatetime          as update_tm
          from ods.ods_tidb_readernovel_tidb_tag_center_ads_ids    as a
          left join (select productid
                           ,langid
                       from dim.DIM_ProductType
                      where langid not in (14, 15)
                    )                                              as b
            on a.applangid = b.langid
       )                                                           as x
  ,unnest(unit_adid)
 union all
-- 游戏配置数据来源于simple后台的配置
select UnitID
      ,0                  as id
      ,0                  as attribute
      ,0                  as CoreVer
      ,0                  as mt
      ,0                  as applang_id
      ,product_id
      ,AdShowType
      ,min(`Position`)    as ad_position
      ,1                  as ad_plat_form
      ,0                  as scene_id
      ,0                  as jgroup_ids
      ,0                  as exclude_jgroup_ids
      ,0                  as minver
      ,0                  as maxver
      ,0                  as is_shield_author
      ,0                  as sort
      ,1                  as status
      ,NOW()              as create_tm
      ,NOW()              as update_tm
      ,NOW()              as etl_tm
  from ods.ods_tidb_readernovel_tidb_admobconfig
 where `Position` in (36, 39, 40)
   and UnitID not in (select unit_adid from dim.dim_app_adplatform_unit_id_info)
 group by 1, 2, 3, 4, 5, 6, 7, 8
;