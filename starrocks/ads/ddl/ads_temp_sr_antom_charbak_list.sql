create table ads.ads_temp_sr_antom_charbak_list(
     dispute_id                     varchar(255)
    ,chargeback_alert_type          varchar(255)    not null
    ,captureid                      int(11)
    ,defendable                     varchar(255)    not null
    ,automatic_defense              varchar(255)    not null
    ,amount                         varchar(255)    not null
    ,dispute_status                 varchar(255)    not null
    ,dispute_creation_date          datetime        not null
    ,due_date                       datetime        not null
    ,reason_type                    varchar(255)    not null
    ,reason_code                    decimal(10, 2)  not null
    ,dispute_last_updated           datetime        not null
    ,transaction_id                 varchar(255)    not null
    ,transaction_date               datetime        not null
    ,transaction_currency           varchar(255)    not null
    ,transaction_amount             decimal(10, 2)  not null
    ,merchant_id                    varchar(255)    not null
    ,merchant_payment_request_id    varchar(255)    not null
)
duplicate key (dispute_id)
comment '临时表'
distributed by hash(dispute_id)
properties (
    "replication_num" = "3",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "lz4"
)
;