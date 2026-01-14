create or replace view dws.dws_consume_short_video_consume_a_view (
     dt                      comment "分区日期"
    ,user_id                 comment "用户id"
    ,consume_money_amt_td    comment "累计消耗代币数"
    ,consume_tv_td           comment "消费剧集bitmap(剧id+集序号)"
)
comment "用户域-用户消耗累计指标"
as
select acc.dt                      as dt
     , acc.user_id                 as user_id
     , acc.consume_money_amt_td    as consume_money_amt_td
     , stat.consume_tv_td          as consume_tv_td
  from dws.dws_user_sv_accumulate_idx_his_15df     as acc
  left join dws.dws_user_sv_status_idx_his_15df    as stat
    on acc.dt = stat.dt
   and acc.user_id = stat.user_id
;