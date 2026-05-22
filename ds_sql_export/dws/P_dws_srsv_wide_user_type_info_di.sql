----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_srsv_wide_user_type_info_di
-- workflow_version : 54
-- create_user      : yanxh
-- task_name        : dws_sr_wide_user_type_info_di
-- task_version     : 19
-- update_time      : 2026-05-19 19:34:41
-- sql_path         : \starrocks\tbl_dws_srsv_wide_user_type_info_di\dws_sr_wide_user_type_info_di
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_srsv_wide_user_type_info_di
with
-- 基础用户数据 - 获取阅读产品的用户基础信息（排除海剧6833）
base_users as (
    select *
    from dws.dws_srsv_wide_user_type_info_di
    where dt = '${bf_1_dt}' and product_id != 6833
),
-- ========== 事件数据层（提取公共CTE，避免重复扫描） ==========
-- 充值曝光事件 - 记录用户在充值相关位置的曝光行为
event_recharge_exposure as (
    select login_id, element_id, page_id
    from dwd.dwd_sensors_production_rechargeexposure_view
    where dt = '${bf_1_dt}'
    group by login_id, element_id, page_id
),
-- 运营位曝光事件 - 记录用户在运营位的曝光行为
event_operation_exposure as (
    select login_id, element_id, page_id
    from dwd.dwd_sensors_production_operationpositionexposure_view
    where dt = '${bf_1_dt}'
    group by login_id, element_id, page_id
),
-- 内容曝光事件 - 记录用户在内容位的曝光行为
event_item_exposure as (
    select login_id, page_id
    from dwd.dwd_sensors_production_itemexposure_view
    where dt = '${bf_1_dt}'
    group by login_id, page_id
),
-- 元素曝光事件 - 记录用户在页面元素的曝光行为
event_element_expose as (
    select login_id, page_id
    from dwd.dwd_sensors_production_element_expose_view
    where dt = '${bf_1_dt}'
    group by login_id, page_id
),
-- APP启动事件 - 记录用户的APP启动行为，用于识别开屏触达
event_app_start as (
    select UserId
    from dwd.dwd_user_appstartlog
    where dt = '${bf_1_dt}'
    group by UserId
),
-- 开始阅读事件 - 记录用户开始阅读章节的行为
event_start_reading as (
    select login_id
    from dwd.dwd_sensors_production_startreadingchapter_view
    where dt = '${bf_1_dt}'
    group by login_id
),
-- 结束阅读事件 - 记录用户结束阅读章节的行为，包含阅读进度信息
event_end_reading as (
    select login_id, book_id, max(read_chapter_sort) as read_chapter_sort
    from dwd.dwd_sensors_production_endreadingchapter_view
    where dt = '${bf_1_dt}'
    group by login_id, book_id
),
-- 元素点击事件 - 记录用户的点击行为，包含来源页面信息
event_element_click as (
    select login_id, element_id, read_source_page_name, type
    from dwd.dwd_sensors_production_element_click_view
    where dt = '${bf_1_dt}'
    group by login_id, element_id, read_source_page_name, type
),
-- ========== 触达位置汇总层 ==========
user_positions as (
    select user_id, group_concat(position_name) as position_name_list
    from (
        -- 半屏D
        select a.user_id, '半屏D' as position_name
        from base_users a
        inner join event_recharge_exposure b on a.user_id = b.login_id and b.element_id = 100708
        union all
        -- 商店页
        select a.user_id, '商店页' as position_name
        from base_users a
        inner join event_recharge_exposure b on a.user_id = b.login_id and b.page_id = 100021
        union all
        -- 阅币福利包页
        select a.user_id, '阅币福利包页' as position_name
        from base_users a
        inner join event_recharge_exposure b on a.user_id = b.login_id and b.page_id = 100023
        union all
        -- 弹窗（合并多个来源）
        select a.user_id, '弹窗' as position_name
        from base_users a
        where exists (
            select 1 from event_operation_exposure c where a.user_id = c.login_id and c.element_id = 100390
        ) or exists (
            select 1 from event_item_exposure d where a.user_id = d.login_id and d.page_id in(10001, 10005)
        ) or exists (
            select 1 from event_element_expose e where a.user_id = e.login_id and e.page_id in(100774, 100225)
        )
        union all
        -- 开屏
        select a.user_id, '开屏' as position_name
        from base_users a
        where exists (
            select 1 from event_operation_exposure c where a.user_id = c.login_id and c.element_id = 100363
        ) or exists (
            select 1 from event_app_start f where a.user_id = f.UserId
        )
        union all
        -- 悬浮窗
        select a.user_id, '悬浮窗' as position_name
        from base_users a
        where exists (
            select 1 from event_operation_exposure c where a.user_id = c.login_id and c.element_id = 100391
        ) or exists (
            select 1 from event_item_exposure d where a.user_id = d.login_id and d.page_id in(10001, 10005)
        ) or exists (
            select 1 from event_element_expose e where a.user_id = e.login_id and e.page_id in(100774, 100225)
        )
        union all
        -- 半屏Banner
        select a.user_id, '半屏Banner' as position_name
        from base_users a
        inner join event_recharge_exposure b on a.user_id = b.login_id and b.element_id = 100708
        union all
        -- 书城Banner
        select a.user_id, '书城Banner' as position_name
        from base_users a
        where exists (
            select 1 from event_operation_exposure c where a.user_id = c.login_id and c.element_id = 100359 and c.page_id = 10001
        ) or exists (
            select 1 from event_item_exposure d where a.user_id = d.login_id and d.page_id = 10001
        )
        union all
        -- 底部弹框
        select a.user_id, '底部弹框' as position_name
        from base_users a
        where exists (
            select 1 from event_operation_exposure c where a.user_id = c.login_id and c.element_id = 100351
        ) or exists (
            select 1 from event_start_reading g where a.user_id = g.login_id
        )
        union all
        -- 章末推送
        select a.user_id, '章末推送' as position_name
        from base_users a
        where exists (
            select 1 from event_operation_exposure c where a.user_id = c.login_id and c.element_id = 100352
        ) or exists (
            select 1 from event_end_reading h where a.user_id = h.login_id
        )
        union all
        -- 私信
        select a.user_id, '私信' as position_name
        from base_users a
        inner join event_operation_exposure c on a.user_id = c.login_id and c.element_id = 100698
        union all
        -- 活动中心
        select a.user_id, '活动中心' as position_name
        from base_users a
        inner join event_operation_exposure c on a.user_id = c.login_id and c.element_id in (100723, 100078)
        union all
        -- 返回推
        select a.user_id, '返回推' as position_name
        from base_users a
        inner join event_operation_exposure c on a.user_id = c.login_id and c.element_id = 100400
        union all
        -- TAB
        select a.user_id, 'TAB' as position_name
        from base_users a
        where exists (
            select 1 from event_operation_exposure c where a.user_id = c.login_id and c.element_id = 100671
        ) or exists (
            select 1 from event_item_exposure d where a.user_id = d.login_id and d.page_id in(10001, 10005)
        ) or exists (
            select 1 from event_element_expose e where a.user_id = e.login_id and e.page_id in(100774, 100225)
        )
        union all
        -- 电池栏推荐
        select a.user_id, '电池栏推荐' as position_name
        from base_users a
        where exists (
            select 1 from event_operation_exposure c where a.user_id = c.login_id and c.element_id = 100355
        ) or exists (
            select 1 from event_start_reading g where a.user_id = g.login_id
        )
        union all
        -- 书架顶部
        select a.user_id, '书架顶部' as position_name
        from base_users a
        where exists (
            select 1 from event_operation_exposure c where a.user_id = c.login_id and c.element_id = 100366
        ) or exists (
            select 1 from event_item_exposure d where a.user_id = d.login_id and d.page_id = 10005
        )
        union all
        -- 返回推弹窗
        select a.user_id, '返回推弹窗' as position_name
        from base_users a
        inner join event_operation_exposure c on a.user_id = c.login_id and c.element_id = 100358
        union all
        -- 推书弹窗
        select a.user_id, '推书弹窗' as position_name
        from base_users a
        inner join event_operation_exposure c on a.user_id = c.login_id and c.element_id in(100392, 100393)
        union all
        -- 频道分页
        select a.user_id, '频道分页' as position_name
        from base_users a
        where exists (
            select 1 from event_operation_exposure c where a.user_id = c.login_id and c.page_id = 10001
        ) or exists (
            select 1 from event_item_exposure d where a.user_id = d.login_id and d.page_id = 10001
        )
        union all
        -- 书架首页
        select a.user_id, '书架首页' as position_name
        from base_users a
        where exists (
            select 1 from event_operation_exposure c where a.user_id = c.login_id and c.page_id = 10005
        ) or exists (
            select 1 from event_item_exposure d where a.user_id = d.login_id and d.page_id = 10005
        )
        union all
        -- 详情页
        select a.user_id, '详情页' as position_name
        from base_users a
        inner join event_element_expose e on a.user_id = e.login_id and e.page_id = 10006
        union all
        -- 福利中心
        select a.user_id, '福利中心' as position_name
        from base_users a
        inner join event_element_expose e on a.user_id = e.login_id and e.page_id = 100774
        union all
        -- 搜索页
        select a.user_id, '搜索页' as position_name
        from base_users a
        where exists (
            select 1 from event_operation_exposure c where a.user_id = c.login_id and c.page_id = 10004
        ) or exists (
            select 1 from event_item_exposure d where a.user_id = d.login_id and d.page_id = 10004
        )
        union all
        -- 末页推荐页
        select a.user_id, '末页推荐页' as position_name
        from base_users a
        where exists (
            select 1 from event_operation_exposure c where a.user_id = c.login_id and c.page_id = 100364
        ) or exists (
            select 1 from event_item_exposure d where a.user_id = d.login_id and d.page_id = 100364
        )
        union all
        -- VIP专题落地页
        select a.user_id, 'VIP专题落地页' as position_name
        from base_users a
        inner join event_item_exposure d on a.user_id = d.login_id and d.page_id = 100648
        union all
        -- 开始阅读
        select a.user_id, '开始阅读' as position_name
        from base_users a
        inner join event_start_reading g on a.user_id = g.login_id
        union all
        -- 结束阅读
        select a.user_id, '结束阅读' as position_name
        from base_users a
        inner join event_end_reading h on a.user_id = h.login_id
        union all
        -- 末章结束阅读
        select a.user_id, '末章结束阅读' as position_name
        from base_users a
        inner join event_end_reading h on a.user_id = h.login_id
        inner join dim.dim_shuangwen_book_read_consume_info book on h.book_id = book.book_id
        where h.read_chapter_sort = if(ifnull(normal_chapter_num_f, 0) = 0, total_chapter_num, normal_chapter_num_f)
        union all
        -- 退出阅读器-频道分页
        select a.user_id, '退出阅读器-频道分页' as position_name
        from base_users a
        inner join event_element_click i on a.user_id = i.login_id
        where i.element_id = 100086 and i.read_source_page_name = '频道分页'
        union all
        -- 退出阅读器-书架首页
        select a.user_id, '退出阅读器-书架首页' as position_name
        from base_users a
        inner join event_element_click i on a.user_id = i.login_id
        where i.element_id = 100086 and i.read_source_page_name = '书架首页'
        union all
        -- 退出阅读器-余额不足
        select a.user_id, '退出阅读器-余额不足' as position_name
        from base_users a
        inner join event_element_click i on a.user_id = i.login_id
        where i.element_id = 100086 and i.read_source_page_name = '余额不足'
    ) t
    group by user_id
)
-- ========== 最终输出 ==========
select
    a.dt, a.product_id, a.user_id, a.user_period, a.corever, a.mt, a.reg_country, a.country_level,
    a.current_language2, a.source, a.last_source, a.book_id, a.is_pay, a.chl2, a.chl,
    --f.group_id_list,
    null as group_id_list,
    b.position_name_list,
    now() as etl_tm
