-- TODO 海剧
insert into ads.ads_series_attribution_match_rate_new
with z1 as (
    select
        d.project_code as project_id,
        date(date_add(a.install_date, interval -13 hour)) as dt,
        hour(date_add(a.install_date, interval -13 hour)) as hour,
        DATE_FORMAT(date_add(a.install_date, interval -13 hour), '%Y-%m-%d %H:00:00') as dt_hour,
        a.product_id,
        case when source in ('facebook') and source_type in ('360security_int') then 'fbs2s'
             when source in ('facebook') and source_type in ('Facebook Ads') then 'facebook'
             when source in ('tiktok') and source_type in ('360security_int') then 'tt'
             when source in ('tiktok') and source_type in ('tiktokglobal_int') then 'tiktok app'
             else source end as source,
        a.mt,
        a.core,
        a.current_language2,
        c.ads_type,
        user_id,
        IFNULL(b.sdk, '无拉剧') as sdk,
        a.book_id,
        b.series_id,
        row_data,
        row_number() over(partition by concat(a.install_date,a.user_id) order by abs(seconds_diff(b.create_time,a.install_date))) as rn
    from (
        select
            install_date,product_id,source,book_id,
            get_json_string(install_original_request,'$.media_source') as source_type,
            ad_id,user_id,mt,core,
            current_language2,unique_cdreaderid
        from ads.ads_user_install_info_view
        where install_date>='${bf_3_dt}' and product_id=6833 and isdelete=0 and minutes_diff(next_attribute_time,install_date)>=1
        union all
        select
            a.create_time,a.product_id,'none' as source,null as book_id,
            null as source_type,
            null as ad_id,a.user_id,a.mt2,a.corever2,
            current_language2,unique_cdreader_id
        from (
            select * from dim.dim_short_video_user_accountinfo where create_time >= '${bf_3_dt}' and product_id not in(8858, 7757)
        ) a
        left join (
            select
                product_id,user_id,core,min(install_date) as install_date
            from ads.ads_user_install_info_view
            where install_date>='${bf_7_dt}' and product_id=6833 and isdelete=0
            group by product_id, user_id, core
        ) b on a.product_id = b.product_id and a.user_id = b.user_id and a.corever2 = b.core
        where hours_diff(ifnull(b.install_date,'2050-01-01'),a.create_time) > 1
    ) a
    left join (
        select
            series_id,unique_cdreader_id,create_time,core,row_data,
            case when sdk in (0,1) then 'fb_deeplink'
                 when sdk in (3,4) then 'GPIR'
                 when sdk in (5) then '剪切板'
                 when sdk in (6) then 'iOS_ASA'
                 when sdk in (7) and defaultdl_Type=0 then '兜底'
                 when sdk in (7) and defaultdl_Type=1 then 'UAC'
                 when sdk in (7) and defaultdl_Type>1 then 'Ipmatch'
                 when sdk in (10,11)  then 'MIR'
                 when sdk in (13)  then 'AF'
                 when sdk in (16)  then 'AF_回调'
                 when sdk in (100) then 'PWA'
                 else sdk end as sdk
        from ads.ads_short_video_video_dl_log_view
        where create_time>='${bf_7_dt}' and has_open=1
    ) b on a.unique_cdreaderid = b.unique_cdreader_id
    and minutes_diff(b.create_time,a.install_date) <if(a.source='adwords',24*60,10)
    and minutes_diff(b.create_time,a.install_date) > -1 and a.core=b.core
    left join dwd.dwd_advertisement_adext_view c on a.product_id = c.product_id and a.ad_id = c.ad_id
    left join dim.dim_project_product d on a.product_id = d.product_id
)
select
    project_id,
    dt,
    hour,
    md5(concat_ws('_',product_id,source,mt,mt,core,current_language2,coalesce(ads_type, -99),coalesce(sdk, -99))) as md5_key,
    dt_hour,
    product_id,
    source,
    mt,
    core,
    current_language2,
    ads_type,
    sdk,
    count(1) as activation,
    sum(if(SDK<>'兜底' and ifnull(book_id,0)=series_id, 1, 0)) as matched_non_fallback,
    sum(if(SDK<>'兜底' and ifnull(book_id,0)<>series_id, 1, 0)) as matched_fallback,
    sum(if(SDK='兜底' and ifnull(book_id,0)=series_id, 1, 0)) as non_matched_non_fallback,
    sum(if(SDK='兜底' and ifnull(book_id,0)<>series_id, 1, 0)) as non_matched_fallback,
    sum(IF(series_id is null, 1, 0)) as no_activation,
    now() as etl_time
from z1
where rn=1   -- 激活时间最近的拉剧
group by 1,2,3,4,5,6,7,8,9,10,11,12
;

