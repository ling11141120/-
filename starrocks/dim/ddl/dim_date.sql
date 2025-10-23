drop table if exists dim.dim_date;
create table dim.dim_date (
     date_id               varchar(50) not null    comment "日期(yyyymmdd)"
    ,datestr               varchar(50) not null    comment "日期(yyyy-mm-dd)"
    ,date_name             varchar(50)             comment "日期名称中文"
    ,weekid                int(11)                 comment "周(0-6,周日~周六)"
    ,week_cn_name          varchar(50)             comment "周_名称_中文"
    ,week_en_name          varchar(50)             comment "周_名称_英文"
    ,week_en_nm            varchar(50)             comment "周_名称_英文缩写"
    ,yearmonthid           varchar(50)             comment "月份id(yyyymm)"
    ,yearmonthstr          varchar(50)             comment "月份(yyyy-mm)"
    ,monthid               int(11)                 comment "月份id(1-12)"
    ,monthstr              varchar(50)             comment "月份"
    ,month_cn_name         varchar(50)             comment "月份名称_中文"
    ,month_en_name         varchar(50)             comment "月份名称_英文"
    ,month_en_nm           varchar(50)             comment "月份名称_简写_英文"
    ,quarterid             int(11)                 comment "季度id(1-4)"
    ,quarterstr            varchar(50)             comment "季度名称"
    ,quarter_cn_name       varchar(50)             comment "季度名称_中文"
    ,quarter_en_name       varchar(50)             comment "季度名称_英文"
    ,quarter_cn_nm         varchar(50)             comment "季度名称_简写中文"
    ,quarter_en_nm         varchar(50)             comment "季度名称_简写英文"
    ,yearid                int(11)                 comment "年份id"
    ,year_cn_name          varchar(50)             comment "年份名称_中文"
    ,year_en_name          varchar(50)             comment "年份名称_英文"
    ,month_start_date      varchar(50)             comment "当月1号(yyyy-mm-dd)"
    ,month_end_date        varchar(50)             comment "当月最后日期(yyyy-mm-dd)"
    ,month_timespan        int(11)                 comment "月跨天数"
    ,week_of_year          int(11)                 comment "当年第几周"
    ,workday_flag          varchar(50)             comment "是否工作日(周一至周五y,否则:n)"
    ,weekend_flag          varchar(50)             comment "是否周末(周六和周日y,否则:n)"
    ,china_holiday_flag    varchar(50)             comment "是否中国节假日y"
    ,china_holiday_name    varchar(50)             comment "补班名称/节假日名称"
    ,china_workday_flag    varchar(50)             comment "是否工作日(周一至周五并且不是中国法定节假日或者节假日前后的补班y,否则:n)"
)
primary key(date_id, datestr)
comment "书籍作者维度表"
distributed by hash(datestr) buckets 3
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "lz4"
)
;