insert into dws.dws_trade_short_video_subscribe_payorder_a
with first as
         (   select  product_id,user_id,
                     max(if(types = 0,item_count,null)) as first_recharge_amt,
                     max(if(types = 1,item_count,null)) as first_subscribe_amt,
                     max(if(types = 0,create_time,null)) as first_recharge_tm,
                     max(if(types = 1,create_time,null)) as first_subscribe_tm,
                     max(if(types = 1,shop_item,null)) as first_subscribe_tp
             from
                 (   select  dt,product_id,user_id,types,item_count,create_time,shop_item,
                             row_number() over (partition by types,product_id,user_id order by create_time,id) as rn
                     from
                     (   select dt,product_id,user_id,0 as types,item_count,create_time,shop_item,id
                         from dwd.dwd_trade_short_video_payorder
                         where dt <= '${bf_1_dt}' and product_id = 6833 and status = 0 and test_flag = 0
                         union all
                         select dt,product_id,user_id,1 as types,item_count,create_time,shop_item,id
                         from dwd.dwd_trade_short_video_payorder
                         where dt <= '${bf_1_dt}' and product_id = 6833 and status = 0 and shop_item in (810,840) and test_flag = 0
                         ) a
                     ) a
             where rn = 1
             group by 1,2
         ),
     last as
         (   select  product_id,user_id,
                     max(if(types = 0,item_count,null)) as last_recharge_amt,
                     max(if(types = 1,item_count,null)) as last_subscribe_amt,
                     max(if(types = 0,create_time,null)) as last_recharge_tm,
                     max(if(types = 1,create_time,null)) as last_subscribe_tm,
                     max(if(types = 1,shop_item,null)) as last_subscribe_tp
             from
                 (   select  dt,product_id,user_id,types,item_count,create_time,shop_item,
                             row_number() over (partition by types,product_id,user_id order by create_time desc,id desc) as rn
                     from
                         (   select dt,product_id,user_id,0 as types,item_count,create_time,shop_item,id
                             from dwd.dwd_trade_short_video_payorder
                             where dt <= '${bf_1_dt}' and product_id = 6833 and status = 0 and test_flag = 0
                             union all
                             select dt,product_id,user_id,1 as types,item_count,create_time,shop_item,id
                             from dwd.dwd_trade_short_video_payorder
                             where dt <= '${bf_1_dt}' and product_id = 6833 and status = 0 and shop_item in (810,840) and test_flag = 0
                         ) a
                 ) a
             where rn = 1
             group by 1,2
         ),
     agg as
         (   select  product_id,user_id,
                     sum(if( status = 0 and shop_item in (810,840),item_count,null)) as total_subscribe_amt,
                     sum(if( status = 0 and shop_item in (810,840) and item_count > 0,1,0)) as total_subscribe_cnt,
                     sum(if( status = 1 and shop_item in (810,840) and item_count < 0,1,0)) as total_subscribe_refund_cnt,
                     bitmap_union(to_bitmap(if( status = 0 and shop_item in (810,840) and item_count > 0,shop_item,null))) as subscribe_tp_bitmap,
                     sum(if(status = 0,item_count,null)) as total_recharge_amt,
                     sum(if(status = 1 and item_count < 0,abs(item_count),null)) as total_refund_amt,
                     sum(if( status = 0 and item_count > 0,1,0)) as total_recharge_cnt,
                     sum(if( status = 1 and item_count < 0,1,0)) as total_refund_cnt,
                     avg(if(status = 0,item_count,null)) as recharge_avg,
                     max(if(status = 0,item_count,null)) as recharge_max,
                     max(if( status = 0 and dt >= date_sub('${bf_1_dt}',interval 30 day),item_count,null)) as month_recharge_max
             from dwd.dwd_trade_short_video_payorder
             where dt <= '${bf_1_dt}' and product_id = 6833 and test_flag = 0
             group by 1,2
             ),
     mode as
         (   select product_id,user_id,item_count as charge_mode ,create_time as  charge_mode_lst_time
             from
                 (   select  product_id,user_id,item_count,num,create_time,
                             row_number() over (partition by product_id,user_id order by num desc,create_time desc) as rn
                     from
                         (   select product_id,user_id,item_count,count(1) as num,max(create_time) as create_time
                             from dwd.dwd_trade_short_video_payorder
                             where dt <= '${bf_1_dt}' and product_id = 6833 and status = 0 and test_flag = 0
                             group by 1,2,3
                         ) a
                 ) a
             where rn = 1
         )
select  '${bf_1_dt}' as dt,
        first.product_id,
        first.user_id,
        agg.total_subscribe_amt,
        first.first_subscribe_amt,
        first.first_subscribe_tp,
        first.first_subscribe_tm,
        last.last_subscribe_amt,
        last.last_subscribe_tp,
        last.last_subscribe_tm,
        agg.total_subscribe_cnt,
        agg.total_subscribe_refund_cnt,
        if(bitmap_count(agg.subscribe_tp_bitmap) > 1,1,0) as is_mul_subscribe,
        if(agg.total_subscribe_cnt >= 1,1,0) as has_subscribe,
        first.first_recharge_amt,
        first.first_recharge_tm,
        agg.total_recharge_amt,
        agg.total_refund_amt,
        agg.total_recharge_cnt,
        agg.total_refund_cnt,
        agg.recharge_avg,
        agg.recharge_max,
        agg.month_recharge_max,
        last.last_recharge_amt,
        last.last_recharge_tm,
        mode.charge_mode,
        now() as etl_time
from first
         left join last
                   on first.product_id = last.product_id and first.user_id = last.user_id
         left join agg
                   on first.product_id = agg.product_id and first.user_id = agg.user_id
         left join mode
                   on first.product_id = mode.product_id and first.user_id = mode.user_id;