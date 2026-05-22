----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_abtest_user_operation_accumulation_stat_di
-- workflow_version : 1
-- create_user      : xixg
-- task_name        : dws_abtest_user_operation_accumulation_stat_di
-- task_version     : 1
-- update_time      : 2024-05-24 19:28:42
-- sql_path         : \starrocks\tbl_dws_abtest_user_operation_accumulation_stat_di\dws_abtest_user_operation_accumulation_stat_di
----------------------------------------------------------------
-- SQL语句
INSERT INTO dws.dws_abtest_user_operation_accumulation_stat_di
-- 阅读
with read_tmp AS (
    SELECT
        exp_grp.dt,
        exp_grp.project_id, -- 项目ID
        exp_grp.exp_id, -- 实验ID
        exp_grp.exp_grp_id, -- 实验组ID
        MAX(exp_grp.exp_name) as exp_name, -- 实验名称
        MAX(exp_grp.exp_grp_type) AS exp_grp_type, -- 实验组类型
        MAX(exp_grp.exp_grp_name) AS exp_grp_name, -- 实验组名称
        MAX(traffic.traffic_allocation) AS traffic_allocation, -- 流量占比
        SUM(IF(trade.recharge_times IS NULL,0 ,trade.recharge_times)) AS recharge_times, -- 充值次数
        SUM(IF(trade.recharge_amount IS NULL,0 ,trade.recharge_amount)) AS ifd_oper_recharge_amount, -- 充值金额（交易域中分成前的充值金额）
        SUM(IF(consume.consume_award IS NULL,0 ,consume.consume_award)) AS ifd_oper_money_consume, -- 充值消费
        SUM(IF(consume.consume_amount IS NULL,0 ,consume.consume_amount)) AS ifd_oper_total_consume -- 总消费
    FROM (
             SELECT
                 DATE_FORMAT (dt_hour, '%Y-%m-%d') AS dt,
                 project_id,
                 exp_id,
                 exp_grp_id,
                 user_id,
                 exp_grp_type,
                 MAX(exp_name) AS exp_name,
                 MAX(exp_grp_name) AS exp_grp_name
             FROM dwd.dwd_abtest_user_operation_p_hi
             WHERE dt_hour >= '${dt}'
               AND dt_hour < '${af_1_dt}'
           AND project_id = 1
         GROUP BY 1,2,3,4,5,6
     )exp_grp
LEFT JOIN(
            SELECT
                    dt,
                    userid AS user_id,
                    chargeitemcount AS recharge_amount, -- 充值的金额（取分成前充值金额）
                    chargecount  AS recharge_times -- 充值次数
             FROM dws.dws_trade_user_shopitem_charge_ed
             WHERE dt = '${dt}'
         )trade
 ON  exp_grp.dt = trade.dt
AND  exp_grp.user_id = trade.user_id
LEFT JOIN(
            SELECT
                    dt,
                    user_id,
                    -- 阅读消费类型types的值说明 1：阅币，2：礼券,3：赠送币,4:vip
                    SUM(IF(types = 1 OR types = 2 OR types = 3, CAST(con_chp_amount AS INT), 0)) AS consume_amount, -- 消费总书币（赠送+充值）
                    SUM(IF(types = 1, CAST(con_chp_amount AS INT), 0)) AS consume_award -- 消费总礼券（充值）
             FROM dwm.dwm_consume_user_consume_mild_ed
            WHERE dt = '${dt}'
              AND types IN(1, 2, 3)
              AND book_id > 0
           GROUP BY 1,2
        )consume
 ON  exp_grp.dt = consume.dt
 AND exp_grp.user_id = consume.user_id
LEFT JOIN (
            SELECT
                dt,
                project_id,
                exp_id,
                exp_grp_id,
                traffic_allocation
            FROM (
                     SELECT
                         DATE_FORMAT (dt_hour, '%Y-%m-%d') AS dt,
                         project_id,
                         exp_id,
                         exp_grp_id,
                         traffic_allocation,
                         ROW_NUMBER() OVER(PARTITION BY project_id,exp_id,exp_grp_id ORDER BY exp_update_time DESC) AS rn -- 流量比例分配可能会修改，要到最新的值
                     FROM dwd.dwd_abtest_user_operation_p_hi
                     WHERE dt_hour >= '${dt}'
                       AND dt_hour < '${af_1_dt}'
                      AND project_id = 1
                ) tmp
          WHERE tmp.rn = 1
        )traffic
ON  exp_grp.project_id = traffic.project_id
AND  exp_grp.exp_id = traffic.exp_id
AND  exp_grp.exp_grp_id = traffic.exp_grp_id
GROUP BY 1,2,3,4
),

