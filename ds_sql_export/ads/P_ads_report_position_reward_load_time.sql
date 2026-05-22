----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_position_reward_load_time
-- workflow_version : 9
-- create_user      : yanxh
-- task_name        : ads_report_position_reward_load_time
-- task_version     : 9
-- update_time      : 2024-04-02 16:58:35
-- sql_path         : \starrocks\tbl_ads_report_position_reward_load_time\ads_report_position_reward_load_time
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_report_position_reward_load_time  where  dt ='${bf_1_dt}';

-- SQL语句
-- 根据 DAS-189 号需求（广告时长统计的位置ID落表） 做以下调整
-- 在 7.2.6 版本及以后，明细表 dwd_readerlog_commonactionlog_view 新增了位置ID信息，存储在字段 f1 上
-- 所以这里新的取值逻辑为，位置ID != 0 则取新的位置ID，否则按之前的逻辑关联维度取值
insert into ads.ads_report_position_reward_load_time
with ld as
         ( -- -------广告上报加载时长的数据--------------------------
             select product_id,
                    dt,
                    S0,
                    S1,
                    corever,
                    mt,
                    app_ver,
                    positions,
                    avg(F0)     avg_num,
                    count(1) as counts
             from (
                      select product_id,
                             dt,
                             a.S0,
                             a.S1,
                             substring(a.appid, 6, 1)                                  as corever,
                             a.mt,
                             a.f0,
                             ntile(100) over (partition by a.product_id ORDER BY a.f0) AS rn,
                             a.f1                                                      as positions,
                             a.appver                                                  as app_ver
                      from dwd.dwd_readerlog_commonactionlog_view a
                      where a.dt = '${bf_1_dt}'
                        and product_id in (3311, 3322, 3333, 3366, 3371, 3388, 3501, 3511)
                        and a.action = 'rewardAdLoadTime'
                  ) a
             where rn < 96
             group by 1, 2, 3, 4, 5, 6, 7, 8
         ),
     -- ----------------先匹配状态为开启的数据-------------------------
     s1 as (
         select ld.dt,
                ld.product_id,
                ld.S0 as adid,
                ld.S1 as app_position,
                ld.corever,
                ld.mt,
                ld.app_ver,
                ld.avg_num,
                ld.counts,
                if (ld.positions != 0, ld.positions, y.positions) as positions,
                y.ad_plat_form,
                1     as types
         from ld
                  inner join
              (select product_id, unit_adid, ad_plat_form, min(ad_position) positions
               from dim.dim_app_adplatform_unit_id_info
               where ad_position in (5, 18, 19, 21, 22, 23, 26, 29, 44)
                 and status = 1
               group by 1, 2, 3) y
              on ld.s0 = y.unit_adid and ld.product_id = y.product_id
     ),
     -- --------- 剩下的再匹配状态为关闭的数据----------------------------
     s0 as (
         select ld.dt,
                ld.product_id,
                ld.S0 as adid,
                ld.S1 as app_position,
                ld.corever,
                ld.mt,
                ld.app_ver,
                ld.avg_num,
                ld.counts,
                if (ld.positions != 0, ld.positions, y.positions) as positions,
                y.ad_plat_form,
                1     as types
         from ld
                  inner join
              (select product_id, unit_adid, ad_plat_form, min(ad_position) positions
               from dim.dim_app_adplatform_unit_id_info
               where ad_position in (5, 18, 19, 21, 22, 23, 26, 29, 44)
                 and status = 0
               group by 1, 2, 3) y
              on ld.s0 = y.unit_adid and ld.product_id = y.product_id
         where ld.s0 not in (select distinct adid from s1) -- 条件：排除掉已经匹配状态为开启的数据
     )
select dt,
       product_id,
       adid,
       app_position,
       corever,
       mt,
       app_ver,
       avg_num,
       counts,
       positions,
       1     as type,
       now() as etl_time,
       ad_plat_form
from s1
union all
select dt,
       product_id,
       adid,
       app_position,
       corever,
       mt,
       app_ver,
       avg_num,
       counts,
       positions,
       1     as type,
       now() as etl_time,
       ad_plat_form
from s0;
