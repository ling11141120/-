create view dwd_srsv_trade_hk_sync_payorder_di_view (
     dt                   comment "日期分区"
    ,id                   comment "主键id"
    ,order_serial_id      comment "订单流水号全局唯一,写入到业务库使用"
    ,order_id             comment "订单号,透传给支付合作方"
    ,coo_order_id         comment "支付订单号,合作方回传的"
    ,pay_chanel_id        comment "渠道号"
    ,account              comment "账号"
    ,user_id              comment "用户Id"
    ,server_id            comment "服务器id,已废弃"
    ,user_i_p_address     comment "客户端ip"
    ,create_time          comment "创建时间"
    ,coo_notify_time      comment "收到的付款时间"
    ,finish_time          comment "订单处理完成时间,表示已经发送给业务服务器的时间"
    ,amount               comment "金额,分为单位"
    ,give_amount          comment "赠送金额,一般无用了"
    ,bank_amount          comment "银行金额,一般等同于Amount"
    ,order_status         comment "订单状态1为成功"
    ,coo_order_status     comment "合作方扣款状态1为成功"
    ,shop_item            comment "支付的商品id"
    ,product_id           comment "充值产品编号"
    ,pay_type
    ,bank_id
    ,ext1
    ,ext2
    ,ext3
    ,ext4
    ,ext5
    ,os_type              comment "相当于Mt"
    ,shop_item_id         comment "商品Id,配置在后台"
    ,coupon_id            comment "优惠券Id"
    ,package_id           comment "客户端透传参数,不同场景用途不一样"
    ,phone
    ,has_notify_times
    ,pay_config_id
    ,core
    ,base_amount          comment "统计收入金额字段"
    ,unique_guid
    ,test_flag            comment "测试标记1为测试"
    ,coo_ext_status
    ,coo_ext_info
    ,bill_info
    ,row_update_timestamp
    ,sub_pay_type         comment "子渠道类型"
    ,auto_renew_times     comment "续订次数"
    ,subscribe_status
    ,app_ver
    ,country
    ,sr_createtime        comment "sr入库时间"
    ,sr_updatetime        comment "sr更新时间"
)
comment "海阅海剧充值表（带国家）"
as
select a1.dt                   as dt                   -- 日期分区
      ,a1.id                   as id                   -- 主键id
      ,a1.order_serial_id      as order_serial_id      -- 订单流水号全局唯一,写入到业务库使用
      ,a1.order_id             as order_id             -- 订单号,透传给支付合作方
      ,a1.coo_order_id         as coo_order_id         -- 支付订单号,合作方回传的
      ,a1.pay_chanel_id        as pay_chanel_id        -- 渠道号
      ,a1.account              as account              -- 账号
      ,a1.user_id              as user_id              -- 用户Id
      ,a1.server_id            as server_id            -- 服务器id,已废弃
      ,a1.user_i_p_address     as user_i_p_address     -- 客户端ip
      ,a1.create_time          as create_time          -- 创建时间
      ,a1.coo_notify_time      as coo_notify_time      -- 收到的付款时间
      ,a1.finish_time          as finish_time          -- 订单处理完成时间,表示已经发送给业务服务器的时间
      ,a1.amount               as amount               -- 金额,分为单位
      ,a1.give_amount          as give_amount          -- 赠送金额,一般无用了
      ,a1.bank_amount          as bank_amount          -- 银行金额,一般等同于Amount
      ,a1.order_status         as order_status         -- 订单状态1为成功
      ,a1.coo_order_status     as coo_order_status     -- 合作方扣款状态1为成功
      ,a1.shop_item            as shop_item            -- 支付的商品id
      ,a1.product_id           as product_id           -- 充值产品编号
      ,a1.pay_type             as pay_type
      ,a1.bank_id              as bank_id
      ,a1.ext1                 as ext1
      ,a1.ext2                 as ext2
      ,a1.ext3                 as ext3
      ,a1.ext4                 as ext4
      ,a1.ext5                 as ext5
      ,a1.os_type              as os_type              -- 相当于Mt
      ,a1.shop_item_id         as shop_item_id         -- 商品Id,配置在后台
      ,a1.coupon_id            as coupon_id            -- 优惠券Id
      ,a1.package_id           as package_id           -- 客户端透传参数,不同场景用途不一样
      ,a1.phone                as phone
      ,a1.has_notify_times     as has_notify_times
      ,a1.pay_config_id        as pay_config_id
      ,a1.core                 as core
      ,a1.base_amount          as base_amount          -- 统计收入金额字段
      ,a1.unique_guid          as unique_guid
      ,a1.test_flag            as test_flag            -- 测试标记1为测试
      ,a1.coo_ext_status       as coo_ext_status
      ,a1.coo_ext_info         as coo_ext_info
      ,a1.bill_info            as bill_info
      ,a1.row_update_timestamp as row_update_timestamp
      ,a1.sub_pay_type         as sub_pay_type         -- 子渠道类型
      ,a1.auto_renew_times     as auto_renew_times     -- 续订次数
      ,a1.subscribe_status     as subscribe_status
      ,a1.app_ver              as app_ver
      ,a1.country              as country
      ,a1.sr_createtime        as sr_createtime        -- sr入库时间
      ,a1.sr_updatetime        as sr_updatetime        -- sr更新时间
  from dwd.dwd_srsv_trade_hk_sync_payorder_di as a1
;
