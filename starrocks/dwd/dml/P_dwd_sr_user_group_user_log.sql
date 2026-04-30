----------------------------------------------------------------
-- 程序功能： 海阅-人群包出入包归因记录（2026-4-29下线）
-- 程序名： P_dwd_sr_user_group_user_log
-- 目标表： dwd.dwd_sr_user_group_user_log
-- 负责人： qhr
-- 开发日期：2026-4-29
----------------------------------------------------------------

insert into dwd.dwd_sr_user_group_user_log
  with group_user_log as (select product_id
                               , group_id
                               , user_id
                               , create_time
                               , op_type
                               , lag(op_type, 1, 3)
                                     over (partition by group_id, user_id order by create_time, start_time, op_type) as lag_op_type
                            from (select product_id
                                       , group_id
                                       , user_id
                                       , start_time
                                       , create_time
                                       , op_type
                                    from dwd.dwd_market_realtimegrouplog_view
                                   where dt = '${bf_1_dt}'
                                   union all
                                  select product_id
                                       , group_id
                                       , user_id
                                       , start_time
                                       , start_time
                                       , 0
                                    from dwd.dwd_sr_user_group_user_log
                                   where end_time = '2099-12-31'
                                  ) t1
      )
     , b as (select product_id
                  , group_id
                  , user_id
                  , create_time
                  , op_type
                  , row_number() over (partition by group_id, user_id, op_type order by create_time) as rn
               from group_user_log
              where op_type != lag_op_type
      )
select l1.product_id
     , l1.group_id
     , l1.user_id
     , l1.create_time                       as start_time
     , ifnull(l2.create_time, '2099-12-31') as end_time
     , now()                                as etl_tm
  from (select *
          from b
         where op_type = 0
        )      l1
  left join (select *
               from b
              where op_type = 3
             ) l2
  on l1.product_id = l2.product_id and l1.group_id = l2.group_id and l1.user_id = l2.user_id and l1.rn = l2.rn;