----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_video_short_video_watch_consume_ed
-- workflow_version : 9
-- create_user      : zhengtt
-- task_name        : dwm_video_short_video_watch_consume_ed
-- task_version     : 9
-- update_time      : 2024-10-16 16:21:46
-- sql_path         : \starrocks\tbl_dwm_video_short_video_watch_consume_ed\dwm_video_short_video_watch_consume_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from dwm.dwm_video_short_video_watch_consume_ed where dt = '${bf_1_dt}';

-- SQL语句
insert into dwm.dwm_video_short_video_watch_consume_ed
select  a.dt as dt,6833 as product_id,a.user_id as user_id,a.series_id,a.epis_num,a.epis_id,
        b.corever as core,b.mt as mt,c.Source as source,d.series_name,d.series_language,
        d.epis_length,d.epis_amount,e.min_start_watch_tm as start_first_time,
        e.max_end_watch_tm as end_last_time,a.epis_watch_num,a.epis_watch_num_real,epis_coin_consume_amount,
        epis_cert_consume_amount,a.is_like_num,now() as etl_time
from
    (   select  coalesce(a.dt,c.dt) as dt,coalesce(a.user_id,c.user_id) as user_id,
                coalesce(a.series_id,c.series_id) as series_id,coalesce(a.epis_num,c.epis_num) as epis_num,
                coalesce(a.epis_id,c.epis_id) as epis_id,
                epis_coin_consume_amount,epis_cert_consume_amount,epis_watch_num,epis_watch_num_real,
                ifnull(c.is_like_num,0) as is_like_num
        from (  select  coalesce(a.dt,b.dt) as dt,coalesce(a.user_id,b.user_id) as user_id,
                        coalesce(a.series_id,b.series_id) as series_id,coalesce(a.epis_num,b.epis_num) as epis_num,
                        coalesce(a.epis_id,b.epis_id) as epis_id,
                        epis_coin_consume_amount,epis_cert_consume_amount,epis_watch_num_real,epis_watch_num
                from
                    (   select   coalesce(a.dt,b.dt) as dt,coalesce(a.user_id,b.user_id) as user_id,
                                 coalesce(a.series_id,b.series_id) as series_id,coalesce(a.epis_num,b.epis_num) as epis_num,
                                 coalesce(a.epis_id,b.epis_id) as epis_id,
                                 epis_coin_consume_amount,epis_cert_consume_amount,epis_watch_num_real
                        from
                            (   select  dt,user_id,series_id,epis_id,epis_num,
                                        max(case when consume_type  = 0 then epis_consume_amount
                                                 when consume_type  = 1 then null
                                            end) as  epis_coin_consume_amount,
                                        max(case when consume_type  = 1 then epis_consume_amount
                                                 when consume_type  = 0 then null
                                            end) as  epis_cert_consume_amount
                                from
                                    (   select  dt,account_id as user_id,b.series_id as series_id ,a.epis_id as epis_id,
                                                a.epis_num,consume_type,sum(consume_value) as epis_consume_amount
                                        from dwd.dwd_sv_consume_user_consume_bill_pdi a
                                                 left join dim.dim_short_video_epis_view b
                                                           on a.epis_id = b.epis_id
                                        where a.dt = '${bf_1_dt}' and a.epis_id != 0 and b.series_id is not null
                                        group by 1,2,3,4,5,6
                                    ) a
                                group by 1,2,3,4,5
                            ) a
                            full join
                            (   select  date(create_time) as dt,account_id as user_id,series_id,epis_id,epis_num,count(1) as epis_watch_num_real
                                from  dwd.dwd_video_short_video_epis_history
                                where date(create_time) = '${bf_1_dt}'
                                group by 1,2,3,4,5
                                ) b
                        on a.dt = b.dt and a.user_id = b.user_id and a.series_id = b.series_id and a.epis_num = b.epis_num and a.epis_id = b.epis_id
                    ) a
                    full join
                    (   select dt,account_id as user_id,series_id,epis_id,epis_num,count(1) as epis_watch_num
                        from dwd.dwd_video_short_video_epis_watch_log
                        where dt = '${bf_1_dt}'
                        group by 1,2,3,4,5
                        ) b
                on a.dt = b.dt and a.user_id = b.user_id and a.series_id = b.series_id and a.epis_num = b.epis_num and a.epis_id = b.epis_id
             ) a
            full join
             (  select dt,user_id,a.epis_id,series_id,epis_num,1 as is_like_num
                from
                (	select  dt,user_id,epis_id,series_id
                    from
                    (	select  dt,user_id,epis_id,series_id,
                             	row_number() over (partition by user_id,epis_id order by create_time) as rn
                        from dwd.dwd_video_short_video_account_like_view
                        where dt = '${bf_1_dt}' and series_id is not null
                        ) a
                    where rn = 1
                    ) a
                left join
                (	select	epis_id,epis_num
                	from dim.dim_short_video_epis_view
                	) b
                	on a.epis_id = b.epis_id
                	where b.epis_id is not null
                ) c
        on a.dt = c.dt and a.user_id = c.user_id and a.series_id = c.series_id and a.epis_num = c.epis_num and a.epis_id = c.epis_id
    ) a
        left join dim.dim_short_video_account_device_info b
                  on a.user_id = b.user_id
        left join
    (   select  User_Id,Source
        from
            (   select User_Id,Source,
                       row_number() over (partition by User_Id order by Create_Time desc) as rn
                from dwd.dwd_user_install_info_ed_view
                where Product_Id = 6833 and IsDelete != 1
            ) c
        where rn = 1
    ) c
    on a.user_id = c.User_Id
        left join
    (   select  a.series_id,b.language as series_language,b.series_name as series_name,
                a.epis_id as epis_id,a.epis_num as epis_num,a.duration as epis_length,
                a.series_price as epis_amount
        from dim.dim_short_video_epis_view a
                 left join dim.dim_short_video_series_view b
                           on a.series_id = b.series_id
        where b.series_id is not null
    ) d
    on a.series_id = d.series_id and a.epis_num = d.epis_num and a.epis_id = d.epis_id
        left join
    (   select login_id as user_id,shortplay_id as series_id,a.episode_id as epis_id,epis_num,min_start_watch_tm,max_end_watch_tm
        from dwd.dwd_short_video_star_end_watching a
                 left join dim.dim_short_video_epis_view b
                           on a.episode_id = b.epis_id
        where b.epis_id is not null
    ) e
    on a.user_id = e.user_id and a.series_id = e.series_id and a.epis_num = e.epis_num and a.epis_id = e.epis_id;
