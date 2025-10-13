create or replace view ads.ads_third_payment_config_view (
     id                      COMMENT "id"
    ,group_ids               COMMENT "选中人群包"
    ,unnest_group_ids        COMMENT "按逗号展开后选中人群包"
    ,exclude_group_ids       COMMENT "排除人群包"
    ,core                    COMMENT "core"
    ,status                  COMMENT "三方支付状态总开关0关1开"
    ,update_time             COMMENT "更新时间"
    ,sr_createtime           COMMENT "starrocks数据注入时间"
    ,sr_updatetime           COMMENT "starrocks数据更新时间"
)
comment "三方支付全局配置表 对应视图（按逗号拆分group_ids）"
AS
SELECT
     id
    ,group_ids
    ,unnest as unnest_group_ids
    ,exclude_group_ids
    ,core
    ,status
    ,update_time
    ,sr_createtime
    ,sr_updatetime
FROM ods.ods_tidb_short_video_third_payment_config
,unnest(split(group_ids, ",")) as unnest
;