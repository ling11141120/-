----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_read_flow_resource_slot_exposure_di
-- workflow_version : 11
-- create_user      : yanxh
-- task_name        : ads_bi_read_flow_resource_slot_exposure_di
-- task_version     : 11
-- update_time      : 2024-10-16 11:55:15
-- sql_path         : \starrocks\tbl_ads_bi_read_flow_resource_slot_exposure_di\ads_bi_read_flow_resource_slot_exposure_di
----------------------------------------------------------------
-- 前置SQL语句
delete from  ads.ads_bi_read_flow_resource_slot_exposure_di where dt >= '${bf_3_dt}' and dt<='${bf_1_dt}';

-- SQL语句
insert into ads.ads_bi_read_flow_resource_slot_exposure_di
   with op_exposure as (
            select dt,
           corever  ,
           mt,
           country_level,
           current_language2,
           case
               when element_id = '100351' then 'reading'
               when element_id = '100352' then 'chapterpush'
               when element_id = '100391' then 'netmonitor'
               when element_id = '100671' then 'centertab'
               when element_id = '100363' then 'flashscreen'
               when element_id = '100390' then 'popup'
               when element_id = '100352' then 'chapterpush'
               when element_id = '100359' then 'banner'
               when element_id = '100400' then 'readerreturn'
               when element_id = '100366' then 'topbookshelf'
           end                                                       as resouce_slot,   -- 资源位
           element_id,                                                                  -- 运营位ID
            parent_group_id,                                                             -- 人群包ID
           if(element_id = '100671', event_strategy_id, activity_id) as strategy_id,    -- 策略ID, TAB推荐控件(控件ID = 100671)的策略ID取 event_strategy_id, 其它控件取activity_id
		   user_id,
           sum(cnt)       as op_exposure_cnt  -- 运营位曝光次数

    from dws.dws_flow_operation_oosition_exposure_ed
    where parent_group_id is not null     -- 过滤无人群包ID的事件
      and instr(parent_group_id, ',') = 0 -- 过滤有多个ID的人群包，这个在口径上划分为异常数据
      and dt >= '${bf_3_dt}' and dt<='${bf_1_dt}'
	  and user_id is not null  -- 排除掉用户id为空的数据
	  and current_language2 is not null -- 排除掉注册语言为空的数据，这部分数据用户在注册账户表中并不存在
      and element_id in (100351, 100352, 100391, 100671, 100363, 100390, 100359, 100400, 100366)
 --   and  activity_id=8682501  and  parent_group_id=8054432  and element_id=100363
    group by  1,2,3,4,5,6,7,8,9,10
)
,
-- 运营位点击
     op_click as (
                select dt,
                element_id,                                                              -- 运营位id
                parent_group_id,                                                         -- 人群包id
                if(element_id = '100671', event_strategy_id, activity_id) as strategy_id, -- TAB推荐控件(控件ID = 100671)的策略ID取 event_strategy_id, 其它控件取activity_id
				identity_login_id                                          as user_id ,
                count(1)                                                  as op_click_cnt  -- 运营位曝光次数

         from dwd.dwd_sensors_production_operationpositionclick_view
         where parent_group_id is not null     -- 过滤无人群包ID的事件
           and instr(parent_group_id, ',') = 0 -- 过滤有多个ID的人群包，这个在口径上划分为异常数据
           and dt >= '${bf_3_dt}' and dt<='${bf_1_dt}'
           and element_id in (100351, 100352, 100391, 100671, 100363, 100390, 100359, 100400, 100366)
         --   and activity_id=8682501  and  parent_group_id=8054432  and element_id=100363
         group by 1,2,3,4,5
     ) ,

-- 入包且活跃用户
     group_active_user as (
                  select a.dt,
                         g.group_id,
						 a.user_id
         from dws.dws_user_wide_active_ed as a
                  inner join dwd.dwd_market_realtimegrouplog_view as g
                  on a.product_id=g.product_id and  a.user_id = g.user_id
         where g.start_time <= a.dt                            -- 入包时间
           and g.end_time > a.dt                               -- 出包时间
           and g.op_type = 0                                   -- op_type = 0 表示入包
           and a.dt >= '${bf_3_dt}' and a.dt<='${bf_1_dt}'
           and g.dt >= date_sub('${bf_1_dt}', interval 30 day) -- 入包时间距离活跃时间不超过30天
         group by 1,2 ,3
     )
 ,

