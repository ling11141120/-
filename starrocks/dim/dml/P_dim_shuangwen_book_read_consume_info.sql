----------------------------------------------------------------
-- 程序功能： 爽文库阅读消耗书籍信息表
-- 程序名： P_dim_shuangwen_book_read_consume_info
-- 目标表： dim.dim_shuangwen_book_read_consume_info
-- 负责人： xjc
-- 开发日期： 2026-03-27
-- 版本号： v1.0
----------------------------------------------------------------

-- ---------------获取用户的免费章节数--------------------------

insert overwrite dim.dim_book_free_chapter_num_temp
select a1.book_id
     ,count(if(a1.free_chapter_num = 0, 1, null))    as free_chapter_num    -- 免费章节数
     ,now()                                         as etl_tm
from (
         -- 法语书籍----
         select (b1.book_id * 1000 + b1.site_id)    as book_id
              ,case when b2.freechapternum = 0 then b1.vip
                    when b2.freechapternum > 0 and b2.freechapternum < b1.serial_number then 1
                    else 0
             end                              as free_chapter_num
         from ods.ods_edit_shuangwen_chapter           as b1
                  left join ods.ods_book_novel_book_m           as b2
                            on (b1.book_id * 1000 + b1.site_id) = b2.bookid
                                and b1.site_id = b2.siteid
                                and b2.productid = 3311
         where b1.productid = 3311
           and b1.site_id in (410,413)
           and b1.status != -1
         union all
         -- 印尼语书籍---
         select (b1.book_id * 1000 + b1.site_id)    as book_id
              ,case when b2.freechapternum = 0 then b1.vip
                    when b2.freechapternum > 0 and b2.freechapternum < b1.serial_number then 1
                    else 0
             end                              as free_chapter_num
         from ods.ods_edit_shuangwen_chapter           as b1
                  left join ods.ods_book_novel_book_m           as b2
                            on (b1.book_id * 1000 + b1.site_id) = b2.bookid
                                and b1.site_id = b2.siteid
                                and b2.productid = 3501
         where b1.productid = 3311
           and b1.site_id = 414
           and b1.status != -1
         union all
         -- ---------泰语书籍-----------------
         select (b1.book_id * 1000 + b1.site_id)    as book_id
              ,case when b2.freechapternum = 0 then b1.vip
                    when b2.freechapternum > 0 and b2.freechapternum < b1.serial_number then 1
                    else 0
             end                              as free_chapter_num
         from ods.ods_edit_shuangwen_chapter           as b1
                  left join ods.ods_book_novel_book_m           as b2
                            on (b1.book_id * 1000 + b1.site_id) = b2.bookid
                                and b1.site_id = b2.siteid
                                and b2.productid = 3511
         where b1.productid = 3311
           and b1.site_id = 433
           and b1.status != -1
         union all
         -- ---------葡语书籍-----------------
         select (b1.book_id * 1000 + b1.site_id)    as book_id
              ,case when b2.freechapternum = 0 then b1.vip
                    when b2.freechapternum > 0 and b2.freechapternum < b1.serial_number then 1
                    else 0
             end                              as free_chapter_num
         from ods.ods_edit_shuangwen_chapter           as b1
                  left join ods.ods_book_novel_book_m           as b2
                            on (b1.book_id * 1000 + b1.site_id) = b2.bookid
                                and b1.site_id = b2.siteid
                                and b2.productid = 3322
         where b1.productid = 3322
           and b1.site_id = 409
           and b1.status != -1
         union all
         --  英语 韩语、菲律宾 书籍 ----
         select (b1.book_id * 1000 + b1.site_id)    as book_id
              ,case when b2.freechapternum = 0 then b1.vip
                    when b2.freechapternum > 0 and b2.freechapternum < b1.serial_number then 1
                    else 0
             end                              as free_chapter_num
         from ods.ods_edit_shuangwen_chapter           as b1
                  left join ods.ods_book_novel_book_m           as b2
                            on (b1.book_id * 1000 + b1.site_id) = b2.bookid
                                and b1.site_id = b2.siteid
                                and b2.productid = 3366
         where b1.productid = 3366
           and b1.site_id in (322,436,445,435,497)
           and b1.status != -1
         union all
         -- ---------西语书籍-----------------
         select (b1.book_id * 1000 + b1.site_id)    as book_id
              ,case when b2.freechapternum = 0 then b1.vip
                    when b2.freechapternum > 0 and b2.freechapternum < b1.serial_number then 1
                    else 0
             end                              as free_chapter_num
         from ods.ods_edit_shuangwen_chapter           as b1
                  left join ods.ods_book_novel_book_m           as b2
                            on (b1.book_id * 1000 + b1.site_id) = b2.bookid
                                and b1.site_id = b2.siteid
                                and b2.productid = 3388
         where b1.productid = 3388
           and b1.site_id in (375)
           and b1.status != -1
         union all
         -- -------俄语书籍----
         select (b1.book_id * 1000 + b1.site_id)    as book_id
              ,case when b2.freechapternum = 0 then b1.vip
                    when b2.freechapternum > 0 and b2.freechapternum < b1.serial_number then 1
                    else 0
             end                              as free_chapter_num
         from ods.ods_edit_shuangwen_chapter           as b1
                  left join ods.ods_book_novel_book_m           as b2
                            on (b1.book_id * 1000 + b1.site_id) = b2.bookid
                                and b1.site_id = b2.siteid
                                and b2.productid = 3371
         where b1.productid = 3311
           and b1.site_id in (418)
           and b1.status != -1
         union all
         -- -------日语书籍----
         select (b1.book_id * 1000 + b1.site_id)    as book_id
              ,case when b2.freechapternum = 0 then b1.vip
                    when b2.freechapternum > 0 and b2.freechapternum < b1.serial_number then 1
                    else 0
             end                              as free_chapter_num
         from ods.ods_edit_shuangwen_chapter           as b1
                  left join ods.ods_book_novel_book_m           as b2
                            on (b1.book_id * 1000 + b1.site_id) = b2.bookid
                                and b1.site_id = b2.siteid
                                and b2.productid = 3399
         where b1.productid = 3311
           and b1.site_id in (419)
           and b1.status != -1
         union all
         -- -------繁体书籍----
         select b1.book_id                         as book_id
              ,case when b2.freechapternum = 0 then b1.vip
                    when b2.freechapternum > 0 and b2.freechapternum < b1.serial_number then 1
                    else 0
             end                              as free_chapter_num
         from ods.ods_book_novel_chaptersync           as b1
                  left join (
             select c1.bookid
                  ,c1.bookname
                  ,c1.newcid
                  ,c1.newcname
                  ,c1.language
                  ,c1.isfull
                  ,c1.sexy2
                  ,c1.freechapternum
             from ods.ods_book_novel_book_m        as c1
             where c1.productid = 3333
         )                                        as b2
                            on b1.book_id = b2.bookid
                  join (
             -- -----------只获取有阅读过的繁体书籍------
             select c1.book_id
             from dws.dws_read_user_readbook_ed    as c1
             where c1.dt >= '2020-06-01'
               and c1.product_id in (3333,8858,7757)
             group by 1
         )                                        as b3
                       on b1.book_id = b3.book_id
     )                                     as a1
