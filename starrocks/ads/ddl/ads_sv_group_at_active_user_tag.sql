drop table if exists ads.ads_sv_group_at_active_user_tag;
create table ads.ads_sv_group_at_active_user_tag (
     dt                       date           NOT NULL COMMENT "日期"
    ,user_id                  bigint(20)     NOT NULL COMMENT "用户id"
    ,core                     varchar(50)             COMMENT "core"
    ,register_time            datetime                COMMENT "注册时间"
    ,ui_lang                  varchar(50)             COMMENT "界面语言"
    ,ad_lang                  varchar(50)             COMMENT "渠道推广语言"
    ,client_ver_num           int                     COMMENT "服务器版本"
    ,nation                   varchar(50)             COMMENT "国家"
    ,nation_level             varchar(50)             COMMENT "国家等级"
    ,platform                 varchar(50)             COMMENT "平台，MT"
    ,sv_last_show_ecpm        decimal(12, 2)          COMMENT "最近展现激励视频eCPM"
    ,is_recharged             varchar(50)             COMMENT "有无充值"
    ,double_recharge_mode     decimal(12, 2)          COMMENT "充值众数(小数)"
    ,current_sign_card_status varchar(50)             COMMENT "当前签到卡状态"
    ,current_vip_status       varchar(50)             COMMENT "当前VIP状态"
    ,current_svip_status      varchar(50)             COMMENT "当前SVIP状态"
    ,double_first_svip_price  decimal(12, 2)          COMMENT "首次SVIP金额(小数)"
    ,double_first_vip_price   decimal(12, 2)          COMMENT "首次VIP金额(小数)"
)
primary key(dt, user_id)
comment "海剧人群标签表-提供给付费墙中台等使用"
partition by date_trunc('day', dt)
distributed by hash(dt, user_id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "LZ4"
)
;