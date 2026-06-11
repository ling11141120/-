select a.dt                 as create_date
     , a.DAU
     , a.new_num            as `新增用户数`
     , b.charge_num         as `充值人数`
     , b.charge_money       as `充值金额`
     , b.fisrt_charge_num   as `首充用户数`
     , b.fisrt_charge_money as `新增付费用户充值总额`
  from (select dt
             , count(distinct user_id)                                        as DAU
             , count(distinct case when dt = date(reg_time) then user_id end) as new_num
          from dws.dws_user_short_video_wide_active_ed a
         where dt >= "${开始时间}"
           and dt <= "${结束时间}"
           and product_id = 6833
           and a.mt in (${mt})
           and 1 = 1
           ${if(len(corever) == 0,"","and a.corever IN ( '" + corever + "')")}
           ${if(len(country) == 0,"","and a.reg_country IN ( '" + country + "')")}
           ${if(len(current_language2) == 0,"","and a.current_language2 IN ( '" + current_language2 + "')")}
           ${if(len(current_language) == 0,"","and a.current_language IN ( '" + current_language + "')")}
         group by 1
       ) a
  left join (select dt
                  , count(distinct user_id)                                          as charge_num
                  , round(sum(charge_money), 2)                                      as charge_money
                  , count(distinct case when dt = First_charge_day then user_id end) as fisrt_charge_num
                  , sum(case when dt = First_charge_day then charge_money end)       as fisrt_charge_money
               from dws.dws_trade_short_viedo_payorder_ed a
              where dt >= "${开始时间}"
                and dt <= "${结束时间}"
                and a.mt in (${mt})
                and 1 = 1
                ${if(len(corever) == 0,"","and a.corever IN ( '" + corever + "')")}
                ${if(len(country) == 0,"","and a.reg_country IN ( '" + country + "')")}
                ${if(len(current_language2) == 0,"","and a.current_language2 IN ( '" + current_language2 + "')")}
                ${if(len(current_language) == 0,"","and a.current_language IN ( '" + current_language + "')")}
              group by 1
   )      b
  on a.dt = b.dt
 order by 1 desc
;