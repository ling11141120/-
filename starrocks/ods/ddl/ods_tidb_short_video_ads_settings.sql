drop table if exists ods.ods_tidb_short_video_ads_settings;
create table ods.ods_tidb_short_video_ads_settings (
     id                     bigint(20)   not null              comment '主键'
    ,strategy_name          varchar(765)                       comment '策略名称'
    ,ads_attr               int(11)                            comment '广告属性 1通用 2降权'
    ,position_ids           varchar(765)                       comment '广告位置id数组 1限免卡降档-半屏充值弹层 2限免卡降档-首页弹窗 3 限免卡降档-返回推弹窗 4任务-签到额外奖励 5任务-看视频领观看券6任务-看广告领额外奖励 7播放页-观看激励视频解锁 8播放页-全屏原生 9播放页-instory 原生'
    ,ads_type               int(11)                            comment '广告类型 1激励视频 2原生视频'
    ,status                 int(11)                            comment '状态 0关闭 1开启'
    ,weight                 int(11)                            comment '权重'
    ,group_ids              string                             comment '选中人群包id逗号拼接'
    ,group_names            string                             comment '选中人群包名称逗号拼接'
    ,exclude_group_ids      string                             comment '剔除人群包id 逗号拼接'
    ,exclude_group_names    string                             comment '剔除人群包名称 逗号拼接'
    ,mt                     int(11)                            comment '平台 1ios 4Android'
    ,lang_ids               varchar(765)                       comment '语言id 逗号拼接'
    ,min_ver_id             int(11)                            comment '服务器最小版本'
    ,max_ver_id             int(11)                            comment '服务器最大版本'
    ,ads_platform           int(11)                            comment '广告平台'
    ,ads_id                 varchar(765)                       comment '广告id'
    ,create_time            datetime                           comment '创建时间'
    ,update_time            datetime                           comment '修改时间'
    ,sr_createtime          datetime default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime          datetime default current_timestamp comment "starrocks数据更新时间" 
)
primary key(id)
comment '海剧-广告id配置表'
distributed by hash(id) BUCKETS 1
properties ("replication_num" = "3",
            "in_memory" = "false",
            "storage_format" = "DEFAULT",
            "enable_persistent_index" = "true",
            "compression" = "LZ4"
)
;

alter view dim.dim_short_video_ads_unit_adid_view 
(unit_adid comment '广告单元id',
status comment '广告开启状态 1：开启,0:关闭,2:关闭',
ads_type COMMENT '广告类型 1激励视频 2原生视频' ,
position_id comment '广告位置id' )
-- comment '海外短剧-tag后台广告位置映射表' 
as  select unit_adid,status ,ads_type,min(position_id) as position_id from (
  select unnest as position_id,unit_adid,status ,ads_type
  from (
  select strategy_name,ads_attr,position_ids,ads_type,status,mt,ads_id as unit_adid,SPLIT(position_ids, ',')  as position_id 
 from ods.ods_tidb_short_video_ads_settings  
 ) x   ,unnest(position_id) 
) a 
group by 1,2,3
