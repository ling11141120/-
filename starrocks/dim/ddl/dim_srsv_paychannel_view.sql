create or replace view dim.dim_srsv_paychannel_view (
     id                   comment "主键"
    ,product_id           comment "产品编号"
    ,merchant_name        comment "渠道名"
    ,createtime           comment "创建时间"
    ,rate_to_product      comment "默认进账比例"
    ,pay_name             comment "支付渠道名"
    ,default_sub_pay_type comment "默认子渠道类型"
    ,corp                 comment "归属公司"
)
comment "充值渠道表"
as
select a1.Id                as id                   -- 主键
      ,a1.ProductId         as product_id           -- 产品编号
      ,a1.MerchantName      as merchant_name        -- 渠道名
      ,a1.createtime        as createtime           -- 创建时间
      ,a1.RateToProduct     as rate_to_product      -- 默认进账比例
      ,a1.PayName           as pay_name             -- 支付渠道名
      ,a1.DefaultSubPayType as default_sub_pay_type -- 默认子渠道类型
      ,a1.Corp              as corp                 -- 归属公司
  from ods.ods_tidb_sr_sharpengine_pay_hk_sync_paychanel_da as a1
;
