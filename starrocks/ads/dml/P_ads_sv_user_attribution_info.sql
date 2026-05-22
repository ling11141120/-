----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_user_attribution_info
-- workflow_version : 8
-- create_user      : chenmo
-- task_name        : ads_sv_user_attribution_info
-- task_version     : 8
-- update_time      : 2024-12-20 11:16:47
-- sql_path         : \starrocks\tbl_ads_sv_user_attribution_info\ads_sv_user_attribution_info
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sv_user_attribution_info
with unique_id as (
   select
       unique_cdreader_id
       ,corever2
       ,max(user_id) as user_id
       ,min(create_time) as reg_time
   from dim.dim_short_video_user_accountinfo
   group by 1,2
)
-- dpt明细
, q_install as (
    -- dpt明细
    select
        qq1.unique_cd_reader_id
        ,IF(ifnull(qq1.user_id, 0) < 10, qq2.user_id, qq1.user_id) as user_id
        ,qq1.source
        ,qq1.book_id
        ,qq1.current_language2
        ,qq1.mt
        ,qq1.ad_id
        ,qq1.core
        ,qq2.reg_time
        ,min(install_date) as install_date
    from (
        -- dpt
        select
            q1.unique_cd_reader_id, q1.mt, q1.source, q1.book_id, q1.product_id, q1.user_id, q1.current_language2, q1.trace_id, q1.ad_id, q1.install_date, q1.core
        from (
            select
                unique_cd_reader_id, mt, source, book_id, product_id, user_id, current_language2, trace_id, ad_id, install_date, core
            from ads.ads_advertisement_if_user_attribution_queue_view
            where date(install_date) >= '${bf_3_dt}' and Product_Id = 6833 and source in('fbs2s','tt') and ifnull(desc_info,'') = ''
        ) q1
        -- 剔除已归因
        left join (
            select
                distinct unique_cdreaderid, core, install_date
            from ads.ads_user_install_info_view
            where dt >= '${bf_7_dt}' and Product_Id = 6833 and source in('fbs2s','facebook','adwords','appleadservice','tiktok app','tt')  and isdelete = 0
        ) q2 on q1.unique_cd_reader_id = q2.unique_cdreaderid and q1.core = q2.core and days_diff(q1.install_date,q2.install_date) < 1 and days_diff(q1.install_date,q2.install_date) > -1
        where q2.unique_cdreaderid is null
    ) qq1
    -- user_id 补缺
    left join unique_id qq2 on qq1.unique_cd_reader_id = qq2.unique_cdreader_id and qq1.core = qq2.corever2
    group by 1,2,3,4,5,6,7,8,9
)
-- 阅读_流失
, q_read as (
    select
        q.unique_cd_reader_id
        ,q.user_id
        ,q.source
        ,q.book_id
        ,q.current_language2
        ,q.mt
        ,q.reg_time
        ,q.install_date
        ,q.ad_id
        ,q.core
        ,ifnull(max(r.create_time),'1990-01-01') as loss_time  -- 流失时间
        ,ifnull(max(case when q.book_id = r.series_id then r.create_time end),'1990-01-01') as ad_loss_time  -- 广告书流失时间
    from q_install q
    left join (
        select
            account_id, series_id, create_time
        from ads.ads_short_video_log_epis_history_view
        where create_time >= date_add('${bf_3_dt}', interval -60 day) -- 获取60天内数据
    ) r on q.user_id = r.account_id and q.install_date > r.create_time
    group by 1,2,3,4,5,6,7,8,9,10
)
-- 历史解锁 & 24H解锁
, q_unlock as (
    select q.unique_cd_reader_id
        ,q.user_id
        ,q.source
        ,q.book_id
        ,q.current_language2
        ,q.mt
        ,q.reg_time
        ,q.install_date
        ,q.loss_time
        ,q.ad_loss_time
        ,q.ad_id
        ,q.core
        ,max(case when q.install_date> u.create_time then u.create_time end) as unlock_time -- bf是否历史解锁
        ,max(case when q.install_date<= u.create_time then 1 end) as  is_24h_unlock   -- af24h内解锁
    from q_read q
    left join (
        select
            user_id, series_id, create_time
        from ads.ads_short_video_series_unlock_view
        where create_time >= date_add('${bf_3_dt}', interval -60 day) -- 获取60天内数据
    ) u on q.user_id = u.user_id and q.book_id = u.series_id and days_diff(u.create_time,q.install_date) < 1  -- 24小时内
    group by 1,2,3,4,5,6,7,8,9,10,11,12
)
-- 所有归因记录，new+rmt+dpt+自然新增
, user_attribute as (
    -- DPT,符合归因判断
    select
        x.unique_cd_reader_id
        ,x.user_id
        ,x.source
        ,x.book_id
        ,x.current_language2
        ,x.mt
        ,x.reg_time
        ,x.install_date
        ,x.ad_id
        ,x.core
        ,x.attribute
    from (
        select
            unique_cd_reader_id, user_id, source, book_id, current_language2, mt, install_date, ad_id, core,reg_time
            ,case -- when minutes_diff(install_date,installtime) <10 and days_diff(install_date,ifnull(loss_time,'2050-01-01'))>=2 then 2   -- 卸载重装，流失2天以上
                when unlock_time is null and days_diff(install_date,ifnull(loss_time,'2050-01-01')) >= 7 and  is_24h_unlock = 1 then 3  -- 新剧消费
                -- when unlock_time is null  and days_diff(install_date,ifnull(loss_time,'2050-01-01'))>=1 and is_24h_unlock =1 then 4  -- 新剧24H内付费
                when days_diff(install_date,ifnull(loss_time,'2050-01-01')) > 30 then 5
            else -1 end as attribute
        from q_unlock
    ) x
    where attribute > 0
    union all
    -- 有渠道记录前自然用户
    select
        info.unique_cdreader_id
        ,info.user_id
        ,'none' as source
        ,0 as book_id
        ,info.current_language2
        ,info.mt2
        ,info.create_time as reg_time
        ,info.create_time
        ,'0' as ad_id
        ,info.corever2
        ,1 as attribute
    from dim.dim_short_video_user_accountinfo info
    -- 渠道最早记录
    left join (
        select
            unique_cd_reader_id, core, min(install_date) install_date
        from ads.ads_advertisement_if_user_attribution_queue_view
        where install_date >= '2023-09-01' and Product_Id in('6833')
        group by 1,2
    ) s on info.unique_cdreader_id = s.unique_cd_reader_id and info.corever2 = s.core
    where hours_diff(ifnull(s.install_date,'2050-01-01'),info.create_time) > 1       -- 预估，渠道和账户时间1小时以上
    union all
    -- new+rmt
    select
        qq1.unique_cdreaderid
        ,IF(ifnull(qq1.user_id, 0) < 10, qq2.user_id, qq1.user_id) as user_id
        ,qq1.source
        ,qq1.book_id
        ,qq1.current_language2
        ,qq1.mt
        ,qq2.reg_time
        ,qq1.install_date
        ,qq1.ad_id
        ,qq1.core
        ,1 as attribute
    from (
        select
            unique_cdreaderid, user_id, source, book_id, current_language2, mt, ad_id, core, install_date
        from ads.ads_user_install_info_view
        where dt >='${bf_3_dt}' and Product_Id in('6833') and isdelete = 0
        -- 新增去重逻辑
        group by 1,2,3,4,5,6,7,8,9
    ) qq1
    -- userid空补缺
    left join unique_id qq2 on qq1.unique_cdreaderid = qq2.unique_cdreader_id and qq1.core = qq2.corever2
)
-- 下一次归因，注册语言处理,时区改西五区，媒体值处理1
, next_attribute as (
    select
        date(hours_add(a1.install_date,-13)) as dt,
        a1.unique_cd_reader_id
        ,a1.core
        ,a1.user_id
        ,case when attribute=1 and a1.source in ('fbs2s','facebook','tt','adwords') then a1.source
            when attribute>1 and a1.source in ('fbs2s','tt') then concat(a1.source,'_dpt')
            when attribute>1 then 'dpt'
            when attribute=1 and a1.source in ('none','organic','(not set)','officialsite') then 'organic'
            else 'other_ad' end as source
        ,a1.source as source_chl   -- 原始媒体值
        ,a1.book_id
        ,s.source_series_code as code
        ,coalesce(s.language, a1.current_language2) as current_language2
        ,a1.mt
        ,hours_add(least(a1.install_date,a1.reg_time),-13) as reg_time  -- 注册时间
        ,hours_add(a1.install_date,-13) as install_date
        ,a1.ad_id
        ,a1.attribute
        -- ,min(a1.install_date) over(partition by user_id) install_date_min
        -- ,case when days_diff(install_date,min(a1.install_date) over(partition by user_id))<1 then 'new' else 'rmt' end u_type
        ,lead(hours_add(a1.install_date,-13),1,'2050-01-01') over(partition by user_id order by a1.install_date, a1.current_language2 desc, a1.ad_id desc, a1.core desc, a1.attribute desc, a1.unique_cd_reader_id, a1.user_id, a1.source, a1.book_id, s.source_series_code, a1.mt) as next_time
    from user_attribute a1
    -- 短剧信息
    left join (
        select
            series_id, language, source_series_code
        from dim.dim_sv_series_hi
        group by 1,2,3
    ) s on a1.book_id=s.series_id
    where a1.core=1
)
select
    dt,
    md5(concat(unique_cd_reader_id,core,
               if(user_id is null,-99,user_id),source,book_id,
               if(code is null,-99,code),current_language2,
               if(mt is null,-99,mt),install_date,
               if(ad_id is null,-99,ad_id),attribute
    )) as md5_key,
    unique_cd_reader_id,core,user_id,source,book_id,code,current_language2,mt,install_date,ad_id,attribute,next_time,now() as etl_time
from next_attribute
-- 去除归因脏数据
where date_add(install_date, interval 1 minute) < next_time;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_user_attribution_info
-- workflow_version : 8
-- create_user      : chenmo
-- task_name        : update_next_time
-- task_version     : 7
-- update_time      : 2024-12-20 11:16:47
-- sql_path         : \starrocks\tbl_ads_sv_user_attribution_info\update_next_time
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sv_user_attribution_info
select
    dt,
    md5_key,
    unique_cd_reader_id,
    core,
    user_id,
    source,
    book_id,
    code,
    current_language2,
    mt,
    install_date,
    ad_id,
    attribute,
    lead(install_date,1,'2050-01-01') over(partition by user_id order by install_date, md5_key) as next_time,
    etl_tm
from ads.ads_sv_user_attribution_info;
