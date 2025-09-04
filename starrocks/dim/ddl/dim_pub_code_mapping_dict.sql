DROP TABLE IF EXISTS dim.dim_pub_code_mapping_dict;
CREATE TABLE dim.dim_pub_code_mapping_dict (
     app_plat           VARCHAR(50)      NOT NULL COMMENT "应用平台"
    ,cd_col             VARCHAR(100)     NOT NULL COMMENT "编码字段"
    ,cd_val             VARCHAR(100)     NOT NULL COMMENT "编码值"
    ,cd_col_desc        VARCHAR(100)              COMMENT "编码字段描述"
    ,cd_val_desc        VARCHAR(100)              COMMENT "编码值描述"
    ,p_cd_col           VARCHAR(100)              COMMENT "上级编码字段"
    ,p_cd_col_desc      VARCHAR(100)              COMMENT "上级编码字段描述"
    ,p_cd_val           VARCHAR(100)              COMMENT "上级编码值"
    ,p_cd_desc          VARCHAR(100)              COMMENT "上级编码描述"
)
PRIMARY KEY (app_plat, cd_col, cd_val)
COMMENT "代码映射字典"
DISTRIBUTED BY HASH (app_plat, cd_col, cd_val)
PROPERTIES (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;