from base_users a
-- left join (
--     select product_id, user_id, group_concat(group_id) as group_id_list
--     from dwd.dwd_sr_user_group_user_log
--     where date(start_time) <= 'yesterday' and date(end_time) >= 'yesterday'
--     group by product_id, user_id
-- ) f on a.product_id = f.product_id and a.user_id = f.user_id
left join user_positions b on a.user_id = b.user_id
;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_srsv_wide_user_type_info_di
-- workflow_version : 54
-- create_user      : yanxh
-- task_name        : dws_sv_wide_user_type_info_di
-- task_version     : 15
-- update_time      : 2026-05-20 23:58:30
-- sql_path         : \starrocks\tbl_dws_srsv_wide_user_type_info_di\dws_sv_wide_user_type_info_di
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_srsv_wide_user_type_info_di
with
-- 基础用户数据 - 获取海剧产品的用户基础信息（只处理product_id=6833）
base_users as (
      select *
      from dws.dws_srsv_wide_user_type_info_di
      where dt = '${bf_1_dt}' and product_id = 6833
),
-- ========== 事件数据层（海剧专属事件） ==========
-- 运营位曝光事件 - 海剧产品的运营位曝光数据
event_operation_exposure as (
      select login_id, element_id, page_id
      from dwd.dwd_sensors_cd_video_operationpositionexposure_view
      where dt = '${bf_1_dt}'
      group by login_id, element_id, page_id
),
-- 内容曝光事件 - 海剧产品的内容曝光数据
event_item_exposure as (
      select login_id, element_id, page_id
      from dwd.dwd_sensors_cd_video_itemexposure_view
      where dt = '${bf_1_dt}'
      group by login_id, element_id, page_id
),
-- 合并所有曝光事件 - 将运营位和内容位曝光合并，便于统一判断触达
event_all_exposure as (
      select login_id, element_id, page_id
      from event_item_exposure
      union all
      select login_id, element_id, page_id
      from event_operation_exposure
),
-- 结束观看事件 - 记录用户观看剧集的完成情况，包含观看进度
event_end_watching as (
      select login_id, shortplay_id, watch_episode_sort, watch_progress
      from dwd.dwd_sensors_cd_video_endwatching_view
      where dt = '${bf_1_dt}'
      group by login_id, shortplay_id, watch_episode_sort, watch_progress
),
-- APP启动事件 - 海剧产品的APP启动数据
event_app_start as (
      select login_id
      from dwd.dwd_sensors_cd_video_appstart_view
      where dt = '${bf_1_dt}'
      group by login_id
),
-- ========== 触达位置汇总层 ==========
user_positions as (
      select user_id, group_concat(position_name) as position_name_list
      from (
          -- 充值半屏页
          select a.user_id, '充值半屏页' as position_name
          from base_users a
          inner join event_operation_exposure b on a.user_id = b.login_id and b.element_id = 200900
          union all
          -- 充值商店页
          select a.user_id, '充值商店页' as position_name
          from base_users a
          inner join event_operation_exposure b on a.user_id = b.login_id and b.page_id = 201300
          union all
          -- 普通弹窗
          select a.user_id, '普通弹窗' as position_name
          from base_users a
          where exists (
              select 1 from event_all_exposure c where a.user_id = c.login_id and c.page_id
in(200100,200200,200300,203500)
          )
          union all
          -- 充值返回推
          select a.user_id, '充值返回推' as position_name
          from base_users a
          where exists (
              select 1 from event_all_exposure c where a.user_id = c.login_id and c.element_id = 200900
          )
          union all
          -- 剧末推
          select a.user_id, '剧末推' as position_name
          from base_users a
          inner join event_end_watching d on a.user_id = d.login_id
          inner join dim.dim_short_video_series_view b on d.shortplay_id = b.series_id
          where d.watch_episode_sort = b.last_epis and d.watch_progress >= 1
          union all
          -- 退出观看返回推
          select a.user_id, '退出观看返回推' as position_name
          from base_users a
          where exists (
              select 1 from event_all_exposure c where a.user_id = c.login_id and c.page_id = 200800
          )
          union all
          -- 悬浮窗
          select a.user_id, '悬浮窗' as position_name
          from base_users a
          where exists (
              select 1 from event_all_exposure c where a.user_id = c.login_id and c.page_id in(200100,200200,200300,203500,200800)
          )
          union all
          -- 开屏页
          select a.user_id, '开屏页' as position_name
          from base_users a
          inner join event_app_start e on a.user_id = e.login_id
          union all
          -- TAB栏
          select a.user_id, 'TAB栏' as position_name
          from base_users a
          where exists (
              select 1 from event_all_exposure c where a.user_id = c.login_id and c.page_id in(200100,200200,200300,203500)
          )
          union all
          -- banner
          select a.user_id, 'banner' as position_name
          from base_users a
          inner join event_operation_exposure b on a.user_id = b.login_id and b.element_id = 200900
          union all
          -- 首页
          select a.user_id, '首页' as position_name
          from base_users a
          where exists (
              select 1 from event_all_exposure c where a.user_id = c.login_id and c.page_id = 200200
          )
      ) t
      group by user_id
)
-- ========== 最终输出 ==========
select
      a.dt, a.product_id, a.user_id, a.user_period, a.corever, a.mt, a.reg_country, a.country_level,
      a.current_language2, a.source, a.last_source, a.book_id, a.is_pay, a.chl2, a.chl,
      f.group_id_list,
      b.position_name_list,
      now() as etl_tm
from base_users a
left join (
      select UserId as user_id
            ,group_concat(
                 concat_ws(',', cast(CrowdId as varchar), if(SubCrowdId is null, null, cast(SubCrowdId as varchar)))
             ) as group_id_list
      from ads.crowd_log
      where dt = '${bf_1_dt}'
        and Operation = 1
        and date(BeginTime) <= '${bf_1_dt}'
        and (EndTime is null or date(EndTime) >= '${bf_1_dt}')
        and ProjectId = 3
      group by UserId
) f on a.user_id = f.user_id
left join user_positions b on a.user_id = b.user_id
;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_srsv_wide_user_type_info_di
-- workflow_version : 54
-- create_user      : yanxh
-- task_name        : tbl_dws_srsv_wide_user_type_info_di
-- task_version     : 29
-- update_time      : 2026-04-24 17:07:21
-- sql_path         : \starrocks\tbl_dws_srsv_wide_user_type_info_di\tbl_dws_srsv_wide_user_type_info_di
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_srsv_wide_user_type_info_di where dt>='${bf_1_dt}' and dt<'${dt}';

