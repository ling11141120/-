----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_cr_book_sale_di
-- workflow_version : 15
-- create_user      : linq
-- task_name        : ads_cr_book_sale_di
-- task_version     : 10
-- update_time      : 2024-09-11 18:11:37
-- sql_path         : \starrocks\tbl_ads_cr_book_sale_di\ads_cr_book_sale_di
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_cr_book_sale_di where dt>=date_sub(date_trunc('month','${dt}'),interval 1 month) and dt<'${dt}';

-- SQL语句
insert into ads.ads_cr_book_sale_di
with amt as (
    select a.dt,a.cn_bookid,a.to_bookid,a.to_langid,money_amt
    from (
        select d.datestr as dt,t1.cn_bookid,t1.to_bookid,t1.to_langid,count(1) over ()
        from dim.dim_sr_object_book_cn_summary_view t1
        left join dim.dim_date d on d.datestr>=date_sub(date_trunc('month','${dt}'),interval 1 month) and d.datestr<'${dt}'
    ) a
    left join (
        select dt,book_id,sum(amount)/100 as money_amt
        from dws.dws_consume_user_consume_ed
        where dt>=date_sub(date_trunc('month','${dt}'),interval 1 month) and dt<'${dt}' and types=1
        group by 1,2
        )b on a.dt=b.dt and concat(a.to_bookid,a.to_langid)=b.book_id
)
select a.dt, a.cn_bookid,coalesce(c.book_name,'-') as book_name,coalesce(c.book_code,'-') as cn_book_code,
       coalesce(c.block_name,'-') as partner_name,a.to_book_ids,a.money_amt,now() as etl_time
from(
    select dt, cn_bookid, round(sum(money_amt),2) as money_amt,group_concat(distinct concat(to_bookid,to_langid)) as to_book_ids
    from amt
    group by 1,2
)a
-- left join dim.dim_shuangwen_book_read_consume_info b on a.cn_bookid=b.book_id  -- ----繁体书不用，如果有的话，显示null
left join (
    -- 找不到的book去ods_book_novel_book_m里找,注意简体和繁体的去重
    select c1.BookID as book_id,c1.BookName as book_name,c2.book_code,x.BlockName as block_name
    from ods.ods_book_novel_book_m c1
    left join(
        select  BookId ,BookNo as book_code  from ods.ods_tidb_readernovel_tidb_tag_center_book_information where  LangId =2  and BookNo  !=''  group by 1,2
    ) c2 on c1.bookid =c2.bookid
    left join ods.ods_panda_publishermanager x on c1.siteid  = x.siteid
    where productid=8858
)c on a.cn_bookid=c.book_id;
