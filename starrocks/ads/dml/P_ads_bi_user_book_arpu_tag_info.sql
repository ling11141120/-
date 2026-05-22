----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_user_book_arpu_tag_info
-- workflow_version : 12
-- create_user      : yanxh
-- task_name        : ads_bi_user_book_arpu_tag_info
-- task_version     : 7
-- update_time      : 2025-04-01 20:10:56
-- sql_path         : \starrocks\tbl_ads_bi_user_book_arpu_tag_info\ads_bi_user_book_arpu_tag_info
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_bi_user_book_arpu_tag_info
with read_info as (
    select  site_id,book_id,sum(read_unt) read_unt
    from(
            select dt,site_id,book_id,is_source,max(first_read_cnt) read_unt
            from ads.ads_book_read_consume_inte_instation where dt >='2023-01-01' and   dt<'${dt}' and site_id!=777
            group by 1,2,3,4
        )  a
    group by 1 ,2
),
tmp_y AS (
    select  enum_id,remarks as lang_id from dim.dim_dic where dic_column ='site_id'
)

select '${dt}' as dt,ifnull(a.lang_id,-99) as lang_id,a.book_id,
       round(if(a.D0_source=0,1,a.D0_source)/read_info.read_unt,2) as latest_book_d0_ad_coins ,
       round(if(a.D0_not_source=0,1,a.D0_not_source)/read_info.read_unt,2) as latest_book_d0_base_coins,
       round(if(a.D0_total=0,1,a.D0_total)/read_info.read_unt,2) as  latest_book_d0_coins,
       round(if(a.D7_source=0,1,a.D7_source)/read_info.read_unt,2) as latest_book_d7_ad_coins ,
       round(if(a.D7_not_source=0,1,a.D7_not_source)/read_info.read_unt,2) as latest_book_d7_base_coins,
       round(if(a.D7_total=0,1,a.D7_total)/read_info.read_unt,2) as  latest_book_d7_coins,
       round((if(a.D7_source=0,1,a.D7_source)/read_info.read_unt)/(if(a.D0_source=0,1,a.D0_source)/read_info.read_unt),2) as  latest_book_d7_d0_ad_coins,
       round((if(a.D7_not_source=0,1,a.D7_not_source)/read_info.read_unt)/(if(a.D0_not_source=0,1,a.D0_not_source)/read_info.read_unt),2) as  latest_book_d7_d0_base_coins,
       round((if(a.D7_total=0,1,a.D7_total)/read_info.read_unt)/(if(a.D0_total=0,1,a.D0_total)/read_info.read_unt),2) as latest_book_d7_d0_coins
        ,now() as etl_tm

from
    (
-- ------------------------计算书籍消耗数据---------------------------------
        select x.site_id,x.book_id,y.lang_id,
               sum(CASE WHEN  x.is_source=1 THEN x.D0_consume_amount ELSE 0 END) as D0_source,
               sum(CASE WHEN  x.is_source=0 THEN x.D0_consume_amount ELSE 0 END) as D0_not_source,
               sum(CASE WHEN x.is_source in (0,1) THEN x.D0_consume_amount ELSE 0 END) as D0_total,
               sum(CASE WHEN x.is_source=1 THEN x.D7_consume_amount ELSE 0 END ) as D7_source,
               sum(CASE WHEN x.is_source=0 THEN x.D7_consume_amount ELSE 0 END) as D7_not_source,
               sum(CASE WHEN x.is_source in (0,1) THEN x.D7_consume_amount ELSE 0 END) as D7_total
        from   ads.ads_book_read_consume_inte_instation x
        left join tmp_y y
               on x.site_id=y.enum_id
        where  x.dt >='2023-01-01' and  x.dt<'${dt}'  and   x.site_id!=777
        group by 1,2 ,3
    )  a
left join  read_info -- ----------------获取书的首次阅读时间及阅读人数----------------------------
 on a.site_id=read_info.site_id
 and a.book_id=read_info.book_id;