-- SQL语句
insert into dws.dws_srsv_wide_user_type_info_di
with
-- ========== 公共基础数据层 ==========
-- 充值用户（阅读+海剧）- 合并两个产品线的充值数据，提前去重减少后续JOIN数据量
base_recharge_user as (
    select product_id, user_id
    from (
        select productid as product_id, userid as user_id
        from dws.dws_trade_user_shopitem_charge_ed
        where dt <= '${bf_1_dt}'
        union all
        select product_id, user_id
        from dws.dws_trade_short_video_payorder_ed
        where dt <= '${bf_1_dt}'
    ) t
    group by product_id, user_id
),
-- 用户媒体来源 - 获取用户的渠道来源信息，用于后续媒体归因分析
base_user_source as (
    select product_id, user_id, mt, corever, lang2, last_source
    from dws.dws_user_market_channel_info_detail_td
    where dt = '${bf_1_dt}'
),
-- 书籍/剧ID映射 - 统一获取阅读书籍ID和海剧剧集ID，支持剧维度分析，NULL转为空字符串
base_book_mapping as (
    select
        product_id,
        id as user_id,
        if(book_id = '' or book_id is null, -1, book_id) as book_id
    from dim.dim_user_account_info_view
    union all
    select
        product_id,
        user_id,
        if(ad_series_id = '' or ad_series_id is null, -1, ad_series_id) as book_id
    from dim.dim_short_video_user_accountinfo
),
-- ========== 用户类型数据层 ==========
-- 1. 新用户 - 基于注册时间识别新用户，关联国家、语言、媒体来源等维度信息
user_new as (
    select
        date(a.CreateTime) as dt,
        a.productid as product_id,
        a.id as user_id,
        1 as user_period,
        coalesce(nullif(a.CoreVer, 0), 1) as corever,
        a.mt,
        coalesce(nullif(a.RegCountry, ''), 'unknown') as reg_country,
        coalesce(b.level, 2) as country_level,
        case a.productid
            when 3311 then coalesce(nullif(a.CurrentLanguage2, 0), 6)
            when 3322 then coalesce(nullif(a.CurrentLanguage2, 0), 5)
            when 3333 then coalesce(nullif(a.CurrentLanguage2, 0), 2)
            when 3366 then coalesce(nullif(a.CurrentLanguage2, 0), 3)
            when 3371 then coalesce(nullif(a.CurrentLanguage2, 0), 7)
            when 3388 then coalesce(nullif(a.CurrentLanguage2, 0), 4)
            when 3501 then coalesce(nullif(a.CurrentLanguage2, 0), 11)
            when 3511 then coalesce(nullif(a.CurrentLanguage2, 0), 12)
            else a.CurrentLanguage2
        end as current_language2,
        case
            when c.last_source in ('fbs2s','facebook','tt','appleadservice','fixadinfo','sem','adwords') then 3
            when c.last_source in ('officialsite','(not set)') then 2
            else 1
        end as source,
        ifnull(c.last_source, '') as last_source,
        ifnull(e.book_id, '') as book_id,
        if(d.user_id is not null, 1, 0) as is_pay,
        a.chl2,
        a.chl,
        null as group_id_list,
        null as position_name_list,
        now() as etl_tm
    from dim.dim_read_and_short_video_accountinfo_tmp_view a
    left join dim.dim_countrylevel b
        on a.productid = b.product_id and a.RegCountry = b.short_name
    left join base_user_source c
        on a.productid = c.product_id
        and a.id = c.user_id
        and a.mt = c.mt
        and a.corever = c.corever
        and a.CurrentLanguage2 = c.lang2
        and c.product_id in (3311,3322,3333,3366,3371,3388,3501,3511,3399,7757,8858,6833)
    left join base_recharge_user d
        on a.productid = d.product_id and a.id = d.user_id
    left join base_book_mapping e
        on a.productid = e.product_id and a.id = e.user_id
    where a.CreateTime >= '${bf_1_dt}'
        and a.createtime < '${dt}'
        and a.productid not in (3521,3531,6883)
        and cast(a.id as int) > 0
),
-- 2. 活跃用户 - 从活跃表获取用户，合并阅读和海剧两个产品线的活跃数据
user_active as (
    select
        a.dt,
        a.product_id,
        a.user_id,
        2 as user_period,
        coalesce(nullif(a.CoreVer, 0), 1) as corever,
        a.mt,
        coalesce(nullif(a.Reg_Country, ''), 'unknown') as reg_country,
        coalesce(a.country_level, 2) as country_level,
        a.current_language2,
        case
            when c.last_source in ('fbs2s','facebook','tt','appleadservice','fixadinfo','sem','adwords') then 3
            when c.last_source in ('officialsite','(not set)') then 2
            else 1
        end as source,
        ifnull(c.last_source, '') as last_source,
        ifnull(f.book_id, '') as book_id,
        if(d.user_id is not null, 1, 0) as is_pay,
        e.chl2,
        e.chl,
        null as group_id_list,
        null as position_name_list,
        now() as etl_tm
    from (
        select dt, product_id, user_id, corever, mt, reg_country, country_level, current_language2
        from dws.dws_user_wide_active_ed
        where dt >= '${bf_1_dt}'
            and dt < '${dt}'
            and product_id not in (3521,3531)
            and user_id > 0
        union all
        select dt, product_id, user_id, corever, mt, reg_country, country_level, current_language2
        from dws.dws_user_short_video_wide_active_ed
        where dt >= '${bf_1_dt}'
            and dt < '${dt}'
            and product_id in (6833)
            and user_id > 0
    ) a
    left join base_user_source c
        on a.product_id = c.product_id
        and a.user_id = c.user_id
        and a.mt = c.mt
        and a.corever = c.corever
        and a.current_language2 = c.lang2
        and c.product_id in (3311,3322,3333,3366,3371,3388,3501,3511,3399,7757,8858,6833)
    left join base_recharge_user d
        on a.product_id = d.product_id and a.user_id = d.user_id
    left join (
        select productid, id, chl2, chl
        from dim.dim_read_and_short_video_accountinfo_tmp_view
        where productid != 6883
    ) e on a.product_id = e.productid and a.user_id = e.id
    left join base_book_mapping f
        on a.product_id = f.product_id and a.user_id = f.user_id
    where cast(a.user_id as int) > 0
),
-- 3. RMT用户 - 识别重装用户（安装时间早于注册时间），使用row_number去重保留优先级最高的记录
user_rmt as (
    select
        a1.dt,
        a1.product_id,
        a1.user_id,
        a1.user_period,
        a1.corever,
        a1.mt,
        a1.reg_country,
        coalesce(b.level, 2) as country_level,
        a1.current_language2,
        a1.source,
        ifnull(a1.last_source, '') as last_source,
        ifnull(e.book_id, '') as book_id,
        if(d.user_id is not null, 1, 0) as is_pay,
        a2.chl2,
        a2.chl,
        null as group_id_list,
        null as position_name_list,
        now() as etl_tm
    from (
        select x.dt, x.install_date, x.product_id, x.user_id, x.corever, x.mt,
               x.reg_country, x.current_language2, x.source, x.last_source, x.user_period
        from (
            select
                dt,
                install_date,
                product_id,
                user_id,
                core as corever,
                mt,
                coalesce(nullif(a.Country, ''), 'unknown') as reg_country,
                a.current_language2,
                case
                    when source in ('fbs2s','facebook','tt','appleadservice','fixadinfo','sem','adwords') then 3
                    when source in ('officialsite','(not set)') then 2
                    else 1
                end as source,
                source as last_source,
                3 as user_period,
                row_number() over(partition by product_id, user_id order by
                    case
                        when source in ('fbs2s','facebook','tt','appleadservice','fixadinfo','sem','adwords') then 3
                        when source in ('officialsite','(not set)') then 2
                        else 1
                    end desc, install_date) as rn
            from dwd.dwd_user_install_info_ed_view a
            where dt >= '${bf_1_dt}'
                and dt < '${dt}'
                and product_id in (3311,3322,3333,3366,3371,3388,3501,3511,3399,7757,8858,6833)
                and User_Id != -1
                and IsDelete = 0
        ) x
        where x.rn = 1
    ) a1
    inner join (
        select productid, id, createtime, chl2, chl
        from dim.dim_read_and_short_video_accountinfo_tmp_view
        where productid not in (3521,3531)
    ) a2 on a1.product_id = a2.productid
        and a1.user_id = a2.id
        and a2.createtime < date_sub(a1.install_date, interval 1 hour)
    left join dim.dim_countrylevel b
        on a1.product_id = b.product_id and a1.reg_country = b.short_name
    left join base_recharge_user d
        on a1.product_id = d.product_id and a1.user_id = d.user_id
    left join base_book_mapping e
        on a1.Product_Id = e.product_id and a1.User_Id = e.user_id
    where cast(a1.user_id as int) > 0
)
-- ========== 合并三类用户 ==========
select * from user_new
union all
select * from user_active
union all
select * from user_rmt;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_srsv_wide_user_type_info_di_chenmo
-- workflow_version : 6
-- create_user      : chenmo
-- task_name        : dws_sr_wide_user_type_info_di
-- task_version     : 4
-- update_time      : 2025-02-08 14:18:23
-- sql_path         : \starrocks\tbl_dws_srsv_wide_user_type_info_di_chenmo\dws_sr_wide_user_type_info_di
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_srsv_wide_user_type_info_di
with a as (
    -- 获取海剧用户
    select
        *
    from dws.dws_srsv_wide_user_type_info_di
    where dt = '${bf_1_dt}' and product_id != 6833
),
b as (
    select login_id,element_id,page_id
    from dwd.dwd_sensors_production_rechargeexposure_view
    where dt = '${bf_1_dt}'
    group by login_id,element_id,page_id
),
c as (
    select login_id,element_id,page_id
    from dwd.dwd_sensors_production_operationpositionexposure_view
    where dt = '${bf_1_dt}'
    group by login_id,element_id,page_id
),
d as (
    select login_id,page_id
    from dwd.dwd_sensors_production_itemexposure_view
    where dt = '${bf_1_dt}'
    group by login_id,page_id
),
e as (
    select login_id,page_id
    from dwd.dwd_sensors_production_element_expose_view
    where dt = '${bf_1_dt}'
    group by login_id,page_id
),
f as (
    select UserId
    from dwd.dwd_user_appstartlog
    where dt = '${bf_1_dt}'
    group by UserId
),
g as (
    select login_id
    from dwd.dwd_sensors_production_startreadingchapter_view
    where dt = '${bf_1_dt}'
    group by login_id
),
h as (
    select login_id,book_id,max(read_chapter_sort) as read_chapter_sort
    from dwd.dwd_sensors_production_endreadingchapter_view
    where dt = '${bf_1_dt}'
    group by login_id,book_id
),
i as (
    select login_id,element_id,read_source_page_name,type
    from dwd.dwd_sensors_production_element_click_view
    where dt = '${bf_1_dt}'
    group by login_id,element_id,read_source_page_name,type
),
k as (
    select login_id,element_id,page_id
    from dwd.dwd_sensors_production_operationpositionexposure_view
    where dt = '${bf_1_dt}'
    group by login_id,element_id,page_id
)
select
    a.dt,
    a.product_id,
    a.user_id,
    a.user_period,
    a.corever,
    a.mt,
    a.reg_country,
    a.country_level,
    a.current_language2,
    a.source,
    a.is_pay,
    a.chl2,
    a.chl,
    f.group_id_list,
    b.position_name_list,
    now() as etl_time