-- TODO 海阅
insert into ads.ads_series_attribution_match_rate_new
with z1 as (
        select
        d.project_code as project_id,
        date(date_add(a.install_date, interval -13 hour)) as dt,
        hour(date_add(a.install_date, interval -13 hour)) as hour,
        DATE_FORMAT(date_add(a.install_date, interval -13 hour), '%Y-%m-%d %H:00:00') as dt_hour,
        a.user_id,
        a.install_date,
        a.next_attribute_time,
        a.product_id,
        a.source,
        a.mt,
        a.core,
        a.current_language2,
        c.ads_type,
        IFNULL(b.sdk, '无拉书') as sdk,
        a.book_id,
        b.open_bk,
        row_number() over(partition by concat(a.install_date,a.user_id,a.product_id) order by abs(seconds_diff(b.create_time,a.install_date))) as rn
    from (
        select
            install_date,product_id,source,book_id,
            get_json_string(install_original_request,'$.media_source') as source_type,
            ad_id,user_id,mt,core,
            current_language2,unique_cdreaderid,next_attribute_time
        from ads.ads_user_install_info_view
        where install_date>='${bf_3_dt}' and product_id<>6833 and isdelete=0 and minutes_diff(next_attribute_time,install_date)>=1
        union all
        select
            a.create_time,a.product_id,'none' as source,null as book_id,
            null as source_type,
            null as ad_id,a.id,a.mt2,a.corever2,
            current_language2,unique_cdreader_id,null as next_attribute_time
        from (
            select * from dim.dim_user_account_info_view where create_time >= '${bf_3_dt}' and product_id not in(8858, 7757)
        ) a
        left join (
            select
                product_id,user_id,core,min(install_date) as install_date
            from ads.ads_user_install_info_view
            where install_date>='${bf_7_dt}' and isdelete=0
            group by product_id, user_id, core
        ) b on a.product_id = b.product_id and a.id = b.user_id and a.corever2 = b.core
        where hours_diff(ifnull(b.install_date,'2050-01-01'),a.create_time) > 1
    ) a
    left join (
        select
            mt,appid,product_id,cast(substr(appid,5,2) as int) as corever,create_time,
            IF(split_part(s4, ':', 1) is null, s4, split_part(s4, ':', 1)) as s4,
            IF(f4 > f5, f4, f5) as open_bk,
            case when f3=-1 then '不是动态链接'
                 when f3=0 then 'fb_deeplink'
                 when f3=1 then 'firebase_deeplink'
                 when f3=22 then 'MIR'
                 when f3=12 then 'GPIR'
                 when f3=14 then '剪贴板'
                 when f3=19 then 'KOC'
                 when f3=23 then 'AF UDL'
                 when f3=2 then 'AF'
                 when f3=17 then (case when f8=0 then '兜底'
                                       when f8=1 then 'UAC'
                                       when f8>=2 then 'Ipmatch'
                                  end)
                 when f3=100 then 'PWA'
                 else f3 end as sdk
        from ads.ads_user_commonactionlog_view
        where dt >='${bf_7_dt}' and f3<>11 and action ='1029' and f6=1
    ) b on a.unique_cdreaderid = b.s4 and a.core=b.corever and a.mt=b.mt and left(a.product_id,3)=left(b.appid,3)
                             and minutes_diff(b.create_time,a.install_date) <if(a.source='adwords',24*60,10)  and minutes_diff(b.create_time,a.install_date) > -1
    left join dwd.dwd_advertisement_adext_view c on a.product_id = c.product_id and a.ad_id = c.ad_id
    left join dim.dim_project_product d on a.product_id = d.product_id
)
select
    project_id,
    dt,
    hour,
    md5(concat_ws('_',product_id,source,mt,mt,core,current_language2,coalesce(ads_type, -99),coalesce(sdk, -99))) as md5_key,
    dt_hour,
    product_id,
    source,
    mt,
    core,
    current_language2,
    ads_type,
    sdk,
    count(1) as activation,
    sum(if(SDK<>'兜底' and ifnull(book_id,0)=open_bk, 1, 0)) as matched_non_fallback,
    sum(if(SDK<>'兜底' and ifnull(book_id,0)<>open_bk, 1, 0)) as matched_fallback,
    sum(if(SDK='兜底' and ifnull(book_id,0)=open_bk, 1, 0)) as non_matched_non_fallback,
    sum(if(SDK='兜底' and ifnull(book_id,0)<>open_bk, 1, 0)) as non_matched_fallback,
    sum(IF(open_bk is null, 1, 0)) as no_activation,
    now() as etl_time
from z1
where rn=1   -- 激活时间最近的拉剧
group by 1,2,3,4,5,6,7,8,9,10,11,12;