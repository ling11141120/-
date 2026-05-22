----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_translate_book_sale_di
-- workflow_version : 1
-- create_user      : xixg
-- task_name        : ads_content_translate_book_sale_di
-- task_version     : 1
-- update_time      : 2024-09-09 17:14:54
-- sql_path         : \starrocks\tbl_ads_content_translate_book_sale_di\ads_content_translate_book_sale_di
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_content_translate_book_sale_di
with translate_book_amt as (
    select a.dt,a.cn_bookid,a.to_bookid,a.to_langid,money_amt
    from (
             select d.datestr as dt,
                    t1.cn_bookid,
                    t1.to_bookid,
                    t1.to_langid,
                    count(1) over ()
             from dim.dim_sr_object_book_cn_summary_view t1
                      left join dim.dim_date d
                          on d.datestr>=date_sub(date_trunc('month','${dt}'),interval 1 month)
                          and d.datestr<'${dt}'
         ) a
    left join (
                select
                        dt,
                        book_id,
                        sum(amount)/100 as money_amt
                from dws.dws_consume_user_consume_ed
                where dt>=date_sub(date_trunc('month','${dt}'),interval 1 month)
                    and dt<'${dt}'
                    and types=1
                group by 1,2
            )b
        on a.dt=b.dt
        and concat(a.to_bookid,a.to_langid)=b.book_id
),

translate_book_month_amt as (
SELECT date_format(dt, '%Y%m')  as month_int,
       cn_bookid,
       to_bookid,
       to_langid,
       date_format(dt, '%Y-%m') as month_str,
       SUM(money_amt)           as money_amt
from translate_book_amt a
group by date_format(dt, '%Y%m'),
         cn_bookid,
         to_bookid,
         to_langid,
         date_format(dt, '%Y-%m')
order by date_format(dt, '%Y%m'),
         cn_bookid,
         to_bookid
),

translate_book_month_amt_order_by as (
    SELECT
        a.month_int AS month_int,
        a.cn_bookid AS cn_book_id,
        '' AS book_name,
        '' AS book_code,
        a.to_bookid AS to_book_id,
        a.to_langid AS to_langid,
        a.month_str AS month_str,
        '' AS partner_name,
        '' AS company_name,
        a.money_amt AS money_amt
    FROM
        translate_book_month_amt a
    order by
        a.cn_bookid,
        a.to_bookid ,
        a.to_langid ,
        a.month_str
),

cn_book_month_amt_order_by  AS (
     SELECT
            month_int AS month_int,
            cn_book_id AS cn_book_id,
            cn_book_name AS book_name,
            cn_book_code AS book_code,
            '' AS to_book_id,
            1 AS to_langid,
            month_str AS month_str,
            partner_name AS partner_name,
            '福州佳软软件技术有限公司' AS company_name,
            money_amt AS money_amt
    FROM ads.ads_cr_book_month_sale_di a
    WHERE a.month_int >= date_format(date_sub(date_trunc('month','${dt}'),interval 1 month),'%Y%m')
      AND a.month_int <= date_format(date_trunc('month','${dt}'),'%Y%m')
      ORDER BY
      cn_book_id,
      to_book_id ,
      to_langid ,
      month_str

),

all_book AS (
    SELECT
        month_int,
        cn_book_id,
        to_langid,
        book_name,
        book_code,
        to_book_id,
        CASE to_langid
            WHEN 445 THEN '菲律宾语译文'
            WHEN 333 THEN '繁体译文'
            WHEN 322 THEN '英语译文'
            WHEN 375 THEN '西语译文'
            WHEN 409 THEN '葡语译文'
            WHEN 410 THEN '法语译文'
            WHEN 418 THEN '俄语译文'
            WHEN 419 THEN '日语译文'
            WHEN 414 THEN '印尼语译文'
            WHEN 433 THEN '泰语译文'
            WHEN 436 THEN '韩语译文'
            WHEN 0 THEN '简体译文'                                                        -- 0表示中文简体
            ELSE ''
        END AS language_name,
        month_str,
        partner_name,
        company_name,
        money_amt
    FROM translate_book_month_amt_order_by
    UNION ALL
    SELECT
        month_int,
        cn_book_id,
        to_langid,
        book_name,
        book_code,
        to_book_id,

        CASE to_langid
            WHEN 445 THEN '菲律宾语译文'
            WHEN 333 THEN '繁体译文'
            WHEN 322 THEN '英语译文'
            WHEN 375 THEN '西语译文'
            WHEN 409 THEN '葡语译文'
            WHEN 410 THEN '法语译文'
            WHEN 418 THEN '俄语译文'
            WHEN 419 THEN '日语译文'
            WHEN 414 THEN '印尼语译文'
            WHEN 433 THEN '泰语译文'
            WHEN 436 THEN '韩语译文'
            WHEN 0 THEN '简体译文'                                                        -- 0表示中文简体
            ELSE ''
        END AS language_name,
        month_str,
        partner_name,
        company_name,
        money_amt
    FROM cn_book_month_amt_order_by
)

  SELECT
        month_int,
        cn_book_id,
        to_langid,
        CASE
            WHEN book_name is null or book_name = '' then language_name
            ELSE book_name
        END AS book_name,
        book_code,
        month_str,
        partner_name,
        company_name,
        money_amt,
        now()
FROM all_book
order by
	cn_book_id,
	month_int,
	to_langid;