from a
left join (
    select
        product_id,
        user_id,
        group_concat(group_id) as group_id_list
    from dwd.dwd_sr_user_group_user_log
    where date(start_time) <= '${bf_1_dt}' and date(end_time) >= '${bf_1_dt}'
    group by product_id,user_id
) f on a.product_id = f.product_id and a.user_id = f.user_id
left join (
    select
        user_id,
        group_concat(position_name) as position_name_list
    from (
        -- 半屏D
        select
            a.user_id,
            '半屏D' as position_name
        from a
        left join b on a.user_id = b.login_id
        where b.element_id = 100708
        group by a.user_id
        union all
        -- 商店页
        select
            a.user_id,
            '商店页' as position_name
        from a
        left join b on a.user_id = b.login_id
        where b.page_id = 100021
        group by a.user_id
        union all
        -- 阅币福利包页
        select
            a.user_id,
            '阅币福利包页' as position_name
        from a
        left join b on a.user_id = b.login_id
        where b.page_id = 100023
        group by a.user_id
        union all
        -- 弹窗
        select
            a.user_id,
            '弹窗' as position_name
        from (
            select
                a.user_id
            from a
            left join c on a.user_id = c.login_id
            where c.element_id = 100390
            union all
            select
                a.user_id
            from a
            left join d on a.user_id = d.login_id
            where d.page_id in(10001, 10005)
            union all
            select
                a.user_id
            from a
            left join e on a.user_id = e.login_id
            where e.page_id in(100774 ,100225)
        ) a
        group by a.user_id
        union all
        -- 开屏
        select
            a.user_id,
            '开屏' as position_name
        from (
            select
                a.user_id
            from a
            left join c on a.user_id = c.login_id
            where c.element_id = 100363
            union all
            select
                a.user_id
            from a
            left join f on a.user_id = f.UserId
            where f.UserId is not null
        ) a
        group by a.user_id
        union all
        -- 悬浮窗
        select
            a.user_id,
            '悬浮窗' as position_name
        from (
            select
                a.user_id
            from a
            left join c on a.user_id = c.login_id
            where c.element_id = 100391
            union all
            select
                a.user_id
            from a
            left join d on a.user_id = d.login_id
            where d.page_id in(10001, 10005)
            union all
            select
                a.user_id
            from a
            left join e on a.user_id = e.login_id
            where e.page_id in(100774 ,100225)
        ) a
        group by a.user_id
        union all
        -- 半屏Banner
        select
            a.user_id,
            '半屏Banner' as position_name
        from a
        left join b on a.user_id = b.login_id
        where b.element_id = 100708
        group by a.user_id
        union all
        -- 书城Banner
        select
            a.user_id,
            '书城Banner' as position_name
        from (
            select
                a.user_id
            from a
            left join k on a.user_id = k.login_id
            where k.element_id = 100359 and k.page_id = 10001
            union all
            select
                a.user_id
            from a
            left join d on a.user_id = d.login_id
            where d.page_id  = 10001
        ) a
        group by a.user_id
        union all
        -- 底部弹框
        select
            a.user_id,
            '底部弹框' as position_name
        from (
            select
                a.user_id
            from a
            left join k on a.user_id = k.login_id
            where k.element_id = 100351
            union all
            select
                a.user_id
            from a
            join g on a.user_id = g.login_id
        ) a
        group by a.user_id
        union all
        -- 章末推送
        select
            a.user_id,
            '章末推送' as position_name
        from (
            select
                a.user_id
            from a
            left join k on a.user_id = k.login_id
            where k.element_id = 100352
            union all
            select
                a.user_id
            from a
            join h on a.user_id = h.login_id
        ) a
        group by a.user_id
        union all
        -- 私信
        select
            a.user_id,
            '私信' as position_name
        from a
        left join c on a.user_id = c.login_id
        where c.element_id = 100698
        group by a.user_id
        union all
        -- 活动中心
        select
            a.user_id,
            '活动中心' as position_name
        from a
        left join c on a.user_id = c.login_id
        where c.element_id = 100723
        group by a.user_id
        union all
        -- 返回推
        select
            a.user_id,
            '返回推' as position_name
        from a
        left join c on a.user_id = c.login_id
        where c.element_id = 100400
        group by a.user_id
        union all
        -- TAB
        select
            a.user_id,
            'TAB' as position_name
        from (
            select
                a.user_id
            from a
            left join c on a.user_id = c.login_id
            where c.element_id = 100671
            union all
            select
                a.user_id
            from a
            left join d on a.user_id = d.login_id
            where d.page_id in(10001, 10005)
            union all
            select
                a.user_id
            from a
            left join e on a.user_id = e.login_id
            where e.page_id in(100774 ,100225)
        ) a
        group by a.user_id
        union all
        -- 电池栏推荐
        select
            a.user_id,
            '电池栏推荐' as position_name
        from (
            select
                a.user_id
            from a
            left join c on a.user_id = c.login_id
            where c.element_id = 100355
            union all
            select
                a.user_id
            from a
            join g on a.user_id = g.login_id
        ) a
        group by a.user_id
        union all
        -- 书架顶部
        select
            a.user_id,
            '书架顶部' as position_name
        from (
            select
                a.user_id
            from a
            left join c on a.user_id = c.login_id
            where c.element_id = 100366
            union all
            select
                a.user_id
            from a
            left join d on a.user_id = d.login_id
            where d.page_id = 10005
        ) a
        group by a.user_id
        union all
        -- 返回推弹窗
        select
            a.user_id,
            '返回推弹窗' as position_name
        from a
        left join c on a.user_id = c.login_id
        where c.element_id = 100358
        group by a.user_id
        union all
        -- 推书弹窗
        select
            a.user_id,
            '推书弹窗' as position_name
        from a
        left join c on a.user_id = c.login_id
        where c.element_id in(100392, 100393)
        group by a.user_id
        union all
        -- 活动中心
        select
            a.user_id,
            '活动中心' as position_name
        from a
        left join c on a.user_id = c.login_id
        where c.element_id = 100078
        group by a.user_id
        union all
        -- 频道分页
        select
            a.user_id,
            '频道分页' as position_name
        from (
            select
                a.user_id
            from a
            left join c on a.user_id = c.login_id
            where c.page_id = 10001
            union all
            select
                a.user_id
            from a
            left join d on a.user_id = d.login_id
            where d.page_id = 10001
        ) a
        group by a.user_id
        union all
        -- 书架首页
        select
            a.user_id,
            '书架首页' as position_name
        from (
            select
                a.user_id
            from a
            left join c on a.user_id = c.login_id
            where c.page_id = 10005
            union all
            select
                a.user_id
            from a
            left join d on a.user_id = d.login_id
            where d.page_id = 10005
        ) a
        group by a.user_id
        union all
        -- 详情页
        select
            a.user_id,
            '详情页' as position_name
        from a
        left join e on a.user_id = e.login_id
        where e.page_id = 10006
        group by a.user_id
        union all
        -- 福利中心
        select
            a.user_id,
            '福利中心' as position_name
        from a
        left join e on a.user_id = e.login_id
        where e.page_id = 100774
        group by a.user_id
        union all
        -- 搜索页
        select
            a.user_id,
            '搜索页' as position_name
        from (
            select
                a.user_id
            from a
            left join c on a.user_id = c.login_id
            where c.page_id = 10004
            union all
            select
                a.user_id
            from a
            left join d on a.user_id = d.login_id
            where d.page_id = 10004
        ) a
        group by a.user_id
        union all
        -- 末页推荐页
        select
            a.user_id,
            '末页推荐页' as position_name
        from (
            select
                a.user_id
            from a
            left join c on a.user_id = c.login_id
            where c.page_id = 100364
            union all
            select
                a.user_id
            from a
            left join d on a.user_id = d.login_id
            where d.page_id = 100364
        ) a
        group by a.user_id
        union all
        -- VIP专题落地页
        select
            a.user_id,
            'VIP专题落地页' as position_name
        from a
        left join d on a.user_id = d.login_id
        where d.page_id = 100648
        group by a.user_id
        union all
        -- 开始阅读
        select
            a.user_id,
            '开始阅读' as position_name
        from a
        join g on a.user_id = g.login_id
        group by a.user_id
        union all
        -- 结束阅读
        select
            a.user_id,
            '结束阅读' as position_name
        from a
        join h on a.user_id = h.login_id
        group by a.user_id
        union all
        -- 末章结束阅读
        select
            a.user_id,
            '末章结束阅读' as position_name
        from a
        left join h on a.user_id = h.login_id
        left join dim.dim_shuangwen_book_read_consume_info book on h.book_id = book.book_id
        where h.read_chapter_sort = if(ifnull(normal_chapter_num_f,0) = 0, total_chapter_num, normal_chapter_num_f)
        group by a.user_id
        union all
        -- 退出阅读器-频道分页
        select
            a.user_id,
            '退出阅读器-频道分页' as position_name
        from a
        left join i on a.user_id = i.login_id
        where element_id = 100086 and read_source_page_name = '频道分页'
        group by a.user_id
        union all
        -- 退出阅读器-书架首页
        select
            a.user_id,
            '退出阅读器-书架首页' as position_name
        from a
        left join i on a.user_id = i.login_id
        where element_id = 100086 and read_source_page_name = '书架首页'
        group by a.user_id
        union all
        -- 退出阅读器-余额不足
        select
            a.user_id,
            '退出阅读器-余额不足' as position_name
        from a
        left join i on a.user_id = i.login_id
        where element_id = 100086 and read_source_page_name = '余额不足'
        group by a.user_id
    ) t
    group by user_id
) b on a.user_id = b.user_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_srsv_wide_user_type_info_di_v3
-- workflow_version : 14
-- create_user      : chenmo
-- task_name        : dws_sr_wide_user_type_info_di
-- task_version     : 5
-- update_time      : 2025-12-23 17:53:41
-- sql_path         : \starrocks\tbl_dws_srsv_wide_user_type_info_di_v3\dws_sr_wide_user_type_info_di
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_srsv_wide_user_type_info_di
with
-- 基础用户数据 - 获取阅读产品的用户基础信息（排除海剧6833）
base_users as (
    select *
    from dws.dws_srsv_wide_user_type_info_di
    where dt = '${bf_1_dt}' and product_id != 6833
),
-- ========== 事件数据层（提取公共CTE，避免重复扫描） ==========
-- 充值曝光事件 - 记录用户在充值相关位置的曝光行为
event_recharge_exposure as (
    select login_id, element_id, page_id
    from dwd.dwd_sensors_production_rechargeexposure_view
    where dt = '${bf_1_dt}'
    group by login_id, element_id, page_id
),
-- 运营位曝光事件 - 记录用户在运营位的曝光行为
event_operation_exposure as (
    select login_id, element_id, page_id
    from dwd.dwd_sensors_production_operationpositionexposure_view
    where dt = '${bf_1_dt}'
    group by login_id, element_id, page_id
),
-- 内容曝光事件 - 记录用户在内容位的曝光行为
event_item_exposure as (
    select login_id, page_id
    from dwd.dwd_sensors_production_itemexposure_view
    where dt = '${bf_1_dt}'
    group by login_id, page_id
),
-- 元素曝光事件 - 记录用户在页面元素的曝光行为
event_element_expose as (
    select login_id, page_id
    from dwd.dwd_sensors_production_element_expose_view
    where dt = '${bf_1_dt}'
    group by login_id, page_id
),
-- APP启动事件 - 记录用户的APP启动行为，用于识别开屏触达
event_app_start as (
    select UserId
    from dwd.dwd_user_appstartlog
    where dt = '${bf_1_dt}'
    group by UserId
),
-- 开始阅读事件 - 记录用户开始阅读章节的行为
event_start_reading as (
    select login_id
    from dwd.dwd_sensors_production_startreadingchapter_view
    where dt = '${bf_1_dt}'
    group by login_id
),
-- 结束阅读事件 - 记录用户结束阅读章节的行为，包含阅读进度信息
event_end_reading as (
    select login_id, book_id, max(read_chapter_sort) as read_chapter_sort
    from dwd.dwd_sensors_production_endreadingchapter_view
    where dt = '${bf_1_dt}'
    group by login_id, book_id
),
-- 元素点击事件 - 记录用户的点击行为，包含来源页面信息
event_element_click as (
    select login_id, element_id, read_source_page_name, type
    from dwd.dwd_sensors_production_element_click_view
    where dt = '${bf_1_dt}'
    group by login_id, element_id, read_source_page_name, type
),
-- ========== 触达位置汇总层 ==========
user_positions as (
    select user_id, group_concat(position_name) as position_name_list
    from (
        -- 半屏D
        select a.user_id, '半屏D' as position_name
        from base_users a
        inner join event_recharge_exposure b on a.user_id = b.login_id and b.element_id = 100708
        union all
        -- 商店页
        select a.user_id, '商店页' as position_name
        from base_users a
        inner join event_recharge_exposure b on a.user_id = b.login_id and b.page_id = 100021
        union all
        -- 阅币福利包页
        select a.user_id, '阅币福利包页' as position_name
        from base_users a
        inner join event_recharge_exposure b on a.user_id = b.login_id and b.page_id = 100023
        union all
        -- 弹窗（合并多个来源）
        select a.user_id, '弹窗' as position_name
        from base_users a
        where exists (
            select 1 from event_operation_exposure c where a.user_id = c.login_id and c.element_id = 100390
        ) or exists (
            select 1 from event_item_exposure d where a.user_id = d.login_id and d.page_id in(10001, 10005)
        ) or exists (
            select 1 from event_element_expose e where a.user_id = e.login_id and e.page_id in(100774, 100225)
        )
        union all
        -- 开屏
        select a.user_id, '开屏' as position_name
        from base_users a
        where exists (
            select 1 from event_operation_exposure c where a.user_id = c.login_id and c.element_id = 100363
        ) or exists (
            select 1 from event_app_start f where a.user_id = f.UserId
        )
        union all
        -- 悬浮窗
        select a.user_id, '悬浮窗' as position_name
        from base_users a
        where exists (
            select 1 from event_operation_exposure c where a.user_id = c.login_id and c.element_id = 100391
        ) or exists (
            select 1 from event_item_exposure d where a.user_id = d.login_id and d.page_id in(10001, 10005)
        ) or exists (
            select 1 from event_element_expose e where a.user_id = e.login_id and e.page_id in(100774, 100225)
        )
        union all
        -- 半屏Banner
        select a.user_id, '半屏Banner' as position_name
        from base_users a
        inner join event_recharge_exposure b on a.user_id = b.login_id and b.element_id = 100708
        union all
        -- 书城Banner
        select a.user_id, '书城Banner' as position_name
        from base_users a
        where exists (
            select 1 from event_operation_exposure c where a.user_id = c.login_id and c.element_id = 100359 and c.page_id = 10001
        ) or exists (
            select 1 from event_item_exposure d where a.user_id = d.login_id and d.page_id = 10001
        )
        union all
        -- 底部弹框
        select a.user_id, '底部弹框' as position_name
        from base_users a
        where exists (
            select 1 from event_operation_exposure c where a.user_id = c.login_id and c.element_id = 100351
        ) or exists (
            select 1 from event_start_reading g where a.user_id = g.login_id
        )
        union all
        -- 章末推送
        select a.user_id, '章末推送' as position_name
        from base_users a
        where exists (
            select 1 from event_operation_exposure c where a.user_id = c.login_id and c.element_id = 100352
        ) or exists (
            select 1 from event_end_reading h where a.user_id = h.login_id
        )
        union all
        -- 私信
        select a.user_id, '私信' as position_name
        from base_users a
        inner join event_operation_exposure c on a.user_id = c.login_id and c.element_id = 100698
        union all
        -- 活动中心
        select a.user_id, '活动中心' as position_name
        from base_users a
        inner join event_operation_exposure c on a.user_id = c.login_id and c.element_id in (100723, 100078)
        union all
        -- 返回推
        select a.user_id, '返回推' as position_name
        from base_users a
        inner join event_operation_exposure c on a.user_id = c.login_id and c.element_id = 100400
        union all
        -- TAB
        select a.user_id, 'TAB' as position_name
        from base_users a
        where exists (
            select 1 from event_operation_exposure c where a.user_id = c.login_id and c.element_id = 100671
        ) or exists (
            select 1 from event_item_exposure d where a.user_id = d.login_id and d.page_id in(10001, 10005)
        ) or exists (
            select 1 from event_element_expose e where a.user_id = e.login_id and e.page_id in(100774, 100225)
        )
        union all
        -- 电池栏推荐
        select a.user_id, '电池栏推荐' as position_name
        from base_users a
        where exists (
            select 1 from event_operation_exposure c where a.user_id = c.login_id and c.element_id = 100355
        ) or exists (
            select 1 from event_start_reading g where a.user_id = g.login_id
        )
        union all
        -- 书架顶部
        select a.user_id, '书架顶部' as position_name
        from base_users a
        where exists (
            select 1 from event_operation_exposure c where a.user_id = c.login_id and c.element_id = 100366
        ) or exists (
            select 1 from event_item_exposure d where a.user_id = d.login_id and d.page_id = 10005
        )
        union all
        -- 返回推弹窗
        select a.user_id, '返回推弹窗' as position_name
        from base_users a
        inner join event_operation_exposure c on a.user_id = c.login_id and c.element_id = 100358
        union all
        -- 推书弹窗
        select a.user_id, '推书弹窗' as position_name
        from base_users a
        inner join event_operation_exposure c on a.user_id = c.login_id and c.element_id in(100392, 100393)
        union all
        -- 频道分页
        select a.user_id, '频道分页' as position_name
        from base_users a
        where exists (
            select 1 from event_operation_exposure c where a.user_id = c.login_id and c.page_id = 10001
        ) or exists (
            select 1 from event_item_exposure d where a.user_id = d.login_id and d.page_id = 10001
        )
        union all
        -- 书架首页
        select a.user_id, '书架首页' as position_name
        from base_users a
        where exists (
            select 1 from event_operation_exposure c where a.user_id = c.login_id and c.page_id = 10005
        ) or exists (
            select 1 from event_item_exposure d where a.user_id = d.login_id and d.page_id = 10005
        )
        union all
        -- 详情页
        select a.user_id, '详情页' as position_name
        from base_users a
        inner join event_element_expose e on a.user_id = e.login_id and e.page_id = 10006
        union all
        -- 福利中心
        select a.user_id, '福利中心' as position_name
        from base_users a
        inner join event_element_expose e on a.user_id = e.login_id and e.page_id = 100774
        union all
        -- 搜索页
        select a.user_id, '搜索页' as position_name
        from base_users a
        where exists (
            select 1 from event_operation_exposure c where a.user_id = c.login_id and c.page_id = 10004
        ) or exists (
            select 1 from event_item_exposure d where a.user_id = d.login_id and d.page_id = 10004
        )
        union all
        -- 末页推荐页
        select a.user_id, '末页推荐页' as position_name
        from base_users a
        where exists (
            select 1 from event_operation_exposure c where a.user_id = c.login_id and c.page_id = 100364
        ) or exists (
            select 1 from event_item_exposure d where a.user_id = d.login_id and d.page_id = 100364
        )
        union all
        -- VIP专题落地页
        select a.user_id, 'VIP专题落地页' as position_name
        from base_users a
        inner join event_item_exposure d on a.user_id = d.login_id and d.page_id = 100648
        union all
        -- 开始阅读
        select a.user_id, '开始阅读' as position_name
        from base_users a
        inner join event_start_reading g on a.user_id = g.login_id
        union all
        -- 结束阅读
        select a.user_id, '结束阅读' as position_name
        from base_users a
        inner join event_end_reading h on a.user_id = h.login_id
        union all
        -- 末章结束阅读
        select a.user_id, '末章结束阅读' as position_name
        from base_users a
        inner join event_end_reading h on a.user_id = h.login_id
        inner join dim.dim_shuangwen_book_read_consume_info book on h.book_id = book.book_id
        where h.read_chapter_sort = if(ifnull(normal_chapter_num_f, 0) = 0, total_chapter_num, normal_chapter_num_f)
        union all
        -- 退出阅读器-频道分页
        select a.user_id, '退出阅读器-频道分页' as position_name
        from base_users a
        inner join event_element_click i on a.user_id = i.login_id
        where i.element_id = 100086 and i.read_source_page_name = '频道分页'
        union all
        -- 退出阅读器-书架首页
        select a.user_id, '退出阅读器-书架首页' as position_name
        from base_users a
        inner join event_element_click i on a.user_id = i.login_id
        where i.element_id = 100086 and i.read_source_page_name = '书架首页'
        union all
        -- 退出阅读器-余额不足
        select a.user_id, '退出阅读器-余额不足' as position_name
        from base_users a
        inner join event_element_click i on a.user_id = i.login_id
        where i.element_id = 100086 and i.read_source_page_name = '余额不足'
    ) t
    group by user_id
)
-- ========== 最终输出 ==========
select
    a.dt, a.product_id, a.user_id, a.user_period, a.corever, a.mt, a.reg_country, a.country_level,
    a.current_language2, a.source, a.last_source, a.book_id, a.is_pay, a.chl2, a.chl,
    f.group_id_list,
    b.position_name_list,
    now() as etl_tm
