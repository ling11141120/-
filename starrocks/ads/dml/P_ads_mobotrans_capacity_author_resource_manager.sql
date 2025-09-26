----------------------------------------------------------------
-- 程序功能： 产能人才资源管理看板
-- 程序名： P_ads_mobotrans_capacity_author_resource_manager
-- 目标表： ads.ads_mobotrans_capacity_author_resource_manager
-- 负责人： xjc
-- 开发日期：2025-09-24
-- 版本号： v0.0.0
----------------------------------------------------------------

insert into ads.ads_mobotrans_capacity_author_resource_manager
with ca as (
    select site_id
          ,role_type
          ,author_id
          ,work_status
          ,font_length_curmonth
          ,avg_score
      from ads.ads_mobotrans_capacity_author_resource
     where dt = '${dt}'
       and role_type in (1, 2, 3)
)
select  '${dt}'                                         as dt
      ,site_id                                          as site_id
      ,role_type                                        as role_type
      ,total_num                                        as total_num
      ,work_status_coo                                  as work_status_coo
      ,work_status_bre                                  as work_status_bre
      ,work_status_sle                                  as work_status_sle
      ,active_num_curmonth                              as active_num_curmonth
      ,active_num_curmonth/total_num                    as active_rate_curmonth
      ,font_length_curmonth                             as font_length_curmonth
      ,font_length_tar_curmonth                         as font_length_tar_curmonth
      ,font_length_tar_curmonth/font_length_curmonth    as length_rate_tar_curmonth
      ,font_length_par_curmonth                         as font_length_par_curmonth
      ,font_length_par_curmonth/font_length_curmonth    as length_rate_par_curmonth
      ,font_length2_curmonth - font_length_curmonth     as process_offset
      ,score_a_num                                      as score_a_num
      ,score_b_num                                      as score_b_num
      ,score_c_num                                      as score_c_num
      ,now()                                            as etl_time
  from (
        select site_id
              ,role_type                                                                           as role_type
              ,total_num                                                                           as total_num
              ,work_status_coo                                                                     as work_status_coo
              ,work_status_bre                                                                     as work_status_bre
              ,work_status_sle                                                                     as work_status_sle
              ,active_num_curmonth                                                                 as active_num_curmonth
              ,active_num_curmonth/total_num                                                       as active_rate_curmonth
              ,font_length_curmonth                                                                as font_length_curmonth
              ,font_length_tar_curmonth                                                            as font_length_tar_curmonth
              ,font_length_tar_curmonth/font_length_curmonth                                       as length_rate_tar_curmonth
              ,font_length_par_curmonth                                                            as font_length_par_curmonth
              ,font_length_par_curmonth/font_length_curmonth                                       as length_rate_par_curmonth
              ,lag(font_length_curmonth, 1, null) over(partition by site_id order by role_type)    as font_length2_curmonth
              ,score_a_num                                                                         as score_a_num
              ,score_b_num                                                                         as score_b_num
              ,score_c_num                                                                         as score_c_num
          from (
                  select site_id
                        ,role_type                                                                                         as role_type
                        ,count(distinct author_id)                                                                         as total_num
                        ,count(distinct if(work_status = 3, author_id, null))                                              as work_status_coo
                        ,count(distinct if(work_status = 1, author_id, null))                                              as work_status_bre
                        ,count(distinct if(work_status = 2, author_id, null))                                              as work_status_sle
                        ,count(distinct if(font_length_curmonth is not null and font_length_curmonth != 0
                                           ,author_id
                                           ,null
                                          )
                              )                                                                                            as active_num_curmonth
                        ,sum(if(font_length_curmonth is not null, font_length_curmonth, 0))                                as font_length_curmonth
                        ,sum(if(font_length_curmonth is not null and font_length_curmonth != 0 and AuthorId is not null
                                ,font_length_curmonth
                                ,0
                               )
                            )                                                                                              as font_length_tar_curmonth
                        ,sum(if(font_length_curmonth is not null and font_length_curmonth != 0 and AuthorId is null
                                ,font_length_curmonth
                                ,0
                               )
                            )                                                                                              as font_length_par_curmonth
                        ,count(distinct if(avg_score is not null and avg_score >= 3.4
                                            ,author_id
                                            ,null
                                          )
                              )                                                                                            as score_a_num
                        ,count(distinct if(avg_score is not null and avg_score >= 3 and avg_score < 3.4
                                            ,author_id
                                            ,null
                                          )
                                )                                                                                          as score_b_num
                        ,count(distinct if(avg_score is not null and avg_score < 3
                                            ,author_id
                                            ,null
                                          )
                              )                                                                                            as score_c_num
                    from ca
                    left join (select SiteId
                                     ,AuthorId
                                     ,RoleType
                                 from ods.ods_tidb_shuangwen_en_viscauthorconfig
                                where date_format(dt, '%Y-%m') = date_format('${bf_1_dt}', '%Y-%m')
                              )                                                                                            as b
                      on ca.site_id = b.SiteId
                     and ca.author_id = b.AuthorId
                     and ca.role_type = b.RoleType
                   group by site_id, role_type
                 )                                                                                 as t
       )                                                as s
