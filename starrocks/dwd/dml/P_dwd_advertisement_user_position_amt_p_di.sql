----------------------------------------------------------------
-- 程序功能： 阅读及海剧用户广告展现位置收益表
-- 程序名： P_dwd_advertisement_user_position_amt_p_di
-- 目标表： dwd.dwd_advertisement_user_position_amt_p_di
-- 负责人： cm/qhr
-- 开发日期：2025-11-24
-- 版本号： v0.1.0
----------------------------------------------------------------

delete from dwd.dwd_advertisement_user_position_amt_p_di where dt>= '${bf_1_dt}' and dt<='${dt}';

-- 阅读 & 圣经
insert into dwd.dwd_advertisement_user_position_amt_p_di
with tmp_data as (
    select productid                                                                     as product_id
          ,userid                                                                        as user_id
          ,mod(appId DIV 1000,1000)                                                      as core
          ,mt                                                                            as mt
          ,appver                                                                        as appver
          ,CreateTime                                                                    as create_time
          ,trim(get_json_string(parse_json(s0), "$.adUnitId"))                           as ad_unit
          ,trim(coalesce( get_json_string(parse_json(s0), "$.positionId")
                         ,get_json_string(parse_json(s0), "$.ad_position_id")
                        )
               )                                                                         as position_id
          ,trim(get_json_string(parse_json(s0), "$.platform"))                           as platform
          ,trim(get_json_string(parse_json(s0), "$.precisionType"))                      as precisionType
          ,cast(get_json_string(parse_json(s0), "$.valueMicros") as double)              as valueMicros
          ,trim(get_json_string(parse_json(s0), "$.mediationAdapterClassName"))          as platform_source
          ,trim(get_json_string(parse_json(s0), "$.main_strategy_id"))                   as main_strategy_id
          ,trim(get_json_string(parse_json(s0), "$.ad_strategy_id"))                     as event_strategy_id
          ,trim(get_json_string(parse_json(s0), "$.programme_id"))                       as programme_id
      from ods_log.ods_readerlog_xx_log_commonactionlog
     where dt >= '${bf_1_dt}'
       and dt <= '${dt}'
       and Action = 'AdMobPainEvent'
     union all
    select 2311                                                                          as product_id
          ,UserId                                                                        as user_id
          ,Core                                                                          as core
          ,mt                                                                            as mt
          ,Appver                                                                        as appver
          ,CreateTime                                                                    as create_time
          ,trim(get_json_string(parse_json(ECPMInfo), '$.adUnitId'))                     as ad_unit
          ,trim(coalesce( get_json_string(parse_json(ECPMInfo), '$.positionId')
                         ,get_json_string(parse_json(ECPMInfo), '$.position')
                        )
               )                                                                         as position_id
          ,trim(get_json_string(parse_json(ECPMInfo), '$.platform'))                     as platform
          ,trim(get_json_string(parse_json(ECPMInfo), '$.precisionType'))                as precisionType
          ,cast(get_json_string(parse_json(ECPMInfo), '$.valueMicros')as double)         as valueMicros
          ,trim(get_json_string(parse_json(ECPMInfo), '$.mediationAdapterClassName'))    as platform_source
          ,trim(get_json_string(parse_json(ECPMInfo), '$.main_strategy_id'))             as main_strategy_id
          ,trim(get_json_string(parse_json(ECPMInfo), '$.event_strategy_id'))            as event_strategy_id
          ,trim(get_json_string(parse_json(ECPMInfo), '$.programme_id'))                 as programme_id
      from ods.ods_tidb_hallow_log_log_advertlog
    where ECPMValueType = 1
      and date(CreateTime) >= '${bf_1_dt}'
      and date(CreateTime) <= '${dt}'
)
, amt as (
    select date(a.create_time)                            as dt
          ,a.create_time                                  as create_time
          ,a.product_id                                   as product_id
          ,a.user_id                                      as user_id
          ,a.core                                         as core
          ,a.mt                                           as mt
          ,a.appver                                       as appver
          ,a.ad_unit                                      as ad_unit
          ,a.position_id                                  as position_id
          ,if(a.platform is null, 'Admob', a.platform)    as ads_name -- 广告平台 (adomob,topon,max)
          ,a.platform_source                              as platform_source
          ,a.main_strategy_id                             as main_strategy_id
          ,a.event_strategy_id                            as event_strategy_id
          ,a.programme_id                                 as programme_id
          ,sum(case when a.core = 4 then case when platform='Admob' or platform is null or platform='' then a.valueMicros/1000000.0
                                              else a.valueMicros
                                          end
                    else case when mt = 4 and (platform='Admob' or platform is null or platform='') then a.valueMicros/1000000.0
                              else a.valueMicros
                          end
                end
              )                                           as amount
          ,current_timestamp()                            as etl_tm
      from (select product_id
                  ,user_id
                  ,core
                  ,mt
                  ,appver
                  ,create_time
                  ,ad_unit
                  ,position_id
                  ,platform
                  ,case precisionType when 2 then valueMicros/1000.0
                                      else valueMicros
                    end                                   as valueMicros
                  ,platform_source
                  ,main_strategy_id
                  ,event_strategy_id
                  ,programme_id
              from tmp_data
           )                                              as a
     where a.valueMicros > 0
     group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14
)
select a.dt                   as dt
      ,a.create_time          as create_time
      ,a.product_id           as product_id
      ,a.user_id              as user_id
      ,a.core                 as corever
      ,a.mt                   as mt
      ,a.appver               as appver
      ,a.ad_unit              as ad_unit
      ,a.positions            as position_id
      ,a.ads_name             as ads_name
      ,a.platform_source      as ads_source
      ,a.ad_show_type         as ad_show_type
      ,a.main_strategy_id     as main_strategy_id
      ,a.event_strategy_id    as event_strategy_id
      ,a.programme_id         as programme_id
      ,a.amount               as ad_position_amt
      ,now()                  as etl_tm
  from (
        -- 旧版本数据没有 position_id 关联取最小位置的广告数据
        select amt.dt
              ,amt.product_id
              ,amt.user_id
              ,amt.core
              ,amt.mt
              ,amt.appver
              ,amt.create_time
              ,amt.ad_unit
              ,d.ad_show_type
              ,d.positions
              ,amt.amount
              ,amt.ads_name
              ,amt.platform_source
              ,amt.main_strategy_id
              ,amt.event_strategy_id
              ,amt.programme_id
          from amt
          left join (select product_id
                           ,unit_adid
                           ,ad_show_type
                           ,min(ad_position)    as positions
                       from dim.dim_app_adplatform_unit_id_info
                      where status = 1
                      group by 1,2,3
                    )                           as d
            on amt.product_id = d.product_id
           and amt.ad_unit = d.unit_adid
         where amt.position_id is null
         union all
        -- 新版本数据 客户端会上报position_id （配置表中会存在广告单元id与position_id一样的重复多条的数据，需要去重后关联获取广告类型）
        select amt.dt
              ,amt.product_id
              ,amt.user_id
              ,amt.core
              ,amt.mt
              ,amt.appver
              ,amt.create_time
              ,amt.ad_unit
              ,case when amt.product_id = 2311 then 3
                    else d.ad_show_type
                end                             as ad_show_type
              ,amt.position_id                  as positions
              ,amt.amount
              ,amt.ads_name
              ,amt.platform_source
              ,amt.main_strategy_id
              ,amt.event_strategy_id
              ,amt.programme_id
          from amt
          left join (select product_id
                           ,unit_adid
                           ,ad_show_type
                           ,ad_position         as positions
                       from (select product_id
                                   ,unit_adid
                                   ,ad_show_type
                                   ,ad_position
                                   ,count(1)
                               from dim.dim_app_adplatform_unit_id_info
                              where status = 1
                              group by 1,2,3,4
                            )                   as a
                    )                           as d
            on amt.product_id = d.product_id
           and amt.ad_unit = d.unit_adid
           and amt.position_id = d.positions
         where amt.position_id is not null
)                                               as a
;