from base_users a
left join (
    select product_id, user_id, group_concat(group_id) as group_id_list
    from dwd.dwd_sr_user_group_user_log
    where date(start_time) <= '${bf_1_dt}' and date(end_time) >= '${bf_1_dt}'
    group by product_id, user_id
) f on a.product_id = f.product_id and a.user_id = f.user_id
left join user_positions b on a.user_id = b.user_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_srsv_wide_user_type_info_di_v3
-- workflow_version : 14
-- create_user      : chenmo
-- task_name        : dws_sv_wide_user_type_info_di
-- task_version     : 5
-- update_time      : 2025-12-23 17:53:41
-- sql_path         : \starrocks\tbl_dws_srsv_wide_user_type_info_di_v3\dws_sv_wide_user_type_info_di
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_srsv_wide_user_type_info_di
with
-- 基础用户数据 - 获取海剧产品的用户基础信息（只处理product_id=6833）
base_users as (
    select *
    from dws.dws_srsv_wide_user_type_info_di
    where dt = '${bf_1_dt}' and product_id = 6833
),
-- ========== 事件数据层（海剧专属事件） ==========
-- 运营位曝光事件 - 海剧产品的运营位曝光数据
event_operation_exposure as (
    select login_id, element_id, page_id
    from dwd.dwd_sensors_cd_video_operationpositionexposure_view
    where dt = '${bf_1_dt}'
    group by login_id, element_id, page_id
),
-- 内容曝光事件 - 海剧产品的内容曝光数据
event_item_exposure as (
    select login_id, element_id, page_id
    from dwd.dwd_sensors_cd_video_itemexposure_view
    where dt = '${bf_1_dt}'
    group by login_id, element_id, page_id
),
-- 合并所有曝光事件 - 将运营位和内容位曝光合并，便于统一判断触达
event_all_exposure as (
    select login_id, element_id, page_id
    from event_item_exposure
    union all
    select login_id, element_id, page_id
    from event_operation_exposure
),
-- 结束观看事件 - 记录用户观看剧集的完成情况，包含观看进度
event_end_watching as (
    select login_id, shortplay_id, watch_episode_sort, watch_progress
    from dwd.dwd_sensors_cd_video_endwatching_view
    where dt = '${bf_1_dt}'
    group by login_id, shortplay_id, watch_episode_sort, watch_progress
),
-- APP启动事件 - 海剧产品的APP启动数据
event_app_start as (
    select login_id
    from dwd.dwd_sensors_cd_video_appstart_view
    where dt = '${bf_1_dt}'
    group by login_id
),
-- ========== 触达位置汇总层 ==========
user_positions as (
    select user_id, group_concat(position_name) as position_name_list
    from (
        -- 充值半屏页
        select a.user_id, '充值半屏页' as position_name
        from base_users a
        inner join event_operation_exposure b on a.user_id = b.login_id and b.element_id = 200900
        union all
        -- 充值商店页
        select a.user_id, '充值商店页' as position_name
        from base_users a
        inner join event_operation_exposure b on a.user_id = b.login_id and b.page_id = 201300
        union all
        -- 普通弹窗
        select a.user_id, '普通弹窗' as position_name
        from base_users a
        where exists (
            select 1 from event_all_exposure c where a.user_id = c.login_id and c.page_id in(200100,200200,200300,203500)
        )
        union all
        -- 充值返回推
        select a.user_id, '充值返回推' as position_name
        from base_users a
        where exists (
            select 1 from event_all_exposure c where a.user_id = c.login_id and c.element_id = 200900
        )
        union all
        -- 剧末推
        select a.user_id, '剧末推' as position_name
        from base_users a
        inner join event_end_watching d on a.user_id = d.login_id
        inner join dim.dim_short_video_series_view b on d.shortplay_id = b.series_id
        where d.watch_episode_sort = b.last_epis and d.watch_progress >= 1
        union all
        -- 退出观看返回推
        select a.user_id, '退出观看返回推' as position_name
        from base_users a
        where exists (
            select 1 from event_all_exposure c where a.user_id = c.login_id and c.page_id = 200800
        )
        union all
        -- 悬浮窗
        select a.user_id, '悬浮窗' as position_name
        from base_users a
        where exists (
            select 1 from event_all_exposure c where a.user_id = c.login_id and c.page_id in(200100,200200,200300,203500,200800)
        )
        union all
        -- 开屏页
        select a.user_id, '开屏页' as position_name
        from base_users a
        inner join event_app_start e on a.user_id = e.login_id
        union all
        -- TAB栏
        select a.user_id, 'TAB栏' as position_name
        from base_users a
        where exists (
            select 1 from event_all_exposure c where a.user_id = c.login_id and c.page_id in(200100,200200,200300,203500)
        )
        union all
        -- banner
        select a.user_id, 'banner' as position_name
        from base_users a
        inner join event_operation_exposure b on a.user_id = b.login_id and b.element_id = 200900
        union all
        -- 首页
        select a.user_id, '首页' as position_name
        from base_users a
        where exists (
            select 1 from event_all_exposure c where a.user_id = c.login_id and c.page_id = 200200
        )
    ) t
    group by user_id
)
-- ========== 最终输出 ==========
select
    a.dt, a.product_id, a.user_id, a.user_period, a.corever, a.mt, a.reg_country, a.country_level,
    a.current_language2, a.source, a.last_source, a.book_id, a.is_pay, a.chl2, a.chl,
    f.group_id_list,
    b.position_name_list,
    now() as etl_tm
