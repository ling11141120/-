drop table if exists ads.ads_bi_ss_inc_auto_lcl_trl_rev_cost;
create table if not exists ads.ads_bi_ss_inc_auto_lcl_trl_rev_cost (
     dt              date               not null                        comment "数据日期"
    ,book_id         bigint             not null                        comment "书籍id"
    ,chl_src         varchar(50)        not null                        comment "渠道来源"
    ,roi             decimal(18,2)                                      comment "投资回报率"
    ,cpi             decimal(18,2)                                      comment "平均注册用户花费数"
    ,arpu            decimal(18,2)                                      comment "日均用户收入"
    ,ttl_amt         decimal(18,2)                                      comment "总成本"
    ,etl_time        datetime           default current_timestamp       comment "etl处理时间"
)
primary key (dt, book_id, chl_src)
comment "BI-短篇孵化自动化小语种翻译收入成本"
PARTITION BY DATE_TRUNC("year",dt)
DISTRIBUTED BY HASH (dt)
properties (
    "replication_num" = "3",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;