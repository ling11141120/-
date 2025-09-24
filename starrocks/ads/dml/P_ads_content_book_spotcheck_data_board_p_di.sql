-- 打P0标签
insert into ads.ads_content_book_spotcheck_data_board_p_di       -- 过滤出角色类型为二校、质检、一校抽查、三校抽查的数据
with tmp_book as (
    select concat(a.productid,a.id)              as unique_id
          ,a.*
      from ods.ods_edit_book_remunerationdetail  as a
     where date(a.createtime) = '${bf_1_dt}'
       and a.roletype in (3,10,11,12)
 )              -- 书籍相关信息
    ,realtime_remuneration as (
select
    a.unique_id,
    date(a.createtime) as dt,
    a.bookid*1000 + a.tolanguage as book_id,
    a.createtime as create_time,
    c.bookcode as book_code,
    c.bookname as book_name,
    a.tolanguage as language_id,
    case a.tolanguage
    when 333 then '繁体'
    when 322 then '英语'
    when 375 then '西语'
    when 409 then '葡语'
    when 410 then '法语'
    when 412 then '德语'
    when 413 then '意大利语'
    when 414 then '印尼语'
    when 415 then '阿拉伯语'
    when 418 then '俄语'
    when 419 then '日语'
    when 433 then '泰语'
    when 435 then '越南语'
    when 436 then '韩语'
    when 445 then '菲律宾语'
    when 447 then '印地语'
    when 448 then '孟加拉语'
    when 495 then '马来西亚语'
    when 497 then '土耳其语'
    when 0 then '简体'
    else ''  end as language_name,
    a.roletype as role_type,
    a.fontlength as spot_check_words,
    d.chaptername as chapter_name,
    b.penname as author_name,
    b.realname as real_name
from tmp_book a
    left join ods.ods_tidb_shuangwen_xx_objectauthor b
on  a.productid = b.productid
    and a.authorid = b.accountid
    and a.tolanguage = b.tolanguage
    left join ods.ods_tidb_shuangwen_en_objectbook c
    on  a.productid = c.productid
    and a.bookid = c.swbookid
    and a.tolanguage = c.tolanguage
    and c.status = 1
    left join ods.ods_tidb_shuangwen_xx_objectchapter d
    on  a.productid = d.productid
    and c.id = d.objectbookid
    and a.chapterid = d.id
    ),

-- 最近60天进过三阶的书
    stage3_before_60d as (
select  book_id,language_id
from
    (select
    codeid as book_id,
    currentlanguage as language_id,
    row_number () over (partition by codeid order by begindate desc) as rank_num                   -- 一本书可能近60天多次进3队，取最近的一条数据
    from ods.ods_tidb_ad_sharpengine_ads_global_marketingplan
    where codestage = 3                                                                                -- 进过3阶
    and datediff(current_date(), begindate) <= 60                                                    -- 近60天进过3阶
    ) a
where a.rank_num = 1
    ),
-- 最近60天进过三阶繁体书
    stage3_ft_source_tmp as (
select
    a.book_id as book_id,
    b.book_code as book_code
from stage3_before_60d a
    inner join dim.dim_shuangwen_book_read_consume_info b
on a.book_id = b.book_id
where a.language_id = 2                                                                                     -- 最近60天进过3阶的繁体书
    ),
-- 最近60天进过三阶的英语书
    stage3_en_source_tmp as (
select
    a.book_id as book_id,
    b.book_code as book_code
from stage3_before_60d a
    inner join dim.dim_shuangwen_book_read_consume_info b
on a.book_id = b.book_id
where a.language_id = 3                                                                                     -- 最近60天进过3阶的英语书
    ),

    p0_book_id_tmp as (
-- 对于繁体源头书，通过书籍代号找到它的英语衍生书
select
    a.book_id
from ads.ads_report_book_capacity_rate_stat a
    inner join stage3_ft_source_tmp b
on a.book_code = b.book_code
where a.dt = '${bf_1_dt}'
  and a.publish_length <= 200000                                                                          -- 发布字数小于20万
  and a.site_id =  322                                                                                    -- 繁体书的衍生书为英语的
  and a.font_length_curmonth > 0                                                                          -- 本月精修字数大于0
union
-- 对于英语源头书，通过书籍代号找到它的小语衍生书
select
    a.book_id
from ads.ads_report_book_capacity_rate_stat a
    inner join stage3_en_source_tmp b
on a.book_code = b.book_code
where a.dt = '${bf_1_dt}'
  and a.publish_length <= 200000                                                                          -- 发布字数小于20万
  and a.site_id !=  322                                                                                   -- 英语源头书的衍生书为除英语外的其它小语言
  and a.font_length_curmonth > 0                                                                          -- 本月精修字数大于0
    )

select
    a.unique_id,
    a.dt,
    a.book_id,
    a.create_time,
    ifnull(a.book_code,c.book_code),
    ifnull(a.book_name,c.book_name),
    a.language_name,
    'P0' as p_level,
    a.role_type,
    a.spot_check_words,
    a.chapter_name,
    a.author_name,
    a.real_name,
    now()
from realtime_remuneration a
         inner join p0_book_id_tmp p0
                    on a.book_id  = p0.book_id
         left join dim.dim_shuangwen_book_read_consume_info c
                   on a.book_id = c.book_id