group by 1
;

insert overwrite dim.dim_shuangwen_book_read_consume_info
-- ------------获取书籍的超点章节数 -----------------------
with ft as (
    select a1.bookid
        ,a1.langid
    from ods.ods_tidb_readernovel_tidb_tag_center_book as a1
    where a1.bookid in (
    select b1.book_id
    from (
    select c1.book_id
        ,c1.speed_chapter_num
        ,count(1)
    from (  -- 繁体的书在英语和繁体种都有 需要排除掉
    select d1.bookid             as book_id
        ,d1.speedchapternum    as speed_chapter_num
        ,d1.chaptercount
        ,d1.langid
    from ods.ods_tidb_readernovel_tidb_tag_center_book as d1
    where d1.langid != 1
    group by 1,2,3,4
    having count(1) = 1  -- 排除简体的书
    )                          as c1
    where c1.langid in (2,3)
    group by 1,2
    having count(1) > 1
    )                                  as b1
    )
    and a1.langid != 1
    )
        , speed_chapter as (
    select a1.bookid             as book_id
        ,a1.speedchapternum    as speed_chapter_num
        ,a1.chaptercount
    from ods.ods_tidb_readernovel_tidb_tag_center_book as a1
    where a1.langid != 1
    and concat(a1.bookid, a1.langid) not in (
    select concat(b1.bookid, b1.langid)
    from ft                                   as b1
    where b1.langid = 3
    )
    group by 1,2,3
    having count(1) = 1  -- 排除简体的书
    )
