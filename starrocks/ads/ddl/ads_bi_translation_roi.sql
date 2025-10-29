drop table if exists ads.ads_bi_translation_roi;
create table if not exists ads.ads_bi_translation_roi (
    dt                              date                    not null    comment "时间"
   ,book_id                         bigint(20)              not null    comment "书籍id"
   ,book_code                       varchar(255)            null        comment "书籍代号"
   ,site_id                         int(11)                 null        comment "语种"
   ,site_name                       varchar(50)             null        comment "语种名称"
   ,book_name                       varchar(1048576)        null        comment "书名"
   ,source_book                     bigint(20)              null        comment "源书籍"
   ,cn_publish_length               bigint(20)              null        comment "中文发布字数"
   ,publish_length                  bigint(20)              null        comment "每日外语发布字数"
   ,trad_money_total_amount         decimal(16, 2)          null        comment "繁体总收入"
   ,fore_money_total_amount         decimal(16, 2)          null        comment "外语总收入"
   ,is_full                         int(11)                 null        comment "完本状态 0连载 1合作商通知完本 3完本打包队列 4打包成功 5打包失败 6完本不打包 7图书打包"
   ,translation_cost                decimal(16, 4)          null        comment "翻译成本"
   ,estimate_cost_day               decimal(16, 4)          null        comment "每日的预估成本"
   ,cost_amt                        decimal(38, 8)          null        comment "投放总成本"
   ,fmx_flag                        varchar(1048576)        null        comment "凤鸣轩-书籍标识"
   ,p_1002                          decimal(16, 2)          null        comment "p-新书续签奖励成本"
   ,p_1003                          decimal(16, 2)          null        comment "p-完本奖成本"
   ,p_1004                          decimal(16, 2)          null        comment "p-全勤奖励成本"
   ,p_1005                          decimal(16, 2)          null        comment "p-衍生收益成本"
   ,p_1007                          decimal(16, 2)          null        comment "p-翻译收入成本"
   ,p_1008                          decimal(16, 2)          null        comment "p-千字稿酬成本"
   ,p_1010                          decimal(16, 2)          null        comment "p-三方收益成本"
   ,p_1011                          decimal(16, 2)          null        comment "p-签约奖励成本"
   ,p_1012                          decimal(16, 2)          null        comment "p-激励奖金包成本"
   ,p_1013                          decimal(16, 2)          null        comment "p-短篇收入成本"
   ,a_0000                          decimal(16, 2)          null        comment "a-稿酬,在凤鸣轩平台的成本"
   ,a_1002                          decimal(16, 2)          null        comment "a-新书续签奖励,在国内编辑部的成本"
   ,a_1003                          decimal(16, 2)          null        comment "a-完本奖,在国内编辑部的成本"
   ,a_1004                          decimal(16, 2)          null        comment "a-全勤奖励,在国内编辑部的成本"
   ,a_1005                          decimal(16, 2)          null        comment "a-衍生收益,在国内编辑部的成本"
   ,a_1007                          decimal(16, 2)          null        comment "a-翻译收入,在国内编辑部的成本"
   ,a_1008                          decimal(16, 2)          null        comment "a-千字稿酬,在国内编辑部的成本"
   ,a_1010                          decimal(16, 2)          null        comment "a-三方收益,在国内编辑部的成本"
   ,a_1011                          decimal(16, 2)          null        comment "a-签约奖励,在国内编辑部的成本"
   ,a_1012                          decimal(16, 2)          null        comment "a-激励奖金包,在国内编辑部的成本"
   ,a_1013                          decimal(16, 2)          null        comment "a-短篇收入,在国内编辑部的成本"
   ,1010_income_amt                 decimal(16, 2)          null        comment "国内编辑系统，三方收益的总收入"
   ,1013_income_amt                 decimal(16, 2)          null        comment "国内编辑系统，短篇收入总收入"
   ,etl_time                        datetime                null        comment "etl时间"
)
primary key(dt, book_id)
comment "签约书籍roi"
distributed by hash(dt) buckets 1
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "lz4"
);