create or replace view dwd.dwd_sv_tt_vip_subscription_payorder_view (
     id                      comment "主键ID"
    ,account_id              comment "账号id"
    ,series_id               comment "购买的剧id"
    ,subscrption_id          comment "订阅id"
    ,order_url               comment "订单信息页面访问链接"
    ,product_name            comment "商品名称"
    ,tier_id                 comment "商品ID"
    ,deduct_type             comment "扣款类型"
    ,price                   comment "价格"
    ,currency                comment "币种"
    ,symbol                  comment "单位"
    ,trade_order_id          comment "TikTok生成的订单号"
    ,trade_order_status      comment "TikTok订单状态"
    ,subscription_record_id  comment "自己的订阅id"
    ,create_time             comment "创建时间"
    ,update_time             comment "更新时间"
    ,sr_updatetime           comment "StarRocks数据更新时间"
)
comment "海剧-TikTok VIP订阅订单清洗视图"
as
select
     a1.id                      as id                      -- 主键ID
    ,a1.account_id              as account_id              -- 账号id
    ,a1.series_id               as series_id               -- 购买的剧id
    ,a1.subscrption_id          as subscrption_id          -- 订阅id
    ,a1.order_url               as order_url               -- 订单信息页面访问链接
    ,a1.product_name            as product_name            -- 商品名称
    ,a1.tier_id                 as tier_id                 -- 商品ID
    ,a1.deduct_type             as deduct_type             -- 扣款类型
    ,a1.price                   as price                   -- 价格
    ,a1.currency                as currency                -- 币种
    ,a1.symbol                  as symbol                  -- 单位
    ,a1.trade_order_id          as trade_order_id          -- TikTok生成的订单号
    ,a1.trade_order_status      as trade_order_status      -- TikTok订单状态
    ,a1.subscription_record_id  as subscription_record_id  -- 自己的订阅id
    ,a1.create_time             as create_time             -- 创建时间
    ,a1.update_time             as update_time             -- 更新时间
    ,a1.sr_updatetime           as sr_updatetime           -- StarRocks数据更新时间
  from ods.ods_tidb_short_video_tt_vip_subscription_payorder    as a1
;
