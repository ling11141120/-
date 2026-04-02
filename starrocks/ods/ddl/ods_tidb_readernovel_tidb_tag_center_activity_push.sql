----------------------------------------------------------------
-- 目标表： ods.ods_tidb_readernovel_tidb_tag_center_activity_push
-- 来源实例： old_tidb_source
-- 来源表： readernovel.center_activity_push
-- 来源负责： 
-- 采集工具： SeaTunnel
-- 开发人： xjc
-- 开发日期： 2026-04-01
----------------------------------------------------------------

drop table if exists ods.ods_tidb_readernovel_tidb_tag_center_activity_push;
create table ods.ods_tidb_readernovel_tidb_tag_center_activity_push (
     dt                  date              not null                     comment '日期,create_time'
    ,id                  int               not null                     comment 'push_id'
    ,activityid          int               not null                     comment '活动id'
    ,sendtype            tinyint           not null                     comment '发送类型'
    ,titleid             int               not null                     comment '标题id'
    ,contentid           int               not null                     comment '内容id'
    ,createtime          datetime          not null                     comment '创建时间'
    ,status              tinyint           not null                     comment '状态'
    ,url                 varchar(65533)                                 comment 'url'
    ,sendhour            decimal(4, 2)     not null                     comment '发送小时'
    ,name                varchar(65533)                                 comment '名称'
    ,actiontype          tinyint           not null                     comment '行的类型'
    ,groupids            varchar(65533)                                 comment '用户组id'
    ,core                varchar(65533)                                 comment 'core'
    ,mt                  varchar(65533)                                 comment '平台'
    ,maxver              int               not null                     comment '最大版本号'
    ,minver              int               not null                     comment '最小版本号'
    ,sendtime            datetime                                       comment '发送时间'
    ,langid              int               not null                     comment '语言id'
    ,materialtype        tinyint           not null                     comment '素材类型'
    ,frequencytype       tinyint           not null                     comment '频率类型'
    ,materialid          int               not null                     comment '素材id'
    ,updatetime          datetime                                       comment '更新时间'
    ,timezone            varchar(65533)                                 comment '时区'
    ,issilent            tinyint           not null                     comment '是否静默'
    ,excludegroupids     varchar(65533)                                 comment '排除用户组id'
    ,usetype             tinyint           not null                     comment '使用类型'
    ,applytype           int               not null                     comment '应用类型'
    ,jgroupids           varchar(65533)                                 comment '极光人群包'
    ,excludejgroupids    varchar(65533)                                 comment '极光剔除人群包'
    ,sr_createtime       datetime          default current_timestamp    comment 'starrocks数据注入时间'
    ,sr_updatetime       datetime          default current_timestamp    comment 'starrocks数据更新时间'
    ,timezones           varchar(1500)                                  comment '时区组'
    ,sendhours           varchar(300)                                   comment '延迟发送时间组'
    ,intervalcount       int               not null                     comment '活动每日次数'
    ,isvipadsource       int               not null                     comment '是否VIP引流（0否，1是）'
    ,plancode            varchar(300)                                   comment '策略代号'
    ,newsstyle           int               not null                     comment '消息样式 0默认，1单图，2双图'
    ,labelid             int               not null                     comment '标签文案Id'
    ,buttonid            int               not null                     comment '按钮文案Id'
    ,secondmaterialid    int               not null                     comment '图2素材Id'
    ,contentgroupid      int               not null                     comment '文案组Id'
    ,isfullscreen        tinyint           not null                     comment '是否开启全屏通知'
)
primary key(dt,id)
comment "tag后台,push管理-记录push_id和活动id的配置表"
partition by date_trunc('year', dt)
distributed by hash(id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "lz4"
)
;


