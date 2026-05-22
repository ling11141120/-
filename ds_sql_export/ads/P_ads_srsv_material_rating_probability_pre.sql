----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ads_srsv_material_rating_probability
-- workflow_version : 73
-- create_user      : chenmo
-- task_name        : ads_sr_material_rating_probability_pre
-- task_version     : 31
-- update_time      : 2025-11-24 15:57:03
-- sql_path         : \starrocks\sch_ads_srsv_material_rating_probability\ads_sr_material_rating_probability_pre
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_srsv_material_rating_probability_pre
with z1 as (
        -- 海阅书籍和标准
        select a.*
            ,UPPER(pt.abbreviation)  as language_name
        from (
            select a.project_code
                ,a.book_id
                ,b.channel
                ,b.new_cid_name
                ,null as source_chl
                ,b.book_language as language_id
                ,r2.mt
                ,coalesce(r1.r0_std,if(b.channel=2,0.9,1)*r2.r0_std) as r0_std
                ,if(r1.mt is null,0,1) as has_r0_std

            -- 历史投放书籍+ 近期书
            from (
                            -- 历史投放书
                select distinct book_id
                    ,1 as project_code
                from ads.ads_advertisement_adext_view
                where  book_id is not null and source_chl in ('fbs2s','facebook','tt') and product_id not in (6833,6883)
                union

                -- 近期更新书
                select distinct book_id
                    ,1 as project_code
                from dim.dim_shuangwen_book_read_consume_info
                where font_length>=90000 and days_diff(now(),update_time)<30
            ) a
            -- 书籍分类，用于通用素材
            left join ads.ads_if_books_view b on a.book_id=b.book_id
            -- 海阅大盘标准
            left join (
                select CurrentLanguage
                    ,BookChannel
                    ,mt
                    ,round(avg(R0Std), 4) as r0_std
                from ods.ods_ads_tidb_sharpengine_ads_global_RoiStdCfgDaily
                where BookChannel=1 and ProjectCode = 1
                group by 1,2,3
            ) r2 on b.book_language=r2.CurrentLanguage
            -- 书籍标准
            left join (
                select BookId
                    ,mt
                    ,round(avg(R0Std), 4) as r0_std
                from ods.ods_ads_tidb_sharpengine_ads_global_BookRoiStdCfgV2Daily
                where days_diff(now(),DateKey)=1
                group by 1,2
            ) r1 on a.book_id=r1.BookId and r2.mt=r1.mt

        -- 海剧短剧和标准
            union all
            select b.project_code
                ,b.series_id
                ,null as channel
                ,null as new_cid_name
                ,r2.SourceChl
                ,b.language
                ,r2.mt
                ,coalesce(r1.r0_std,r2.r0_std) as r0_std
                ,if(r1.mt is null,0,1) as has_r0_std

            -- 历史短剧
            from (
                select distinct
                    series_id
                    ,2 as project_code
                    ,language
                from dim.dim_sv_series_hi
            ) b
            -- 海剧大盘标准
            left join (
                select CurrentLanguage
                    ,SourceChl
                    ,mt
                    ,round(avg(R0Std), 4) as r0_std
                from ods.ods_ads_tidb_sharpengine_ads_global_RoiStdCfgDaily
                where ProjectCode = 1 and days_diff(now(),DateKey)=1
                group by 1, 2, 3
            ) r2 on b.language=r2.CurrentLanguage
            -- 短剧标准
            left join (
                select VideoId
                    ,SourceChl
                    ,mt
                    ,round(avg(R0Std), 4) as r0_std
                from ods.ods_ads_tidb_sharpengine_ads_global_VideoRoiStdCfgV2Daily
                where days_diff(now(),DateKey)=1
                group by 1, 2, 3
            ) r1 on b.series_id=r1.VideoId and r1.SourceChl=r2.SourceChl and r2.mt=r1.mt
        ) a
        --  获取语言
        left join (
            select langid
                ,abbreviation
            from  dim.DIM_ProductType
            where KeyProductType != 14
        ) pt  on a.language_id = pt.langid
    )

    -- 素材投放数据，书籍，语言，属性
    , z2_1 as (
        select a.date_key
            ,a.product_id
            ,a.AssetGuid
            ,e.source_chl
            ,e.book_id
            ,e.is_mai
            ,e.project_code
            ,e.channel
            ,e.new_cid_name
            ,e.language_id
            ,e.language_name
            ,sum(a.spend) spend
            ,sum(a.impressions) impressions
            ,sum(a.clicks) clicks
            ,sum(a.link_clicks) link_clicks
            ,sum(a.installs) installs
            ,sum(a.amount) amount
            ,round(sum(a.spend*e.r0_std), 6) as amount_std
        -- 素材投放数据
        from (
            select *
            from ads.ads_advertisement_adassetltv_view
            where date_key>='${bf_3_dt}' and AssetGuid is not null
        ) a
        -- 获取adsetid,book_id,mai，语言，书籍属性，投放标准
        join (
            select a.*
                ,b.r0_std
                ,b.project_code
                ,b.channel
                ,b.new_cid_name
                ,b.language_id
                ,b.language_name
            from (
                select
                    product_id
                    ,ad_id
                    ,ad_set_id
                    ,book_id
                    ,source_chl
                    ,mt
                    ,case when ads_type like '%1.0%' or UPPER(ads_type) in ('MAI') then 'MAI' else 'NOT_MAI' end as is_mai
                from ads.ads_advertisement_adext_view
                where source_chl in ('tt','fbs2s','facebook') and create_time>='2024-01-01' and book_id is not null
            ) a
            -- 语言，书籍属性，投放标准
            join z1 b on if(a.product_id=6833,2,1)=b.project_code and a.book_id=b.book_id and if(b.project_code=1,a.source_chl,b.source_chl)=a.source_chl and a.mt=b.mt
        ) e on a.product_id=e.product_id and a.adid=e.ad_id
        group by 1,2,3,4,5,6,7,8,9,10,11
    )

    ,z2_2 as (
        select asset_guid,
               code,
               materia_uid,
               material_name,
               bm_compelete_time,
               source_chl_type,
               tgt_type,
               material_type,
               language_asset,
               asset_type,
               code_type,
               date_key,
               product_id,
               AssetGuid,
               source_chl,
               book_id,
               is_mai,
               project_code,
               channel,
               new_cid_name,
               language_id,
               a.language_name,
               b.language_name as language_name2,
               spend,
               impressions,
               clicks,
               link_clicks,
               installs,
               amount,
               amount_std
        from (
            -- 上传成功素材及属性
            select  distinct
                asset_guid
                ,language_name
                ,code
                ,materia_uid
                ,material_name
                ,bm_compelete_time
                ,source_chl_type
                ,tgt_type
                ,material_type
                ,if(language_name in('无文案')
                    ,case when region_folder like '%欧美%' then '欧美'
                        when region_folder like '%东南亚%' then '东南亚'
                        else '全语种' end
                    ,language_name) as language_asset  -- 素材语言
                ,case when code in ('无文案','通用','男频','狼人')   then '通用'
                    when material_name like '%滚动%' then '定制'
                    when material_name like '%滚屏%' then '定制'
                    when material_name like '%解压%' then '定制'
                    else '通用' end as  asset_type  -- 是否通用
                ,case when code in ('无文案','通用','男频','狼人')  then '通用'  else '定制' end as code_type   -- 素材分类
                -- ,case when concat(code,material_name) like '%男频%' then '男频'
                --     when concat(code,material_name) like '%狼人%' then '狼人'
                --     when concat(code,material_name) like '%古风%' then '古言'
                --     when concat(code,material_name) like '%古言%' then '古言'
                --     end as code_type   -- 素材分类
            from ads.ads_material_upload_log_view a
            left join ods.ods_ads_tidb_sharpengine_ads_global_AssetBlacklist b
            on a.asset_guid = b.AssetGuid
            where upload_status=4 and bm_compelete_time>='2024-01-01'
            and ((a.tgt_type=2 and a.material_full_name NOT REGEXP 'h2|h3|H2|H3|1\\.5') or (a.tgt_type=1 and a.material_full_name NOT REGEXP 'h1|h2|h3|H1|H2|H3|1\\.5'))  -- 上传成功
            and b.AssetGuid is null
        ) a
        -- 素材投放数据，书籍，语言，属性
        left join z2_1 b on b.AssetGuid=a.asset_guid and a.source_chl_type=if(b.source_chl ='tt',2,1)
    )

    -- -- 书籍信息
    ,z2_3 as (
        select a.*
            ,UPPER(pt.abbreviation)  as language_name
        from (
        -- 书籍信息
            select distinct
                book_id
                ,book_code
                ,languageid
                ,1 as project_code
            from dim.dim_shuangwen_book_read_consume_info
            where font_length>0
            union all
            -- 短剧信息
            select distinct
                series_id
                ,source_series_code
                ,language
                ,2 as project_code
            from dim.dim_sv_series_hi
        ) a
        -- 获取语言
        left join (
            select langid
                ,abbreviation
            from  dim.DIM_ProductType
            where KeyProductType != 14
        ) pt  on a.languageid = pt.langid
    )

    -- 上传素材 & 投放数据
    , z2 as (
        select
            md5(concat(ifnull(asset_guid, -99), ifnull(language_name, -99), ifnull(code, -99), ifnull(materia_uid, -99),
                ifnull(material_name, -99), ifnull(bm_compelete_time, -99), ifnull(project_code, -99), ifnull(source_chl, -99),
                ifnull(source_chl_type, -99), ifnull(language_asset, -99), ifnull(asset_type, -99), ifnull(code_type, -99),
                ifnull(date_key, -99), ifnull(is_mai, -99), ifnull(book_id, -99))) as md5_key,
            asset_guid,
            language_name,
            code,
            materia_uid,
            material_name,
            bm_compelete_time,
            project_code,
            source_chl,
            source_chl_type,
            language_asset,
            asset_type,
            code_type,
            material_type,
            date_key,
            is_mai,
            book_id,
            spend,
            impressions,
            clicks,
            link_clicks,
            installs,
            amount,
            amount_std,
            channel,  -- 男女频 1=女频，2=男频
            new_cid_name,     -- 书籍分类
            etl_tm
        from (
            select
                a.asset_guid
                ,coalesce(a.language_name2,a.language_name3) as language_name   -- 书籍语言
                ,a.code
                ,a.materia_uid
                ,a.material_name
                ,a.bm_compelete_time
                ,coalesce(a.project_code,a.tgt_type) as project_code
                ,a.source_chl
                ,a.source_chl_type
                ,a.language_asset    -- 素材语言或语言分类
                ,a.asset_type    -- 是否定制
                ,a.code_type       -- 素材分类
                ,a.material_type
                ,a.date_key
                ,a.is_mai
                ,coalesce(a.book_id,a.book_id3) as  book_id
                ,a.channel  -- 男女频 1=女频，2=男频
                ,a.new_cid_name     -- 书籍分类
                ,sum(spend) as spend
                ,sum(impressions) as impressions
                ,sum(clicks) as clicks
                ,sum(link_clicks) as link_clicks
                ,sum(installs) as installs
                ,sum(amount) as amount
                ,sum(amount_std) as amount_std  -- 收入目标
                ,now() as etl_tm
            from (
                select asset_guid,code,materia_uid,material_name,bm_compelete_time,source_chl_type,tgt_type,material_type,language_asset,asset_type,
                       code_type,date_key,product_id,AssetGuid,source_chl,a.book_id,is_mai,a.project_code,channel,new_cid_name,language_id,
                       a.language_name,
                       language_name2,
                       spend,
                       impressions,
                       clicks,
                       link_clicks,
                       installs,
                       amount,
                       amount_std,
                       b.book_id as book_id3,
                       book_code,
                       languageid,
                       b.project_code as project_code3,
                       b.language_name as language_name3
                from (
                    select
                        *
                    from z2_2
                    where book_id is not null
                ) a
                left join z2_3 b on a.book_id = b.book_id and case when a.product_id is null then a.tgt_type when a.product_id=6833 then 2 else 1 end=b.project_code
                union all
                select asset_guid,code,materia_uid,material_name,bm_compelete_time,source_chl_type,tgt_type,material_type,language_asset,asset_type,
                       code_type,date_key,product_id,AssetGuid,source_chl,a.book_id,is_mai,a.project_code,channel,new_cid_name,language_id,
                       a.language_name,
                       language_name2,
                       spend,
                       impressions,
                       clicks,
                       link_clicks,
                       installs,
                       amount,
                       amount_std,
                       b.book_id as book_id3,
                       book_code,
                       languageid,
                       b.project_code as project_code3,
                       b.language_name as language_name3
                from (
                    select
                        *
                    from z2_2
                    where book_id is null
                ) a
                left join z2_3 b on a.code = b.book_code and a.language_name = b.language_name and case when a.product_id is null then a.tgt_type when a.product_id=6833 then 2 else 1 end=b.project_code
            ) a
            group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18
        ) a
        where ifnull(spend,0)>0 or (bm_compelete_time>=date(hours_sub(now(),13+48)) and bm_compelete_time<=date(hours_sub(now(),13-48)))
    )

select md5_key,
       asset_guid,
       language_name,
       code,
       materia_uid,
       material_name,
       bm_compelete_time,
       project_code,
       source_chl,
       source_chl_type,
       language_asset,
       asset_type,
       code_type,
       material_type,
       date_key,
       is_mai,
       book_id,
       spend,
       impressions,
       clicks,
       link_clicks,
       installs,
       amount,
       amount_std,
       channel,
       new_cid_name,
       etl_tm
from z2
;
