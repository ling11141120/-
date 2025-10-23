drop table if exists dim.dim_bib_crs_info;
create table if not exists dim.dim_bib_crs_info (
     crs_id                 bigint               not null                        comment "课程id"
    ,crs_name               varchar(1020)                                        comment "课程名称"
    ,crs_cover              varchar(1020)                                        comment "课程封面"
    ,pub_statu_cd           tinyint                                              comment "上架状态编码"
    ,pub_statu_name         varchar(50)                                          comment "上架状态名称"
    ,crs_ep_num             int                                                  comment "课程集数"
    ,crs_tag_lst            array<varchar(1020)>                                 comment "课程标签序列"
    ,crs_rtg                int                                                  comment "课程评分"
    ,rmk                    varchar(4096)                                        comment "备注"
    ,scn                    varchar(1020)                                        comment "场景"
    ,scn_tag                varchar(1020)                                        comment "场景标签"
    ,auth                   varchar(1020)                                        comment "作者"
    ,bg_clr_type_cd         int                                                  comment "背景图片编码"
    ,bg_clr_type_name       varchar(50)                                          comment "背景图片类型名称"
    ,etl_time               datetime                                             comment "etl时间"
)
primary key (crs_id)
comment "圣经课程信息"
distributed by hash (crs_id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "lz4"
)
;