select a1.productid
     ,a1.bookid
     ,a1.yt
     ,if(a1.bookname is not null and a1.bookname != '', a1.bookname, '-')                      as bookname
     ,if(a1.createtime is null or a1.createtime = '', '1970-01-01 00:00:00', a1.createtime)    as create_time
     ,if(a1.updatetime is null or a1.updatetime = '', '1970-01-01 00:00:00', a1.updatetime)    as update_time
     ,if(a1.booknature is null, '-', a1.booknature)                                            as book_nature
     ,if(a1.signtype is null, '-', a1.signtype)                                                as sign_type
     ,if(a1.channel is null, '-', a1.channel)                                                  as channel
     ,if(a1.isfull is null, 0, a1.isfull)                                                      as is_full
     ,if(a1.siteid is null, '-', a1.siteid)                                                    as site_id
     ,if(a1.siteid2 is null, '-', a1.siteid2)                                                  as site_id2
     ,if(a1.priceperthousand is null, '-', a1.priceperthousand)                                as price_per_thousand
     ,if(a1.newcid is null, '-', a1.newcid)                                                    as new_cid
     ,if(a1.newcname is null or a1.newcname = '', '-', a1.newcname)                            as new_cname
     ,if(a1.sexy2 is null, '-', a1.sexy2)                                                      as sexy2
     ,if(a1.normalchapternum_f is null, '-', a1.normalchapternum_f)                            as normal_chapter_num_f    -- 发布章节数
     ,if(a1.buildtime is null or a1.buildtime = '', '1970-01-01 00:00:00', a1.buildtime)       as build_time
     ,if(a1.blockname is null or a1.blockname = '', '-', a1.blockname)                         as block_name
     ,a1.fontlength                                                                            as font_length
     ,if(a1.bookcode is null or a1.bookcode = '', '-', a1.bookcode)                            as book_code
     ,a1.fulltime                                                                              as full_time
     ,a1.languageid
     ,a1.public_fontlength
     ,a1.authorid                                                                              as author_id
     ,a1.authorname                                                                            as author_name
     ,a1.free_chapter_num                                                                      as free_chapternum
     ,if(a1.latestupdatetime is null or a1.latestupdatetime = '', '1970-01-01 00:00:00', a1.latestupdatetime) as latest_update_time
     ,a1.chapternum                                                                            as total_chapter_num       -- 总章节数
     ,ifnull(a1.speed_chapter_num, 0)                                                          as speed_chapter_num       -- 超点章节数
     ,a1.isputdown
     ,a1.putdownlevel
     ,a1.penname
     ,a1.authortype
     ,now()                                                                                    as etl_time
