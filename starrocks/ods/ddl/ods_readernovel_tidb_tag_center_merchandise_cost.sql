create table if not exists ods.ods_readernovel_tidb_tag_center_merchandise_cost (
     Id                    int(11)          not null                COMMENT 'ID'
    ,Name                  varchar(765)     not null                COMMENT '商品价值名称'
    ,ApplyType             int(2)           not null                COMMENT '应用场景'
    ,MerchandiseType       int(2)           not null                COMMENT '商品类型'
    ,Money                 int(11)          not null                COMMENT '阅币'
    ,GifMoney              int(11)          not null                COMMENT '礼券'
    ,AddGifMoney           int(11)          not null                COMMENT '充值挽留加赠礼券'
    ,IsThird               int(2)           not null                COMMENT '是否开启第三方加赠'
    ,Price                 int(11)          not null                COMMENT '商品价值'
    ,CreateTime            datetime         not null                COMMENT '创建时间'
    ,UpdateTime            datetime         not null                COMMENT '更新时间'
    ,IsDelete              int(1)           not null                COMMENT '是否删除'
    ,Color                 int(11)          not null default "0"    COMMENT '颜色'
    ,FirstChargeType       int(2)           not null default "0"    COMMENT '首充属性'
    ,TitleId               int(11)          not null default "0"    COMMENT 'SVIP角标标题Id'
    ,Validity              int(4)           not null default "0"    COMMENT '有效期'
    ,FirstValidity         int(11)          not null default "0"    COMMENT '首充有效期'
    ,FirstPrice            int(11)          not null default "0"    COMMENT '首充价格'
    ,AddGifMoneyByDay      int(11)          not null default "0"    COMMENT '充值挽留每日加赠礼券'
    ,StyleType             int(11)          not null default "0"    COMMENT '档位展示样式'
    ,CardId                int(11)          not null default "0"    COMMENT '限时免费卡Id'
    ,AddCardId             int(11)          not null default "0"    COMMENT '加赠限免卡'
    ,FirstRechargeCoins    int(11)          not null default "0"    COMMENT '首充消耗阅币'
    ,OriginalPrice         decimal(18,2)             default "0"    COMMENT '原价'
    ,ActualPrice           decimal(18,2)    not null default "0"    COMMENT '实际精准金额'
)
primary key (id)
comment '核心商品价值配置'
distributed by hash(id)
properties("replication_num" = "3"
          ,"in_memory" = "false"
          ,"enable_persistent_index" = "true"
          ,"replicated_storage" = "true"
          ,"compression" = "LZ4"
)
;