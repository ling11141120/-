insert into dws.dws_advertisement_ad_position_play_data_ed_bak
with ex as (select dt
                  ,ad_position_id
                  ,count(1) as exposure_cnt
                  ,count(distinct user_id) as exposure_unt
              from dwd.dwd_flow_user_adposition_exposure
             where dt='${bf_1_dt}'
               and product_id is not null
               and product_id!=6833
             group by 1,2
)
,cl as (select dt
              ,d_position_id
              ,count(1) as click_cnt
              ,count(distinct user_id) as click_unt
          from   dwd.dwd_flow_user_adposition_click
         where  dt='${bf_1_dt}'
           and product_id is not null
           and product_id!=6833
         group by 1,2
)
,sh as (select dt
              ,d_position_id
              ,count(1) as show_cnt
              ,count(distinct user_id) as show_unt
          from   dwd.dwd_flow_user_adposition_adshow
         where  dt='${bf_1_dt}'
           and product_id is not null
           and product_id!=6833
         group by 1,2
)
,wt as (select dt
              ,d_position_id
              ,count(1) as watch_cnt
              ,count(distinct user_id) as watch_unt
          from   dwd.dwd_flow_user_adposition_adwatchsuccess
         where  dt='${bf_1_dt}'
           and product_id is not null
           and product_id!=6833
         group by 1,2
)
select ex.dt
      ,ex.ad_position_id
      ,ex.exposure_cnt
      ,ex.exposure_unt
      ,cl.click_cnt
      ,cl.click_unt
      ,sh.show_cnt
      ,sh.show_unt
      ,wt.watch_cnt
      ,wt.watch_unt
      ,now() as etl_tm
from ex
left join cl
  on ex.dt=cl.dt
 and ex.ad_position_id=cl.ad_position_id
left join sh
  on ex.dt=sh.dt
 and ex.ad_position_id=sh.ad_position_id
left join wt
  on ex.dt=wt.dt
 and ex.ad_position_id=wt.ad_position_id
where ex.ad_position_id !=0
;





insert into dws.dws_advertisement_ad_position_play_data_ed
with ex as (select dt
                  ,ad_position_id
                  ,product_id
                  ,if(corever is null or CoreVer=0,1,CoreVer)    as corever
                  ,count(1)                                      as exposure_cnt
                  ,count(distinct user_id)                       as exposure_unt
              from dwd.dwd_flow_user_adposition_exposure
             where dt='${bf_1_dt}'
               and product_id is not null
               and product_id!=6833
             group by 1,2,3,4
)
,cl as (select dt
              ,ad_position_id
              ,product_id
              ,if(corever is null or CoreVer=0,1,CoreVer)        as corever
              ,count(1)                                          as click_cnt
              ,count(distinct user_id)                           as click_unt
          from dwd.dwd_flow_user_adposition_click
         where dt='${bf_1_dt}'
           and product_id is not null
           and product_id!=6833
         group by 1,2,3,4
)
,sh as (select dt
              ,ad_position_id
              ,product_id
              ,if(corever is null or CoreVer=0,1,CoreVer)        as corever
              ,count(1)                                          as show_cnt
              ,count(distinct user_id)                           as show_unt
          from dwd.dwd_flow_user_adposition_adshow
         where dt='${bf_1_dt}'
           and product_id is not null
           and product_id!=6833
         group by 1,2,3,4
)
,wt as (select dt
              ,ad_position_id
              ,product_id
              ,if(corever is null or CoreVer=0,1,CoreVer)        as corever
              ,count(1)                                          as watch_cnt
              ,count(distinct user_id)                           as watch_unt
          from dwd.dwd_flow_user_adposition_adwatchsuccess
         where dt='${bf_1_dt}'
           and product_id is not null
           and product_id!=6833
         group by 1,2,3,4
)
select ex.dt
      ,ex.ad_position_id
      ,ex.product_id
      ,ex.corever                 as core
      ,ex.exposure_cnt
      ,ex.exposure_unt
      ,cl.click_cnt
      ,cl.click_unt
      ,sh.show_cnt
      ,sh.show_unt
      ,wt.watch_cnt
      ,wt.watch_unt
      ,now()                      as etl_tm
  from ex
  left join cl
    on ex.dt=cl.dt
   and ex.ad_position_id=cl.ad_position_id
   and ex.product_id=cl.product_id
   and ex.corever=cl.corever
  left join sh
    on ex.dt=sh.dt
   and ex.ad_position_id=sh.ad_position_id
   and ex.product_id=sh.product_id
   and ex.corever=sh.corever
  left join wt
    on ex.dt=wt.dt
   and ex.ad_position_id=wt.ad_position_id
   and ex.product_id=wt.product_id
   and ex.corever=wt.corever
 where ex.ad_position_id !=0
;
 