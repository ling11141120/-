----------------------------------------------------------------
-- 目标表： ods.ods_readernovel_tidb_tag_center_merchandise_cost
-- 来源实例： idc-tidb-查询
-- 来源表： ReaderNovel_tidb_tag.center_merchandise_cost
-- 采集工具： SeaTunnel
-- 负责人： qhr
-- 开发日期： 2023-08-05
----------------------------------------------------------------

CREATE TABLE IF NOT EXISTS ods.ods_readernovel_tidb_tag_center_merchandise_cost (
     Id                    INT(11)          NOT NULL                COMMENT 'ID'
    ,Name                  VARCHAR(765)     NOT NULL                COMMENT '商品价值名称'
    ,ApplyType             INT(2)           NOT NULL                COMMENT '应用场景'
    ,MerchandiseType       INT(2)           NOT NULL                COMMENT '商品类型'
    ,Money                 INT(11)          NOT NULL                COMMENT '阅币'
    ,GifMoney              INT(11)          NOT NULL                COMMENT '礼券'
    ,AddGifMoney           INT(11)          NOT NULL                COMMENT '充值挽留加赠礼券'
    ,IsThird               INT(2)           NOT NULL                COMMENT '是否开启第三方加赠'
    ,Price                 INT(11)          NOT NULL                COMMENT '商品价值'
    ,CreateTime            DATETIME         NOT NULL                COMMENT '创建时间'
    ,UpdateTime            DATETIME         NOT NULL                COMMENT '更新时间'
    ,IsDelete              INT(1)           NOT NULL                COMMENT '是否删除'
    ,Color                 INT(11)          NOT NULL DEFAULT "0"    COMMENT '颜色'
    ,FirstChargeType       INT(2)           NOT NULL DEFAULT "0"    COMMENT '首充属性'
    ,TitleId               INT(11)          NOT NULL DEFAULT "0"    COMMENT 'SVIP角标标题Id'
    ,Validity              INT(4)           NOT NULL DEFAULT "0"    COMMENT '有效期'
    ,FirstValidity         INT(11)          NOT NULL DEFAULT "0"    COMMENT '首充有效期'
    ,FirstPrice            INT(11)          NOT NULL DEFAULT "0"    COMMENT '首充价格'
    ,AddGifMoneyByDay      INT(11)          NOT NULL DEFAULT "0"    COMMENT '充值挽留每日加赠礼券'
    ,StyleType             INT(11)          NOT NULL DEFAULT "0"    COMMENT '档位展示样式'
    ,CardId                INT(11)          NOT NULL DEFAULT "0"    COMMENT '限时免费卡Id'
    ,AddCardId             INT(11)          NOT NULL DEFAULT "0"    COMMENT '加赠限免卡'
    ,FirstRechargeCoins    INT(11)          NOT NULL DEFAULT "0"    COMMENT '首充消耗阅币'
    ,OriginalPrice         DECIMAL(18,2)             DEFAULT "0"    COMMENT '原价'
    ,ActualPrice           DECIMAL(18,2)    NOT NULL DEFAULT "0"    COMMENT '实际精准金额'
)
PRIMARY KEY (id)
COMMENT '核心商品价值配置'
DISTRIBUTED BY HASH(id)
PROPERTIES("replication_num" = "3"
          ,"in_memory" = "false"
          ,"enable_persistent_index" = "true"
          ,"replicated_storage" = "true"
          ,"compression" = "LZ4"
)
;