insert into ads.ads_content_quality_feedback
with tmp_data_1 as (
    select date(completiontime) as dt
          ,a.siteid
          ,a.authorid
          ,a.roletype
          ,1 as check_model
          ,a.authorname
          ,a.createuserid as check_person
          ,a.authorname as checked_person
          ,a.bookname
          ,a.chaptername
      from ods.ods_tidb_shuangwen_xx_qualityfeedback a
     where a.feedbacktype in (10, 14)
)
select md5(concat_ws('_', date(b.createtime), a.siteid, a.authorid, a.roletype, 1, a.authorname, a.check_person, a.checked_person, c.bookname, d.chaptername)) as md5_key
      ,date(b.createtime) as dt
      ,a.siteid
      ,a.authorid
      ,b.roletype
      ,1 as check_model
      ,a.authorname
      ,a.check_person as check_person
      ,a.checked_person as checked_person
      ,b.bookid
      ,c.bookname as book_name
      ,b.chapterid
      ,d.chaptername as chapter_name
      ,now() as etl_time
  from tmp_data_1 a
 inner join ods.ods_edit_book_remunerationdetail b
    on a.authorid = b.authorid
  left join ods.ods_tidb_shuangwen_en_objectbook c
    on b.productid = c.productid
   and b.bookid = c.swbookid
   and b.tolanguage = c.tolanguage
   and c.status = 1
  left join ods.ods_tidb_shuangwen_xx_objectchapter d
    on b.productid = d.productid
   and c.id = d.objectbookid
   and b.chapterid = d.id
;

insert into ads.ads_content_quality_feedback
with tmp_task_data1 as (
    select date(createtime) dt
          ,tolanguage as siteid
          ,optusers as checked_user
          ,row_number() over(partition by taskcontent, optusers order by createtime) as r_num
      from ods.ods_shuangwen_tidb_xx_taskcenter
     where tasktype = '低分重校章节'
)
,tmp_data2 as (
    select *
      from tmp_task_data1
     where r_num = 1
)
,remuneration as (
    select a.authorid
          ,b.penname as authorname
          ,b.tolanguage as site_id
          ,date(a.createtime) dt
          ,a.roletype
          ,a.bookid
          ,c.bookname as book_name
          ,a.chapterid
          ,d.chaptername as chapter_name
      from ods.ods_edit_book_remunerationdetail a
      left join ods.ods_tidb_shuangwen_xx_objectauthor b
        on a.productid = b.productid
       and a.authorid = b.accountid
       and a.tolanguage = b.tolanguage
      left join ods.ods_tidb_shuangwen_en_objectbook c
        on a.productid = c.productid
       and a.bookid = c.swbookid
       and a.tolanguage = c.tolanguage
       and c.status = 1
      left join ods.ods_tidb_shuangwen_xx_objectchapter d
        on a.productid = d.productid
       and c.id = d.objectbookid
       and a.chapterid = d.id
)
select md5(concat_ws('_', b.dt, b.site_id, b.authorid, b.roletype, 2, b.authorname, null, b.authorname, b.book_name, b.chapter_name)) as md5_key
      ,b.dt
      ,b.site_id
      ,b.authorid
      ,b.roletype
      ,2 as check_model
      ,b.authorname
      ,null as check_person
      ,b.authorname as checked_person
      ,b.bookid
      ,b.book_name as book_name
      ,b.chapterid
      ,b.chapter_name as chapter_name
      ,now() as etl_time
  from tmp_data2 a
 inner join remuneration b
    on a.checked_user = b.authorname
;

insert into ads.ads_content_quality_feedback
with tmp_data1 as (
    select date(completiontime) as dt
          ,productid
          ,chapterid
          ,bookid
          ,roletype
          ,tolanguage as site_id
          ,authorid as authorid
          ,penname as authorname
          ,bookname as book_name
          ,chaptername as chapter_name
          ,row_number() over(partition by penname, bookname, chaptername order by a.completiontime) as r_num
      from ods.ods_shuangwen_tidb_xx_objectchaptercheck a
     where roletype = 2
)
,tmp_data2 as (
    select *
      from tmp_data1
     where r_num = 1
)
,tmp_data3 as (
    select a.*
      from tmp_data2 a
     inner join ods.ods_tidb_shuangwen_xx_objectchapter d
        on a.productid = d.productid
       and a.chapterid = d.id
     where round((d.modifylength / d.foreignlength) * 100, 2) >= 70
)
select md5(concat_ws('_', a.dt, a.site_id, a.authorid, a.roletype, 3, a.authorname, null, a.authorname, a.book_name, a.chapter_name)) as md5_key
      ,a.dt
      ,a.site_id
      ,a.authorid
      ,a.roletype
      ,3 as check_model
      ,a.authorname
      ,null as check_person
      ,a.authorname as checked_person
      ,a.bookid
      ,a.book_name as book_name
      ,a.chapterid
      ,a.chapter_name as chapter_name
      ,now() as etl_time
  from tmp_data3 a
