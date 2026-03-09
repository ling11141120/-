drop table if exists dwd.dwd_ab_exp_version_detail;
create table dwd.dwd_ab_exp_version_detail (
     project_id     bigint       not null comment "1-阅读  2-国内短剧 3-海外短剧 4-其他"
    ,exp_id         bigint       not null comment "实验id"
    ,exp_grp_id     bigint       not null comment "实验组id"
    ,exp_grp_type   bigint       not null comment "实验组类型ID: 1-对照组 2-实验组"
    ,exp_grp_ver_id bigint       not null comment "实验版本id"
    ,exp_start_time datetime              comment "实验开始时间"
    ,exp_end_time   datetime              comment "实验结束时间"
    ,start_time     datetime              comment "实验版本开始时间"
    ,end_time       datetime              comment "实验版结束时间"
    ,exp_name       varchar(500)          comment "实验名称"
    ,exp_grp_name   varchar(500)          comment "实验组名称"
    ,etl_time       datetime              comment "数据时间"
)
primary key(project_id, exp_id, exp_grp_isd, exp_grp_type, exp_grp_ver_id)
comment "海剧-实验所有版本--明细表"
distributed by hash(exp_id, exp_grp_ver_id) buckets 3
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "exp_id, exp_grp_ver_id",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;