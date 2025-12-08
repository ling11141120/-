----------------------------------------------------------------
-- 程序功能： 设备域-神农机型信息表-每日全量
-- 程序名： P_dim_device_device_model_info_df
-- 目标表： dim.dim_device_device_model_info_df
-- 负责人： roger
-- 开发日期：2025/11/27
-- 版本号： v1.0
----------------------------------------------------------------

insert into dim.dim_device_device_model_info_df
with sv_user_account_info as (
  select date(a1.createtime)            as dt
        ,6833                           as product_id
        ,a1.corever2
        ,IFNULL(a2.Device2, a3.Device2) as device2
  from ods.ods_tidb_short_video_accountinfo as a1
           left join (select product_id
                            ,id
                            ,Userid
                            ,Timestamp
                            ,Device2
                      from (select 6833                                                             as product_id
                                  ,id
                                  ,Userid
                                  ,Timestamp
                                  ,Device2
                                  ,row_number() over (partition by Userid order by Timestamp desc ) as rn
                            from ods.ods_tidb_short_video_device_info
                           ) as c1
                      where rn = 1
                     )                      as a2
                     on a2.product_id = 6833
                         and a1.id = a2.userid
           left join (select c2.AccountId
                            ,c3.Device2
                      from ods.ods_tidb_short_video_device_account            as c2
                               left join ods.ods_tidb_short_video_device_info as c3
                                         on c2.DeviceId = c3.UniqueCdReaderId
                     )                      as a3
                     on a1.id = a3.AccountId
  where date(a1.createtime) = '${bf_1_dt}'
  group by 1, 2, 3, 4
)
    ,today_dev_mdl_tmp as (
    select a1.dt
         ,a1.corever2 as core
         ,a1.device2 as dev_mdl
         ,a1.product_id
    from sv_user_account_info as a1 -- 短剧用户信息表
    where a1.device2 is not null and a1.dt = '${bf_1_dt}'
    union all
    select date(a2.createtime) as dt
         ,if (a2.CoreVer2 = 0,1,a2.CoreVer2) as corever2
         ,a3.Device2 as dev_mdl
         ,a2.productid as product_id
    from ods.ods_book_user_accountinfo      as a2 -- 用户账号信息表
         join ods.ods_tidb_readernovel_tidb_userdata as a3 -- 阅读用户信息表
           on a3.id = a2.id
          and a3.product_id = a2.productid
          and a3.Device2 is not null
    where date(a2.createtime) = '${bf_1_dt}'
      and a2.productid not in (3521, 3531, 7757, 8858)
)
    ,total_dev_mdl_tmp as (select a1.dt
                               ,a1.core
                               ,a1.dev_mdl
                               ,a1.product_id
                               ,a1.etl_tm
                               ,row_number() over (partition by a1.core, a1.dev_mdl, a1.product_id order by a1.etl_tm) as rn
                         from (select b1.dt, b1.core, b1.dev_mdl, b1.product_id, now() as etl_tm
                               from today_dev_mdl_tmp as b1
                               where b1.core is not null
                                 and b1.product_id is not null
                               group by b1.dt, b1.core, b1.dev_mdl, b1.product_id
                               union all
                               select dt, core, dev_mdl, product_id, etl_tm
                               from dim.dim_device_device_model_info_df
                               where dt = '${bf_2_dt}'
                              ) a1
)

select '${bf_1_dt}' as dt
      ,core
      ,dev_mdl
      ,product_id
      ,a2.p_cd_val  as biz_type_cd
      ,a2.p_cd_desc as biz_type_name
      ,etl_tm
from total_dev_mdl_tmp a1
    left join dim.dim_pub_code_mapping_dict as a2
      on a2.app_plat = 'beidou'
     and a2.cd_col = 'product_id'
     and a2.p_cd_val is not null
     and a1.product_id = a2.cd_val
where a1.rn = 1
  and a1.core is not null
  and ifnull(a1.dev_mdl, '') <> ''
  and a1.product_id is not null
  and a2.p_cd_desc is not null
;