;

insert into ads.ads_content_quality_feedback
with tmp_data1 as (
    select date(a.createtime) dt
          ,a.bookid
          ,a.chapterid
          ,a.tolanguage as site_id
          ,null as author_id
          ,null as author_name
          ,2 as role_type
          ,4 as check_model
          ,a.optusers as check_person
          ,replace(split(a.tasktitle, '：')[2], '章节名', '') as book_name
          ,split(a.tasktitle, '：')[3] as chapter_name
          ,now()
      from ods.ods_shuangwen_tidb_xx_taskcenter a
     where tasktype = '外审评分审核'
)
select md5(concat_ws('_', a.dt, a.site_id, a.author_id, a.role_type, 4, a.author_name, a.check_person, null, a.book_name, a.chapter_name)) as md5_key
      ,a.dt
      ,a.site_id
      ,a.author_id
      ,a.role_type
      ,4 as check_model
      ,a.author_name
      ,a.check_person as check_person
      ,null as checked_person
      ,a.bookid
      ,a.book_name as book_name
      ,a.chapterid
      ,a.chapter_name as chapter_name
      ,now() as etl_time
  from tmp_data1 a
;

insert into ads.ads_content_quality_feedback
with tmp_data1 as (
    select date(completiontime) as dt
          ,productid
          ,roletype
          ,tolanguage as site_id
          ,authorid as authorid
          ,penname as authorname
          ,bookid
          ,bookname as book_name
          ,chapterid
          ,chaptername as chapter_name
          ,row_number() over(partition by penname, bookname, chaptername order by a.completiontime) as r_num
      from ods.ods_shuangwen_tidb_xx_objectchaptercheck a
     where roletype = 3
)
,tmp_data2 as (
    select *
      from tmp_data1
     where r_num = 1
)
,tmp_data3 as (
    select a.*
      from tmp_data2 a
     inner join ods.ods_tidb_shuangwen_xx_objectchapter d
        on a.productid = d.productid
       and a.chapterid = d.id
     where d.foreignpercent <= 1
)
select md5(concat_ws('_', a.dt, a.site_id, a.authorid, a.roletype, 5, a.authorname, null, a.authorname, a.book_name, a.chapter_name)) as md5_key
      ,a.dt
      ,a.site_id
      ,a.authorid
      ,a.roletype
      ,5 as check_model
      ,a.authorname
      ,null as check_person
      ,a.authorname as checked_person
      ,a.bookid
      ,a.book_name as book_name
      ,a.chapterid
      ,a.chapter_name as chapter_name
      ,now() as etl_time
  from tmp_data3 a
;

insert into ads.ads_content_quality_feedback
with tmp_data1 as (
    select siteid as siteid
          ,roletype
          ,authorid as authorid
          ,authorname as authorname
      from ods.ods_tidb_shuangwen_en_viscauthorconfig a
     where cooperatemode in (1, 3)
)
,remuneration as (
    select a.authorid
          ,b.penname as authorname
          ,b.tolanguage as site_id
          ,date(a.createtime) dt
          ,a.roletype
          ,a.bookid
          ,c.bookname as book_name
          ,a.chapterid
          ,d.chaptername as chapter_name
      from ods.ods_edit_book_remunerationdetail a
      left join ods.ods_tidb_shuangwen_xx_objectauthor b
        on a.productid = b.productid
       and a.authorid = b.accountid
       and a.tolanguage = b.tolanguage
      left join ods.ods_tidb_shuangwen_en_objectbook c
        on a.productid = c.productid
       and a.bookid = c.swbookid
       and a.tolanguage = c.tolanguage
       and c.status = 1
      left join ods.ods_tidb_shuangwen_xx_objectchapter d
        on a.productid = d.productid
       and c.id = d.objectbookid
       and a.chapterid = d.id
)
select md5(concat_ws('_', b.dt, a.siteid, b.authorid, b.roletype, 6, b.authorname, null, b.authorname, b.book_name, b.chapter_name)) as md5_key
      ,b.dt
      ,a.siteid
      ,b.authorid
      ,b.roletype
      ,6 as check_model
      ,b.authorname
      ,null as check_person
      ,b.authorname as checked_person
      ,b.bookid
      ,b.book_name as book_name
      ,b.chapterid
      ,b.chapter_name as chapter_name
      ,now() as etl_time
  from tmp_data1 a
 inner join remuneration b
    on a.authorid = b.authorid
;