create or replace view dwd.dwd_sv_tt_payorder_view (
     id                  comment "主键ID"
    ,order_incr_id       comment "自增订单id"
    ,account_id          comment "用户ID"
    ,goods_option_id     comment "商品价值方案ID"
    ,series_id           comment "购买的剧id"
    ,token_type          comment "令牌类型"
    ,token_amount        comment "令牌数量"
    ,order_url           comment "订单信息页面访问链接"
    ,product_name        comment "商品名称"
    ,product_id          comment "商品ID"
    ,quantity            comment "商品数量"
    ,quantity_unit       comment "商品数量单位"
    ,image_url           comment "订单封面图URL"
    ,trade_order_id      comment "TikTok生成的订单号"
    ,trade_order_status  comment "TikTok订单状态"
    ,order_type          comment "订单类型"
    ,create_time         comment "创建时间"
    ,update_time         comment "更新时间"
    ,sr_createtime       comment "StarRocks数据注入时间"
    ,sr_updatetime       comment "StarRocks数据更新时间"
)
comment "海剧-TikTok换币订单清洗视图"
as
select
     a1.id                  as id                  -- 主键ID
    ,a1.order_incr_id       as order_incr_id       -- 自增订单id
    ,a1.account_id          as account_id          -- 用户ID
    ,a1.goods_option_id     as goods_option_id     -- 商品价值方案ID
    ,a1.series_id           as series_id           -- 购买的剧id
    ,a1.token_type          as token_type          -- 令牌类型
    ,a1.token_amount        as token_amount        -- 令牌数量
    ,a1.order_url           as order_url           -- 订单信息页面访问链接
    ,a1.product_name        as product_name        -- 商品名称
    ,a1.product_id          as product_id          -- 商品ID
    ,a1.quantity            as quantity            -- 商品数量
    ,a1.quantity_unit       as quantity_unit       -- 商品数量单位
    ,a1.image_url           as image_url           -- 订单封面图URL
    ,a1.trade_order_id      as trade_order_id      -- TikTok生成的订单号
    ,a1.trade_order_status  as trade_order_status  -- TikTok订单状态
    ,a1.order_type          as order_type          -- 订单类型
    ,a1.create_time         as create_time         -- 创建时间
    ,a1.update_time         as update_time         -- 更新时间
    ,a1.sr_createtime       as sr_createtime       -- StarRocks数据注入时间
    ,a1.sr_updatetime       as sr_updatetime       -- StarRocks数据更新时间
  from ods.ods_tidb_short_video_tt_payorder    as a1
;
