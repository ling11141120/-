insert overwrite ads.ads_user_user_login partition (p'${pname}')
with yesterdayLogin as (
    select date(date_add(dt,interval 1 DAY)) as dt,
           ProductId,
           UserId,
           FirstLoginTime,
           PreLoginTime,
           LastLoginTime,
           LoginDays,
           LoginTimes
    from ads.ads_user_user_login
    where dt = '${yesterday}'
),
     login as (
         select first.dt,
                first.UserId,
                first.ProductId,
                FirstLoginTime,
                pre_login_time,
                last_login_time
         from (
                  select dt, UserId, ProductId, CreateTime as FirstLoginTime
                  from (
                           select dt,
                                  UserId,
                                  ProductId,
                                  CreateTime,
                                  row_number() over (partition by ProductId,UserId order by createtime ) rk
                           from dwd.dwd_user_log_appstartlog
                           where dt = '${today}'
                       ) login1
                  where rk = 1
              ) first
                  left join (
             select dt, UserId, ProductId, max(pre_login_time) pre_login_time, max(last_login_time) last_login_time
             from (
                      select dt,
                             UserId,
                             ProductId,
                             if(rk = 2, createtime, null) as pre_login_time,
                             if(rk = 1, createtime, null) as last_login_time
                      from (
                               select dt,
                                      UserId,
                                      ProductId,
                                      CreateTime,
                                      row_number() over (partition by ProductId,UserId order by createtime desc ) rk
                               from dwd.dwd_user_log_appstartlog
                               where dt = '${today}'
                           ) last_t1
                      where rk <= 2
                  ) last_t2
             group by dt, UserId, ProductId
         ) last on first.ProductId = last.ProductId and first.UserId = last.UserId
     ),
     loginDay as (
         select UserId,
                ProductId,
                1        as login_days,
                count(1) as login_times
         from dwd.dwd_user_log_appstartlog
         where dt = '${today}'
         group by UserId, ProductId
     ),
     loginAll as (
         select dt,
                ProductId,
                UserId,
                FirstLoginTime,
                PreLoginTime,
                LastLoginTime,
                LoginDays,
                LoginTimes
         from yesterdayLogin
         union all
         select dt,
                login.ProductId,
                login.UserId,
                FirstLoginTime,
                pre_login_time,
                last_login_time,
                login_days,
                login_times
         from login
                  left join loginDay on login.ProductId = loginDay.ProductId and login.UserId = loginDay.UserId
     ),
     loginAllWithRk as (
         select dt,
                ProductId,
                UserId,
                FirstLoginTime,
                PreLoginTime,
                LastLoginTime,
                LoginDays,
                LoginTimes,
                row_number() over (partition by ProductId,UserId order by LastLoginTime) rk
         from loginAll
     )
select dt,
       t1.ProductId,
       t1.UserId,
       FirstLoginTime,
       PreLoginTime,
       LastLoginTime,
       LoginDays,
       LoginTimes,
       datediff(LastLoginTime, acc.createtime) + 1 as RemainDays
from (
         select r1.dt,
                r1.ProductId,
                r1.UserId,
                r1.FirstLoginTime,
                case
                    when r2.PreLoginTime is null and r2.PreLoginTime is null then r1.PreLoginTime
                    when r2.PreLoginTime is null and r2.LastLoginTime is not null then r1.LastLoginTime
                    else r2.PreLoginTime
                    end                                                                 as PreLoginTime,
                if(r2.LastLoginTime is not null, r2.LastLoginTime, r1.LastLoginTime)       LastLoginTime,
                if(r2.LoginDays is null, r1.LoginDays, r1.LoginDays + 1)                as LoginDays,
                if(r2.LoginTimes is null, r1.LoginTimes, r1.LoginTimes + r2.LoginTimes) as LoginTimes
         from (
                  select dt,
                         ProductId,
                         UserId,
                         FirstLoginTime,
                         PreLoginTime,
                         LastLoginTime,
                         LoginDays,
                         LoginTimes,
                         rk
                  from loginAllWithRk
                  where rk = 1
              ) r1
                  left join (
             select dt,
                    ProductId,
                    UserId,
                    FirstLoginTime,
                    PreLoginTime,
                    LastLoginTime,
                    LoginDays,
                    LoginTimes,
                    rk
             from loginAllWithRk
             where rk = 2
         ) r2 on r1.ProductId = r2.ProductId and r1.UserId = r2.UserId
     ) t1
         left join (
    select id as UserId, productid as ProductId, createtime
    from real_dw.dwd_book_user_accountinfo_m
) acc on t1.ProductId = acc.ProductId and t1.UserId = acc.UserId;
//test123123123