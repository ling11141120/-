drop table if exists ads.ads_shennong_dev_mdl_anr_dau_ad_imp_eval;
create table if not exists ads.ads_shennong_dev_mdl_anr_dau_ad_imp_eval (
     dt                  date             not null    comment '日期'
    ,biz_type_cd         int              not null    comment '业务类型编码'
    ,core                int              not null    comment 'core'
    ,dev_mdl             varchar(100)     not null    comment '设备型号'
    ,biz_type_name       varchar(10)                  comment '业务类型名称'
    ,mfr                 varchar(100)                 comment '厂商'
    ,anr_ocr_dt          date                         comment 'ANR发生日期'
    ,anr_fch_dt          date                         comment 'ANR抓取日期'
    ,dev_guid            varchar(50)                  comment '设备GUID'
    ,imp_num             decimal(20,0)                comment '影响数'
    ,sess_num            decimal(20,0)                comment '会话数'
    ,imp_pct             decimal(20,5)                comment '受影响占比'
    ,hist_anr_usr_rat    decimal(20,5)                comment '历史ANR用户比例'
    ,svr_dau             decimal(20,5)                comment '服务端日活'
    ,ad_uv               decimal(20,5)                comment '广告uv'
    ,ad_ttl_amt          decimal(20,5)                comment '广告总收入'
    ,ad_rpc              decimal(20,5)                comment '广告人均单价'
    ,web_ad_amt          decimal(20,5)                comment 'web广告收入'
    ,web_ad_rpc          decimal(20,5)                comment 'web广告人均单价'
    ,med_sdk_ad_amt      decimal(20,5)                comment '聚合SDK广告收入'
    ,med_sdk_ad_rpc      decimal(20,5)                comment '聚合SDK广告人均单价'
)
primary key (dt, biz_type_cd ,core ,dev_mdl)
comment '神农-机型ANR日活广告影响评估'
partition by date_trunc('month',dt)
distributed by hash (dt, biz_type_cd, core, dev_mdl)
properties("replication_num" = "3",
           "enable_persistent_index" = "true",
           "replicated_storage" = "true",
           "compression" = "LZ4"
)
;