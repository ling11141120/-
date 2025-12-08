----------------------------------------------------------------
-- 程序功能： 用户匿名id映射表
-- 程序名： P_dim_user_login_anonymous_map
-- 目标表： dim.dim_user_login_anonymous_map
-- 负责人： xjc
-- 开发日期： 2025-12-04
----------------------------------------------------------------

insert into dim.dim_user_login_anonymous_map
select a1.login_id                                                             as login_id        -- 用户id
      ,a1.anonymous_id                                                         as anonymous_id    -- 匿名id
      ,coalesce(cast((substring(a1.app_id, 4, 3)) as int) ,a1.app_core_ver)    as core            -- core
      ,now()                                                                   as etl_time        -- 数据清洗时间
  from ods_log.ods_sensors_cd_video_ElmentExposure    as a1
 where a1.dt=date('${dt}')
   and a1.etl_tm>=date_sub('${dt}',interval 1 hour)
   and a1.etl_tm<='${dt}'
   and length(a1.login_id)>1
   and a1.anonymous_id is not null
   and coalesce(cast((substring(a1.app_id, 4, 3)) as int) ,a1.app_core_ver) is not null
 group by 1,2,3
 union
select a1.login_id                                  as login_id        -- 用户id
      ,a1.anonymous_id                              as anonymous_id    -- 匿名id
      ,cast((substring(a1.app_id, 4, 3)) as int)    as core            -- core
      ,now()                                        as etl_time        -- 数据清洗时间
  from ods_log.ods_sensors_cd_video_startwatching    as a1
 where a1.dt=date('${dt}')
   and a1.etl_tm>=date_sub('${dt}',interval 1 hour)
   and a1.etl_tm<='${dt}'
   and length(a1.login_id)>1
   and a1.anonymous_id is not null
   and cast((substring(a1.app_id, 4, 3)) as int) is not null
 group by 1,2,3
 union
select a1.login_id                                                             as login_id        -- 用户id
      ,a1.anonymous_id                                                         as anonymous_id    -- 匿名id
      ,coalesce(cast((substring(a1.app_id, 4, 3)) as int) ,a1.app_core_ver)    as core            -- core
      ,now()                                                                   as etl_time        -- 数据清洗时间
  from ods_log.ods_sensors_cd_video_production_rechargeexposure    as a1
 where a1.dt=date('${dt}')
   and a1.etl_tm>=date_sub('${dt}',interval 1 hour)
   and a1.etl_tm<='${dt}'
   and length(a1.login_id)>1
   and a1.anonymous_id is not null
   and coalesce(cast((substring(a1.app_id, 4, 3)) as int) ,a1.app_core_ver) is not null
 group by 1,2,3
;