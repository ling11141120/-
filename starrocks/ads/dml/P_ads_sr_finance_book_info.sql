----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_srsv_finance_book_info
-- workflow_version : 3
-- create_user      : chenmo
-- task_name        : ads_sr_finance_book_info
-- task_version     : 2
-- update_time      : 2025-03-19 16:59:40
-- sql_path         : \starrocks\tbl_ads_srsv_finance_book_info\ads_sr_finance_book_info
----------------------------------------------------------------
-- SQL语句
-- TODO 书籍明细字段需求
insert overwrite ads.ads_sr_finance_book_info
select
    a.product_id as '产品id',
    a.book_id as '书籍id',
    b.ProductTypeName as '产品名称',
    a.book_code as '书籍代号',
    a.book_name as '书籍名称',
    a.normal_chapter_num_f as '总章节数',
    a.font_length as '总字数',
    a.site_id2 as '语言id',
    c.abbreviation as '语言',
    a.site_id,
    case when a.site_id in(446, 449) then '新掌中'
        when a.site_id = 090 then '凤鸣轩'
        else '未知'
    end as '新掌中/凤鸣轩',
    a.new_cid as '分类id',
    a.new_cname as '分类名称',
    a.book_nature as '书籍类型id',
    case when a.book_nature = 1 then '机翻'
        when a.book_nature = 2 then '人工'
        when a.book_nature = 3 then '原创'
        when a.book_nature = 4 then 'cp'
        when a.book_nature = 5 then '原创拆章'
        when a.book_nature = 6 then '翻译拆章'
        when a.book_nature = 7 then '原创图书'
        when a.book_nature = 8 then '定制文'
        when a.book_nature = 9 then 'cp翻译'
        when a.book_nature = 0 then '未知'
    end as '书籍类型',
    a.author_id,
    a.author_name,
    a.sexy2 as '上下架id',
    case when a.sexy2 >= 4 then '下架'
        when a.sexy2 < 4 then '上架'
        else '未知'
    end as '上下架状态',
    a.build_time as '上下架日期',
    now() as etl_time
from dim.dim_shuangwen_book_read_consume_info a
left join dim.DIM_ProductType b
on a.product_id = b.Productid
left join dim.DIM_ProductType c
on a.site_id2 = c.book_langid
where book_name not like '%短剧%'
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总
-- workflow_version : 36
-- create_user      : chenmo
-- task_name        : 海阅书籍明细
-- task_version     : 2
-- update_time      : 2026-02-16 11:47:07
-- sql_path         : \starrocks\审计测试-总\海阅书籍明细
----------------------------------------------------------------
-- SQL语句
-- 海阅
drop table ads.ads_sr_finance_book_info_1;

-- SQL语句
create table ads.ads_sr_finance_book_info_1 like ads.ads_sr_finance_book_info;

-- SQL语句
-- 书籍明细字段需求
insert into ads.ads_sr_finance_book_info
select
    a.product_id as '产品id',
    a.book_id as '书籍id',
    b.ProductTypeName as '产品名称',
    a.book_code as '书籍代号',
    a.book_name as '书籍名称',
    a.normal_chapter_num_f as '总章节数',
    a.font_length as '总字数',
    a.site_id2 as '语言id',
    c.abbreviation as '语言',
    a.site_id,
    case when a.site_id in(446, 449) then '新掌中'
        when a.site_id = 090 then '凤鸣轩'
        else '未知'
    end as '新掌中/凤鸣轩',
    a.new_cid as '分类id',
    a.new_cname as '分类名称',
    a.book_nature as '书籍类型id',
    case when a.book_nature = 1 then '机翻'
        when a.book_nature = 2 then '人工'
        when a.book_nature = 3 then '原创'
        when a.book_nature = 4 then 'cp'
        when a.book_nature = 5 then '原创拆章'
        when a.book_nature = 6 then '翻译拆章'
        when a.book_nature = 7 then '原创图书'
        when a.book_nature = 8 then '定制文'
        when a.book_nature = 9 then 'cp翻译'
        when a.book_nature = 0 then '未知'
    end as '书籍类型',
    a.author_id,
    a.author_name,
    a.sexy2 as '上下架id',
    case when a.sexy2 >= 4 then '下架'
        when a.sexy2 < 4 then '上架'
        else '未知'
    end as '上下架状态',
    a.build_time as '上下架日期',
    if(a.create_time <= '2024-07-01', '2024-06-30', a.create_time) as create_time,
    now() as etl_time
from dim.dim_shuangwen_book_read_consume_info a
left join dim.DIM_ProductType b
on a.product_id = b.Productid
left join dim.DIM_ProductType c
on a.site_id2 = c.book_langid
where book_name not like '%短剧%' and (book_name not rlike '作废|废弃|测试|文案书|素材' or book_id = 8071419)
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总_改
-- workflow_version : 11
-- create_user      : xiejc
-- task_name        : 海阅书籍明细
-- task_version     : 3
-- update_time      : 2026-04-08 11:46:36
-- sql_path         : \starrocks\审计测试-总_改\海阅书籍明细
----------------------------------------------------------------
-- SQL语句
-- 海阅
drop table ads.ads_sr_finance_book_info_1;

-- SQL语句
create table ads.ads_sr_finance_book_info_1 like ads.ads_sr_finance_book_info;

-- SQL语句
-- 书籍明细字段需求
insert into ads.ads_sr_finance_book_info
select
    a.product_id as '产品id',
    a.book_id as '书籍id',
    b.ProductTypeName as '产品名称',
    a.book_code as '书籍代号',
    a.book_name as '书籍名称',
    a.normal_chapter_num_f as '总章节数',
    a.font_length as '总字数',
    a.site_id2 as '语言id',
    c.abbreviation as '语言',
    a.site_id,
    case when a.site_id in(446, 449) then '新掌中'
        when a.site_id = 090 then '凤鸣轩'
        else '未知'
    end as '新掌中/凤鸣轩',
    a.new_cid as '分类id',
    a.new_cname as '分类名称',
    a.book_nature as '书籍类型id',
    case when a.book_nature = 1 then '机翻'
        when a.book_nature = 2 then '人工'
        when a.book_nature = 3 then '原创'
        when a.book_nature = 4 then 'cp'
        when a.book_nature = 5 then '原创拆章'
        when a.book_nature = 6 then '翻译拆章'
        when a.book_nature = 7 then '原创图书'
        when a.book_nature = 8 then '定制文'
        when a.book_nature = 9 then 'cp翻译'
        when a.book_nature = 0 then '未知'
    end as '书籍类型',
    a.author_id,
    a.author_name,
    a.sexy2 as '上下架id',
    case when a.sexy2 >= 4 then '下架'
        when a.sexy2 < 4 then '上架'
        else '未知'
    end as '上下架状态',
    a.build_time as '上下架日期',
    if(a.create_time <= '2024-07-01', '2024-06-30', a.create_time) as create_time,
    now() as etl_time
from dim.dim_shuangwen_book_read_consume_info a
left join dim.DIM_ProductType b
on a.product_id = b.Productid
left join dim.DIM_ProductType c
on a.site_id2 = c.book_langid
where book_name not like '%短剧%' and (book_name not rlike '作废|废弃|测试|文案书|素材' or book_id = 8071419)
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21;
