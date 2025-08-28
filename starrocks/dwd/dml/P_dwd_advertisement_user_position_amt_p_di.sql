DELETE FROM dwd.dwd_advertisement_user_position_amt_p_di WHERE dt >= '${bf_1_dt}' AND dt <= '${dt}'
;

INSERT INTO dwd.dwd_advertisement_user_position_amt_p_di
WITH amt AS (SELECT DATE(a.create_time)                         AS dt
                   ,a.create_time
                   ,a.product_id
                   ,a.user_id
                   ,a.core
                   ,a.mt
                   ,a.appver
                   ,a.ad_unit
                   ,a.position_id
                   ,IF(a.platform IS NULL, 'Admob', a.platform) AS ads_name -- 广告平台 (adomob,topon,max)
                   ,a.platform_source
                   ,a.main_strategy_id
                   ,a.event_strategy_id
                   ,a.programme_id
                   ,SUM(CASE WHEN mt = 4 AND (platform = 'Admob' OR platform IS NULL) THEN a.valueMicros / 1000000.0
                             ELSE a.valueMicros
                         END
                       )                                        AS amount
                   ,CURRENT_TIMESTAMP() etl_tm
               FROM (SELECT productid                                             AS product_id
                           ,userid                                                AS user_id
                           ,MOD(appId DIV 1000, 1000)                             AS core
                           ,mt
                           ,appver
                           ,CreateTime                                            AS create_time
                           ,get_json_string(s0, '$.adUnitId')                     AS ad_unit
                           ,get_json_string(s0, '$.positionId')                   AS position_id
                           ,get_json_string(s0, '$.platform')                     AS platform
                           ,CASE WHEN get_json_int(s0, '$.precisionType') = 2 THEN get_json_string(s0, '$.valueMicros') / 1000.0
                                 ELSE get_json_string(s0, '$.valueMicros')
                             END                                                  AS valueMicros
                           ,get_json_string(s0, '$.mediationAdapterClassName')    AS platform_source
                           ,get_json_string(s0, '$.main_strategy_id')             AS main_strategy_id
                           ,get_json_string(s0, '$.ad_strategy_id')               AS event_strategy_id
                           ,get_json_string(s0, '$.programme_id')                 AS programme_id
                       FROM ods_log.ods_readerlog_xx_log_commonactionlog
                      WHERE dt >= '${bf_1_dt}'
                        AND dt <= '${dt}'
                        AND Action = 'AdMobPainEvent'
                    ) a
              WHERE a.valueMicros > 0
              GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
            )
SELECT a.dt
      ,a.create_time
      ,a.product_id
      ,a.user_id
      ,a.core               AS corever
      ,a.mt
      ,a.appver
      ,a.ad_unit
      ,a.positions          AS position_id
      ,a.ads_name
      ,a.platform_source    AS ads_source
      ,a.ad_show_type
      ,main_strategy_id     AS main_strategy_id
      ,event_strategy_id    AS event_strategy_id
      ,programme_id
      ,a.amount             AS ad_position_amt
      ,now()                AS etl_tm
  -- ---------旧版本数据没有 position_id 关联取最小位置的广告数据-----------------------------
  FROM (SELECT amt.dt
              ,amt.product_id
              ,amt.user_id
              ,amt.core
              ,amt.mt
              ,amt.appver
              ,amt.create_time
              ,amt.ad_unit
              ,d.ad_show_type
              ,d.positions
              ,amt.amount
              ,amt.ads_name
              ,amt.platform_source
              ,amt.main_strategy_id
              ,amt.event_strategy_id
              ,amt.programme_id
          FROM amt
          LEFT JOIN (SELECT product_id
                           ,unit_adid
                           ,ad_show_type
                           ,MIN(ad_position) AS positions
                       FROM dim.dim_app_adplatform_unit_id_info
                      WHERE status = 1
                      GROUP BY 1, 2, 3
                    ) d
            ON amt.product_id = d.product_id
           AND amt.ad_unit = d.unit_adid
         WHERE amt.position_id IS NULL

         UNION ALL

        -- 新版本数据 客户端会上报position_id （配置表中会存在广告单元id与position_id 一样的重复多条的数据，需要去重后关联获取广告类型）-----------
        SELECT amt.dt
              ,amt.product_id
              ,amt.user_id
              ,amt.core
              ,amt.mt
              ,amt.appver
              ,amt.create_time
              ,amt.ad_unit
              ,d.ad_show_type
              ,amt.position_id    AS positions
              ,amt.amount
              ,amt.ads_name
              ,amt.platform_source
              ,amt.main_strategy_id
              ,amt.event_strategy_id
              ,amt.programme_id
          FROM amt
          LEFT JOIN (SELECT product_id
                           ,unit_adid
                           ,ad_show_type
                           ,ad_position    AS positions
                       FROM (SELECT product_id
                                   ,unit_adid
                                   ,ad_show_type
                                   ,ad_position
                                   ,COUNT(1)
                               FROM dim.dim_app_adplatform_unit_id_info 
                              WHERE status = 1
                              GROUP BY 1, 2, 3, 4
                            ) a
                    ) d
            ON amt.product_id = d.product_id
           AND amt.ad_unit = d.unit_adid
           AND amt.position_id = d.positions
         WHERE amt.position_id IS NOT NULL
       ) a
;

