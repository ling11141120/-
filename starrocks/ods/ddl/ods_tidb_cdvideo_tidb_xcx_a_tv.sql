CREATE TABLE `ods_tidb_cdvideo_tidb_xcx_a_tv` (
  `ID` bigint(20) NOT NULL COMMENT "自增主键ID",
  `tv_id` varchar(50) NOT NULL COMMENT "对应抓取数据a_tv._id",
  `status` tinyint(4) NULL COMMENT "上架状态,true上架 false下架",
  `tv_name` varchar(300) NULL COMMENT "电视剧名",
  `tv_image` varchar(200) NULL COMMENT "封面",
  `baseurl` varchar(200) NULL COMMENT "目录地址",
  `all_series` int(11) NULL COMMENT "总集数",
  `update_witch` int(11) NULL COMMENT "更新集数",
  `allow_ads` tinyint(4) NULL COMMENT "允许看广告解锁",
  `is_end` tinyint(4) NULL COMMENT "完结状态",
  `sort` int(11) NULL COMMENT "排序",
  `ranks` int(11) NULL COMMENT "排行榜名次",
  `cate` varchar(200) NULL COMMENT "类型",
  `index_cate` varchar(200) NULL COMMENT "视频分类",
  `all_like` int(11) NULL COMMENT "总点赞数",
  `tag_color` varchar(20) NULL COMMENT "标签颜色",
  `tag_text` varchar(200) NULL COMMENT "标签文字",
  `index_box` int(11) NULL COMMENT "首页推荐位",
  `start_needpay` int(11) NULL COMMENT "开始付费集数",
  `how_much` int(11) NULL COMMENT "每集多少金豆",
  `gzhbox_start` int(11) NULL COMMENT "公众号弹窗开始集数",
  `gzhbox_end` int(11) NULL COMMENT "公众号弹窗结束集数",
  `add_time` datetime NULL COMMENT "创建时间",
  `tv_class` varchar(200) NULL COMMENT "短剧分类",
  `description` varchar(200) NULL COMMENT "介绍",
  `is_delete` tinyint(4) NOT NULL COMMENT "删除状态,1删除，0正常",
  `alias` varchar(100) NULL COMMENT "代号",
  `update_time` datetime NULL COMMENT "更新时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`ID`, `tv_id`)
COMMENT "剧集信息表"
DISTRIBUTED BY HASH(`ID`, `tv_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
