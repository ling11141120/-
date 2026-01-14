create or replace view ads.ads_wide_short_video_user_info_a_view (
     dt                            comment "统计日期"
    ,user_id                       comment "用户id"
    ,sex                           comment "性别"
    ,reg_tm                        comment "用户的注册时间"
    ,mt                            comment "平台 0未知 1iphone 4安卓 9书城"
    ,mt2                           comment "注册时平台 0未知 1iphone 4安卓 9书城"
    ,corever                       comment "当前core"
    ,corever2                      comment "注册时core"
    ,app_ver                       comment "app版本"
    ,ver                           comment "客户端版本号"
    ,current_language              comment "用户当前语言"
    ,current_language2             comment "注册时语言"
    ,reg_country                   comment "注册时国家，不会变化"
    ,is_bound_email                comment "是否绑定邮箱 1:是 0：否"
    ,fst_login_tm                  comment "首次登录时间"
    ,lst_login_tm                  comment "上一次登录时间"
    ,new_login_tm                  comment "最新登录时间"
    ,login_days_td                 comment "累计登录天数"
    ,login_cnt_td                  comment "累计登录次数"
    ,remain_day                    comment "登录留存天数"
    ,consume_amt_td                comment "累计消耗(代币、赠币)"
    ,fst_consume_tm                comment "首次消费时间"
    ,lst_consume_tm                comment "最近一次消费时间"
    ,consume_cnt_td                comment "累积消费次数"
    ,consume_tv_td                 comment "消费剧集bitmap(剧id+集序号)"
    ,consume_money_amt_td          comment "累计消耗代币数"
    ,fst_consume_money_tm          comment "首次消费代币时间"
    ,lst_consume_money_tm          comment "最近一次消费代币时间"
    ,consume_money_cnt_td          comment "累积消费代币次数"
    ,consume_money_tv_td           comment "代币消费剧集bitmap(剧id+集序号)"
    ,consume_cert_amt_td           comment "累计消耗赠币"
    ,fst_consume_cert_tm           comment "首次消费赠币时间"
    ,lst_consume_cert_tm           comment "最近一次消费赠币时间"
    ,consume_cert_cnt_td           comment "累积消费赠币次数"
    ,consume_cert_tv_td            comment "赠币消费剧集bitmap(剧id+集序号)"
    ,fst_watch_tm                  comment "首次观看时间"
    ,lst_watch_tm                  comment "末次观看时间"
    ,watch_series_td               comment "累计观看剧的bitmap"
    ,watch_tv_td                   comment "累计观看剧集bitmap(剧id+集序号)"
    ,watch_days_td                 comment "累计观看天数"
    ,watch_cnt_td                  comment "累计观看次数(需要除以2再向上取整)"
    ,new_epis_series_td            comment "观看到了最新剧集的剧集"
    ,total_subscribe_amt           comment "累计订阅金额（不考虑退款因素）"
    ,first_subscribe_amt           comment "首次订阅金额"
    ,first_subscribe_tp            comment "首次订阅类型"
    ,first_subscribe_tm            comment "首次订阅时间"
    ,last_subscribe_amt            comment "最后订阅金额"
    ,last_subscribe_tp             comment "最后订阅类型"
    ,last_subscribe_tm             comment "最后订阅时间"
    ,total_subscribe_cnt           comment "累计订阅次数（不考虑退款因素）"
    ,total_subscribe_refund_cnt    comment "累计退订次数"
    ,is_mul_subscribe              comment "有无多项订阅"
    ,has_subscribe                 comment "历史有无订阅"
    ,first_recharge_amt            comment "首次充值金额"
    ,first_recharge_tm             comment "首次充值时间"
    ,total_recharge_amt            comment "累计充值金额"
    ,total_refund_amt              comment "累计退款金额"
    ,total_recharge_cnt            comment "累计充值次数"
    ,total_refund_cnt              comment "累计退款次数"
    ,recharge_avg                  comment "平均充值金额"
    ,recharge_max                  comment "最大充值金额"
    ,month_recharge_max            comment "近一个月最大充值金额"
    ,last_recharge_amt             comment "最后充值金额"
    ,last_recharge_tm              comment "最近充值时间"
    ,charge_mode                   comment "充值众数（不考虑退款因素）"
    ,fst_like_tm                   comment "首次点赞时间"
    ,lst_like_tm                   comment "末次点赞时间"
    ,like_series_td                comment "累计点赞剧的bitmap"
    ,like_epis_td                  comment "累计点赞剧集bitmap(剧id+集序号)"
    ,like_cnt_td                   comment "累计点赞次数"
    ,fst_install_book_id           comment "首次引流书籍"
    ,lst_install_book_id           comment "最新引流书籍"
    ,lst_source                    comment "最新媒体值"
    ,lst_install_date              comment "最新激活时间"
)
comment "海剧用户累计指标"
as
select acc.dt
     , acc.user_id
     , uinfo.sex
     , uinfo.create_time                                     as reg_tm
     , uinfo.mt
     , uinfo.mt2
     , uinfo.corever
     , uinfo.corever2
     , uinfo.app_ver
     , uinfo.ver
     , uinfo.current_language
     , uinfo.current_language2
     , uinfo.reg_country
     , case when uinfo.email is not null then 1
            else 0
       end                                                   as is_bound_email
     , stat.fst_login_tm
     , stat.lst_login_tm
     , stat.new_login_tm
     , acc.login_days_td
     , acc.login_cnt_td
     , stat.remain_day
     , acc.consume_amt_td
     , stat.fst_consume_tm
     , stat.lst_consume_tm
     , acc.consume_cnt_td
     , acc.consume_tv_td
     , acc.consume_money_amt_td
     , stat.fst_consume_money_tm
     , stat.lst_consume_money_tm
     , acc.consume_money_cnt_td
     , acc.consume_money_tv_td
     , acc.consume_cert_amt_td
     , stat.fst_consume_cert_tm
     , stat.lst_consume_cert_tm
     , acc.consume_cert_cnt_td
     , acc.consume_cert_tv_td
     , stat.fst_watch_tm
     , stat.lst_watch_tm
     , acc.watch_series_td
     , acc.watch_tv_td
     , acc.watch_days_td
     , acc.watch_cnt_td
     , stat.new_epis_series_td
     , acc.total_subscribe_amt
     , stat.first_subscribe_amt
     , stat.first_subscribe_tp
     , stat.first_subscribe_tm
     , stat.last_subscribe_amt
     , stat.last_subscribe_tp
     , stat.last_subscribe_tm
     , acc.total_subscribe_cnt
     , acc.total_subscribe_refund_cnt
     , if(bitmap_count(acc.mul_subscribe_item) > 1, 1, 0)    as is_mul_subscribe
     , acc.has_subscribe
     , stat.first_recharge_amt
     , stat.first_recharge_tm
     , acc.total_recharge_amt
     , acc.total_refund_amt
     , acc.total_recharge_cnt
     , acc.total_refund_cnt
     , acc.recharge_avg
     , stat.recharge_max
     , stat.month_recharge_max
     , stat.last_recharge_amt
     , stat.last_recharge_tm
     , stat.charge_mode
     , stat.fst_like_tm
     , stat.lst_like_tm
     , acc.like_series_td
     , acc.like_epis_td
     , acc.like_cnt_td
     , stat.fst_install_book_id
     , stat.lst_install_book_id
     , stat.lst_source
     , stat.lst_install_date
  from dws.dws_user_sv_accumulate_idx_his_15df      as acc
  left join dws.dws_user_sv_status_idx_his_15df     as stat
    on acc.dt = stat.dt
   and acc.user_id = stat.user_id
  left join dim.dim_short_video_user_accountinfo    as uinfo
    on acc.user_id = uinfo.user_id
;