-- 海剧
overseas_shorvideo_tmp AS (
SELECT
        exp_grp.dt,
        exp_grp.project_id, -- 项目ID
        exp_grp.exp_id, -- 实验ID
        exp_grp.exp_grp_id, -- 实验组ID
        MAX(exp_grp.exp_name) as exp_name, -- 实验名称
        MAX(exp_grp.exp_grp_type) AS exp_grp_type, -- 实验组类型
        MAX(exp_grp.exp_grp_name) AS exp_grp_name, -- 实验组名称
        MAX(traffic.traffic_allocation) AS traffic_allocation, -- 流量占比
        SUM(IF(trade.recharge_times IS NULL,0 ,trade.recharge_times)) AS recharge_times, -- 充值次数
        SUM(IF(trade.recharge_amount IS NULL,0 ,trade.recharge_amount)) ifd_oper_recharge_amount, -- 充值金额
        SUM(IF(consume.consume_award IS NULL,0 ,consume.consume_award)) AS ifd_oper_money_consume, -- 充值消费
        SUM(IF(consume.consume_amount IS NULL,0 ,consume.consume_amount)) AS ifd_oper_total_consume -- 总消费
FROM (
         SELECT
                 DATE_FORMAT (dt_hour, '%Y-%m-%d') AS dt,
                 project_id,
                 exp_id,
                 exp_grp_id,
                 user_id,
                 exp_grp_type,
                 MAX(exp_name) AS exp_name,
                 MAX(exp_grp_name) AS exp_grp_name
           FROM dwd.dwd_abtest_user_operation_p_hi
          WHERE dt_hour >= '${dt}'
            AND dt_hour < '${af_1_dt}'
            AND project_id = 3
          GROUP BY 1,2,3,4,5,6
     )exp_grp
LEFT JOIN(
            SELECT
                    dt,
                    user_id,
                    SUM(base_amount) AS recharge_amount,  -- 充值金额
                    COUNT(1) AS recharge_times  -- 充值次数
            FROM ads.ads_trade_sharpenginepaycenter_payorder_view
            WHERE dt = '${dt}'
              AND product_id = '6833'  -- 过滤短剧项目
              AND order_status = 1
              AND test_flag = 0
            GROUP BY 1,2
        )trade
 ON exp_grp.dt = trade.dt
AND exp_grp.user_id = trade.user_id
LEFT JOIN(
            SELECT
                dt,
                user_id,
                -- 短剧消耗类型type值说明： 0货币,1赠币
                SUM(consume_amt) consume_amount, -- 消费总书币（赠送+充值）
                SUM(CASE WHEN types = 0 THEN consume_amt ELSE 0 END) AS consume_award -- 消费总礼券（充值）
            FROM dws.dws_consume_short_video_consume_ed
            WHERE dt = '${dt}'
            GROUP BY 1,2
        )consume
 ON exp_grp.dt = consume.dt
AND exp_grp.user_id = consume.user_id
LEFT JOIN (
            SELECT
                dt,
                project_id,
                exp_id,
                exp_grp_id,
                traffic_allocation
            FROM (
                     SELECT
                         DATE_FORMAT (dt_hour, '%Y-%m-%d') AS dt,
                         project_id,
                         exp_id,
                         exp_grp_id,
                         traffic_allocation,
                         ROW_NUMBER() OVER(PARTITION BY project_id,exp_id,exp_grp_id ORDER BY exp_update_time DESC) AS rn -- 流量比例分配可能会修改，要到最新的值
                     FROM dwd.dwd_abtest_user_operation_p_hi
                     WHERE dt_hour >= '${dt}'
                       AND dt_hour < '${af_1_dt}'
                      AND project_id = 3
                ) tmp
          WHERE tmp.rn = 1
        )traffic
ON  exp_grp.project_id = traffic.project_id
AND  exp_grp.exp_id = traffic.exp_id
AND  exp_grp.exp_grp_id = traffic.exp_grp_id
GROUP BY 1,2,3,4)

SELECT
        dt,
        project_id, -- 项目ID
        exp_id, -- 实验ID
        exp_grp_id, -- 实验组ID
        exp_name, -- 实验名称
        exp_grp_type, -- 实验组类型
        exp_grp_name, -- 实验组名称
        traffic_allocation, -- 流量占比
        recharge_times, --充值次数
        ifd_oper_recharge_amount, -- 充值金额
        ifd_oper_money_consume, -- 充值消费
        ifd_oper_total_consume, -- 总消费
        NOW()
FROM read_tmp
UNION ALL
SELECT
        dt,
        project_id, -- 项目ID
        exp_id, -- 实验ID
        exp_grp_id, -- 实验组ID
        exp_name, -- 实验名称
        exp_grp_type, -- 实验组类型
        exp_grp_name, -- 实验组名称
        traffic_allocation, -- 流量占比
        recharge_times, --充值次数
        ifd_oper_recharge_amount, -- 充值金额
        ifd_oper_money_consume, -- 充值消费
        ifd_oper_total_consume, -- 总消费
        NOW()
FROM overseas_shorvideo_tmp;
