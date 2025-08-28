----------------------------------------------------------------
-- 目标表： ods.ods_tidb_SharpEngineDB_b_userinfo_tb
-- 来源实例： new_tidb_source
-- 来源表： SharpEngineDB.b_userinfo_tb
-- 采集工具： SeaTunnel
-- 负责人： qhr
-- 创建日期： 2023-08-13
----------------------------------------------------------------

CREATE TABLE IF NOT EXISTS ods.ods_tidb_SharpEngineDB_b_userinfo_tb (
     UserId           VARCHAR(108)  NOT NULL                          COMMENT '用户ID'
    ,RealUserId       VARCHAR(60)                                     COMMENT '真实用户ID'
    ,Account          VARCHAR(90)                                     COMMENT '账号'
    ,NickName         VARCHAR(60)                                     COMMENT '昵称'
    ,Pwd              VARCHAR(300)                                    COMMENT '密码'
    ,UserType         INT                                             COMMENT '用户类型'
    ,RoleId           VARCHAR(108)                                    COMMENT '角色ID'
    ,Phone            VARCHAR(33)                                     COMMENT '手机号'
    ,DingId           VARCHAR(150)                                    COMMENT '钉钉ID'
    ,Email            VARCHAR(150)                                    COMMENT '邮箱'
    ,CreateTime       DATETIME                                        COMMENT '创建时间'
    ,CreateTimeEnd    DATETIME                                        COMMENT '创建时间结束'
    ,UpdateTime       DATETIME                                        COMMENT '更新时间'
    ,DelFlag          INT                                             COMMENT '删除标志'
    ,LastLoginTime    DATETIME                                        COMMENT '最后登录时间'
    ,sr_createtime    DATETIME              DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
    ,sr_updatetime    DATETIME              DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
)
PRIMARY KEY(UserId)
COMMENT "优化师信息表"
DISTRIBUTED BY HASH(UserId)
PROPERTIES ("replication_num" = "3",
            "in_memory" = "false",
            "enable_persistent_index" = "true",
            "replicated_storage" = "true",
            "compression" = "LZ4"
)
;