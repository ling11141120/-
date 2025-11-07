drop table if exists ads.ads_bi_book_chap5_ret_rt_info;
create table ads.ads_bi_book_chap5_ret_rt_info (
     dt                   date      not null comment '日期'
    ,book_id              bigint    not null comment '书籍id'
    ,site_id              int(11)            comment '语言id'
    ,new_cid              int(11)            comment '分类id'
    ,new_cname            varchar(100)       comment '分类名称'
    ,chap5_read_num       int(11)            comment '第五章阅读人数'
    ,ttl_chap_read_num    int(11)            comment '总阅读人数'
    ,chap5_ret_rt         decimal(10,4)      comment '第五章留存率'
)
primary key (dt,book_id)
comment 'bi-书籍第5章留存信息表'
partition by range(dt)()
distributed by hash(dt, book_id) buckets 1
properties (
    "replication_num" = "3",
    "compression" = "LZ4",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "DAY",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-7",
    "dynamic_partition.end" = "1",
    "dynamic_partition.history_partition_num" = "9",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "1",
    "compression" = "LZ4"
)
;