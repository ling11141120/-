----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_srsv_d0_hour_dpt
-- workflow_version : 20
-- create_user      : chenmo
-- task_name        : ads_srsv_d0_hour_dpt_user_tz
-- task_version     : 13
-- update_time      : 2025-12-17 16:10:10
-- sql_path         : \starrocks\tbl_ads_srsv_d0_hour_dpt\ads_srsv_d0_hour_dpt_user_tz
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_srsv_d0_hour_dpt_user_tz
with z1 as (
    select
        a.unique_cd_reader_id,
        a.ad_id,
        a.source
    from ads.ads_advertisement_if_user_attribution_queue_view a
    inner join ods.ods_sharpengine_ads_hk_bak_if_user_installreferrer b
    on a.id = b.Id
    left join ads.ads_advertisement_adext_view c
    on a.ad_id = c.ad_id
    where date(DATE_ADD(a.install_date, INTERVAL ifnull(account_tz,-13) HOUR)) >= '${bf_60_dt}'
    and date(DATE_ADD(a.install_date, INTERVAL ifnull(account_tz,-13) HOUR)) <= '${dt}'
    and b.IsDelete = 0
    group by 1, 2, 3
),
z2 as (
    select
        dt,
        product_id,
        ad_id,
        unique_cd_reader_id,
        install_date,
        last_click_time,
        source
    from (
        select
            date(DATE_SUB(a.install_date, INTERVAL 13 HOUR)) AS dt,
            a.product_id,
            a.ad_id,
            a.unique_cd_reader_id,
            a.install_date,
            a.last_click_time,
            a.source,
            if(a.source = z1.source, 1, 0) as x
        from ads.ads_advertisement_if_user_attribution_queue_view a
        left join z1
        on a.unique_cd_reader_id = z1.unique_cd_reader_id and a.ad_id = z1.ad_id
        left join ads.ads_advertisement_adext_view b
        on a.ad_id = b.ad_id
        where date(DATE_ADD(install_date, INTERVAL ifnull(account_tz,-13) HOUR)) >= '${bf_60_dt}'
        and date(DATE_ADD(install_date, INTERVAL ifnull(account_tz,-13) HOUR)) <= '${dt}'
--         and a.attributed = 0
    ) a where x = 0
),
-- 归因到了
z3 as (
    select
        date(DATE_SUB(a.install_date, INTERVAL 13 HOUR)) AS dt,
        a.unique_cd_reader_id,
        a.ad_id,
        a.source,
        a.install_date,
        a.last_click_time
    from ads.ads_advertisement_if_user_attribution_queue_view a
    inner join ods.ods_sharpengine_ads_hk_bak_if_user_installreferrer b
    on a.id=b.Id
    left join ads.ads_advertisement_adext_view c
    on a.ad_id = c.ad_id
    where date(DATE_ADD(a.install_date, INTERVAL ifnull(account_tz,-13) HOUR)) >= '${bf_60_dt}'
    and date(DATE_ADD(a.install_date, INTERVAL ifnull(account_tz,-13) HOUR)) <= '${dt}'
    and b.IsDelete =0
),
af as (
    select
        date(DATE_SUB(install_date, INTERVAL 13 HOUR)) AS dt,
        a.product_id,
        a.ad_id,
        count(distinct unique_cd_reader_id) as af
    from ads.ads_advertisement_if_user_attribution_queue_view a
    left join ads.ads_advertisement_adext_view b
    on a.ad_id = b.ad_id
    where date(DATE_ADD(install_date, INTERVAL ifnull(account_tz,-13) HOUR)) >= '${bf_60_dt}'
    and date(DATE_ADD(install_date, INTERVAL ifnull(account_tz,-13) HOUR)) <= '${dt}'
    GROUP BY 1,2,3
    order by 1,2,3
),
attribution as (
    select
        date(DATE_SUB(a.install_date, INTERVAL 13 HOUR)) AS dt,
        a.product_id,
        a.ad_id,
        count(distinct a.unique_cd_reader_id) as attribution
    from ads.ads_advertisement_if_user_attribution_queue_view a
    inner join ods.ods_sharpengine_ads_hk_bak_if_user_installreferrer b
    on a.id=b.Id
    left join ads.ads_advertisement_adext_view c
    on a.ad_id = c.ad_id
    where date(DATE_ADD(a.install_date, INTERVAL ifnull(account_tz,-13) HOUR)) >= '${bf_60_dt}'
    and date(DATE_ADD(a.install_date, INTERVAL ifnull(account_tz,-13) HOUR)) <= '${dt}'
    and b.IsDelete =0
    GROUP BY 1,2,3
    order by 1,2,3
),
dpt as (
    select
        dt,
        product_id,
        ad_id,
        count(distinct unique_cd_reader_id) as dpt
    from(
        select
            date(DATE_SUB(a.install_date, INTERVAL 13 HOUR)) AS dt,
            a.product_id,
            a.ad_id,
            a.unique_cd_reader_id,
            a.install_date,
            a.last_click_time,
            if(a.source=z1.source,1,0) as x
        from ads.ads_advertisement_if_user_attribution_queue_view a
        left join z1
        on a.unique_cd_reader_id=z1.unique_cd_reader_id and a.ad_id = z1.ad_id
        left join ads.ads_advertisement_adext_view b
        on a.ad_id = b.ad_id
        where date(DATE_ADD(install_date, INTERVAL ifnull(account_tz,-13) HOUR)) >= '${bf_60_dt}'
        and date(DATE_ADD(install_date, INTERVAL ifnull(account_tz,-13) HOUR)) <= '${dt}'
--         and a.attributed = 0
    ) a where x = 0
    group by 1, 2, 3
),
ast as (
    select
        z2.dt,
        z2.product_id,
        z2.ad_id,
        count(distinct z2.unique_cd_reader_id) as ast
    from z2
    inner join z3
    on z2.unique_cd_reader_id = z3.unique_cd_reader_id and z2.source != z3.source and ABS(UNIX_TIMESTAMP(z2.install_date) - UNIX_TIMESTAMP(z3.install_date)) <= 300
    where z2.last_click_time <= z3.last_click_time
    group by 1,2,3
),
a AS (
	SELECT
      u.InstallDate,
      u.InstallDateEst AS Dt,
      u.ProductId,
      u.Mt,
      u.Core,
      u.UserId,
      u.AdId,
      u.UserType,
      sum( CASE WHEN datediff ( date( DATE_ADD( p.CreateTime, INTERVAL ifnull(account_tz,-13) HOUR ) ), u.InstallDateEst )< 1 THEN p.BaseAmount ELSE 0 END ) AS D0Amount,
      sum( CASE WHEN datediff ( date( DATE_ADD( p.CreateTime, INTERVAL ifnull(account_tz,-13) HOUR ) ), u.InstallDateEst )< 4 THEN p.BaseAmount ELSE 0 END ) AS D3Amount,
      sum( CASE WHEN datediff ( date( DATE_ADD( p.CreateTime, INTERVAL ifnull(account_tz,-13) HOUR ) ), u.InstallDateEst )< 8 THEN p.BaseAmount ELSE 0 END ) AS D7Amount
    FROM (
      SELECT
        a1.InstallDate,
        a1.InstallDateEst,
        a1.ProductId,
        a1.Mt,
        a1.Core,
        a1.UserId,
        a1.UniqueCdReaderId,
        a1.account_tz,
        a1.AdId,
        a1.Rn,
      CASE

            WHEN a2.create_time >= a1.InstallDateBegin
            AND a2.create_time <= a1.InstallDateEnd THEN
              'New'
              WHEN a2.create_time < a1.InstallDateBegin THEN
              'Rmt'
            END AS UserType
          FROM
            (
            SELECT
              DATE_ADD( InstallDate, INTERVAL ifnull(account_tz,-13) HOUR ) InstallDate,
              DATE_ADD( InstallDate, INTERVAL - 1 HOUR ) InstallDateBegin,
              DATE_ADD( InstallDate, INTERVAL 24 HOUR ) InstallDateEnd,
              DATE_FORMAT( DATE_ADD( InstallDate, INTERVAL ifnull(account_tz,-13) HOUR ), '%Y-%m-%d' ) InstallDateEst,
              ProductId,
              AdId,
              Mt,
              Core,
              UserId,
              UniqueCdReaderId,
              account_tz,
              row_number () over (
                PARTITION BY ProductId,
                UserId,
                DATE_FORMAT( DATE_ADD( InstallDate, INTERVAL ifnull(account_tz,-13) HOUR ), '%Y-%m-%d' )
                      ORDER BY
                      CASE
                          WHEN Source IN ( 'fbs2s', 'facebook', 'tt', 'appleadservice', 'fixadinfo', 'sem', 'adwords', 'inmobidsp_int', 'applovin_int', 'mintegral_int', 'snapchat', 'kwaiforbusiness_int', 'tiktokglobal_int', 'moloco_int'  ) THEN
                          3
                          WHEN source IN ( 'officialsite', '(not set)' ) THEN
                          2 ELSE 1
                      END DESC,
                      InstallDate
              ) AS Rn
                  FROM (
                      select InstallDate,ProductId,AdId,Mt,Core,UserId,UniqueCdReaderId,Source
                      from ods.ods_sharpengine_ads_hk_bak_if_user_installreferrer
                      where IsDelete = 0 and InstallDate >= '${bf_62_dt}'
                  ) devtb
                  LEFT JOIN (select account_tz,ad_id as ExtAdId from ads.ads_advertisement_adext_view) adext on adext.ExtAdId = devtb.AdId
                  WHERE date(DATE_ADD(InstallDate, INTERVAL ifnull(account_tz,-13) HOUR)) >= '${bf_60_dt}'
                  and date(DATE_ADD(InstallDate, INTERVAL ifnull(account_tz,-13) HOUR)) <= '${dt}'
            ) a1
            LEFT JOIN (
                SELECT product_id, user_id, create_time FROM dim.dim_short_video_user_accountinfo
                union all
                SELECT product_id, id, create_time FROM dim.dim_user_account_info_view
                union all
        	    select product_id, id, DATE_ADD( create_time, INTERVAL - 13 HOUR ) CreateTime from dim.dim_hallow_user_account_info_view
            ) a2 ON a1.ProductId = a2.product_id and a1.UserId = a2.user_id
          WHERE
            a1.RN = 1
            AND a1.AdId IS NOT NULL
            AND a1.AdId != '' UNION
          SELECT
            q.InstallDate,
            q.InstallDateEst,
            q.product_id,
            q.Mt,
            q.Core,
            q.UserId,
            q.unique_cd_reader_id,
            q.account_tz,
            q.ad_id,
            0 AS Rn,
            'Dpt' AS UserType
          FROM
            (
            SELECT
              q1.product_id,
              q1.Core,
              q1.Mt,
              q1.unique_cd_reader_id,
              q1.account_tz,
            CASE
                  WHEN q1.user_id < 5 THEN
                q2.id ELSE q1.user_id
              END AS UserId,
              q1.InstallDateEst,
              q1.ad_id,
              q1.InstallDate
            FROM
              (
              SELECT
                product_id,
                Core,
                Mt,
                unique_cd_reader_id,
                account_tz,
                ad_id,
                user_id,
                DATE_FORMAT( DATE_ADD( install_date, INTERVAL ifnull(account_tz,-13) HOUR ), '%Y-%m-%d' ) InstallDateEst,
                min(
                DATE_ADD( install_date, INTERVAL ifnull(account_tz,-13) HOUR )) AS InstallDate
              FROM (
                  select install_date,product_id,ad_id,Mt,Core,user_id,unique_cd_reader_id
                 from ads.ads_advertisement_if_user_attribution_queue_view
                 where is_delete = 0 and install_date >= '${bf_62_dt}'
                AND Source IN ( 'fbs2s', 'facebook', 'tt', 'appleadservice', 'fixadinfo', 'sem', 'adwords', 'officialsite', 'inmobidsp_int', 'applovin_int', 'mintegral_int', 'snapchat', 'kwaiforbusiness_int', 'tiktokglobal_int', 'moloco_int'  )
              ) devtb
              LEFT JOIN (select account_tz,ad_id as ExtAdId from ads.ads_advertisement_adext_view) adext on adext.ExtAdId = devtb.ad_id
              WHERE date(DATE_ADD(install_date, INTERVAL ifnull(account_tz,-13) HOUR)) >= '${bf_60_dt}'
                  and date(DATE_ADD(install_date, INTERVAL ifnull(account_tz,-13) HOUR)) <= '${dt}'
              GROUP BY 1, 2, 3, 4, 5, 6, 7, 8
              ) q1
              LEFT JOIN (
              SELECT unique_cdreader_id, corever, max(user_id) as id FROM dim.dim_short_video_user_accountinfo GROUP BY 1, 2
                union all
                SELECT unique_cdreader_id, corever, max(id) FROM dim.dim_user_account_info_view GROUP BY 1, 2
              ) q2 ON q1.unique_cd_reader_id = q2.unique_cdreader_id
              AND q1.Core = q2.CoreVer
            ) q
            LEFT JOIN (
            SELECT
              DATE_FORMAT( DATE_ADD( InstallDate, INTERVAL ifnull(account_tz,-13) HOUR ), '%Y-%m-%d' ) InstallDateEst,
              UserId,
              ProductId,
              Mt,
              Core
            FROM
              (select InstallDate,ProductId,AdId,Mt,Core,UserId,UniqueCdReaderId,Source
               from ods.ods_sharpengine_ads_hk_bak_if_user_installreferrer
               where IsDelete = 0 and InstallDate >= '${bf_62_dt}') devtb
              LEFT JOIN (select account_tz,ad_id as ExtAdId from ads.ads_advertisement_adext_view) adext on adext.ExtAdId = devtb.AdId
            WHERE date(DATE_ADD(InstallDate, INTERVAL ifnull(account_tz,-13) HOUR)) >= '${bf_60_dt}'
                  and date(DATE_ADD(InstallDate, INTERVAL ifnull(account_tz,-13) HOUR)) <= '${dt}'
            GROUP BY 1, 2, 3, 4, 5
            ) m ON q.product_id = m.ProductId
            AND q.Mt = m.Mt
            AND q.Core = m.Core
            AND q.UserId = m.UserId
            AND q.InstallDateEst >= DATE_ADD( m.InstallDateEst, INTERVAL - 2 DAY )
            AND q.InstallDateEst <= DATE_ADD( m.InstallDateEst, INTERVAL 2 DAY )
          WHERE
            q.ad_id IS NOT NULL
            AND q.ad_id != ''
            AND m.UserId IS NULL
          ) u
          LEFT JOIN (
          SELECT
            ProductId,
            Core,
            OsType,
            UserId,
            BaseAmount/100 BaseAmount,
            CreateTime
          FROM ods.ods_tidb_sharpenginepaycenter_hk_payorder
          WHERE
            TestFlag = 0
            AND BaseAmount > 0
            AND OrderStatus = 1
            AND CreateTime >= '${bf_62_dt}'
          ) p ON u.ProductId = p.ProductId
          AND u.Core = p.Core
          AND u.Mt = p.OsType
          AND u.UserId = p.UserId
          AND DATE_ADD( p.CreateTime, INTERVAL ifnull(account_tz,-13) HOUR ) >= u.InstallDate
      GROUP BY 1, 2, 3, 4, 5, 6, 7, 8
)
select
    ifnull(a.dt, b.dt) as dt,
    md5(concat(ifnull(a.ProductId, b.product_id),ifnull(a.AdId, b.ad_id))) as md5_key,
    ifnull(a.ProductId, b.product_id) as product_id,
    ifnull(a.AdId, b.ad_id) as ad_id,
    ifnull(a.UserNum, 0) as user_num,
    ifnull(a.NewNum, 0) as new_num,
    ifnull(a.RmtNum, 0) as rmt_num,
    ifnull(b.af, 0) as af,
    ifnull(b.attribution, 0) as attribution,
    ifnull(b.net_dpt, 0) as net_dpt,
    ifnull(b.ast, 0) as ast,
    ifnull(a.NewD0Amount, 0) as new_d0_amount,
    ifnull(a.RmtD0Amount, 0) as rmt_d0_amount,
    ifnull(a.NewD3Amount, 0) as new_d3_amount,
    ifnull(a.RmtD3Amount, 0) as rmt_d3_amount,
    ifnull(a.NewD7Amount, 0) as new_d7_amount,
    ifnull(a.RmtD7Amount, 0) as rmt_d7_amount,
    now() as etl_time
