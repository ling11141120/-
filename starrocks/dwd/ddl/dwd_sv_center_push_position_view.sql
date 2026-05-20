create or replace view dwd.dwd_sv_center_push_position_view (
     id                         comment "主键id"
    ,strategy_code              comment "策略代码"
    ,push_position_name         comment "push资源位名称"
    ,strategy_begin_time        comment "策略消息投递开始时间"
    ,strategy_end_time          comment "策略消息投递结束时间"
    ,push_type                  comment "推送场景类型：1-活动推送；2-短剧推送；3-召回推送"
    ,activity_type              comment "活动类型"
    ,activity_id                comment "活动id"
    ,series_bill_id             comment "推送短剧的剧目库id"
    ,push_frequency             comment "推送频率"
    ,push_count                 comment "活动期间每日N值"
    ,filter_type                comment "过滤条件"
    ,push_strategy_type         comment "推送策略类型"
    ,send_time                  comment "发送时间"
    ,send_time_param_json       comment "推送n次扩展json"
    ,delay_send_time            comment "延迟推送的小时数"
    ,title_id                   comment "标题id"
    ,content_id                 comment "内容id"
    ,guide_id                   comment "引导文案id"
    ,count_down                 comment "倒计时，单位分钟"
    ,material_id                comment "图片素材id"
    ,material_id2               comment "图片2素材id"
    ,style_type                 comment "消息样式"
    ,button_id                  comment "按钮文案id"
    ,label_id                   comment "标签文案id"
    ,url                        comment "链接url"
    ,group_ids                  comment "选中人群包id，逗号分割"
    ,exclude_group_ids          comment "剔除人群包id，逗号分割"
    ,sort                       comment "排序，值越小排序越高"
    ,status                     comment "状态：1-开启，2-关闭"
    ,app_type                   comment "应用类型：1-短剧，2-阅读"
    ,create_time                comment "创建时间"
    ,update_time                comment "更新时间"
    ,off_line_group_ids         comment "离线人群包选中人群包id，逗号分割"
    ,off_line_exclude_group_ids comment "离线人群包剔除人群包id，逗号分割"
    ,page_type                  comment "承接页面"
    ,page_macro                 comment "宏定义配置"
    ,material_source            comment "素材来源"
    ,material_type              comment "素材类型"
    ,material_one_type          comment "图1素材类型"
    ,material_two_type          comment "图2素材类型"
    ,page_limit_type            comment "指定页面限制类型"
    ,text_group_id              comment "文案组id"
    ,text_group_type            comment "文案组下发方式"
    ,p_type                     comment "0-立即展示，1-本地展示"
    ,local_push_strategy        comment "本地push策略"
    ,local_push_interval        comment "本地push间隔时间，单位小时"
    ,ios_push_switch            comment "0-iOS即时通知关闭，1-开启"
    ,notification_permission    comment "通知权限"
    ,live_permission            comment "Live权限"
    ,sr_createtime              comment "starrocks数据注入时间"
    ,sr_updatetime              comment "starrocks数据更新时间"
)
comment "push资源位表"
as
select a1.id                         as id                         -- 主键id
      ,a1.strategy_code              as strategy_code              -- 策略代码
      ,a1.push_position_name         as push_position_name         -- push资源位名称
      ,a1.strategy_begin_time        as strategy_begin_time        -- 策略消息投递开始时间
      ,a1.strategy_end_time          as strategy_end_time          -- 策略消息投递结束时间
      ,a1.push_type                  as push_type                  -- 推送场景类型：1-活动推送；2-短剧推送；3-召回推送
      ,a1.activity_type              as activity_type              -- 活动类型
      ,a1.activity_id                as activity_id                -- 活动id
      ,a1.series_bill_id             as series_bill_id             -- 推送短剧的剧目库id
      ,a1.push_frequency             as push_frequency             -- 推送频率
      ,a1.push_count                 as push_count                 -- 活动期间每日N值
      ,a1.filter_type                as filter_type                -- 过滤条件
      ,a1.push_strategy_type         as push_strategy_type         -- 推送策略类型
      ,a1.send_time                  as send_time                  -- 发送时间
      ,a1.send_time_param_json       as send_time_param_json       -- 推送n次扩展json
      ,a1.delay_send_time            as delay_send_time            -- 延迟推送的小时数
      ,a1.title_id                   as title_id                   -- 标题id
      ,a1.content_id                 as content_id                 -- 内容id
      ,a1.guide_id                   as guide_id                   -- 引导文案id
      ,a1.count_down                 as count_down                 -- 倒计时，单位分钟
      ,a1.material_id                as material_id                -- 图片素材id
      ,a1.material_id2               as material_id2               -- 图片2素材id
      ,a1.style_type                 as style_type                 -- 消息样式
      ,a1.button_id                  as button_id                  -- 按钮文案id
      ,a1.label_id                   as label_id                   -- 标签文案id
      ,a1.url                        as url                        -- 链接url
      ,a1.group_ids                  as group_ids                  -- 选中人群包id，逗号分割
      ,a1.exclude_group_ids          as exclude_group_ids          -- 剔除人群包id，逗号分割
      ,a1.sort                       as sort                       -- 排序，值越小排序越高
      ,a1.status                     as status                     -- 状态：1-开启，2-关闭
      ,a1.app_type                   as app_type                   -- 应用类型：1-短剧，2-阅读
      ,a1.create_time                as create_time                -- 创建时间
      ,a1.update_time                as update_time                -- 更新时间
      ,a1.off_line_group_ids         as off_line_group_ids         -- 离线人群包选中人群包id，逗号分割
      ,a1.off_line_exclude_group_ids as off_line_exclude_group_ids -- 离线人群包剔除人群包id，逗号分割
      ,a1.page_type                  as page_type                  -- 承接页面
      ,a1.page_macro                 as page_macro                 -- 宏定义配置
      ,a1.material_source            as material_source            -- 素材来源
      ,a1.material_type              as material_type              -- 素材类型
      ,a1.material_one_type          as material_one_type          -- 图1素材类型
      ,a1.material_two_type          as material_two_type          -- 图2素材类型
      ,a1.page_limit_type            as page_limit_type            -- 指定页面限制类型
      ,a1.text_group_id              as text_group_id              -- 文案组id
      ,a1.text_group_type            as text_group_type            -- 文案组下发方式
      ,a1.p_type                     as p_type                     -- 0-立即展示，1-本地展示
      ,a1.local_push_strategy        as local_push_strategy        -- 本地push策略
      ,a1.local_push_interval        as local_push_interval        -- 本地push间隔时间，单位小时
      ,a1.ios_push_switch            as ios_push_switch            -- 0-iOS即时通知关闭，1-开启
      ,a1.notification_permission    as notification_permission    -- 通知权限
      ,a1.live_permission            as live_permission            -- Live权限
      ,a1.sr_createtime              as sr_createtime              -- starrocks数据注入时间
      ,a1.sr_updatetime              as sr_updatetime              -- starrocks数据更新时间
  from ods.ods_tidb_short_video_admin_center_push_position    as a1
;