-- H5页面曝光
     h5_exposure as (
      select     dt,
                split(send_id, '_')[2]           as resource_slot, -- 资源位
                split(send_id, '_')[4]           as strategy_id,   -- 策略ID 转化来源，send_id = {书籍ID}_资源位_{活动ID}_{策略ID}_{资源位触达事件ID}_{时间}
				 identity_login_id               as user_id
				from (
select dt,send_id ,identity_login_id
				 from dwd.dwd_sensors_production_rechargeexposure_view
         where dt >= '${bf_3_dt}' and dt<='${bf_1_dt}'
		   and  lib='js'
           and send_id != 'null'
           and send_id is not null -- 过滤转化来源为空的数据
           and split(send_id, '_')[2] is not null
           union all
select dt,send_id ,identity_login_id from dwd.dwd_sensors_production_element_expose_view
         where dt >= '${bf_3_dt}' and dt<='${bf_1_dt}'
		   and  lib='js'
           and send_id != 'null'
           and send_id is not null -- 过滤转化来源为空的数据
         and   split(send_id, '_')[2] is not null
         ) n  group by 1,2,3,4

     ),

-- H5页面创建订单
     h5_click as (
         select dt,
                split(send_id, '_')[2] as resource_slot, -- 资源位
                split(send_id, '_')[4] as strategy_id,   -- 策略ID 转化来源，send_id = {书籍ID}_资源位_{活动ID}_{策略ID}_{资源位触达事件ID}_{时间}
				identity_login_id      as user_id            -- H5点击用户
         from dwd.dwd_sensors_production_ordercreateaction_view
         where send_id is not null -- 过滤转化来源为空的数据
           and send_id != 'null'   -- 异常数据null 字符串
           and   dt >= '${bf_3_dt}' and dt<='${bf_1_dt}'
           and  split(send_id, '_')[2] is not null
         group by 1,2,3,4
     )
,

-- H5页面充值成功 / H5页面充值成功金额
     h5_recharge_success as (
         select dt,
                split(send_id, '_')[2]            as resource_slot,             -- 资源位
                split(send_id, '_')[4]            as strategy_id,               -- 策略ID
				distinct_id                       as user_id ,
                sum(real_recharge)                as recharge_amt -- H5充值成功金额（单位:美元）
         from dwd.dwd_sensors_production_ordersuccess_view
         where send_id is not null -- 过滤转化来源为空的数据
           and send_id != 'null'   -- 异常数据null 字符串
           and dt >= '${bf_3_dt}' and dt<='${bf_1_dt}'
           and split(send_id, '_')[4] != 0
         group by 1,2,3,4
     )

select a.dt,                                                                -- 日期
       a.corever,                                                              -- core
       if(a.mt is null ,-99,a.mt) as mt ,                                                                -- 终端
       a.country_level,                                                     -- 国家等级
       a.current_language2,                                                 -- 投放语言（注册语言）
       ifnull(a.strategy_id,-99),                                                       -- 策略ID
       a.parent_group_id  as group_id,                                      -- 人群包ID
       a.element_id,                                                        -- 运营位ID
       bitmap_agg(f.user_id)               as group_active_unt,          -- 入包且活跃UV
       bitmap_agg(a.user_id)               as op_exposure_unt,           -- 运营位曝光UV
       sum(ifnull(a.op_exposure_cnt,0))    as op_exposure_cnt,           -- 运营位曝光PV
       bitmap_agg(b.user_id)               as op_click_unt,              -- 运营位点击UV
       sum(ifnull(op_click_cnt,0))         as op_click_cnt,              -- 运营位点击PV
       bitmap_agg(c.user_id)               as h5_exposure_unt,           -- h5页面曝光UV
       bitmap_agg(d.user_id)               as h5_click_unt,              -- h5页面点击UV
       bitmap_agg(e.user_id)               as recharge_unt,              -- h5页面充值成功UV
       sum(ifnull(e.recharge_amt,0))       as recharge_amt,-- h5页面充值成功金额
       now() as etl_tm
from op_exposure as a
         left join op_click as b on a.element_id = b.element_id and a.parent_group_id = b.parent_group_id and a.strategy_id = b.strategy_id and a.user_id =  b.user_id and a.dt=b.dt

         left join h5_exposure as c on a.resouce_slot = c.resource_slot and a.strategy_id = c.strategy_id  and a.user_id =  c.user_id and a.dt=c.dt
         left join h5_click as d on a.resouce_slot = d.resource_slot and a.strategy_id = d.strategy_id   and a.user_id =  d.user_id and a.dt=d.dt
         left join h5_recharge_success as e on a.resouce_slot = e.resource_slot and a.strategy_id = e.strategy_id  and a.user_id =  e.user_id  and a.dt=e.dt
         left join group_active_user as f on a.parent_group_id = f.group_id and a.user_id =  f.user_id  and a.dt=f.dt
		 group by 1,2,3,4,5,6,7,8;
