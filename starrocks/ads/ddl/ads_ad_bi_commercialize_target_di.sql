drop table if exists ads.ads_ad_bi_commercialize_target_di;
create table if not exists ads.ads_ad_bi_commercialize_target_di (
     dt                  date               not null                    comment "日期"
    ,project_type        int(11)            not null                    comment "项目类型 1=海阅|2=海剧"
    ,week                varchar(65533)     not null                    comment "年周"
    ,quarter             varchar(128)       not null                    comment "年季度"
    ,core                varchar(400)                                   comment "core ，多个用逗号隔开(1core1，2core2，3core3，4core4)"
    ,dau                 int(11)            not null                    comment "日活"
    ,deu                 int(11)            not null                    comment "广告总活跃"
    ,motive_deu          int(11)            not null                    comment "激励视频活跃"
    ,ad_amt_zs           decimal(38, 6)     not null                    comment "真实广告收益"
    ,click_cnt_zs        int(11)            not null                    comment "激励视频广告点击次数"
    ,show_cnt_zs         int(11)            not null                    comment "激励视频广告展示次数"
    ,ad_amt_yg           decimal(38, 6)     not null                    comment "激励视频预估广告收益"
    ,show_cnt_yg         int(11)            not null                    comment "激励视频广告展示次数"
    ,show_unt_yg         int(11)            not null                    comment "激励视频广告展示人数"
    ,watch_cnt_sc        int(11)            not null                    comment "激励视频广告完播次数"
    ,click_cnt_sc        int(11)            not null                    comment "激励视频资源位点击次数"
    ,ad_unlock_user_cnt  int(11)                                        comment "广告解锁用户数"
    ,ad_all_user_cnt     int(11)                                        comment "全广告渗透用户(sdk+h5+广告解锁 用户去重)"
    ,ad_amt_zs_c1        decimal(38, 6)                                 comment "core1商业化收入"
    ,unlock_unt          int(11)                                        comment "解锁剧集人数"
    ,unlock_cnt          int(11)                                        comment "解锁剧集次数"
    ,unlock_unt_d0       int(11)                                        comment "d0解锁剧集人数"
    ,unlock_cnt_d0       int(11)                                        comment "d0解锁剧集次数"
    ,unlock_unt_d1       int(11)                                        comment "d1+解锁剧集人数"
    ,unlock_cnt_d1       int(11)                                        comment "d1+解锁剧集次数"
    ,ad_unlock_unt       int(11)                                        comment "广告解锁剧集人数"
    ,ad_unlock_cnt       int(11)                                        comment "广告解锁剧集次数"
    ,ad_unlock_unt_d0    int(11)                                        comment "d0广告解锁剧集人数"
    ,ad_unlock_cnt_d0    int(11)                                        comment "d0广告解锁剧集次数"
    ,ad_unlock_unt_d1    int(11)                                        comment "d1+广告解锁剧集人数"
    ,ad_unlock_cnt_d1    int(11)                                        comment "d1+广告解锁剧集次数"
    ,watch_unt           int(11)                                        comment "开始观看的人数"
    ,watch_cnt           int(11)                                        comment "开始观看的次数"
    ,watch_unt_d0        int(11)                                        comment "d0开始观看的人数"
    ,watch_cnt_d0        int(11)                                        comment "d0开始观看的次数"
    ,watch_unt_d1        int(11)                                        comment "d1+开始观看的人数"
    ,watch_cnt_d1        int(11)                                        comment "d1+开始观看的次数"
    ,series_cnt          decimal(38, 6)                                 comment "人均观看短剧数量"
    ,series_cnt_d0       decimal(38, 6)                                 comment "人均观看短剧数量（d0）"
    ,series_cnt_d1       decimal(38, 6)                                 comment "人均观看短剧数量（d1+）"
    ,etl_tm              datetime           default current_timestamp   comment "etl清洗时间"
)
primary key(dt, project_type)
comment "海阅/海剧广告商业化指标表"
distributed by hash(dt, project_type) buckets 3
properties (
     "replication_num" = "3",
     "in_memory" = "false",
     "enable_persistent_index" = "false",
     "replicated_storage" = "true",
     "compression" = "lz4"
)
;