from (
    SELECT
        a.dt,
        a.ProductId,
        a.AdId,
        count( DISTINCT UserId ) AS UserNum,
        count( CASE WHEN UserType = 'New' THEN UserId END ) AS NewNum,
        count( CASE WHEN UserType = 'Rmt' THEN UserId END ) AS RmtNum,
        sum(( UserType = 'New' )* D0Amount ) NewD0Amount,
        sum(( UserType = 'Rmt' )* D0Amount ) RmtD0Amount,
        sum(( UserType = 'New' )* D3Amount ) NewD3Amount,
        sum(( UserType = 'Rmt' )* D3Amount ) RmtD3Amount,
        sum(( UserType = 'New' )* D7Amount ) NewD7Amount,
        sum(( UserType = 'Rmt' )* D7Amount ) RmtD7Amount
    FROM a
    GROUP BY 1, 2, 3
) a
full join (
    select
        a.dt,
        a.product_id,
        a.ad_id,
        a.af,
        ifnull(b.attribution, 0) as attribution,
        ifnull(c.dpt, 0)-ifnull(d.ast, 0) as net_dpt,
        ifnull(d.ast, 0) as ast
    from af a
    left join attribution b on a.dt = b.dt and a.product_id = b.product_id and a.ad_id = b.ad_id
    left join dpt c on a.dt = c.dt and a.product_id = c.product_id and a.ad_id = c.ad_id
    left join ast d on a.dt = d.dt and a.product_id = d.product_id and a.ad_id = d.ad_id
) b
on a.dt = b.dt and a.ProductId = b.product_id and a.AdId = b.ad_id
where ifnull(a.AdId, b.ad_id) is not null;
