----------------------------------------------------------------
-- 目标表： ods.ods_koc_b_userinfo_tb
-- 来源实例： hk-koc-mysql-slave
-- 来源表： koc_db.koc_adltvitem
-- 来源负责： 黄文
-- 采集工具： SeaTunnel
-- 开发人： qhr/wxl
-- 开发日期： 2023-08-05
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_koc_b_userinfo_tb;
CREATE TABLE ods.ods_koc_b_userinfo_tb (
     UserId               VARCHAR(1000) NOT NULL COMMENT "达人id"
    ,RealUserId           VARCHAR(200)           COMMENT ""
    ,Account              VARCHAR(5000)          COMMENT "账户"
    ,NickName             VARCHAR(5000)          COMMENT "昵称"
    ,Pwd                  VARCHAR(1000)          COMMENT ""
    ,UserType             INT                    COMMENT "用户类型"
    ,RoleId               VARCHAR(36)            COMMENT "角色id"
    ,Phone                VARCHAR(500)           COMMENT ""
    ,DingId               VARCHAR(500)           COMMENT ""
    ,Email                VARCHAR(5000)          COMMENT ""
    ,CreateTime           DATETIME               COMMENT "创建时间"
    ,CreateTimeEnd        DATETIME               COMMENT "创建结束时间"
    ,UpdateTime           DATETIME               COMMENT "更新时间"
    ,DelFlag              INT                    COMMENT "删除状态"
    ,LastLoginTime        DATETIME               COMMENT "最后登录时间"
    ,LoginStatus          INT                    COMMENT "登录状态"
    ,CountryType          INT           NOT NULL COMMENT "国家地区 0无 1国内  2国外"
    ,RealName             VARCHAR(1000)          COMMENT "真实姓名"
    ,IDCard               VARCHAR(500)           COMMENT "身份证号码"
    ,IDCardFrontPhoto     VARCHAR(1000)          COMMENT "身份证正面"
    ,IDCardVersoPhoto     VARCHAR(1000)          COMMENT "身份证背面"
    ,Province             VARCHAR(500)           COMMENT "省"
    ,City                 VARCHAR(500)           COMMENT "市"
    ,County               VARCHAR(500)           COMMENT "县/区"
    ,Address              VARCHAR(1000)          COMMENT "地址"
    ,FDDCustomerId        VARCHAR(500)           COMMENT "法大大id"
    ,FDDCustomerVerifyUrl VARCHAR(5000)        COMMENT "法大大认证地址"
    ,FDDVerifyNo          VARCHAR(500)           COMMENT "法大大流水单号"
    ,FDDVerifyStatus      INT           NOT NULL COMMENT "法大大个人认证状态 0无"
    ,CA                   VARCHAR(500)           COMMENT "法大大CA"
    ,OpenId               VARCHAR(1000)          COMMENT "微信openid"
    ,UnionId              VARCHAR(1000)          COMMENT "微信unionid"
    ,HasBindWx            INT                    COMMENT "是否换绑微信"
    ,IpAdress             VARCHAR(200)           COMMENT "IP地址"
    ,IpCountry            VARCHAR(500)           COMMENT "IP国家 通过ip地址解析"
    ,sr_createtime        DATETIME               COMMENT "同步时间"
    ,sr_updatetime        DATETIME               COMMENT "更新时间"
)
PRIMARY KEY (UserId)
COMMENT "达人用户信息"
DISTRIBUTED BY HASH (UserId) BUCKETS 1 
PROPERTIES (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;