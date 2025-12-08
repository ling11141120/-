drop table if exists dim.dim_user_login_anonymous_map;
create table dim.dim_user_login_anonymous_map (
     login_id        varchar(1024)    not null                     comment "登录id"
    ,anonymous_id    varchar(1024)    not null                     comment "匿名id"
    ,core            varchar(50)      not null                     comment "core"
    ,etl_time        datetime         default current_timestamp    comment "etl清洗时间"
)
primary key (login_id,anonymous_id,core)
comment "用户id-匿名id映射表"
distributed by hash (login_id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"compression" = "lz4"
)
;