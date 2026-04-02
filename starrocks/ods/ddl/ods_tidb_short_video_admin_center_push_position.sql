----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_admin_center_push_position
-- 来源实例： old_tidb_source
-- 来源表： short_video.admin_center_push_position
-- 来源负责： 
-- 采集工具： SeaTunnel
-- 开发人： xjc
-- 开发日期： 2026-04-01
----------------------------------------------------------------

drop table if exists ods.ods_tidb_short_video_admin_center_push_position;
create table ods.ods_tidb_short_video_admin_center_push_position (
     id                            bigint           not null                     comment '主键id'
    ,strategy_code                 varchar(300)                                  comment '策略代号'
    ,push_position_name            varchar(1500)                                 comment 'push资源位名称'
    ,strategy_begin_time           datetime                                      comment '策略消息投递开始时间'
    ,strategy_end_time             datetime                                      comment '策略消息投递结束时间'
    ,push_type                     tinyint          not null                     comment '推送场景类型：1-活动推送；2-短剧推送；3-召回推送'
    ,activity_type                 int                                           comment '活动类型：5:组合活动，6-推剧(剧目单)，7-推剧(指定短剧)'
    ,activity_id                   bigint                                        comment '活动Id。即center_activity_main表id'
    ,series_bill_id                bigint                                        comment '推送短剧的剧目库id'
    ,push_frequency                tinyint          not null                     comment '推送频率：1-单次；2-活动期间每日一次。当推送场景=活动推送时，可选择单次、活动期间每日一次；当推送场景=短剧推送时，可选择单次'
    ,push_count                    int                                           comment '活动期间每日N值'
    ,filter_type                   varchar(96)                                   comment '过滤条件，多选逗号拼接。取值：NULL-不限制；1-过滤已购买的短剧；2-过滤加入追剧的短剧；4-过滤看完短剧（过滤观看记录是最后一集的所有完结剧）；6-过滤曝光短剧；7-过滤点击短剧'
    ,push_strategy_type            tinyint                                       comment '推送策略（类型）：1-全量统一；2-用户所属时区；3-注册时间；4-活跃时间'
    ,send_time                     datetime                                      comment '发送时间。当推送策略为固定时间推送，即（全量统一和用户所属时区），该值必填；否则为null'
    ,send_time_param_json          varchar(3000)                                 comment '推送n次扩展json'
    ,delay_send_time               decimal(20, 1)                                comment '延迟推送的小时数。-12＜X＜12，最小单位为0.1。当推送策略为延时时间推送，即（3-注册时间；4-活跃时间），该值必填；否则为null'
    ,title_id                      bigint                                        comment '标题Id'
    ,content_id                    bigint                                        comment '内容Id'
    ,guide_id                      bigint                                        comment '引导文案Id'
    ,count_down                    int                                           comment '倒计时（单位分）'
    ,material_id                   bigint                                        comment '图片素材Id'
    ,material_id2                  bigint                                        comment '图片2素材Id'
    ,style_type                    int              not null                     comment '消息样式 0默认 1单图 2双图'
    ,button_id                     bigint                                        comment '按钮文案id'
    ,label_id                      bigint                                        comment '标签文案id'
    ,url                           varchar(6000)                                 comment '链接url(图片素材URL？)'
    ,group_ids                     varchar(1500)                                 comment '选中人群包id（逗号分割）'
    ,exclude_group_ids             varchar(1500)                                 comment '剔除人群包id（逗号分割）'
    ,sort                          int              not null                     comment '排序。值越小，排序越高'
    ,status                        tinyint          not null                     comment '状态1 开启，2 关闭'
    ,app_type                      int                                           comment '应用类型： 1：短剧，2：阅读'
    ,create_time                   datetime         not null                     comment '创建时间'
    ,update_time                   datetime                                      comment '更新时间'
    ,off_line_group_ids            varchar(1500)                                 comment '离线人群包（北头人群包）选中人群包id（逗号分割）'
    ,off_line_exclude_group_ids    varchar(1500)                                 comment '离线人群包（北斗人群包）剔除人群包id（逗号分割）'
    ,page_type                     tinyint                                       comment '承接页面；0：自定义，1：首页，2：福利中心，3：商店页，4：最近观看的剧'
    ,page_macro                    varchar(1800)                                 comment '宏定义配置'
    ,material_source               int              not null                     comment '素材来源：1-运营后台；2-内容后台。默认值为：1-运营后台'
    ,material_type                 int                                           comment '素材类型：1-PUSH推剧；其他-暂定。默认值为：1-push推剧'
    ,material_one_type             int                                           comment '图1素材 1剧封2自定义'
    ,material_two_type             int                                           comment '图2素材 1剧封2自定义'
    ,page_limit_type               varchar(300)                                  comment '指定页面-限制类型： 1:福利中心-当前未签到用户（非签到卡），2:福利中心-当前未签到用户（签到卡）,3:最新观看集-有剩余广告解锁次数的剧。多个用逗号隔开'
    ,text_group_id                 bigint                                        comment '文案组id'
    ,text_group_type               tinyint                                       comment '文案组下发方式: 1随机,2顺序'
    ,p_type                        tinyint          not null                     comment '0 立即展示 1 本地展示'
    ,local_push_strategy           tinyint                                       comment '0 锁屏状态，1 常亮状态，2 行为动作'
    ,local_push_interval           varchar(150)                                  comment '本地push间隔时间(单位小时)'
    ,ios_push_switch               tinyint          not null                     comment '0 iOS即时通知关闭 1 开启'
    ,notification_permission       varchar(96)                                   comment '通知权限，三态：0未获取,1关闭,2开启，多选逗号分隔'
    ,live_permission               varchar(96)                                   comment 'Live权限，三态：0未获取,1关闭,2开启，多选逗号分隔'
    ,sr_createtime                 datetime         default current_timestamp    comment 'starrocks数据注入时间'
    ,sr_updatetime                 datetime         default current_timestamp    comment 'starrocks数据更新时间'
)
primary key(id)
comment "push资源位表"
distributed by hash(id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "lz4"
)
;