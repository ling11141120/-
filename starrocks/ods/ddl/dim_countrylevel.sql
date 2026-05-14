create table if not exists ods.`tmp.dim_countrylevel` (
    product_id      int                                not null comment '产品id',
    id              int                                not null comment '自增id',
    level           int                                not null comment '国家等级，1：t1国家，2：t2国家',
    short_name      varchar(65533)                     not null comment '国家缩写',
    remark          varchar(65533)                     null comment '备注',
    is_delete       int      default 0                 null,
    row_update_time datetime                           null comment '更新时间',
    sync_language   varchar(65533)                     null comment '同步语言',
    language        int                                null,
    etl_tm          datetime default current_timestamp null
)
    comment 'OLAP' engine = StarRocks;