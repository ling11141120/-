----------------------------------------------------------------
-- 程序功能： 海外短剧-用户最新订单表
-- 程序名： P_dim_sv_user_latest_ord
-- 目标表： dim.dim_sv_user_latest_ord
-- 负责人： roger
-- 开发日期：2025/11/19
-- 版本号： v1.0
----------------------------------------------------------------

-- 每日脚本
insert into dim.dim_sv_user_latest_ord
select '${bf_1_dt}'  as dt              -- 日期
       ,user_id      as dt              -- 用户id
       ,order_id     as user_id         -- 订单id
       ,pay_method   as order_id        -- 支付方式
       ,crt_tm       as pay_method      -- 创建时间
       ,etl_tm       as crt_tm          -- etl时间
from (select user_id
             ,order_id
             ,pay_method
             ,crt_tm
             ,etl_tm
             ,row_number() over (partition by user_id order by crt_tm desc) as rn
        from (select user_id
                    ,order_id
                    ,pay_method
                    ,crt_tm
                    ,etl_tm
                from dim.dim_sv_user_latest_ord
                where dt = '${bf_2_dt}'
                union all
                select userid
                     ,orderid
                     ,SubPayType
                     ,createtime
                     ,now() as etl_tm
                from ods.ods_tidb_short_video_payorder
                where dt = '${bf_1_dt}'
                  and TestFlag = 0
                  and ProdId = 6833
              ) b
      ) a
where a.rn = 1 and a.user_id is not null
;