from base_users a
left join (
    select user_id, group_concat(group_id) as group_id_list
    from dwd.dwd_sv_user_group_user_log
    where date(start_time) <= '${bf_1_dt}' and date(end_time) >= '${bf_1_dt}'
    group by user_id
) f on a.user_id = f.user_id
left join user_positions b on a.user_id = b.user_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_srsv_wide_user_type_info_di_v3
-- workflow_version : 14
-- create_user      : chenmo
-- task_name        : tbl_dws_srsv_wide_user_type_info_di
-- task_version     : 6
-- update_time      : 2025-12-23 13:37:32
-- sql_path         : \starrocks\tbl_dws_srsv_wide_user_type_info_di_v3\tbl_dws_srsv_wide_user_type_info_di
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_srsv_wide_user_type_info_di
with
-- ========== 公共基础数据层 ==========
-- 充值用户（阅读+海剧）- 合并两个产品线的充值数据，提前去重减少后续JOIN数据量
base_recharge_user as (
    select product_id, user_id
    from (
        select productid as product_id, userid as user_id
        from dws.dws_trade_user_shopitem_charge_ed
        where dt <= '${bf_1_dt}'
        union all
        select product_id, user_id
        from dws.dws_trade_short_video_payorder_ed
        where dt <= '${bf_1_dt}'
    ) t
    group by product_id, user_id
),
-- 用户媒体来源 - 获取用户的渠道来源信息，用于后续媒体归因分析
base_user_source as (
    select product_id, user_id, mt, corever, lang2, last_source
    from dws.dws_user_market_channel_info_detail_td
    where dt = '${bf_1_dt}'
),
-- 书籍/剧ID映射 - 统一获取阅读书籍ID和海剧剧集ID，支持剧维度分析，NULL转为空字符串
base_book_mapping as (
    select
        product_id,
        id as user_id,
        if(book_id = '' or book_id is null, -1, book_id) as book_id
    from dim.dim_user_account_info_view
    union all
    select
        product_id,
        user_id,
        if(ad_series_id = '' or ad_series_id is null, -1, ad_series_id) as book_id
    from dim.dim_short_video_user_accountinfo
),
-- ========== 用户类型数据层 ==========
-- 1. 新用户 - 基于注册时间识别新用户，关联国家、语言、媒体来源等维度信息
user_new as (
    select
        date(a.CreateTime) as dt,
        a.productid as product_id,
        a.id as user_id,
        1 as user_period,
        coalesce(nullif(a.CoreVer, 0), 1) as corever,
        a.mt,
        coalesce(nullif(a.RegCountry, ''), 'unknown') as reg_country,
        coalesce(b.level, 2) as country_level,
        case a.productid
            when 3311 then coalesce(nullif(a.CurrentLanguage2, 0), 6)
            when 3322 then coalesce(nullif(a.CurrentLanguage2, 0), 5)
            when 3333 then coalesce(nullif(a.CurrentLanguage2, 0), 2)
            when 3366 then coalesce(nullif(a.CurrentLanguage2, 0), 3)
            when 3371 then coalesce(nullif(a.CurrentLanguage2, 0), 7)
            when 3388 then coalesce(nullif(a.CurrentLanguage2, 0), 4)
            when 3501 then coalesce(nullif(a.CurrentLanguage2, 0), 11)
            when 3511 then coalesce(nullif(a.CurrentLanguage2, 0), 12)
            else a.CurrentLanguage2
        end as current_language2,
        case
            when c.last_source in ('fbs2s','facebook','tt','appleadservice','fixadinfo','sem','adwords') then 3
            when c.last_source in ('officialsite','(not set)') then 2
            else 1
        end as source,
        ifnull(c.last_source, '') as last_source,
        ifnull(e.book_id, '') as book_id,
        if(d.user_id is not null, 1, 0) as is_pay,
        a.chl2,
        a.chl,
        null as group_id_list,
        null as position_name_list,
        now() as etl_tm
    from dim.dim_read_and_short_video_accountinfo_tmp_view a
    left join dim.dim_countrylevel b
        on a.productid = b.product_id and a.RegCountry = b.short_name
    left join base_user_source c
        on a.productid = c.product_id
        and a.id = c.user_id
        and a.mt = c.mt
        and a.corever = c.corever
        and a.CurrentLanguage2 = c.lang2
        and c.product_id in (3311,3322,3333,3366,3371,3388,3501,3511,3399,7757,8858,6833)
    left join base_recharge_user d
        on a.productid = d.product_id and a.id = d.user_id
    left join base_book_mapping e
        on a.productid = e.product_id and a.id = e.user_id
    where a.CreateTime >= '${bf_1_dt}'
        and a.createtime < '${dt}'
        and a.productid not in (3521,3531,6883)
        and cast(a.id as int) > 0
),
-- 2. 活跃用户 - 从活跃表获取用户，合并阅读和海剧两个产品线的活跃数据
user_active as (
    select
        a.dt,
        a.product_id,
        a.user_id,
        2 as user_period,
        coalesce(nullif(a.CoreVer, 0), 1) as corever,
        a.mt,
        coalesce(nullif(a.Reg_Country, ''), 'unknown') as reg_country,
        coalesce(a.country_level, 2) as country_level,
        a.current_language2,
        case
            when c.last_source in ('fbs2s','facebook','tt','appleadservice','fixadinfo','sem','adwords') then 3
            when c.last_source in ('officialsite','(not set)') then 2
            else 1
        end as source,
        ifnull(c.last_source, '') as last_source,
        ifnull(f.book_id, '') as book_id,
        if(d.user_id is not null, 1, 0) as is_pay,
        e.chl2,
        e.chl,
        null as group_id_list,
        null as position_name_list,
        now() as etl_tm
    from (
        select dt, product_id, user_id, corever, mt, reg_country, country_level, current_language2
        from dws.dws_user_wide_active_ed
        where dt >= '${bf_1_dt}'
            and dt < '${dt}'
            and product_id not in (3521,3531)
            and user_id > 0
        union all
        select dt, product_id, user_id, corever, mt, reg_country, country_level, current_language2
        from dws.dws_user_short_video_wide_active_ed
        where dt >= '${bf_1_dt}'
            and dt < '${dt}'
            and product_id in (6833)
            and user_id > 0
    ) a
    left join base_user_source c
        on a.product_id = c.product_id
        and a.user_id = c.user_id
        and a.mt = c.mt
        and a.corever = c.corever
        and a.current_language2 = c.lang2
        and c.product_id in (3311,3322,3333,3366,3371,3388,3501,3511,3399,7757,8858,6833)
    left join base_recharge_user d
        on a.product_id = d.product_id and a.user_id = d.user_id
    left join (
        select productid, id, chl2, chl
        from dim.dim_read_and_short_video_accountinfo_tmp_view
        where productid != 6883
    ) e on a.product_id = e.productid and a.user_id = e.id
    left join base_book_mapping f
        on a.product_id = f.product_id and a.user_id = f.user_id
    where cast(a.user_id as int) > 0
),
-- 3. RMT用户 - 识别重装用户（安装时间早于注册时间），使用row_number去重保留优先级最高的记录
user_rmt as (
    select
        a1.dt,
        a1.product_id,
        a1.user_id,
        a1.user_period,
        a1.corever,
        a1.mt,
        a1.reg_country,
        coalesce(b.level, 2) as country_level,
        a1.current_language2,
        a1.source,
        ifnull(a1.last_source, '') as last_source,
        ifnull(e.book_id, '') as book_id,
        if(d.user_id is not null, 1, 0) as is_pay,
        a2.chl2,
        a2.chl,
        null as group_id_list,
        null as position_name_list,
        now() as etl_tm
    from (
        select x.dt, x.install_date, x.product_id, x.user_id, x.corever, x.mt,
               x.reg_country, x.current_language2, x.source, x.last_source, x.user_period
        from (
            select
                dt,
                install_date,
                product_id,
                user_id,
                core as corever,
                mt,
                coalesce(nullif(a.Country, ''), 'unknown') as reg_country,
                a.current_language2,
                case
                    when source in ('fbs2s','facebook','tt','appleadservice','fixadinfo','sem','adwords') then 3
                    when source in ('officialsite','(not set)') then 2
                    else 1
                end as source,
                source as last_source,
                3 as user_period,
                row_number() over(partition by product_id, user_id order by
                    case
                        when source in ('fbs2s','facebook','tt','appleadservice','fixadinfo','sem','adwords') then 3
                        when source in ('officialsite','(not set)') then 2
                        else 1
                    end desc, install_date) as rn
            from dwd.dwd_user_install_info_ed_view a
            where dt >= '${bf_1_dt}'
                and dt < '${dt}'
                and product_id in (3311,3322,3333,3366,3371,3388,3501,3511,3399,7757,8858,6833)
                and User_Id != -1
                and IsDelete = 0
        ) x
        where x.rn = 1
    ) a1
    inner join (
        select productid, id, createtime, chl2, chl
        from dim.dim_read_and_short_video_accountinfo_tmp_view
        where productid not in (3521,3531)
    ) a2 on a1.product_id = a2.productid
        and a1.user_id = a2.id
        and a2.createtime < date_sub(a1.install_date, interval 1 hour)
    left join dim.dim_countrylevel b
        on a1.product_id = b.product_id and a1.reg_country = b.short_name
    left join base_recharge_user d
        on a1.product_id = d.product_id and a1.user_id = d.user_id
    left join base_book_mapping e
        on a1.Product_Id = e.product_id and a1.User_Id = e.user_id
    where cast(a1.user_id as int) > 0
)
-- ========== 合并三类用户 ==========
select * from user_new
union all
select * from user_active
union all
select * from user_rmt;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_srsv_wide_user_type_info_di_xxg
-- workflow_version : 1
-- create_user      : xixg
-- task_name        : dws_srsv_wide_user_type_info_di_xxg
-- task_version     : 1
-- update_time      : 2024-09-24 20:26:59
-- sql_path         : \starrocks\tbl_dws_srsv_wide_user_type_info_di_xxg\dws_srsv_wide_user_type_info_di_xxg
----------------------------------------------------------------
-- SQL语句
-- -------------新用户按天的----------------------------
insert into dws.dws_srsv_wide_user_type_info_di
select
    date(a.CreateTime) as dt,
    a.productid as product_id,
    a.id as user_id ,
    1 as user_period,
    case when a.CoreVer is null or a.corever=0 then 1 else a.corever end as corever,
