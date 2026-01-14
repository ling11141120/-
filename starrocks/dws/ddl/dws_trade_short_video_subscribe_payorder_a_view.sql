create or replace view dws.dws_trade_short_video_subscribe_payorder_a_view (
     dt                    comment "分区日期"
    ,user_id               comment "用户id"
    ,last_recharge_tm      comment "最近充值时间"
    ,first_recharge_amt    comment "首次充值金额"
    ,last_recharge_amt     comment "最后充值金额"
    ,recharge_max          comment "最大充值金额"
    ,charge_mode           comment "充值众数（不考虑退款因素）"
    ,month_recharge_max    comment "近一个月最大充值金额"
    ,total_recharge_amt    comment "累计充值金额"
    ,total_recharge_cnt    comment "累计充值次数"
    ,recharge_avg          comment "平均充值金额"
    ,total_refund_amt      comment "累计退款金额"
    ,total_refund_cnt      comment "累计退款次数"

)
comment "交易域-海剧用户订阅充值累计指标"
as
select acc.dt
     , acc.user_id
     , stat.last_recharge_tm
     , stat.first_recharge_amt
     , stat.last_recharge_amt
     , stat.recharge_max
     , stat.charge_mode
     , stat.month_recharge_max
     , acc.total_recharge_amt
     , acc.total_recharge_cnt
     , acc.recharge_avg
     , acc.total_refund_amt
     , acc.total_refund_cnt
  from dws.dws_user_sv_accumulate_idx_his_15df     as acc
  left join dws.dws_user_sv_status_idx_his_15df    as stat
    on acc.dt = stat.dt
   and acc.user_id = stat.user_id
;