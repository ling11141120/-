insert into dws.dws_consume_short_video_consume_a
select dt
     , product_id
     , user_id
     , sum(consume_amt_td)               as consume_amt_td
     , min(fst_consume_tm)               as fst_consume_tm
     , max(lst_consume_tm)               as lst_consume_tm
     , sum(consume_cnt_td)               as consume_cnt_td
     , bitmap_union(consume_tv_td)       as consume_tv_td
     , sum(consume_money_amt_td)         as consume_money_amt_td
     , min(fst_consume_money_tm)         as fst_consume_money_tm
     , max(lst_consume_money_tm)         as lst_consume_money_tm
     , sum(consume_money_cnt_td)         as consume_money_cnt_td
     , bitmap_union(consume_money_tv_td) as consume_money_tv_td
     , sum(consume_cert_amt_td)          as consume_cert_amt_td
     , min(fst_consume_cert_tm)          as fst_consume_cert_tm
     , max(lst_consume_cert_tm)          as lst_consume_cert_tm
     , sum(consume_cert_cnt_td)          as consume_cert_cnt_td
     , bitmap_union(consume_cert_tv_td)  as consume_cert_tv_td
     , now()                             as etl_time
  from (select '${bf_1_dt}' as dt
             , product_id
             , user_id
             , consume_amt_td
             , fst_consume_tm
             , lst_consume_tm
             , consume_cnt_td
             , consume_tv_td
             , consume_money_amt_td
             , fst_consume_money_tm
             , lst_consume_money_tm
             , consume_money_cnt_td
             , consume_money_tv_td
             , consume_cert_amt_td
             , fst_consume_cert_tm
             , lst_consume_cert_tm
             , consume_cert_cnt_td
             , consume_cert_tv_td
          from dws.dws_consume_short_video_consume_a
         where dt = '${bf_2_dt}'
         union all
       -- 每日
        select dt
             , product_id
             , user_id
             , consume_amt_td
             , fst_consume_tm
             , lst_consume_tm
             , consume_cnt_td
             , consume_tv_td
             , consume_money_amt_td
             , fst_consume_money_tm
             , lst_consume_money_tm
             , consume_money_cnt_td
             , consume_money_tv_td
             , consume_cert_amt_td
             , fst_consume_cert_tm
             , lst_consume_cert_tm
             , consume_cert_cnt_td
             , consume_cert_tv_td
          from (select dt
                     , 6833                                                                             as product_id
                     , user_id
                     , sum(consume_value)                                                               as consume_amt_td
                     , min(create_time)                                                                 as fst_consume_tm
                     , max(create_time)                                                                 as lst_consume_tm
                     , count(distinct id)                                                               as consume_cnt_td
                     , bitmap_union(to_bitmap(concat(series_id, epis_num)))                             as consume_tv_td
                     -- 代币
                     , sum(if(consume_type = 0, consume_value, 0))                                      as consume_money_amt_td
                     , if(min(if(consume_type = 0, create_time, '9999-12-31')) < '9999-12-31',
                          min(if(consume_type = 0, create_time, '9999-12-31')),
                          null)                                                                         as fst_consume_money_tm
                     , if(max(if(consume_type = 0, create_time, '0000-01-01')) > '0000-01-01',
                          max(if(consume_type = 0, create_time, '0000-01-01')),
                          null)                                                                         as lst_consume_money_tm
                     , count(distinct if(consume_type = 0, id, null))                                   as consume_money_cnt_td
                     , bitmap_union(if(consume_type = 0, to_bitmap(concat(series_id, epis_num)), null)) as consume_money_tv_td
                     -- 赠币
                     , sum(if(consume_type = 1, consume_value, 0))                                      as consume_cert_amt_td
                     , if(min(if(consume_type = 1, create_time, '9999-12-31')) < '9999-12-31',
                          min(if(consume_type = 1, create_time, '9999-12-31')),
                          null)                                                                         as fst_consume_cert_tm
                     , if(max(if(consume_type = 1, create_time, '0000-01-01')) > '0000-01-01',
                          max(if(consume_type = 1, create_time, '0000-01-01')),
                          null)                                                                         as lst_consume_cert_tm
                     , count(distinct if(consume_type = 1, id, null))                                   as consume_cert_cnt_td
                     , bitmap_union(if(consume_type = 1, to_bitmap(concat(series_id, epis_num)), null)) as consume_cert_tv_td
                  from (select a.dt
                             , a.id
                             , 6833         as product_id
                             , a.account_id as user_id
                             , a.epis_id
                             , b.series_id
                             , a.epis_num
                             , a.consume_type
                             , a.consume_value
                             , a.create_time
                          from dwd.dwd_sv_consume_user_consume_bill_pdi a
                          left join dim.dim_short_video_epis_view       b
                          on a.epis_id = b.epis_id
                         where dt = '${bf_1_dt}' and a.epis_id != 0 and b.series_id is not null
                        ) c
                 group by 1, 2, 3
                ) t1
        ) t2
 group by 1, 2, 3;