a.mt ,
case when a.RegCountry ='' then 'unknown' else  a.RegCountry end  as reg_country,
case when b.level is null then 2 else b.level end  as country_level  ,
case when (a.CurrentLanguage2  is null or a.CurrentLanguage2=0) and a.productid=3311 then 6
when (a.CurrentLanguage2  is null or a.CurrentLanguage2=0) and a.productid=3322 then 5
when (a.CurrentLanguage2  is null or a.CurrentLanguage2=0) and a.productid=3333 then 2
when (a.CurrentLanguage2  is null or a.CurrentLanguage2=0) and a.productid=3366 then 3
when (a.CurrentLanguage2  is null or a.CurrentLanguage2=0) and a.productid=3371 then 7
when (a.CurrentLanguage2  is null or a.CurrentLanguage2=0) and a.productid=3388 then 4
when (a.CurrentLanguage2  is null or a.CurrentLanguage2=0) and a.productid=3501 then 11
when (a.CurrentLanguage2  is null or a.CurrentLanguage2=0) and a.productid=3511 then 12
else a.CurrentLanguage2
end as current_language2,
 case when c.last_source in ('fbs2s','facebook','tt','appleadservice','fixadinfo','sem','adwords') then 3
    when c.last_source in ('officialsite','(not set)') then 2
    else 1 end  as source,
 if(d.user_id is not null ,1,0) as  is_pay, -- 1:付费 0：非付费
 a.chl2,
 a.chl,
