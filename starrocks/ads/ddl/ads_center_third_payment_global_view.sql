create or replace view ads.ads_center_third_payment_global_view (
     id                     COMMENT "主键"
    ,applangid              COMMENT "app语言"
    ,jgroupids              COMMENT "极光选中人群包"
    ,unnest_jgroupid        COMMENT "按逗号展开后极光选中人群包"
    ,excludejgroupids       COMMENT "极光剔除人群包"
    ,status                 COMMENT "状态（0关闭，1开启）"
    ,createtime             COMMENT "创建时间"
    ,updatetime             COMMENT "修改时间"
    ,sr_createtime          COMMENT "创建时间"
    ,sr_updatetime          COMMENT "修改时间"
)
comment "第三方支付全局配置表 author:195666 对应视图（按逗号拆分jgroupids）"
AS
SELECT
     id
    ,applangid
    ,jgroupids
    ,unnest as unnest_jgroupid
    ,excludejgroupids
    ,status
    ,createtime
    ,updatetime
    ,sr_createtime
    ,sr_updatetime
FROM ods.ods_tidb_readernovel_tidb_tag_center_third_payment_global
,unnest(split(jgroupids, ",")) as unnest
;