INSERT INTO dwd.dwd_advertisement_user_position_amt_p_di
WITH us AS (SELECT DATE(create_tm)                        AS dt
                  ,create_tm
                  ,6833                                   AS product_id
                  ,user_id
                  ,IFNULL(core, 1)                        AS core
                  ,mt
                  ,Appver                                 AS app_ver
                  ,ad_unit
                  ,POSITION
                  ,IF(adsPlatform = 2, 'Max', 'Admob')    AS ads_name
                  ,MediationAdapterClassName              AS ads_source
                  ,mainstrategyid                         AS main_strategy_id
                  ,eventstrategyid                        AS event_strategy_id
                  ,SUM(CASE WHEN adsPlatform = 2 THEN value_micros
                            ELSE value_micros / 1000000.0
                        END
                      )                                   AS amount
              FROM (SELECT CASE WHEN PrecisionType = 2 THEN ValueMicros / 1000.0
                                ELSE ValueMicros
                            END                      AS value_micros
                          ,AccountId                 AS user_id
                          ,core                      AS core
                          ,createtime                AS create_tm
                          ,AdUnitId                  AS ad_unit
                          ,Appver
                          ,POSITION
                          ,MediationAdapterClassName
                          ,IFNULL(adsPlatform, 1)    AS adsPlatform
                          ,mt                                             --  adsPlatform:null 和1  表示 admob ,将null值转换为 1
                          ,mainstrategyid
                          ,eventstrategyid
                      FROM ods.ods_tidb_short_video_admob_paid_event
                     WHERE createtime >= '${bf_1_dt}'
                       AND DATE(createtime) <= '${dt}'
                       AND AdUnitId != 'ca-app-pub-1669209234634531/6952416968'    -- 这个是测试数据 直接剔除----
                     -- AND adsPlatform = 2
                     -- AND AdUnitId = 'ca-app-pub-1669209234634531/2070058392'
                   ) res
             WHERE value_micros > 0
             GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
         )
-- -------本身自带position的 关联配置表获取广告类型 ads_type ,优先取广告状态开启的---
,p AS (SELECT us.dt
             ,us.product_id
             ,us.user_id
             ,us.core
             ,us.mt
             ,us.app_ver
             ,us.ad_unit
             ,us.create_tm
             ,us.position
             ,us.amount
             ,b.ads_type
             ,us.ads_name
             ,us.ads_source
             ,us.main_strategy_id
             ,us.event_strategy_id
         FROM us
         -- - 按广告单元id进行开窗排序，优先取状态为开启的进行匹配（status in (0,2) 为关闭状态）
         LEFT JOIN (SELECT unit_adid
                          ,position_id
                          ,ads_type
                      FROM dim.dim_short_video_ads_unit_adid_view
                   QUALIFY row_number() OVER (PARTITION BY unit_adid ORDER BY IF(status IN (0, 2), 2, status)) = 1
                   ) b
           ON us.ad_unit = b.unit_adid
        WHERE us.POSITION > 0
      )
,n AS (SELECT us.dt
             ,us.product_id
             ,us.user_id
             ,us.core
             ,us.mt
             ,us.app_ver
             ,us.ad_unit
             ,us.create_tm
             ,b.position_id AS position
             ,us.amount
             ,b.ads_type
             ,us.ads_name
             ,us.ads_source
             ,us.main_strategy_id
             ,us.event_strategy_id
         FROM us
         -- ----------将广告单元id进行排序
         -- - 按广告单元id进行开窗排序，优先取状态为开启的进行匹配（status in (0,2) 为关闭状态）
         LEFT JOIN (SELECT unit_adid
                          ,position_id
                          ,ads_type
                      FROM dim.dim_short_video_ads_unit_adid_view
                   QUALIFY row_number() OVER (PARTITION BY unit_adid ORDER BY IF(status IN (0, 2), 2, status)) = 1
                   ) b
           ON us.ad_unit = b.unit_adid
        WHERE (us.POSITION < 0 OR us.position IS NULL)
       )
SELECT dt                   AS dt
      ,create_tm            AS create_tm
      ,product_id           AS product_id
      ,user_id              AS user_id
      ,core                 AS core
      ,mt                   AS mt
      ,app_ver              AS app_ver
      ,ad_unit              AS ad_unit
      ,position             AS positon_id
      ,ads_name             AS ads_name
      ,ads_source           AS ads_source
      ,ads_type             AS ad_show_type
      ,main_strategy_id     AS main_strategy_id
      ,event_strategy_id    AS event_strategy_id
      ,NULL                 AS programme_id
      ,amount               AS ad_position_amt
      ,now()                AS etl_tm
  FROM p
 UNION ALL
SELECT dt                   AS dt
      ,create_tm            AS create_tm
      ,product_id           AS product_id
      ,user_id              AS user_id
      ,core                 AS core
      ,mt                   AS mt
      ,app_ver              AS app_ver
      ,ad_unit              AS ad_unit
      ,position             AS positon_id
      ,ads_name             AS ads_name
      ,ads_source           AS ads_source
      ,ads_type             AS ad_show_type
      ,main_strategy_id     AS main_strategy_id
      ,event_strategy_id    AS event_strategy_id
      ,NULL                 AS programme_id
      ,amount               AS ad_position_amt
      ,now()                AS etl_tm
  FROM n
;