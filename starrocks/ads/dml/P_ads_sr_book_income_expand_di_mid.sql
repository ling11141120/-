----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_book_income_expand_di_mid
-- workflow_version : 7
-- create_user      : linq
-- task_name        : tbl_ads_sr_book_income_expand_di_mid
-- task_version     : 3
-- update_time      : 2025-07-07 16:12:15
-- sql_path         : \starrocks\tbl_ads_sr_book_income_expand_di_mid\tbl_ads_sr_book_income_expand_di_mid
----------------------------------------------------------------
-- SQL语句
insert overwrite ads.ads_sr_book_income_expand_di_mid
with base_book as(
    select product_id,book_id,lang_id,author_id,book_name,book_code,is_put_down,put_down_level,author_name,author_type
    from(
        select product_id,book_id,languageid as lang_id,author_id,book_name,book_code,
               is_put_down,put_down_level,coalesce(author_name,pen_name) as author_name,author_type,sign_type,latest_update_time
        from dim.dim_shuangwen_book_read_consume_info a
        where product_id!=3333
        union all
        select 3333 as product_id,concat(b.BookId,b.SiteId) as book_id,Language as lang_id,AuthorId as author_id,BookName as book_name,BookCode as book_code,
               IsPutdown as is_put_down,PutdownLevel as put_down_level,coalesce(AuthorName,c.penname) as author_name,c.AuthorType as author_type,SignType,d.LatestUpdateTime
        from ods.ods_edit_book b
        left join (
            select AccountId,PenName,AuthorType
            from ods.ods_edit_author
            where productid =3366
            )c on b.AuthorId=c.AccountId
        left join(
            select BookID,LatestUpdateTime from ods.ods_book_novel_book_m where productid=3333
            ) d on concat(b.BookId,b.SiteId)=d.BookID
        where b.SiteId=450
    )d
),

book_tmp AS (
       select c.product_id,concat(c.ChannelBookId,c.SiteId) as trans_book_id,2 as book_type,c.Language as lang_id,c.AuthorId as author_id,base_book.book_name,
               base_book.book_code,base_book.is_put_down,base_book.put_down_level,author.penname,author.AuthorType
        from ods.ods_tidb_shuangwen_book_channel_income_config c
                 left join ods.ods_edit_author author on c.product_id=author.ProductId and c.authorid=author.AccountId
                 left join base_book on concat(c.ChannelBookId,c.SiteId)=base_book.book_id
        where DelFlag=0
)
select product_id,book_id,book_type,lang_id,author_id,book_name,book_code,is_put_down,put_down_level,author_name,author_type,
       now() as etl_time
from(
        select product_id,book_id,1 as book_type,lang_id,author_id,book_name,book_code,is_put_down,put_down_level,author_name,author_type
        from base_book where author_type=4 -- -----创作者联盟-------------
        union all
        SELECT * FROM book_tmp WHERE AuthorType = 4
    )t1;