now() as etl_time
 from dim.dim_read_and_short_video_accountinfo_tmp_view a
 -- 获取国家等级------
 left join dim.dim_countrylevel b on a.productid =b.product_id   and a.RegCountry =b.short_name

 left join
 -- 获取媒体来源------------
 (select product_id,user_id,mt,corever,lang2,last_source from dws.dws_user_market_channel_info_detail_td where dt='${bf_1_dt}' ) c
 on a.productid =c.product_id and a.id=c.user_id and a.mt=c.mt and a.corever=c.corever and a.CurrentLanguage2=c.lang2  and c.product_id in (3311,3322,3333,3366,3371,3388,3501,3511,3399,7757,8858,6833)

  left join  -- ------判断用户是否收费--------------------
 ( -- 阅读的充值表-----------------
 select productid as product_id,userid as user_id from dws.dws_trade_user_shopitem_charge_ed where dt<'${bf_1_dt}' group by 1,2
 union all
 -- 海剧的充值--------------------
 select product_id,user_id from dws.dws_trade_short_video_payorder_ed where dt<'${bf_1_dt}' group by 1,2
 ) d
on a.productid=d.product_id and a.id=d.user_id

 where a.CreateTime >='${bf_1_dt}' and a.createtime<'${dt}' and a.productid  not in (3521,3531,6883) ;

-- SQL语句
-- -------------活跃用户按天的----------------------------
insert into dws.dws_srsv_wide_user_type_info_di
select
    a.dt ,
    a.product_id,
    a.user_id ,
    2 as user_period,
    case when a.CoreVer is null or a.corever=0 then 1 else a.corever end as corever,
    a.mt ,
    case when a.Reg_Country ='' then 'unknown' else  a.Reg_Country end  as reg_country,
    case when a.country_level is null then 2 else a.country_level end  as country_level ,
    a.current_language2,
    case when c.last_source in ('fbs2s','facebook','tt','appleadservice','fixadinfo','sem','adwords') then 3
         when c.last_source in ('officialsite','(not set)') then 2
         else 1 end  as source,
    if(d.user_id is not null ,1,0) as  is_pay, -- 1:付费 0：非付费
    e.chl2,
    e.chl,
    now() as etl_time
from
    (	select dt,product_id,user_id,corever,mt,reg_country,country_level,current_language2 from  dws.dws_user_wide_active_ed a where  a.dt >='${bf_1_dt}' and a.dt<'${dt}' and a.product_id  not in (3521,3531) and a.user_id >0
         union all
         select dt,product_id,user_id,corever,mt,reg_country,country_level,current_language2 from  dws.dws_user_short_video_wide_active_ed a where a.dt >='${bf_1_dt}' and a.dt<'${dt}' and a.product_id  in (6833)  and a.user_id >0
    ) a
        left join
    (select product_id,user_id,mt,corever,lang2,last_source from dws.dws_user_market_channel_info_detail_td where dt='${bf_1_dt}' ) c
    on a.product_id =c.product_id and a.user_id=c.user_id and a.mt=c.mt and a.corever=c.corever and a.current_language2=c.lang2  and c.product_id in (3311,3322,3333,3366,3371,3388,3501,3511,3399,7757,8858,6833)

        left join  -- ------判断用户是否收费--------------------
        ( -- 阅读的充值表-----------------
            select productid as product_id,userid as user_id from dws.dws_trade_user_shopitem_charge_ed where dt<'${bf_1_dt}' group by 1,2
            union all
            -- 海剧的充值--------------------
            select product_id,user_id from dws.dws_trade_short_video_payorder_ed where dt<'${bf_1_dt}' group by 1,2
        ) d
                   on a.product_id=d.product_id and a.user_id=d.user_id
        left join
    (select productid ,id ,chl2,chl from  dim.dim_read_and_short_video_accountinfo_tmp_view where productid  !=6883)  e
    on a.product_id =e.productid and a.user_id =e.id
;

-- SQL语句
-- -------------rmt 用户按天的----------------------------
insert into dws.dws_srsv_wide_user_type_info_di
select
    a1.dt  ,
    a1.product_id,
    a1.user_id ,
    a1.user_period,
    a1.corever,
    a1.mt ,
    a1.reg_country,
    case when b.level is null then 2 else b.level end  as country_level  ,
    a1.current_language2,
    a1.source,
    if(d.user_id is not null ,1,0) as  is_pay, -- 1:付费 0：非付费
    a2.chl2,
    a2.chl,
    now() as etl_time
from (
         select x.dt,
                x.install_date,
                x.product_id,
                x.user_id ,
                x.corever,
                x.mt ,
                x.reg_country,
                x.current_language2,
                x.source,
                x.user_period
         from (
                  select
                      dt ,
                      install_date,
                      product_id,
                      user_id,
                      core as corever,
                      mt,
                      case when a.Country ='' then 'unknown' else  a.Country end  as reg_country,
                      a.current_language2,
                      case when source in ('fbs2s','facebook','tt','appleadservice','fixadinfo','sem','adwords') then 3
                           when source in ('officialsite','(not set)') then 2 else 1 end as source ,
                      3 as user_period,
                      row_number() over(partition by product_id,user_id order by
                    case when source in ('fbs2s','facebook','tt','appleadservice','fixadinfo','sem','adwords') then 3
                    when source in ('officialsite','(not set)') then 2 else 1 end desc,install_date) as rn
                  from dwd.dwd_user_install_info_ed_view a
                  where      a.dt >='${bf_1_dt}' and a.dt<'${dt}' and a.product_id   in (3311,3322,3333,3366,3371,3388,3501,3511,3399,7757,8858,6833)  and a.User_Id !=-1 and a.IsDelete =0
              ) x where x.rn =1
     ) a1
         inner join (
    select productid,id,createtime,chl2,chl  from dim.dim_read_and_short_video_accountinfo_tmp_view where productid  not in (3521,3531)  ) a2
                    on a1.product_id = a2.productid   and a1.user_id = a2.id
                        and a2.createtime < date_sub(a1.install_date, interval 1 HOUR)
         left join dim.dim_countrylevel b on a1.product_id =b.product_id   and a1.reg_country =b.short_name

         left join  -- ------判断用户是否收费--------------------
    ( -- 阅读的充值表-----------------
        select productid as product_id,userid as user_id from dws.dws_trade_user_shopitem_charge_ed where dt<'${bf_1_dt}' group by 1,2
        union all
        -- 海剧的充值--------------------
        select product_id,user_id from dws.dws_trade_short_video_payorder_ed where dt<'${bf_1_dt}' group by 1,2
    ) d
                    on a1.product_id=d.product_id and a1.user_id=d.user_id  ;
