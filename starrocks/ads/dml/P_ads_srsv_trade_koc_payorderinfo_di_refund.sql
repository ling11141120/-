----------------------------------------------------------------
-- 程序功能： KOC订单信息-退单
-- 程序名： P_ads_srsv_trade_koc_payorderinfo_di_refund
-- 目标表： ads.ads_srsv_trade_koc_payorderinfo_di
-- 负责人： qhr
-- 开发日期： 2025-09-08
----------------------------------------------------------------

-- SQL语句
insert into ads.ads_srsv_trade_koc_payorderinfo_di
select a2.ref_order_id           as ref_order_id           -- 订单号
      ,a1.status                 as status                 -- 订单状态
      ,date(a1.create_time)      as dt                     -- 日期
      ,a2.code                   as code                   -- 口令词
      ,a2.story_id               as story_id               -- 故事
      ,a2.story_name             as story_name             -- 故事名称
      ,a2.amount                 as amount                 -- 金额数
      ,a2.base_amount            as base_amount            -- 分成后金额数
      ,a2.project_type           as project_type           -- 项目类型
      ,a2.institution_user_id    as institution_user_id    -- 机构用户
      ,a2.star_user_id           as star_user_id           -- 达人用户
      ,a1.create_time            as create_time            -- 创建时间
      ,now()                     as etl_time               -- etl清洗时间
      ,a2.core                   as core                   -- core
      ,a2.current_language       as current_language       -- 投放语言
      ,a2.user_id                as user_id                -- 用户id
      ,a2.mt                     as mt                     -- mt
      ,a2.sub_pay_type           as sub_pay_type           -- 支付方式
      ,a2.shop_item              as shop_item              -- 权益类型
      ,a2.activation_time        as activation_time        -- 激活时间
      ,a2.country                as country                -- 国家
      ,case when a3.user_id is not null then 1
            else 0
        end                      as is_anom_ord            -- 是否异常订单
      ,a1.reg_dev_id             as reg_dev_id             -- 注册时设备id
      ,a1.reg_ip                 as reg_ip                 -- 注册IP
  from (select b1.ProductId              as product_id
              ,b1.UserId                 as user_id
              ,b1.OrderId                as order_id
              ,1                         as status
              ,1                         as project_type
              ,null                      as book_id
              ,b1.refund_time            as create_time          -- 取退款时间
              ,b2.unique_cdreader_id     as reg_dev_id
              ,b2.reg_ip                 as reg_ip
              ,sum(b1.ItemCount)         as item_count
              ,sum(b1.BaseAmount)/100    as base_amount
          from dwd.dwd_sr_trade_user_refund_order_di    as b1    -- 海阅的退款订单
          left join dim.dim_user_account_info_view      as b2
            on b1.UserId = b2.id
         where b1.dt>='${bf_30_dt}'
           and b1.dt<='${dt}'
         group by 1,2,3,4,5,6,7,8,9
         union all
         select b3.product_id              as product_id
               ,b3.user_id                 as user_id
               ,b3.order_id                as order_id
               ,b3.status                  as status
               ,2                          as project_type
               ,cast(substring_index(substring_index(substring_index(b3.package_id, 'Ps_Half_', -1)
                                                     , '_', 1
                                                    )
                                     , '_', -1
                                    ) as int
                    )                      as book_id
               ,b3.dt                      as create_time
               ,b4.unique_cdreader_id      as reg_dev_id
               ,b4.ip                      as reg_ip
               ,sum(b3.item_count)         as item_count
               ,sum(b3.base_amount)/100    as base_amount
           from dwd.dwd_trade_short_video_payorder_view      as b3    -- 海剧的退款订单
           left join dim.dim_short_video_user_accountinfo    as b4
             on b3.user_id = b4.user_id
          where b3.dt >= '${bf_30_dt}'
            and b3.dt <= '${dt}'
            and b3.product_id = 6833
            and b3.test_flag = 0
            and b3.status = 1    -- 退款订单
          group by 1,2,3,4,5,6,7,8,9
       )                                          as a1
  join ads.ads_srsv_trade_koc_payorderinfo_di     as a2    -- 退款订单关联koc订单
    on a1.order_id = a2.ref_order_id
   and a2.status = 0
  left join dim.dim_koc_anom_user_info             as a3    -- 异常用户
    on a1.user_id = a3.user_id
   and a3.anom_status_cd = 1
 where date(a1.create_time) >= '${bf_3_dt}'
;