-- 短剧
insert into dwd.dwd_advertisement_user_position_amt_p_di
with us as (
    select DATE(create_tm)                    as dt
          ,create_tm                          as create_tm
          ,6833                               as product_id
          ,user_id                            as user_id
          ,IFNULL(core,1)                     as core 
          ,mt                                 as mt
          ,app_ver                            as app_ver
          ,ad_unit                            as ad_unit
          ,position                           as position
          ,if(adsPlatform=2,'Max','Admob')    as ads_name
          ,MediationAdapterClassName          as ads_source
          ,mainstrategyid                     as main_strategy_id
          ,eventstrategyid                    as event_strategy_id
          ,sum(case when adsPlatform=2 then value_micros
                    when adsPlatform=1 and core in(2,4) and mt = 1 then value_micros
                    else value_micros/1000000.0
                end
              )                               as amount
    from (select case PrecisionType when 2 then ValueMicros / 1000.0
                                    else ValueMicros
                  end                         as value_micros
                ,AccountId                    as user_id
                ,core                         as core
                ,createtime                   as create_tm
                ,AdUnitId                     as ad_unit
                ,Appver                       as app_ver
                ,POSITION                     as position
                ,MediationAdapterClassName    as MediationAdapterClassName
                ,IFNULL(adsPlatform,1)        as adsPlatform    -- adsPlatform:null和1表示 admob,将null值转换为1
                ,mt                           as mt
                ,mainstrategyid               as mainstrategyid
                ,eventstrategyid              as eventstrategyid
            from ods.ods_tidb_short_video_admob_paid_event
           where createtime >= '${bf_1_dt}'
             and date(createtime)<='${dt}'
             and AdUnitId !='ca-app-pub-1669209234634531/6952416968'    -- 这个是测试数据
         ) res
   where value_micros >0
   group by 1,2,3,4,5,6,7,8,9,10,11,12,13
)
, p as (
    -- 本身自带position的 关联配置表获取广告类型 ads_type,优先取广告状态开启的
    select us.dt                                  as dt
          ,us.product_id                          as product_id
          ,us.user_id                             as user_id
          ,us.core                                as core
          ,us.mt                                  as mt
          ,us.app_ver                             as app_ver
          ,us.ad_unit                             as ad_unit
          ,us.create_tm                           as create_tm
          ,us.position                            as position
          ,us.amount                              as amount
          ,b.ads_type                             as ads_type
          ,us.ads_name                            as ads_name
          ,us.ads_source                          as ads_source
          ,us.main_strategy_id                    as main_strategy_id
          ,us.event_strategy_id                   as event_strategy_id
      from us 
      left join (
                 -- 按广告单元id进行开窗排序，优先取状态为开启的进行匹配（status in (0,2) 为关闭状态）
                 select unit_adid, position_id, ads_type
                   from dim.dim_short_video_ads_unit_adid_view
                  qualify row_number() over(partition by unit_adid order by if(status in (0,2),2,status)) = 1
                ) b
        on us.ad_unit = b.unit_adid
     where us.position > 0
) 
, n as (
    select us.dt                   as dt
          ,us.product_id           as product_id
          ,us.user_id              as user_id
          ,us.core                 as core
          ,us.mt                   as mt
          ,us.app_ver              as app_ver
          ,us.ad_unit              as ad_unit
          ,us.create_tm            as create_tm
          ,b.position_id           as position
          ,us.amount               as amount
          ,b.ads_type              as ads_type
          ,us.ads_name             as ads_name
          ,us.ads_source           as ads_source
          ,us.main_strategy_id     as main_strategy_id
          ,us.event_strategy_id    as event_strategy_id
      from us
      left join (
                 -- 将广告单元id进行排序
                 select unit_adid
                       ,position_id
                       ,ads_type
                   from dim.dim_short_video_ads_unit_adid_view 
                qualify row_number() over(partition by unit_adid order by if(status in (0,2),2,status)) = 1    -- 按广告单元id进行开窗排序，优先取状态为开启的进行匹配（status in (0,2) 为关闭状态）
                ) b 
        on us.ad_unit = b.unit_adid
     where (us.position < 0 or us.position is null)
)
select dt                          as dt
      ,create_tm                   as create_tm
      ,product_id                  as product_id
      ,user_id                     as user_id
      ,core                        as core
      ,mt                          as mt
      ,app_ver                     as app_ver
      ,ad_unit                     as ad_unit
      ,position                    as positon_id
      ,ads_name                    as ads_name
      ,ads_source                  as ads_source
      ,ads_type                    as ad_show_type
      ,main_strategy_id            as main_strategy_id
      ,event_strategy_id           as event_strategy_id
      ,null                        as programme_id
      ,amount                      as ad_position_amt
      ,now()                       as etl_tm 
  from p
 union all
select dt                          as dt
      ,create_tm                   as create_tm
      ,product_id                  as product_id
      ,user_id                     as user_id
      ,core                        as core
      ,mt                          as mt
      ,app_ver                     as app_ver
      ,ad_unit                     as ad_unit
      ,position                    as positon_id
      ,ads_name                    as ads_name
      ,ads_source                  as ads_source
      ,ads_type                    as ad_show_type
      ,main_strategy_id            as main_strategy_id
      ,event_strategy_id           as event_strategy_id
      ,null                        as programme_id
      ,amount                      as ad_position_amt
      ,now()                       as etl_tm 
  from n
;