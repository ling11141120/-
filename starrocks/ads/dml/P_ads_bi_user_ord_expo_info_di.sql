----------------------------------------------------------------
-- 程序功能： 海外短剧-用户订单曝光信息表
-- 程序名： P_ads_bi_user_ord_expo_info_di
-- 目标表： ads.ads_bi_user_ord_expo_info_di
-- 负责人： roger
-- 开发日期：2025/11/19
-- 版本号： v1.0
----------------------------------------------------------------

SET cbo_cte_reuse = true;  -- 开启 CTE 复用

insert into ads.ads_bi_user_ord_expo_info_di
with tmp_recharge_exposure as (
      select login_id as usr_id
            ,event_tm
            ,zffs_list
            ,array_join(array_slice(split(zffs_list, ','), 1, 3), ',') as zffs_list_filter
      from ods_log.ods_sensors_cd_video_production_rechargeexposure
      where product_id = 6833
       and dt >= '${bf_4_dt}' 
       and dt <= '${bf_1_dt}'
      group by login_id, event_tm, zffs_list
)
      ,tmp_order as (select a1.dt
                           ,a1.usr_id
                           ,a1.ord_id
                           ,a1.pay_mth as cur_pay_mth
                           ,lag(a1.pay_mth) over (partition by a1.usr_id order by a1.createtime) as lst_pay_mth
                           ,a1.mt
                           ,a1.cstm_data
                           ,a1.sub_statu_cd
                           ,a1.createtime
                           ,a1.shopitem
                     from (select  c1.dt as dt
                                  ,c1.userid as usr_id
                                  ,c1.orderid as ord_id
                                  ,c1.SubPayType as pay_mth
                                  ,c1.MT as mt
                                  ,parse_json(c1.CustomData) as cstm_data
                                  ,get_json_int(c1.CooOrderExtInfo, "$.SubscribeStatus") as sub_statu_cd
                                  ,c1.createtime
                                  ,c1.shopitem
                          from ods.ods_tidb_short_video_payorder c1
                          where c1.dt = '${bf_1_dt}'
                           and c1.TestFlag = 0
                           and c1.ProdId = 6833
                           and c1.userid is not null
                           and c1.orderid is not null
                          union all
                          select b1.dt as dt
                                ,b1.user_id as usr_id
                                ,b1.order_id as ord_id
                                ,b1.pay_method as pay_mth
                                ,'' as mt
                                ,'' as cstm_data
                                ,'' as sub_statu_cd
                                ,b1.crt_tm as createtime
                                ,'' as shopitem
                          from dim.dim_sv_user_latest_ord b1
                              left semi join ods.ods_tidb_short_video_payorder b2
                              on b1.user_id = b2.userid
                              and b2.dt = '${bf_1_dt}'
                              and b2.TestFlag = 0
                              and b2.ProdId = 6833
                          where b1.dt = '${bf_2_dt}'
                          ) a1
)

select a1.dt             as dt                     -- 日期
      ,a1.usr_id         as user_id                -- 用户id
      ,a1.ord_id         as order_id               -- 订单id
      ,a1.cur_pay_mth    as zffs                   -- 当前支付方式
      ,a1.lst_pay_mth    as last_zffs              -- 上次支付方式
      ,a1.core           as core                   -- core
      ,a1.mt             as mt                     -- 移动终端
      ,a1.shopitem       as shop_item              -- 充值类型名称
      ,a1.cstm_data      as custom_data            -- 自定义数据
      ,a1.sub_statu_cd   as subscribe_status       -- 订阅状态编码
      ,a1.reg_ctry_cd    as reg_country            -- 注册国家编码
      ,a1.usr_type_name  as user_type              -- 用户类型名称
      ,a1.lang_cd        as current_language2      -- 投放语言
      ,a1.lang_name      as current_language2_name -- 投放语言名称
      ,a2.cur_zffs_list  as zffs_list              -- 本次支付方式列表
      ,a2.next_zffs_list as next_zffs_list         -- 下次支付方式列表
      ,now()             as etl_tm                 -- etl时间
from (
      select /*+ broadcast(c2, c3, c4) */
            c1.dt                as dt
           ,c1.usr_id
           ,c1.ord_id
           ,c1.cur_pay_mth
           ,c1.lst_pay_mth
           ,c2.corever2          as core
           ,c5.cd_val_desc       as mt
           ,c1.cstm_data
           ,c1.sub_statu_cd
           ,c2.reg_country       as reg_ctry_cd
           ,c3.user_type         as usr_type_name
           ,c3.current_language2 as lang_cd
           ,c4.cd_val_desc       as lang_name
           ,c1.createtime
           ,c1.shopitem
      from tmp_order                                                 as c1
           left join dim.dim_short_video_user_accountinfo            as c2
                  on c1.usr_id = c2.user_id
           left join dws.dws_user_short_video_wide_active_period_ed  as c3
                  on c3.dt = '${bf_1_dt}' 
                 and c3.period_type = "ctt"
                 and c3.product_id = 6833 
                 and c1.usr_id = c3.user_id
           left join dim.dim_pub_code_mapping_dict                   as c4
                  on c4.app_plat = "pub" 
                 and c4.cd_col = "lang_cd" 
                 and c3.current_language2 = c4.cd_val
           left join dim.dim_pub_code_mapping_dict                   as c5
                  on c5.app_plat = "pub" 
                 and c5.cd_col = 'mt' 
                 and c1.mt = c5.cd_val
     where c1.dt = '${bf_1_dt}'
     )              as a1
     left join (select  b1.userid
                       ,b1.orderid
                       ,max_by(b2.zffs_list_filter, IF(b2.event_tm <= b1.createtime, b2.event_tm, NULL)) as cur_zffs_list
                       ,min_by(b2.zffs_list_filter, IF(b2.event_tm > b1.createtime, b2.event_tm, NULL))  as next_zffs_list
                from ods.ods_tidb_short_video_payorder                                                   as b1
                left join tmp_recharge_exposure                                                          as b2
                on b1.userid = b2.usr_id
                where b1.dt = '${bf_1_dt}'
                and b1.TestFlag = 0
                and b1.ProdId = 6833
                group by b1.userid, b1.orderid
               )    as a2
     on a1.usr_id = a2.userid
     and a1.ord_id = a2.orderid
;