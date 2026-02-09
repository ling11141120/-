insert into ads.ads_syncbi_book_newcid_rank_info
-- ----------------yesterday ---------------------
select
    '${bf_1_dt}' as dt,
    1 as time_types,
    a.language_id,
    a.book_id,
    a.book_name,
    a.introduce,
    a.newc_id,
    a.newc_name,
    a.sign_type,
    now() as etl_time,
    a.build_time,
    a.author_name,
    group_concat(tag order by tag separator ', ') as tag
from (
    select
        product_id,
        language_id,
        a.book_id,
        book_name,
        introduce,
        newc_id,
        newc_name,
        sign_type,
        build_time,
        author_name,
        ROW_NUMBER() over (partition by language_id,newc_id order by if(sign_type = -1, 4, sign_type),build_time desc) as ranks
    from dim.dim_novel_book_info_view a
    left join (
        select distinct book_id from dim.dim_tag_book_info_view where tag_id in(
            select id from dim.dim_tag_config_view where is_delete = 0 and (tag like '%18%' or tag like '%19%') and site_id not in(409, 410, 418, 433, 414, 0, 446, 450)
        ) and is_delete = 0 and book_id = 17589409
    ) b on a.book_id = b.book_id
    where build_time >= '${bf_1_dt}'
    and build_time < '${dt}'
    and sign_type in (0, 1, 2, -1)
    and sexy2 = 0
    and newc_id in (20007, 20008, 20005, 20010, 20011, 20012, 10005, 10003, 10001)
    and product_id != 3333 and b.book_id is null and a.book_id = 17589409
) a
left join (
    select
        product_id,
        tag_id,
        book_id
    from dim.dim_tag_book_info_view
    where is_delete = 0
) b on a.product_id = b.product_id and a.book_id  = b.book_id
left join (
    select
        product_id,
        id,
        tag
    from dim.dim_tag_config_view
    where is_delete = 0
) c on b.product_id = c.product_id and b.tag_id = c.id
where ranks <= 20
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
union all
-- ----------3333------yesterday ---------------------
select
    '${bf_1_dt}' as dt,
    1 as time_types,
    a.language_id,
    a.book_id,
    a.book_name,
    a.introduce,
    a.newc_id,
    a.newc_name,
    a.sign_type,
    now() as etl_time,
    a.build_time,
    a.author_name,
    group_concat(tag order by tag separator ', ') as tag
from (
    select
        product_id,
        language_id,
        a.book_id,
        book_name,
        introduce,
        newc_id,
        newc_name,
        if(sign_type is null ,9999,sign_type) as sign_type,
        build_time,
        author_name,
        ROW_NUMBER () over(partition by language_id,newc_id order by build_time desc ) as ranks
    from dim.dim_novel_book_info_view a
    left join (
        select distinct book_id from dim.dim_tag_book_info_view where tag_id in(
            select id from dim.dim_tag_config_view where is_delete = 0 and (tag like '%18%' or tag like '%19%') and site_id not in(409, 410, 418, 433, 414, 0, 446, 450)
        ) and is_delete = 0
    ) b on a.book_id = b.book_id
    where build_time>='${bf_1_dt}' and build_time<'${dt}'
--  and sign_type in (0,1,2,-1)
    and sexy2  =0
    and newc_id in (20002,20011,20007,20008,20014,21001,10002,10001,10008)
    and product_id =3333 and b.book_id is null
) a
left join (
    select
        product_id,
        tag_id,
        book_id
    from dim.dim_tag_book_info_view
    where is_delete = 0
) b on a.product_id = b.product_id and a.book_id  = b.book_id
left join (
    select
        product_id,
        id,
        tag
    from dim.dim_tag_config_view
    where is_delete = 0
) c on b.product_id = c.product_id and b.tag_id = c.id
where ranks <= 20
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
union all
-- ------------history---------------------------------
select
    '${bf_1_dt}' as dt,
    2 as time_types,
    a.language_id,
    a.book_id,
    a.book_name,
    a.introduce,
    a.newc_id,
    a.newc_name,
    a.sign_type,
    now() as etl_time,
    a.build_time,
    a.author_name,
    group_concat(tag order by tag separator ', ') as tag
from (
    select
        product_id,
        language_id,
        a.book_id,
        book_name,
        introduce,
        newc_id,
        newc_name,
        sign_type,
        build_time,
        author_name,
        ROW_NUMBER () over(partition by language_id,newc_id order by if(sign_type=-1 ,4 ,sign_type),build_time desc ) as ranks
    from dim.dim_novel_book_info_view a
    left join (
        select distinct book_id from dim.dim_tag_book_info_view where tag_id in(
            select id from dim.dim_tag_config_view where is_delete = 0 and (tag like '%18%' or tag like '%19%') and site_id not in(409, 410, 418, 433, 414, 0, 446, 450)
        ) and is_delete = 0
    ) b on a.book_id = b.book_id
    where build_time>= date_sub('${dt}',interval 1 year) and build_time<'${dt}'
    and sign_type in (0,1,2,-1)
    and sexy2 =0
    and newc_id in (20007,20008,20005,20010,20011,20012,10005,10003,10001)
    and product_id !=3333 and b.book_id is null
) a
left join (
    select
        product_id,
        tag_id,
        book_id
    from dim.dim_tag_book_info_view
    where is_delete = 0
) b on a.product_id = b.product_id and a.book_id  = b.book_id
left join (
    select
        product_id,
        id,
        tag
    from dim.dim_tag_config_view
    where is_delete = 0
) c on b.product_id = c.product_id and b.tag_id = c.id
where ranks <= 20
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
union all
-- -------3333-----history---------------------------------
select
    '${bf_1_dt}' as dt,
    2 as time_types,
    a.language_id,
    a.book_id,
    a.book_name,
    a.introduce,
    a.newc_id,
    a.newc_name,
    a.sign_type,
    now() as etl_time,
    a.build_time,
    a.author_name,
    group_concat(tag order by tag separator ', ') as tag
from (
    select
        product_id,
        language_id,
        a.book_id,
        book_name,
        introduce,
        newc_id,
        newc_name,
        if(sign_type is null ,9999,sign_type) as sign_type,
        build_time,
        author_name,
        ROW_NUMBER () over(partition by language_id,newc_id order by build_time desc ) as ranks
    from dim.dim_novel_book_info_view a
    left join (
        select distinct book_id from dim.dim_tag_book_info_view where tag_id in(
            select id from dim.dim_tag_config_view where is_delete = 0 and (tag like '%18%' or tag like '%19%') and site_id not in(409, 410, 418, 433, 414, 0, 446, 450)
        ) and is_delete = 0
    ) b on a.book_id = b.book_id
    where build_time>= date_sub('${dt}',interval 1 year) and build_time<'${dt}'
--  and sign_type in (0,1,2,-1)
    and sexy2  =0
    and newc_id in (20002,20011,20007,20008,20014,21001,10002,10001,10008)
    and product_id =3333 and b.book_id is null
) a
left join (
    select
        product_id,
        tag_id,
        book_id
    from dim.dim_tag_book_info_view
    where is_delete = 0
) b on a.product_id = b.product_id and a.book_id  = b.book_id
left join (
    select
        product_id,
        id,
        tag
    from dim.dim_tag_config_view
    where is_delete = 0
) c on b.product_id = c.product_id and b.tag_id = c.id
where ranks <= 20
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12;