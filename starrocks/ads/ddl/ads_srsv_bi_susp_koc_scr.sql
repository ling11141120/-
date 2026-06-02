drop table if exists ads.ads_srsv_bi_susp_koc_scr;
create table ads.ads_srsv_bi_susp_koc_scr (
     dt                  date        not null comment "日期"
    ,usr_id              bigint      not null comment "用户id"
    ,prj_type_cd         int         not null comment "项目类型"
    ,prj_type_name       varchar(20)          comment "项目类型名称"
    ,ttl_view_num        int                  comment "总观看数"
    ,ttl_view_min        int                  comment "总观看分钟数"
    ,pay_mth             string               comment "支付方式"
    ,tp_prd              varchar(20)          comment "充值产品"
    ,ad_show_cnt         int                  comment "广告展示次数"
    ,avg_rev_per_ad      double               comment "单广告平均收入"
    ,watch_sec_per_ad    int                  comment "单广告看剧时长"
)
primary key (dt, usr_id, prj_type_cd)
comment "嫌疑达人分值表"
partition by date_trunc('month', dt)
distributed by hash(dt, usr_id) buckets 3
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "lz4"
);