from (
         -- 3311 fr  3501 id 3511 th  (20251119新增阿拉伯语言数据 ar 20260327新增意大利语)   -----------------------------
         select m.server_product_id                            as productid
              ,b1.bookid
              ,date(b1.createtime)                               as yt
              ,b1.bookname
              ,b1.createtime
              ,b1.updatetime
              ,case when b1.booknature is null then 0
                    else b1.booknature
             end                                              as booknature
              ,b1.signtype
              ,b1.channel
              ,b1.isfull
              ,b1.siteid
              ,b1.siteid                                         as siteid2
              ,b1.priceperthousand
              ,b2.newcid
              ,b2.newcname
              ,b2.sexy2
              ,b2.normalchapternum_f
              ,b2.buildtime
              ,b1.blockname
              ,b1.fontlength
              ,b1.bookcode
              ,b1.fulltime
              ,b1.languageid
              ,b2.length                                          as public_fontlength
              ,b1.authorid
              ,b1.authorname
              ,b2.latestupdatetime
              ,b3.chaptercount                        as chapternum           -- 总章节数
              ,b3.speed_chapter_num                                           -- 超点章节数
              ,b4.free_chapter_num                                                 -- 免费章节数
              ,b1.isputdown
              ,b1.putdownlevel
              ,b1.penname
              ,b1.authortype
         from (
                  select (c1.bookid * 1000) + c1.siteid              as bookid
                       ,c1.bookname
                       ,c1.createtime
                       ,c1.updatetime
                       ,case when c2.authortype = 4 and c1.booknature not in (6,9) then 4
                             else c1.booknature
                      end                                      as booknature
                       ,c1.signtype
                       ,c1.channel
                       ,c1.isfull
                       ,c1.siteid
                       ,c1.priceperthousand
                       ,c1.fontlength
                       ,c1.bookcode
                       ,c1.fulltime
                       ,c1.language                                as languageid
                       ,c1.authorid
                       ,c1.authorname
                       ,c1.isputdown
                       ,c1.putdownlevel
                       ,c2.penname
                       ,c2.authortype
                       ,c3.blockname
                  from ods.ods_edit_book                        as c1   -- shuangwen_fr.book
                           left join ods.ods_edit_author                 as c2
                                     on c1.authorid = c2.accountid
                                         and c2.productid = 3311
                           left join ods.ods_panda_publishermanager      as c3
                                     on c1.siteid = c3.siteid
                  where c1.productid = 3311
                    and c1.siteid in (410,412,414,433,415,413)
              )                                                 as b1
                  left join dim.dim_rule_productid_lang_mapping        as m
                            on m.site_id = b1.siteid
                  left join (
             select c1.productid
                  ,c1.bookid
                  ,c1.newcid
                  ,c2.cname                                   as newcname
                  ,c1.sexy2
                  ,c1.normalchapternum_f
                  ,c1.buildtime
                  ,c1.length
                  ,c1.latestupdatetime
             from ods.ods_book_novel_book_m                as c1
                      left join ods.ods_tidb_readernovel_tidb_en_novel_bookcategory_new as c2
                                on c1.productid = c2.productid
                                    and c1.`language` = c2.`language`
                                    and c1.newcid = c2.cid
             where (c1.productid = 3501 and c1.siteid = 414)
                or (c1.productid = 3511 and c1.siteid = 433)
                or (c1.productid = 3311 and c1.siteid = 410)
                or (c1.productid = 3311 and c1.siteid in (412,415,413))
         )                                                 as b2
                            on b1.bookid = b2.bookid
                  left join speed_chapter                                as b3   -- ---获取书籍的超点章节数
                            on b1.bookid = b3.book_id
                  left join dim.dim_book_free_chapter_num_temp           as b4   -- ---获取免费章节数
                            on b1.bookid = b4.book_id
         union all
         -- 3322 pt -----------------------------
         select b1.productid
              ,b1.bookid
              ,date(b1.createtime)                               as yt
              ,b1.bookname
              ,b1.createtime
              ,b1.updatetime
              ,case when b1.booknature is null then 0
                    else b1.booknature
             end                                              as booknature
              ,b1.signtype
              ,b1.channel
              ,b1.isfull
              ,b1.siteid
              ,b1.siteid                                         as siteid2
              ,b1.priceperthousand
              ,b2.newcid
              ,b2.newcname
              ,b2.sexy2
              ,b2.normalchapternum_f
              ,b2.buildtime
              ,b1.blockname
              ,b1.fontlength
              ,b1.bookcode
              ,b1.fulltime
              ,b1.languageid
              ,b2.length                                          as public_fontlength
              ,b1.authorid
              ,b1.authorname
              ,b2.latestupdatetime
              ,b3.chaptercount                        as chapternum           -- 总章节数
              ,b3.speed_chapter_num                                           -- 超点章节数
              ,b4.free_chapter_num                                                 -- 免费章节数
              ,b1.isputdown
              ,b1.putdownlevel
              ,b1.penname
              ,b1.authortype
         from (
                  select c1.productid
                       ,(c1.bookid * 1000) + c1.siteid              as bookid
                       ,c1.bookname
                       ,c1.createtime
                       ,c1.updatetime
                       ,case when c2.authortype = 4 and c1.booknature not in (6,9) then 4
                             else c1.booknature
                      end                                      as booknature
                       ,c1.signtype
                       ,c1.channel
                       ,c1.isfull
                       ,c1.siteid
                       ,c1.priceperthousand
                       ,c1.fontlength
                       ,c1.bookcode
                       ,c1.fulltime
                       ,c1.language                                as languageid
                       ,c1.authorid
                       ,c1.authorname
                       ,c1.isputdown
                       ,c1.putdownlevel
                       ,c2.penname
                       ,c2.authortype
                       ,c3.blockname
                  from ods.ods_edit_book                        as c1
                           left join ods.ods_edit_author                 as c2
                                     on c1.authorid = c2.accountid
                                         and c2.productid = 3322
                           left join ods.ods_panda_publishermanager      as c3
                                     on c1.siteid = c3.siteid
                  where c1.productid = 3322
                    and c1.siteid = 409
              )                                                 as b1
                  left join (
             select c1.productid
                  ,c1.bookid
                  ,c1.newcid
                  ,c2.cname                                   as newcname
                  ,c1.sexy2
                  ,c1.normalchapternum_f
                  ,c1.buildtime
                  ,c1.length
                  ,c1.latestupdatetime
             from ods.ods_book_novel_book_m                as c1
                      left join ods.ods_tidb_readernovel_tidb_en_novel_bookcategory_new as c2
                                on c1.productid = c2.productid
                                    and c1.`language` = c2.`language`
                                    and c1.newcid = c2.cid
             where c1.productid = 3322
               and c1.siteid = 409
         )                                                 as b2
                            on b1.bookid = b2.bookid
                  left join speed_chapter                                as b3   -- ---获取书籍的超点章节数
                            on b1.bookid = b3.book_id
                  left join dim.dim_book_free_chapter_num_temp           as b4   -- ---获取免费章节数
                            on b1.bookid = b4.book_id
         union all
         -- 3366 en ko tl -----------------------------
         select m.server_product_id                            as productid
              ,b1.bookid
              ,date(b1.createtime)                               as yt
              ,b1.bookname
              ,b1.createtime
              ,b1.updatetime
              ,case when b1.booknature is null then 0
                    else b1.booknature
             end                                              as booknature
              ,b1.signtype
              ,b1.channel
              ,b1.isfull
              ,b1.siteid
              ,b1.siteid                                         as siteid2
              ,b1.priceperthousand
              ,b2.newcid
              ,b2.newcname
              ,b2.sexy2
              ,b2.normalchapternum_f
              ,b2.buildtime
              ,b1.blockname
              ,b1.fontlength
              ,b1.bookcode
              ,b1.fulltime
              ,m.lang_id                                         as languageid
              ,b2.length                                          as public_fontlength
              ,b1.authorid
              ,b1.authorname
              ,b2.latestupdatetime
              ,b3.chaptercount                        as chapternum           -- 总章节数
              ,b3.speed_chapter_num                                           -- 超点章节数
              ,b4.free_chapter_num                                                 -- 免费章节数
              ,b1.isputdown
              ,b1.putdownlevel
              ,b1.penname
              ,b1.authortype
         from (
                  select (c1.bookid * 1000) + c1.siteid              as bookid
                       ,c1.bookname
                       ,c1.createtime
                       ,c1.updatetime
                       ,case when c2.authortype = 4 and c1.booknature not in (6,9) then 4
                             else c1.booknature
                      end                                      as booknature
                       ,c1.signtype
                       ,c1.channel
                       ,c1.isfull
                       ,c1.siteid
                       ,c1.priceperthousand
                       ,c1.fontlength
                       ,c1.bookcode
                       ,c1.fulltime
                       ,c1.language                                as languageid
                       ,c1.authorid
                       ,c1.authorname
                       ,c1.isputdown
                       ,c1.putdownlevel
                       ,c2.penname
                       ,c2.authortype
                       ,c3.blockname
                  from ods.ods_edit_book                        as c1
                           left join ods.ods_edit_author                 as c2
                                     on c1.authorid = c2.accountid
                                         and c2.productid = 3366
                           left join ods.ods_panda_publishermanager      as c3
                                     on c1.siteid = c3.siteid
                  where c1.productid = 3366
                    and c1.siteid in (322,436,445,435,497)
              )                                                 as b1
                  left join dim.dim_rule_productid_lang_mapping        as m
                            on m.site_id = b1.siteid
                  left join (
             select c1.productid
                  ,c1.bookid
                  ,c1.newcid
                  ,c2.cname                                   as newcname
                  ,c1.sexy2
                  ,c1.normalchapternum_f
                  ,c1.buildtime
                  ,c1.length
                  ,c1.latestupdatetime
             from ods.ods_book_novel_book_m                as c1
                      left join ods.ods_tidb_readernovel_tidb_en_novel_bookcategory_new as c2
                                on c1.newcid = c2.cid
                                    and c2.`language` = 3
             where c1.productid = 3366
               and c1.siteid in (322,436,445,435,497)
         )                                                 as b2
                            on b1.bookid = b2.bookid
                  left join speed_chapter                                as b3   -- ---获取书籍的超点章节数
                            on b1.bookid = b3.book_id
                  left join dim.dim_book_free_chapter_num_temp           as b4   -- ---获取免费章节数
                            on b1.bookid = b4.book_id
         union all
         -- 3388 sp 3371 ru 3399 jp  -----------------------------
         select m.server_product_id                            as productid
              ,b1.bookid
              ,date(b1.createtime)                               as yt
              ,b1.bookname
              ,b1.createtime
              ,b1.updatetime
              ,case when b1.booknature is null then 0
                    else b1.booknature
             end                                              as booknature
              ,b1.signtype
              ,b1.channel
              ,b1.isfull
              ,b1.siteid
              ,b1.siteid                                         as siteid2
              ,b1.priceperthousand
              ,b2.newcid
              ,b2.newcname
              ,b2.sexy2
              ,b2.normalchapternum_f
              ,b2.buildtime
              ,b1.blockname
              ,b1.fontlength
              ,b1.bookcode
              ,b1.fulltime
              ,m.lang_id                                         as languageid
              ,b2.length                                          as public_fontlength
              ,b1.authorid
              ,b1.authorname
              ,b2.latestupdatetime
              ,b3.chaptercount                        as chapternum           -- 总章节数
              ,b3.speed_chapter_num                                           -- 超点章节数
              ,b4.free_chapter_num                                                 -- 免费章节数
              ,b1.isputdown
              ,b1.putdownlevel
              ,b1.penname
              ,b1.authortype
         from (
                  select (c1.bookid * 1000) + c1.siteid              as bookid
                       ,c1.bookname
                       ,c1.createtime
                       ,c1.updatetime
                       ,case when c2.authortype = 4 and c1.booknature not in (6,9) then 4
                             else c1.booknature
                      end                                      as booknature
                       ,c1.signtype
                       ,c1.channel
                       ,c1.isfull
                       ,c1.siteid
                       ,c1.priceperthousand
                       ,c1.fontlength
                       ,c1.bookcode
                       ,c1.fulltime
                       ,c1.language                                as languageid
                       ,c1.authorid
                       ,c1.authorname
                       ,c1.isputdown
                       ,c1.putdownlevel
                       ,c2.penname
                       ,c2.authortype
                       ,c3.blockname
                  from ods.ods_edit_book                        as c1
                           left join ods.ods_edit_author                 as c2
                                     on c1.authorid = c2.accountid
                                         and c2.productid = 3388
                           left join ods.ods_panda_publishermanager      as c3
                                     on c1.siteid = c3.siteid
                  where c1.productid = 3388
                    and c1.siteid in (375,418,419)
              )                                                 as b1
                  left join dim.dim_rule_productid_lang_mapping        as m
                            on m.site_id = b1.siteid
                  left join (
             select c1.productid
                  ,c1.bookid
                  ,c1.newcid
                  ,c2.cname                                   as newcname
                  ,c1.sexy2
                  ,c1.normalchapternum_f
                  ,c1.buildtime
                  ,c1.length
                  ,c1.latestupdatetime
             from ods.ods_book_novel_book_m                as c1
                      left join ods.ods_tidb_readernovel_tidb_en_novel_bookcategory_new as c2
                                on c1.productid = c2.productid
                                    and c1.`language` = c2.`language`
                                    and c1.newcid = c2.cid
             where (c1.productid = 3388 and c1.siteid = 375)
                or (c1.productid = 3371 and c1.siteid = 418)
                or (c1.productid = 3399 and c1.siteid = 419)
         )                                                 as b2
                            on b1.bookid = b2.bookid
                  left join speed_chapter                                as b3   -- ---获取书籍的超点章节数
                            on b1.bookid = b3.book_id
                  left join dim.dim_book_free_chapter_num_temp           as b4   -- ---获取免费章节数
                            on b1.bookid = b4.book_id
         union all
         -- ------------3333-------------------------------------
         select '3333'                                            as productid
              ,b1.bookid
              ,date(b1.buildtime)                                as yt
              ,b1.bookname
              ,b1.row_create_time                                as createtime
              ,b1.updatetime
              ,case when b1.booknature is null then 0
                    when right(b1.bookid, 3) = '450' then 4
                    when right(b1.bookid, 3) = '090' or (right(b1.bookid, 3) = '449' and b6.departmenttype = 1) then '凤鸣轩'
                    when right(b1.bookid, 3) = '446' then '精修编辑部'
                    when right(b1.bookid, 3) = '449' and b6.departmenttype = 0 then '内容编辑部'
                    else b1.booknature
             end                                              as booknature
              ,case when b1.source in (1,2) then 0
                    else 2
             end                                              as signtype
              ,b1.channel
              ,b1.isfull
              ,b1.siteid
              ,333                                               as siteid2
              ,b1.priceperthousand
              ,b1.newcid
              ,b3.newcname
              ,b1.sexy2
              ,b1.normalchapternum_f
              ,b1.buildtime
              ,b7.blockname                                      as blockname
              ,b1.length                                         as fontlength
              ,b2.bookno                                         as bookcode
              ,b1.fulltime
              ,if(b1.language = 0, 2, b1.language)               as languageid
              ,b1.length                                         as public_fontlength
              ,b1.authorid
              ,b1.authorname
              ,b1.latestupdatetime
              ,b1.normalchapternum_f                             as chapternum           -- 这是总章节数
              ,b4.speed_chapter_num                                           -- 超点章节数
              ,b5.free_chapter_num                                                 -- 免费章节数
              ,null                                              as isputdown
              ,null                                              as putdownlevel
              ,null                                              as penname
              ,null                                              as authortype
         from ods.ods_book_novel_book_m                        as b1
                  left join (
             -- 获取繁体的书籍代号----
             select c1.bookid
                  ,max(c1.bookno)                            as bookno
             from (
                      -- 繁体配置的书
                      select d1.bookid
                           ,d1.bookno
                      from ods.ods_tidb_readernovel_tidb_tag_center_book_information as d1
                      where d1.langid = 2
                        and d1.bookno != ''
                      group by 1,2
                      union all
                      -- 新掌中的书  449 090的书
                      select d1.bookid * 1000 + d1.siteid      as bookid
                           ,d1.bookcode                       as bookno
                      from ods.ods_mysql_zhangzhong_xzz_Book as d1
                      group by 1,2
                  )                                         as c1
             group by 1
         )                                                 as b2
                            on b1.bookid = b2.bookid                               -- 获取书籍的 书籍分类 CName ,SEXY 等----
                  left join (
             select c1.cid
                  ,c1.sexy                                   as sexy2
                  ,c1.cname                                  as newcname
             from ods.ods_tidb_readernovel_tidb_en_novel_bookcategory_new as c1
             where c1.productid = 3333
         )                                                 as b3
                            on b1.newcid = b3.cid
                  left join speed_chapter                                as b4   -- ---获取书籍的超点章节数
                            on b1.bookid = b4.book_id
                  left join dim.dim_book_free_chapter_num_temp           as b5   -- ---获取免费章节数
                            on b1.bookid = b5.book_id
                  left join (
             --  DepartmentType '部门类型 0内容编辑部 1凤鸣轩'  凤鸣轩新的书是在新掌中站点创建的，虽然书的siteid=449但是书的来源还是属于凤鸣轩
             select c1.bookid * 1000 + c1.siteid              as book_id
                  ,c1.departmenttype
             from ods.ods_mysql_zhangzhong_xzz_Book        as c1
             where c1.siteid = 449
             order by 2,1
         )                                                 as b6
                            on b1.bookid = b6.book_id
                  left join ods.ods_panda_publishermanager              as b7
                            on b1.siteid = b7.siteid
         where b1.productid = 3333
         union all
         -- 2025-04-21 增加海外简体的书  Language = 19
         select b1.productid
              ,b1.bookid
              ,date(b1.buildtime)                                as yt
              ,b1.bookname
              ,b1.row_create_time                                as createtime
              ,b1.updatetime
              ,case when b1.booknature is null then 0
                    when right(b1.bookid, 3) = '450' then 4
                    when right(b1.bookid, 3) = '090' or (right(b1.bookid, 3) = '449' and b6.departmenttype = 1) then '凤鸣轩'
                    when right(b1.bookid, 3) = '446' then '精修编辑部'
                    when right(b1.bookid, 3) = '449' and b6.departmenttype = 0 then '内容编辑部'
                    else b1.booknature
             end                                              as booknature
              ,case when b1.source in (1,2) then 0
                    else 2
             end                                              as signtype
              ,b1.channel
              ,b1.isfull
              ,b1.siteid
              ,b1.siteid                                         as siteid2
              ,b1.priceperthousand
              ,b1.newcid
              ,b3.newcname
              ,b1.sexy2
              ,b1.normalchapternum_f
              ,b1.buildtime
              ,b7.blockname                                      as blockname
              ,b1.length                                         as fontlength
              ,b2.bookno                                         as bookcode
              ,b1.fulltime
              ,if(b1.language = 0, 2, b1.language)               as languageid
              ,b1.length                                         as public_fontlength
              ,b1.authorid
              ,b1.authorname
              ,b1.latestupdatetime
              ,b1.normalchapternum_f                             as chapternum           -- 这是总章节数
              ,b4.speed_chapter_num                                           -- 超点章节数
              ,b5.free_chapter_num                                                 -- 免费章节数
              ,null                                              as isputdown
              ,null                                              as putdownlevel
              ,null                                              as penname
              ,null                                              as authortype
         from ods.ods_book_novel_book_m                        as b1
                  left join (
             -- 获取繁体的书籍代号----
             select c1.bookid
                  ,max(c1.bookno)                            as bookno
             from (
                      -- 繁体配置的书
                      select d1.bookid
                           ,d1.bookno
                      from ods.ods_tidb_readernovel_tidb_tag_center_book_information as d1
                      where d1.langid = 2
                        and d1.bookno != ''
                      group by 1,2
                      union all
                      -- 新掌中的书  449 090的书
                      select d1.bookid * 1000 + d1.siteid      as bookid
                           ,d1.bookcode                       as bookno
                      from ods.ods_mysql_zhangzhong_xzz_Book as d1
                      group by 1,2
                  )                                         as c1
             group by 1
         )                                                 as b2
                            on b1.bookid = b2.bookid                               -- 获取书籍的 书籍分类 CName ,SEXY 等----
                  left join (
             select c1.cid
                  ,c1.sexy                                   as sexy2
                  ,c1.cname                                  as newcname
             from ods.ods_tidb_readernovel_tidb_en_novel_bookcategory_new as c1
             where c1.productid = 3333
         )                                                 as b3
                            on b1.newcid = b3.cid
                  left join speed_chapter                                as b4   -- ---获取书籍的超点章节数
                            on b1.bookid = b4.book_id
                  left join dim.dim_book_free_chapter_num_temp           as b5   -- ---获取免费章节数
                            on b1.bookid = b5.book_id
                  left join (
             --  DepartmentType '部门类型 0内容编辑部 1凤鸣轩'  凤鸣轩新的书是在新掌中站点创建的，虽然书的siteid=449但是书的来源还是属于凤鸣轩
             select c1.bookid * 1000 + c1.siteid              as book_id
                  ,c1.departmenttype
             from ods.ods_mysql_zhangzhong_xzz_Book        as c1
             where c1.siteid = 449
             order by 2,1
         )                                                 as b6
                            on b1.bookid = b6.book_id
                  left join ods.ods_panda_publishermanager              as b7
                            on b1.siteid = b7.siteid
         where b1.language = 19
         union all
         -- --------------3333  ------------------------------
         select '3333'                                            as productid
              ,b1.voicebookid * 1000 + 990                       as bookid
              ,date(b1.createtime)                               as yt
              ,b1.bookname
              ,b1.createtime
              ,b1.updatetime
              ,8                                                 as booknature
              ,0                                                 as signtype
              ,null                                              as channel
              ,b1.isfull
              ,null                                              as siteid
              ,333                                               as siteid2
              ,null                                              as priceperthousand
              ,null                                              as newcid
              ,null                                              as newcname
              ,b1.sexy                                           as sexy2
              ,null                                              as normalchapternum_f
              ,b1.createtime                                     as buildtime
              ,null                                              as blockname
              ,null                                              as fontlength
              ,null                                              as bookcode
              ,null                                              as fulltime
              ,2                                                 as languageid
              ,null                                              as public_fontlength
              ,null                                              as authorid
              ,b1.authorname
              ,'1970-01-01 00:00:00'                             as latestupdatetime
              ,null                                              as chapternum
              ,0                                                 as speed_chapter_num    -- 超点章节数
              ,0                                                 as free_chapter_num     -- 免费章节数
              ,null                                              as isputdown
              ,null                                              as putdownlevel
              ,null                                              as penname
              ,null                                              as authortype
         from ods.ods_voice_book                               as b1
         union all
         -- 解说漫数据 2026-04-24 新增
         select coalesce(m.server_product_id, 0)              as productid
              ,cast(concat('11100000', cast(a.SeriesId as string)) as bigint) as bookid
              ,date(if(a.CreateTime is null, '1970-01-01 00:00:00', a.CreateTime)) as yt
              ,if(a.SeriesName is not null and a.SeriesName != '', a.SeriesName, '-') as bookname
              ,if(a.CreateTime is null, '1970-01-01 00:00:00', a.CreateTime) as createtime
              ,if(a.UpdateTime is null, '1970-01-01 00:00:00', a.UpdateTime) as updatetime
              ,10                                               as booknature
              ,case when b.CooperateType = 1 then 0
                    when b.CooperateType = 2 then 1
                    when b.CooperateType = 3 then 2
                    else -1
             end                                              as signtype
              ,case when b.WorkType = 1 then 2
                    when b.WorkType = 2 then 1
                    else 0
             end                                              as channel
              ,b.IsComplete                                     as isfull
              ,null                                             as siteid
              ,case a.Language
                   when 1 then 777
                   when 2 then 333
                   else m.site_id
             end                                              as siteid2
              ,null                                             as priceperthousand
              ,null                                             as newcid
              ,null                                             as newcname
              ,0                                                as sexy2
              ,a.LastEpis                                       as normalchapternum_f
              ,if(b.FirstPublicationTime is null or b.FirstPublicationTime = '', '1970-01-01 00:00:00', b.FirstPublicationTime) as buildtime
              ,if(c.Holder is null or c.Holder = '', '-', c.Holder) as blockname
              ,null                                             as fontlength
              ,if(b.SeriesCode is null or b.SeriesCode = '', '-', b.SeriesCode) as bookcode
              ,null                                             as fulltime
              ,a.Language                                       as languageid
              ,null                                             as public_fontlength
              ,null                                             as authorid
              ,null                                             as authorname
              ,a.UpdateTime                                     as latestupdatetime
              ,a.AllEpis                                        as chapternum
              ,0                                                as speed_chapter_num    -- 超点章节数
              ,0                                                as free_chapter_num     -- 免费章节数
              ,null                                             as isputdown
              ,null                                             as putdownlevel
              ,null                                             as penname
              ,null                                             as authortype
         from ods.ods_tidb_short_video_admin_series        as a
                  inner join (
             select SeriesId
             from ods.ods_tidb_source_series
             where LocalType = 5
             union
             select SeriesId
             from ods.ods_tidb_short_video_admin_source_series
             where LocalType = 5
         )                                                as s
                             on a.SourceSeriesId = s.SeriesId
                  left join ods.ods_tidb_short_video_admin_source_series as b
                            on a.SourceSeriesId = b.SeriesId
                  left join ods.ods_tidb_short_video_admin_rights_holder as c
                            on b.RightsHolderId = c.Id
                  left join (
             select lang_id, server_product_id, site_id
             from (
                      select lang_id, server_product_id, site_id
                           ,row_number() over (partition by lang_id order by site_id desc) as rn
                      from dim.dim_rule_productid_lang_mapping
                      where lang_id is not null
                  ) as t
             where rn = 1
         )                                                as m
                            on m.lang_id = a.Language
         where a.IsDelete = 0
     )                                     as a1
;


