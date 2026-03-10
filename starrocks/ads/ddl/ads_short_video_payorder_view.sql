create or replace view ads.ads_short_video_payorder_view (
     dt               comment "createtime分区"
    ,product_id       comment "产品id 6833海外短剧"
    ,id               comment "自增id"
    ,type             comment "类型"
    ,user_id          comment "用户id"
    ,used             comment "是否执行"
    ,order_id         comment "订单id"
    ,flag             comment "标识"
    ,create_time      comment "创建时间"
    ,get_time         comment "获取时间"
    ,item_count       comment "金额数"
    ,system_type      comment "系统类型"
    ,receive_date     comment "被接收时间"
    ,mt               comment "终端"
    ,coupon_id        comment "礼券id"
    ,package_id       comment "存放充值页面来源"
    ,shop_item        comment "充值类型"
    ,extinfo          comment "信息"
    ,vip_expire_time  comment "充值订阅卡时，过期时间"
    ,real_money       comment "给的阅币数"
    ,give_money       comment "暂时无用"
    ,amount           comment "暂时无用"
    ,prod_id          comment "暂时无用"
    ,pay_config_id    comment "充值项的id，可能不准确"
    ,corever          comment "包体"
    ,unique_guid      comment "用户设备id"
    ,test_flag        comment "是否是测试号充值（0正式，1测试）"
    ,buy_token        comment "购买时候的google的token"
    ,base_amount      comment "分成后的数量"
    ,version          comment "购买时，用户客户端的版本号"
    ,subpay_type      comment "充值渠道"
    ,gift_money       comment "充值赠送的礼券数(可能不准确)"
    ,order_init_time  comment "用户订单创建时间"
    ,cooorder_extinfo comment "合作方订单扩展"
    ,custom_data      comment "自定义数据，透传，json格式"
    ,corever2         comment "当前core"
    ,vip_type         comment "订阅周期"
)
comment "短剧支付订单视图"
as
select a.dt                 as dt                  -- createtime分区
     , 6833                 as product_id          -- 产品id 6833海外短剧
     , a.id                 as id                  -- 自增id
     , a.type               as type                -- 类型
     , a.userid             as user_id             -- 用户id
     , a.used               as used                -- 是否执行
     , a.orderid            as order_id            -- 订单id
     , a.flag               as flag                -- 标识
     , a.createtime         as create_time         -- 创建时间
     , a.gettime            as get_time            -- 获取时间
     , a.itemcount          as item_count          -- 金额数
     , a.systemtype         as system_type         -- 系统类型
     , a.receivedate        as receive_date        -- 被接收时间
     , a.mt                 as mt                  -- 终端
     , a.couponid           as coupon_id           -- 礼券id
     , a.packageid          as package_id          -- 存放充值页面来源
     , a.shopitem           as shop_item           -- 充值类型
     , a.extinfo            as extinfo             -- 信息
     , a.vipexpiretime      as vip_expire_time     -- 充值订阅卡时，过期时间
     , a.realmoney          as real_money          -- 给的阅币数
     , a.givemoney          as give_money          -- 暂时无用
     , a.amount             as amount              -- 暂时无用
     , a.prodid             as prod_id             -- 暂时无用
     , a.payconfigid        as pay_config_id       -- 充值项的id，可能不准确
     , a.corever            as corever             -- 包体
     , a.uniqueguid         as unique_guid         -- 用户设备id
     , a.testflag           as test_flag           -- 是否是测试号充值（0正式，1测试）
     , a.buytoken           as buy_token           -- 购买时候的google的token
     , a.baseamount         as base_amount         -- 分成后的数量
     , a.version            as version             -- 购买时，用户客户端的版本号
     , a.subpaytype         as subpay_type         -- 充值渠道
     , a.giftmoney          as gift_money          -- 充值赠送的礼券数(可能不准确)
     , a.orderinittime      as order_init_time     -- 用户订单创建时间
     , a.cooorderextinfo    as cooorder_extinfo    -- 合作方订单扩展
     , a.customdata         as custom_data         -- 自定义数据，透传，json格式
     , b.corever2           as corever2            -- 当前core
     , c.vip_type           as vip_type            -- 订阅周期
  from ods.ods_tidb_short_video_payorder         as a
  left join dim.dim_short_video_user_accountinfo as b
    on a.userid = b.user_id
  left outer join (select item_id
                        , shop_item_id
                        , effective_time
                        , vip_type
                        , case when vip_type = 1 then '月卡'
                               when vip_type = 2 then '季卡'
                               when vip_type = 3 then '年卡'
                               when vip_type = 4 then '周卡'
                               when vip_type = 5 then concat(effective_time, '天卡')
                           end          as vip_type_info
                        , goods_attribute
                        , first_price
                        , first_effective_time
                        , max(price)    as price
                     from dim.dim_short_video_goods_view
                    where shop_item_id in (840, 810, 860)
                      and is_remove = 0
                    group by 1, 2, 3, 4, 5, 6, 7, 8
                  )                              as c
    on (substring_index(substring_index(substring_index(substring_index(substring_index(a.ExtInfo, '|', -1), 'com.changdu.mobovideo.', -1), 'com.changdu.moboshort.', -1), 'com.changjian.moboshortcj.', -1), 'third.', -1)) = c.item_id
   and a.ShopItem = c.shop_item_id
;